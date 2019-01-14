module 'CanIHazLink.network.version'

local CanIHazLink = require 'CanIHazLink'
local network = require 'CanIHazLink.network.core'
local version = CanIHazLink.version

M.SEND = 'versionCheck'
M.RECV = 'version'

local prefix_send = SEND .. network.SEPARATOR .. version
local prefix_recv = RECV .. network.SEPARATOR .. version

function send_version()
    SendAddonMessage(network.PREFIX, prefix_send, 'WHISPER', 'Evion')
    if IsInGuild()then
        SendAddonMessage(network.PREFIX, prefix_send, 'GUILD')
    end
end

function recv_version()
    local prefix, message, channel, sender = arg1, arg2, arg3, arg4
    local token, data, msg = strsplit(network.SEPARATOR, message)
    
    if token == RECV and sender == 'Evion' then
        if tonumber(data) > version then
            CanIHazLink.print(msg)
        end
    end
    
    if token == SEND then
        if channel == 'WHISPER' then
            reply_version(channel, sender)
        elseif channel == 'GUILD' then
            reply_version(channel)
        end
    end
end

function reply_version(channel, sender)
    SendAddonMessage(network.PREFIX, prefix_recv .. network.SEPARATOR .. 'New version is available, contact Evion for details.', channel, sender)
end

CanIHazLink.register("ADDON_LOADED", function()
    if arg1 ~= "CanIHazLink" then return end
    send_version()
end)

CanIHazLink.register("CHAT_MSG_ADDON", function()
    if arg1 ~= network.PREFIX then return end
	recv_version()
end)
