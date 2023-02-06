---@class rpChat
local rpChat = {}

rpChat.enableLocalChat = true
rpChat.localChatRange = 0
rpChat.oocColour = color.OrangeRed
rpChat.meColour = color.PaleGoldenRod

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
---@param message string
function rpChat.sendLocalMessage(pid, message)
    if not rpChat.enableLocalChat then return end
    local playerName = Players[pid].name
    local cell = Players[pid].data.location.cell

    rpChat.SendMessageToCell(cell, "\n" .. playerName .. ": " .. message)
end

---@param pid integer PlayerID
---@param message string
function rpChat.meAction(pid, message)
    if not rpChat.enableLocalChat then return end
    local playerName = Players[pid].name
    local cell = Players[pid].data.location.cell
    rpChat.SendMessageToCell(cell, rpChat.meColour .. "\n *" .. playerName .. " " .. message[2])
end

---@param pid integer PlayerID
---@param message string
function rpChat.sendGlobalMessage(pid, message)
    tes3mp.SendMessage(pid, message, true)
end

---@param pid integer PlayerID
---@param message table
function rpChat.sendOOCMessage(pid, message)
    local playerName = Players[pid].name
    local text = rpChat.oocColour .. "\n [OOC] " .. playerName .. ": " .. message[2]
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