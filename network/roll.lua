module 'CanIHazLink.network.roll'

local CanIHazLink = require 'CanIHazLink'
local network = require 'CanIHazLink.network.core'
local SEPARATOR = network.SEPARATOR

local player = UnitName'player'
local lockdown
local rolls = {}
local callback
local f = CreateFrame'Frame'
f.elapsed = 0
f:Hide()

f:SetScript('OnUpdate', function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > 2 then
		lockdown = nil
		self.elapsed = 0
		this:Hide()
		
		on_lockdown_release()
	end
end)

M.ROLL_SEND = 'roll'

--CanIHazLink.register("CHAT_MSG_GUILD", on_message)

M.contains = function(name)
	for k,v in ipairs(rolls) do
		if v[1] == name then
			return k
		end
	end
	return
end

M.sortroll = function()
	sort(rolls, function(a, b)
		if a[2] == b[2] then
			return a[1] < b[1]
		end
		return a[2] > b[2]
	end)
end

function on_lockdown_release()
    sortroll()
    if not rolls[1] then return end
    
    if rolls[1][1] == player then
        callback()
    end
    
    rolls = {}
end

function on_network_in()
    if arg1 ~= network.PREFIX or arg3 ~= 'GUILD' then return end
    
    local arguments = CanIHazLink.tokenize(arg2, '[^'..SEPARATOR..']+')
    
    --for k, v in ipairs(arguments) do
    --    CanIHazLink.print('arguments['..k..'] = '..v)
    --end
    
    if not arguments[3] then return end
    
    if arguments[3] == ROLL_SEND then
        if not contains(arg4) then
            table.insert(rolls, {arg4, tonumber(arguments[4])} )
        end
    end
end

function M.do_roll(userfunc)
    if lockdown then return end
    callback = userfunc
    SendAddonMessage(network.PREFIX, network.BEGIN..ROLL_SEND..SEPARATOR..random(1, 100), 'GUILD')
    lockdown = true
    f:Show()
end

CanIHazLink.register("CHAT_MSG_ADDON", on_network_in)
