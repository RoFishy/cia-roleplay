-- // Services
local Players = game:GetService("Players")

-- // Utils
local Utils = script.Parent.Parent.Parent.Utils
local Signals = require(Utils.Signals)

-- // signals
local AddIcon = Signals.AddIcon
local RemoveIcon = Signals.RemoveIcon

-- // Objects
local Pads : Model = workspace.Pads

-- // Local Functions
local function GetPlayer(Partial : string)
    Partial = string.lower(Partial)
    local User = nil
    for _, Player in Players:GetPlayers() do
        if Player.Name:lower():sub(1, #Partial) == Partial then
            User = Player
        end
    end
    return User
end

return {
    clear = function(Args : {})
        if #Args ~= 1 then return end
        local Player = Args[1]
        Player = GetPlayer(Player)
        if Player then
            AddIcon:Fire(Player, "Access")
        end
    end,
    unclear = function(Args : {})
        if #Args ~= 1 then return end
        local Player = Args[1]
        Player = GetPlayer(Player)
        if Player then
            RemoveIcon:Fire(Player, "Access")
        end
    end,
    kos = function(Args : {})
        if #Args ~= 1 then return end
        local Player = Args[1]
        Player = GetPlayer(Player)
        if Player then
            AddIcon:Fire(Player, "KOS")
        end
    end,
    unkos = function(Args : {})
        if #Args ~= 1 then return end
        local Player = Args[1]
        Player = GetPlayer(Player)
        if Player then
            RemoveIcon:Fire(Player, "KOS")
        end
    end,
    lockpad = function(Args : {})
        if #Args ~= 1 then return end
        local Pad = Args[1]
        if Pad:lower() == "all" then
            for _, Part in Pads:GetDescendants() do
                if not Part:IsA("Part") then continue end
                Part.Transparency = 0
                Part.CanCollide = true
            end
        else
            Pad = Pads:FindFirstChild(tostring(Pad))
            if Pad then
                for _, Part in Pad:GetChildren() do
                    Part.Transparency = 0
                    Part.CanCollide = true
                end
            end
        end
    end,
    unlockpad = function(Args : {})
        if #Args ~= 1 then return end
        local Pad = Args[1]
        if Pad:lower() == "all" then
            for _, Part in Pads:GetDescendants() do
                if not Part:IsA("Part") then continue end
                Part.Transparency = 1
                Part.CanCollide = false
            end
        else
            Pad = Pads:FindFirstChild(tostring(Pad))
            if Pad then
                for _, Part in Pad:GetChildren() do
                    Part.Transparency = 1
                    Part.CanCollide = false
                end
            end
        end
    end
}