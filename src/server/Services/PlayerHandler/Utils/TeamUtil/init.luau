-- // Services
local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- // Config
local Config = require(script.Config)

-- // Local Functions
local function GetRankInGroup(Player : Player)
    return Promise.new(function(resolve)
        resolve(Player:GetRankInGroup(Config.GroupId))
    end)
end

-- // Utils
local TeamUtil = {}

function TeamUtil:AssignTeam(Player : Player)
    GetRankInGroup(Player):andThen(function(Rank)
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