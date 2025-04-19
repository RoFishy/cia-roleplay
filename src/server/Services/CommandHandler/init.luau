-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Modules
local Modules = ReplicatedStorage.Modules
local GroupUtils = require(Modules.GroupUtils)

-- // Utils
local Utils = script.Parent.Parent.Utils
local Signals = require(Utils.Signals)

local PlayerAdded = Signals.PlayerAdded

-- // modules
local Commands = require(script.Commands)
local Config = require(script.Config)

-- // Module
local CommandHandler = {}

function CommandHandler:Start()
    PlayerAdded:Connect(function(Player : Player)
        GroupUtils:GetRankInGroup(Player):andThen(function(Rank)
            if Rank >= Config.MinRank then
                Player.Chatted:Connect(function(Message : string, _)
                    local Args = Message:split(" ")
                    local CommandName = Args[1]
                    table.remove(Args, 1)
                    if CommandName:split("")[1] == Config.Prefix then
                        Commands[CommandName:sub(2):lower()](Args)
                    end
                end)
            end
        end)
    end)
end

return CommandHandler