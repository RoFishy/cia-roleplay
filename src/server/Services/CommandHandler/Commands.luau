-- // Services
local Players = game:GetService("Players")

-- // Utils
local Utils = script.Parent.Parent.Parent.Utils
local Signals = require(Utils.Signals)

-- // signals
local AddIcon = Signals.AddIcon
local RemoveIcon = Signals.RemoveIcon

-- // Local Functions
local function GetPlayer(Partial : string)
    Partial = string.lower(Partial)
    local User = nil
    for _, Player in Players:GetPlayers() do
        if Player.Name:lower():sub(1, #Partial) == Partial then
            User = Player
        end
    end
    return User
end

return {
    clear = function(Args : {})
        local Player = Args[1]
        Player = GetPlayer(Player)
        if Player then
            AddIcon:Fire(Player, "Access")
        end
    end,
    unclear = function(Args : {})
        local Player = Args[1]
        Player = GetPlayer(Player)
        if Player then
            RemoveIcon:Fire(Player, "Access")
        end
    end
}