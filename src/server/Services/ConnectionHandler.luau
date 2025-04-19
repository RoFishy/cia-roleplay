-- // Services
local Players = game:GetService("Players")

-- //  Utils
local Utils = script.Parent.Parent.Utils
local Signals = require(Utils.Signals)

-- // Module
local ConnectionHandler = {}

function ConnectionHandler:Start()
    Players.PlayerAdded:Connect(function(player)
        Signals.PlayerAdded:Fire(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        Signals.PlayerRemoving:Fire(player)
    end)
end

return ConnectionHandler