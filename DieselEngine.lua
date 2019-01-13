function PrintDebug(msg) for i=1,NUM_CHAT_WINDOWS do local windowName = GetChatWindowInfo(i); if windowName == "Debug" then getglobal("ChatFrame" .. i):AddMessage(msg); end end end

CanIHazLinkDB = CanIHazLinkDB or {}
Engine = CreateFrame("Frame")
Engine:RegisterEvent("PLAYER_ENTERING_WORLD")
Engine:RegisterEvent("ADDON_LOADED")
--Engine:RegisterEvent("CHAT_MSG_CHANNEL")
Engine:RegisterEvent("CHAT_MSG_ADDON")
Engine:RegisterEvent("CHAT_MSG_GUILD")
Engine:SetScript("OnEvent", function(self, event, ...) self:OnEvent(event, ...); end);

local version = 1.0
local FilterOutgoing = {}
local TimeOffset=2
local lastDump=0
local maxResults=5
local normalize = {}

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

function Engine:FilterOutgoing(self, event, ... )
	msg=...
	if ( tContains(FilterOutgoing, msg) ) then
		return true
	else
		return false
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", function(self, event, ...) return Engine:FilterOutgoing(self, event, ...); end);

function Engine:OnEvent(event, ...)
	msg_debug ="";
	if ( event == "ADDON_LOADED" and arg1 == "CanIHazLink" ) then
		PrintDebug("CanIHazLink loaded! yay")
		self:VersionCheck("CHECK")
	end
	if ( event == "CHAT_MSG_GUILD" ) then
		self:TriggerDump("SELF", ...)
		self:GrabData(...)
	end
	if ( event == "CHAT_MSG_ADDON" and arg1 == "CanIHazLink" ) then
		self:VersionCheck("LISTEN", ...)
	end
end

function Engine:msg(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function Engine:GrabData(...)
	Pattern = "(|cffffd000|Htrade:%d+:(%d+):(%d+):(%x+):(.[^|]+)|h%[(%a+)]|h|r)"
	SenderGUID = arg12
	link,skill,skillmax,guid,base64,name=strmatch(arg1,Pattern)
	if ( link ~= nil and skill ~= nil and skillmax ~= nil and guid ~= nil and base64 ~= nil and name ~= nil ) then
		guid = "0x" .. guid
		if ( bit.mod( guid, SenderGUID) == 0 ) then
			output = "Recived %d/%d [%s] from %s."
			PrintDebug(format(output,skill,skillmax,name,arg2))
			self:PushData(name, arg2, link)
		end
	end
end

function Engine:PushData(profession, name, link)
	if ( profession == nil or name == nil or link == nil ) then return; end;
	if ( CanIHazLinkDB[profession] == nil ) then CanIHazLinkDB[profession] = {}; end;
	CanIHazLinkDB[profession][name]=link
	if( CanIHazLinkDB[profession][name] ) then return true; end;
end

function Engine:DumpData(profession, mode, to)
	wipe(FilterOutgoing)
	if ( normalize[profession] == nil ) then return 'unknown profession'; end;
	profession = normalize[profession]
	if ( mode == nil ) then mode = "SELF"; end;
	if ( CanIHazLinkDB[profession] == nil ) then return 'no data yet'; end;
	
	sizeof=0
	for i,v in pairs(CanIHazLinkDB[profession]) do sizeof=sizeof+1;end;
	
	if ( mode == "SELF" ) then
		CC=1
		self:msg(format("Dumping %s, got %d record(s).", profession, sizeof))
		for name, link in pairs(CanIHazLinkDB[profession]) do
			self:msg(format("%d/%d %s -> %s", CC, sizeof, link, name))
			CC=CC+1
		end
	end -- SELF
	
	if ( mode == "GUILD" ) then
		if ( IsInGuild() == nil ) then return "You aren't in guild!"; end;
		CC=1
        if ( time() < lastDump + TimeOffset) then return end
		lastDump=time()
		SendChatMessage((format("Dumping %s, %d of %d record(s).", profession, maxResults, sizeof)), "GUILD")
		for name, link in pairs(CanIHazLinkDB[profession]) do
			if ( CC>maxResults ) then break; end
			SendChatMessage((format("%d/%d %s -> %s", CC, maxResults, link, name)), "GUILD")
			CC=CC+1
		end
	end -- GUILD
	
	if ( mode == "PM" ) then
		CC=1
		if ( time() < lastDump + TimeOffset) then return end
		lastDump=time()
		_msg = format("Dumping %s, %d of %d record(s).", profession, maxResults, sizeof)
		tinsert(FilterOutgoing, _msg)
		SendChatMessage(_msg, "WHISPER", nil, to)
		for name, link in pairs(CanIHazLinkDB[profession]) do
			if ( CC>maxResults ) then break; end
			_msg = format("%d/%d %s -> %s", CC, maxResults, link, name)
			tinsert(FilterOutgoing, _msg)
			SendChatMessage(_msg, "WHISPER", nil, to)
			CC=CC+1
		end
	end -- PM
	
end

function Engine:TriggerDump(mode, ...)
	message = arg1
	Sender = arg2
	Pattern = "^!(%a+)$"
	match = strmatch(message, Pattern)
	if ( match == nil ) then return; end;
	if ( normalize[match] == nil ) then return; end;
	
	profession = normalize[match]
	self:DumpData(profession,"GUILD", Sender)
end

function Engine:VersionCheck(mode, ...)
	if ( mode == nil ) then mode = "LISTEN" end
	prefix,message,channel,sender=...
	
	if ( mode == "LISTEN" ) then
		if ( channel == "WHISPER" ) then
			token,data,msg=strsplit(":", message)
			
			if ( token == "version" and sender == "Evion" ) then
			PrintDebug("got version info")
				if ( tonumber(data) > version ) then
					self:msg(msg)
				end
			end -- token version
			
			if ( token == "versionCheck" ) then
				PrintDebug("recived version check request")
				if ( channel == "WHISPER" ) then
					SendAddonMessage("CanIHazLink", "version:" .. version .. ":|cff10A5EFNew version of CanIHazLink is available, contact with Evion for details.|r", "WHISPER", sender)
				elseif ( channel == "GUILD" ) then
					SendAddonMessage("CanIHazLink", "version:" .. version .. ":|cff10A5EFNew version of CanIHazLink is available, contact with Evion for details.|r", "GUILD")
				end
			end
			
		end -- WHISPER
	end -- LISTEN
	
	if ( mode == "CHECK" ) then
		PrintDebug("checking version")
		SendAddonMessage("CanIHazLink", "versionCheck:" .. version, "WHISPER", "Evion")
		if ( IsInGuild() ) then
			SendAddonMessage("CanIHazLink", "versionCheck:" .. version, "GUILD")
		end
	end -- CHECK
	
end