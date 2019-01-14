module 'CanIHazLink.message'

local CanIHazLink = require 'CanIHazLink'
local roll = require 'CanIHazLink.network.roll'

local engine_profession, engine_mode, engine_sender
M.TimeOffset = 2
M.lastDump = 0
M.maxResults = 5

function on_roll()
    do_message(engine_profession, engine_mode, engine_sender)
end

function trigger()
	local message = arg1
	local Sender = arg2
	local Pattern = "^!(%a+)$"
	local match = strmatch(message, Pattern)
	if match == nil then return end
	if CanIHazLink.professions[match] == nil then return end
	
	profession = CanIHazLink.professions[match]
    
    engine_profession = profession
    engine_mode = 'GUILD'
    engine_sender = sender
    
    roll.do_roll(on_roll)
end

function on_message()
    trigger()
    CanIHazLink.find_data()
end


function do_message(profession, mode, sender)
    local CC = 1
	local sizeof = 0
    local t = time()
	if mode == nil then mode = 'SELF' end
    
	if CanIHazLinkDB[profession] == nil then 
        if t < (lastDump + TimeOffset) then return end
        
        lastDump = t
        
        if sender and mode == 'WHISPER' then
            SendChatMessage(format('No data yet for %s.', profession), mode, sender)
        else
             SendChatMessage(format('No data yet for %s.', profession), mode)
        end
        
        return
    end

	for i, v in pairs(CanIHazLinkDB[profession]) do 
        sizeof = sizeof + 1
    end
	
	if mode == 'SELF' then
		print(format('Dumping %s, got %d record(s).', profession, sizeof))
        
        CC = 1
		for name, link in pairs(CanIHazLinkDB[profession]) do
			print(format('%d/%d %s -> %s', CC, sizeof, link, name))
			CC = CC + 1
		end
	end -- SELF
	
	if mode == 'GUILD' then
		if IsInGuild() == nil then return end
        if t < (lastDump + TimeOffset) then return end
        
        CC = 1
		lastDump = t
		SendChatMessage((format('Dumping %s, %d of %d record(s).', profession, maxResults, sizeof)), 'GUILD')
        
		for name, link in pairs(CanIHazLinkDB[profession]) do
			if CC > maxResults then 
                break
            end
			SendChatMessage((format('%d/%d %s -> %s', CC, maxResults, link, name)), 'GUILD')
			CC = CC + 1
		end
	end -- GUILD
	
	if ( mode == 'PM' ) then
		if t < (lastDump + TimeOffset) then return end
        
        CC = 1
		lastDump = t
		local msg = format('Dumping %s, %d of %d record(s).', profession, maxResults, sizeof)
		tinsert(FilterOutgoing, msg)
		SendChatMessage(msg, 'WHISPER', nil, sender)
        
		for name, link in pairs(CanIHazLinkDB[profession]) do
			if CC > maxResults then break end
			msg = format('%d/%d %s -> %s', CC, maxResults, link, name)
			tinsert(FilterOutgoing, msg)
			SendChatMessage(msg, 'WHISPER', nil, sender)
			CC = CC + 1
		end
	end -- PM
	
end

CanIHazLink.register("CHAT_MSG_GUILD", on_message)
