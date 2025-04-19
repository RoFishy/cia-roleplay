-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PlayerRemotes = Remotes:WaitForChild("PlayerRemotes")

local CreateOverhead = PlayerRemotes.CreateOverhead
local AddIcon = PlayerRemotes.AddIcon
local RemoveIcon = PlayerRemotes.RemoveIcon

-- // Utils
local OverheadUtil = require(script.OverheadUtil)

-- // Controller
local OverheadController = {}

function OverheadController:Start()
    CreateOverhead.OnClientEvent:Connect(function(Player : Player, Icons : {string}?)
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Head = Character.Head

        if Head:FindFirstChildOfClass("BillboardGui") then
            Head:FindFirstChildOfClass("BillboardGui"):Destroy()
        end
        OverheadUtil:CreateOverhead(Player, Icons)
    end)
    AddIcon.OnClientEvent:Connect(function(Player : Player, IconName : string)
        OverheadUtil:AddIcon(Player, IconName)
    end)
    RemoveIcon.OnClientEvent:Connect(function(Player : Player, IconName : string)
        OverheadUtil:RemoveIcon(Player, IconName)
    end)
end

return OverheadController