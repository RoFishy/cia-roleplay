-- // Services
local Players = game:GetService("Players")

-- // Utils
local Utils = script.Utils
local DataUtil = require(Utils.DataUtil)
local TeamUtil = require(Utils.TeamUtil)

-- // Server Utils
local ServerUtils = script.Parent.Parent.Utils
local Signals = require(ServerUtils.Signals)

local PlayerAdded = Signals.PlayerAdded
local PlayerRemoving = Signals.PlayerRemoving

-- // PlayerHandler
local PlayerHandler = {}

function PlayerHandler:Start()
    PlayerAdded:Connect(function(player)
        TeamUtil:AssignTeam(player) 
        DataUtil:CreateProfile(player)
    end)
    PlayerRemoving:Connect(function(player)
        DataUtil:EndSession(player)
    end)

    for _, Player in Players:GetPlayers() do
        DataUtil:CreateProfile(Player)
    end
end

function PlayerHandler:GetProfile(Player : Player) : DataUtil.ProfileTemplate
    return DataUtil.Profiles[Player]
end

return PlayerHandler