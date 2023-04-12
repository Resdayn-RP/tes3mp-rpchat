---@class rpChat
local rpChat = {}

rpChat.TalkRange = 8
rpChat.YellRange = 15
rpChat.WhisperRange = 2
rpChat.oocColour = color.OrangeRed
rpChat.meColour = color.PaleGoldenRod
rpChat.yellColour = color.Blue
rpChat.whisperColour = color.Violet

rpChat.functions = require('custom.rpChat.functions')

---@param source integer sourcePlayerID
---@param message string
function rpChat.Talk(source, message)
    rpChat.functions.RangedMethod(source, message, rpChat.TalkRange)
end

---@param source integer sourcePlayerID
---@param message string
function rpChat.Yell(source, message)
    rpChat.functions.RangedMethod(source, message, rpChat.YellRange)
end

---@param source integer sourcePlayerID
---@param message string
function rpChat.Whisper(source, message)
    rpChat.functions.RangedMethod(source, message, rpChat.WhisperRange)
end

---@param pid integer Player ID
---@param message table
function rpChat.SendTalkMessage(pid, message)
    local message = rpChat.functions.concatenateMessage(message)
    rpChat.Talk(pid, "\n" .. message)
end

---@param pid integer Player ID
---@param message table
function rpChat.SendWhisperMessage(pid, message)
    local playerName = Players[pid].name
    local message = rpChat.functions.concatenateMessage(message)
    local text = "\n" .. rpChat.whisperColour .. " [WHISPER] " .. playerName .. ": " .. message
    rpChat.Whisper(pid, text)
end

---@param pid integer Player ID
---@param message table
function rpChat.SendYellMessage(pid, message)
    local playerName = Players[pid].name
    local message = rpChat.functions.concatenateMessage(message)
    local text = "\n" .. rpChat.yellColour .. " [YELL] " .. playerName .. ": " .. message
    rpChat.Yell(pid, text)
end

---@param pid integer PlayerID
---@param message table
function rpChat.meAction(pid, message)
    local playerName = Players[pid].name
    local text = rpChat.functions.concatenateMessage(message)
    rpChat.Talk(pid, rpChat.meColour .. "\n *" .. playerName .. " " .. text)
end

---@param eventStatus table
---@param pid integer PlayerID
---@param message string
function rpChat.sendOOCMessage(eventStatus, pid, message)
    eventStatus.validDefaultHandler = false
    local i, _ = string.find(message, "/")
    if i == 1 then return eventStatus end
    local playerName = Players[pid].name
    local text = "\n" .. rpChat.oocColour .. " [OOC] " .. playerName .. ": " .. message
    tes3mp.SendMessage(pid, text, true)
    return eventStatus
end

customCommandHooks.registerCommand("t", rpChat.SendTalkMessage)
customCommandHooks.registerCommand("me", rpChat.meAction)
customCommandHooks.registerCommand("whisper", rpChat.SendWhisperMessage)
customCommandHooks.registerCommand("yell", rpChat.SendYellMessage)
customEventHooks.registerValidator("OnPlayerSendMessage", rpChat.sendOOCMessage)

return rpChat