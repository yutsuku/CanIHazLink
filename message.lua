module 'CanIHazLink.message'

local CanIHazLink = require 'CanIHazLink'
local roll = require 'CanIHazLink.network.roll'

local engine_profession, engine_mode, engine_sender
M.TimeOffset = 5
M.lastDump = 0
M.maxResults = 5

function on_roll()
    do_message(engine_profession, engine_mode, engine_sender)
end

function trigger()
	local message = arg1
	local sender = arg2

	local match = strmatch(message, "^!(%a+)$")
    
    if match and CanIHazLink.professions[match] ~= nil then
        trigger_roll(profession, 'GUILD', sender)
    end
end

function trigger_roll(profession, mode, sender)
    engine_profession = profession
    engine_mode = mode
    engine_sender = sender
    
    roll.do_roll(on_roll)
end

function on_message()
    local t = time()
    
    if t > (lastDump + TimeOffset) then
        lastDump = t
        trigger()
    end
    
    CanIHazLink.find_data()
end


function do_message(profession, mode, sender)
    local CC = 1
	local sizeof = 0
    local t = time()
	if mode == nil then mode = 'SELF' end
    
	if CanIHazLinkDB[profession] == nil then 
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
	
	if mode == 'GUILD' and IsInGuild() then
        CC = 1
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
        CC = 1
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
