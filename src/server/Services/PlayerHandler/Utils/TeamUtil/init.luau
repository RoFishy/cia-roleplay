-- // Services
local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Modules
local Modules = ReplicatedStorage.Modules
local GroupUtils = require(Modules.GroupUtils)

-- // Config
local Config = require(script.Config)

-- // Utils
local TeamUtil = {}

function TeamUtil:AssignTeam(Player : Player)
    GroupUtils:GetRankInGroup(Player):andThen(function(Rank)
        local HighestRank
        for RankConstraint, _ in Config.Ranks do
            if not HighestRank then
                HighestRank = RankConstraint
            end
            if Rank >= RankConstraint and Rank >= HighestRank then
                HighestRank = RankConstraint
            end
        end
        local Team = Config.Ranks[HighestRank]
        Player.Team = Teams:FindFirstChild(Team)
    end):catch(warn)
end

return TeamUtil