-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Packages
local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

return {
    PlayerAdded = Signal.new(),
    PlayerRemoving = Signal.new(),

    AddIcon = Signal.new(),
    RemoveIcon = Signal.new(),
}