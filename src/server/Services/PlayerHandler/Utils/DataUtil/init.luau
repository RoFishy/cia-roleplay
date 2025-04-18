-- // Services
local Players = game:GetService("Players")

-- // Util
local ProfileStore = require(script.ProfileStore)

-- // Template
export type ProfileTemplate = {
    Cash : number,
}

local PROFILE_TEMPLATE : ProfileTemplate =  {
    Cash = 0
}

-- // Store
local PlayerStore = ProfileStore.New("Player", PROFILE_TEMPLATE)

-- // Module
local DataUtil = {
    Profiles = {} :: {[Player]: typeof(PlayerStore:StartSessionAsync())}
}

function DataUtil:CreateProfile(Player : Player)
    local Profile = PlayerStore:StartSessionAsync(`{Player.UserId}`, {
        Cancel = function()
           return Player.Parent ~= Players
        end,
     })

     if Profile ~= nil then
        Profile:AddUserId(Player.UserId)
        Profile:Reconcile()

        Profile.OnSessionEnd:Connect(function()
            self.Profiles[Player] = nil
            Player:Kick("Profile session end - Please Rejoin")
        end)

        if Player.Parent == Players then
            self.Profiles[Player] = Profile
        end
    else
        Player:Kick("Profile load fail - Please rejoin")
    end
end

function DataUtil:EndSession(Player : Player)
    local Profile = self.Profiles[Player]
    if Profile ~= nil then
        Profile:EndSession()
    end
end

function DataUtil:IncrementCash(Player : Player, Amount : number)
    local Profile = self.Profiles[Player]
    if Profile ~= nil then
        Profile:Increment("Cash", Amount)
    else
        warn(("Profile not found for %s"):format(Player.Name))
    end
end

return DataUtil