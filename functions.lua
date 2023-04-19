---@class functions
local functions = {}

---@param pid integer PlayerID
---@return vector3 playerCoordinates
function functions.getPlayerCoords(pid)
    return vec3(tes3mp.GetPosX(pid), tes3mp.GetPosY(pid), tes3mp.GetPosZ(pid))
end

---@param message string
function functions.log(message)
    tes3mp.LogMessage(enumerations.log.VERBOSE, "[ RPChat ]: " .. message)
end

---@param message table
---@return string text
function functions.concatenateMessage(message)
    local text = ""
    for i, j in pairs(message) do
        if i ~= 1 then
            text = text .. " " .. j
        end
    end
    return text
end

---@param pid integer Source PlayerID
---@param pidTarget integer pid of target player
---@param maxDisplacement integer Voice Range
---@param message string
function functions.sendRangedMessage(pid, pidTarget, maxDisplacement, message)
    if not pidTarget then return end
    local source, target = functions.getPlayerCoords(pid), functions.getPlayerCoords(pidTarget)
    if -(source - target) > maxDisplacement then return end

    tes3mp.SendMessage(pidTarget, message, false)
end

---@param pid integer Source Player ID
---@param message string
---@param maxDisplacement integer Voice Range 
function functions.RangedMethod(pid, message, maxDisplacement)
    local otherPlayers = functions.retrieveOtherPlayerInfo(pid)
    
    if next(otherPlayers) then 
        for tid in pairs(otherPlayers) do
            functions.sendRangedMessage(pid, tid, maxDisplacement, message)
        end
    end
    tes3mp.SendMessage(pid, message, false)
end

---@param pid integer Source PlayerID
function functions.retrieveOtherPlayerInfo(pid)
    local otherPlayers = {}
    for i in pairs(Players) do
        if i ~= pid then
            otherPlayers[#otherPlayers+1] = i
        end
    end
    return otherPlayers
end

return functions
