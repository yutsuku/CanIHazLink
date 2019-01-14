module 'CanIHazLink'

local roll = require 'CanIHazLink.network.roll'

M.version = tonumber(GetAddOnMetadata('CanIHazLink', 'version'))

_G.CanIHazLinkDB = {}

local Engine = CreateFrame("Frame")
Engine:RegisterEvent("ADDON_LOADED")

local eventsframe = CreateFrame('Frame')
local events = {}
eventsframe:SetScript('OnEvent', function()
    if events[event] then
        for _, callback in ipairs(events[event]) do
            callback(event, this)
        end
    end
end)

function M.register(event, callback)
    if not events[event] then events[event] = {} end
    table.insert(events[event], callback)
    eventsframe:RegisterEvent(event)
end

Engine:SetScript('OnEvent', function()
	this[event](this)
end)

local normalize = {}
M.professions = normalize;

normalize["Alchemy"] 		= "Alchemy"
normalize["Blacksmithing"] 	= "Blacksmithing"
normalize["Enchanting"] 	= "Enchanting"
normalize["Engineering"] 	= "Engineering"
normalize["Inscription"] 		= "Inscription"
normalize["Jewelcrafting"] 	= "Jewelcrafting"
normalize["Leatherworking"]= "Leatherworking"
normalize["Tailoring"] 		= "Tailoring"

normalize["engi"] = normalize["Engineering"]
normalize["bs"] = normalize["Blacksmithing"]
normalize["ench"] = normalize["Enchanting"]
normalize["insc"] = normalize["Inscription"]
normalize["scribe"] = normalize["Inscription"]
normalize["insc"] = normalize["Inscription"]
normalize["jc"] = normalize["Jewelcrafting"]
normalize["jwc"] = normalize["Jewelcrafting"]
normalize["lw"] = normalize["Leatherworking"]
normalize["tailo"] = normalize["Tailoring"] 

function Engine:CHAT_MSG_GUILD()
    self:GrabData()
end

function Engine:ADDON_LOADED()
    if arg1 ~= 'CanIHazLink' then return end
    print('loaded')
end

function M.print(arg)
	DEFAULT_CHAT_FRAME:AddMessage(LIGHTYELLOW_FONT_COLOR_CODE .. '<CanIHazLink> ' .. tostring(arg), ' ')
end

function M.tokenize(str, delimiter)
    if not delimiter then delimiter = '%S+' end
	local tokens = {}
	for token in string.gmatch(str, delimiter) do tinsert(tokens, token) end
	return tokens
end

function M.find_data()
	local Pattern = '(|cffffd000|Htrade:%d+:(%d+):(%d+):(%x+):(.[^|]+)|h%[(%a+)]|h|r)'
	local SenderGUID = arg12
	local link, skill, skillmax, guid, base64, name = strmatch(arg1, Pattern)
    
	if link ~= nil and skill ~= nil and skillmax ~= nil and guid ~= nil and base64 ~= nil and name ~= nil then
		guid = '0x' .. guid
		if bit.mod( guid, SenderGUID) == 0 then
			local output = 'Recived %d/%d [%s] from %s.'
			print(format(output,skill,skillmax,name,arg2))
			save(name, arg2, link)
		end
	end
end

function M.save(profession, name, link)
	if profession == nil or name == nil or link == nil then return end
	if CanIHazLinkDB[profession] == nil then CanIHazLinkDB[profession] = {} end
	CanIHazLinkDB[profession][name] = link
end

