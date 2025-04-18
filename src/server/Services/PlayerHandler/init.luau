-- // Services
local Players = game:GetService("Players")

-- // Utils
local Utils = script.Utils
local DataUtil = require(Utils.DataUtil)
local OverheadUtil = require(Utils.OverheadUtil)
local TeamUtil = require(Utils.TeamUtil)

-- // PlayerHandler
local PlayerHandler = {}

function PlayerHandler:Start()
    Players.PlayerAdded:Connect(function(player : Player)
        TeamUtil:AssignTeam(player) 
        DataUtil:CreateProfile(player)
        OverheadUtil:CreateOverhead(player)
        player.CharacterAdded:Connect(function(_)
            OverheadUtil:CreateOverhead(player)
        end)
    end)
    Players.PlayerRemoving:Connect(function(player)
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