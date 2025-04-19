-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- // Config
local Config = require(script.Config)
local DefaultGroupId = Config.GroupId

-- // GroupUtils
local GroupUtils = {}

function GroupUtils:IsPlayerInGroup(Player : Player, GroupId : number?) : boolean
    GroupId = GroupId or DefaultGroupId
    return Promise.new(function(resolve)
        resolve(Player:IsInGroup(GroupId))
    end)
end

function GroupUtils:GetRoleInGroup(Player : Player, GroupId : number?) : string
    GroupId = GroupId or DefaultGroupId
    return Promise.new(function(resolve)
        resolve(Player:GetRoleInGroup(GroupId))
    end)
end

function GroupUtils:GetRankInGroup(Player : Player, GroupId : number?) : number
    GroupId = GroupId or DefaultGroupId
    return Promise.new(function(resolve)
        resolve(Player:GetRankInGroup(GroupId))
    end)
end

return GroupUtils