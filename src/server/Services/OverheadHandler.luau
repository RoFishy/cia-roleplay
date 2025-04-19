-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Remotes
local Remotes = ReplicatedStorage.Remotes
local PlayerRemotes = Remotes.PlayerRemotes
local AddIcon = PlayerRemotes.AddIcon
local RemoveIcon = PlayerRemotes.RemoveIcon

local CreateOverhead = PlayerRemotes.CreateOverhead

-- // Utils
local Utils = script.Parent.Parent.Utils
local Signals = require(Utils.Signals)

local PlayerAdded = Signals.PlayerAdded
local AddIconSignal = Signals.AddIcon
local RemoveIconSignal = Signals.RemoveIcon

-- // Module
local OverheadHandler = {}

function OverheadHandler.Init()
    OverheadHandler.Players = {}
end

function OverheadHandler:Start()
    PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function()
            task.delay(.5, function()
                if self.Players[Player.Name] then
                    CreateOverhead:FireAllClients(Player, self.Players[Player.Name])
                else
                    CreateOverhead:FireAllClients(Player)
                end
            end)
        end)
    end)
    AddIconSignal:Connect(function(Player, Icon)
        if self.Players[Player.Name] then
            table.insert(self.Players[Player.Name], Icon)
        else
            self.Players[Player.Name] = {}
            table.insert(self.Players[Player.Name], Icon)
        end
        AddIcon:FireAllClients(Player, Icon)
    end)
    RemoveIconSignal:Connect(function(Player, Icon)
        if self.Players[Player.Name] then
            table.remove(self.Players[Player.Name], table.find(self.Players[Player.Name], Icon))
            RemoveIcon:FireAllClients(Player, Icon)
        end
    end)
end

return OverheadHandler