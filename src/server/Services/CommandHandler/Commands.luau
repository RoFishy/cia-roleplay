-- // Services
local Players = game:GetService("Players")

-- // Utils
local Utils = script.Parent.Parent.Parent.Utils
local Signals = require(Utils.Signals)

-- // signals
local AddIcon = Signals.AddIcon
local RemoveIcon = Signals.RemoveIcon

return {
    clear = function(Args : {})
        local Player = Args[1]
        Player = Players:FindFirstChild(Player)
        if Player then
            AddIcon:Fire(Player, "Access")
        end
    end,
    unclear = function(Args : {})
        local Player = Args[1]
        Player = Players:FindFirstChild(Player)
        if Player then
            RemoveIcon:Fire(Player, "Access")
        end
    end
}