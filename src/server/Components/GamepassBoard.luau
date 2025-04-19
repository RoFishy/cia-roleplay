-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-- // Packages
local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Janitor = require(Packages.Janitor)

-- // Module
local GamepassBoard = Component.new({
    Tag = "GamepassBoard",
    Ancestors = { workspace }
})

function GamepassBoard:Construct()
    self._janitor = Janitor.new()
end

function GamepassBoard:Start()
    local PromptPart : Part = self.Required.PromptPart
    local ClickDetector : ClickDetector = PromptPart.ClickDetector
    local GamepassId : NumberValue = ClickDetector.GamepassID.Value
    
    self._janitor:Add(ClickDetector.MouseClick:Connect(function(Player  : Player)
        MarketplaceService:PromptGamePassPurchase(Player, GamepassId)
    end))
end

function GamepassBoard:Stop()
    self._janitor:Cleanup()
end

return GamepassBoard