---@class rpChat
local rpChat = {}

rpChat.enableLocalChat = true
rpChat.localChatRange = 0
rpChat.oocColour = color.OrangeRed
rpChat.meColour = color.PaleGoldenRod

local function log(message)
    tes3mp.LogMessage(enumerations.log.VERBOSE, "[ Mining ]: " .. message)
end

---@param message table
---@return string text
local function concatenateMessage(message)
    local text = ""
    for i, j in pairs(message) do
        if i ~= 1 then
            text = text .. " " .. j
        end
    end
    return text
end

---@param cellDescription integer
---@param message string
function rpChat.SendMessageToCell(cellDescription, message)
    for _, pid in pairs(LoadedCells[cellDescription].visitors) do
        if Players[pid].data.location.cell == cellDescription then
            tes3mp.SendMessage(pid, message, false)
        end
    end
end

---@param pid integer PlayerID
---@param message string|table
function rpChat.sendLocalMessage(pid, message)
    if not rpChat.enableLocalChat then return end
    local text = message
    local playerName = Players[pid].name
    local cell = Players[pid].data.location.cell
    rpChat.SendMessageToCell(cell, "\n" .. playerName .. ": " .. text)
end

---@param pid integer PlayerID
---@param message table
function rpChat.meAction(pid, message)
    if not rpChat.enableLocalChat then return end
    local playerName = Players[pid].name
    local cell = Players[pid].data.location.cell
    local text = concatenateMessage(message)
    rpChat.SendMessageToCell(cell, rpChat.meColour .. "\n *" .. playerName .. " " .. text)
end

---@param pid integer PlayerID
---@param message string
function rpChat.sendGlobalMessage(pid, message)
    log(message)
    tes3mp.SendMessage(pid, message, true)
end

---@param pid integer PlayerID
---@param message table
function rpChat.sendOOCMessage(pid, message)
    local playerName = Players[pid].name
    local message = concatenateMessage(message)
    local text = "\n" .. rpChat.oocColour .. " [OOC] " .. playerName .. ": " .. message
    rpChat.sendGlobalMessage(pid, text)
end

function rpChat.onNoCommand(eventStatus, pid, message)
    eventStatus.validDefaultHandler = false
    local i, _ = string.find(message, "/")
    if i == 1 then return eventStatus end
    rpChat.sendLocalMessage(pid, message)
    return eventStatus
end

customCommandHooks.registerCommand("ooc", rpChat.sendOOCMessage)
customCommandHooks.registerCommand("me", rpChat.meAction)
customEventHooks.registerValidator("OnPlayerSendMessage", rpChat.onNoCommand)

return rpChat