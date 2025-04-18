-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- //  Packages
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)

-- // Config
local Config = require(script.Config)

-- // TweenInfo
local IconTween = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

-- // Assets
local Assets : Folder = ReplicatedStorage.Assets
local Overhead : Folder = Assets.Overhead

local Icons = Overhead.Icons
local ProfileTemplate : BillboardGui = Overhead.Profile

-- // Local Functions
local function IsPlayerInGroup(Player : Player)
    return Promise.new(function(resolve)
        resolve(Player:IsInGroup(Config.GroupId))
    end)
end

local function GetRoleInGroup(Player : Player)
    return Promise.new(function(resolve)
        resolve(Player:GetRoleInGroup(Config.GroupId))
    end)
end

local function GetRankInGroup(Player : Player)
    return Promise.new(function(resolve)
        resolve(Player:GetRankInGroup(Config.GroupId))
    end)
end

-- // Util
local OverheadUtil = {
    Players = {}
}

function OverheadUtil:CreateOverhead(Player : Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()

    local OverheadClone = ProfileTemplate:Clone()
    OverheadClone.Parent = Character.Head

    local RankLabel : TextLabel = OverheadClone.Rank.Text
    local RankShadow : TextLabel = OverheadClone.Rank.Shadow

    local NameLabel = OverheadClone:FindFirstChild("Name").Text
    local NameShadow = OverheadClone:FindFirstChild("Name").Shadow

    if Config.NameCase == "Upper" then
        NameLabel.Text = Player.Name:upper()
    elseif Config.NameCase == "Lower" then
        NameLabel.Text = Player.Name:lower()
    end

    NameShadow.Text = NameLabel.Text

    IsPlayerInGroup(Player):andThen(function(InGroup)
        if InGroup then
            GetRoleInGroup(Player):andThen(function(Role)
                if Config.RankCase == "Upper" then
                    Role = Role:upper()
                elseif Config.RankCase == "Lower" then
                    Role = Role:lower()
                end
                RankLabel.Text = `{Config.RankEndings} {Role} {Config.RankEndings}`
                RankShadow.Text = RankLabel.Text
            end):catch(warn)
        else
            RankLabel.Text = Config.DefaultRank
            RankShadow.Text = RankLabel.Text
        end
    end):andThen(function()
        RankLabel.TextColor3 = Player.Team and Player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
    end):catch(warn)

    if table.find(self.Players, Player) then
        for _, Icon in self.Players[Player].Icons do
            self:AddIcon(Player, Icon)
        end
    else
        self.Players[Player.Name] = {
            Icons = {}
        }
    end

    GetRankInGroup(Player):andThen(function(Rank)
        if Rank == Config.DeveloperRank then
            self:AddIcon(Player, "Developer")
        end
    end):catch(warn)

    Character.Humanoid.Died:Connect(function()
        OverheadClone:Destroy()
    end)
end

function OverheadUtil:AddIcon(Player : Player, IconName : string)
    local Icon = Icons:FindFirstChild(IconName)
    assert(Icon, "Icon not found")
    table.insert(self.Players[Player.Name].Icons, IconName)

    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Head = Character.Head

    local PlayerOverhead = Head:FindFirstChild("Profile")
    local IconsHolder = PlayerOverhead.Icons

    local IconClone = Icon:Clone()
    IconClone.Shadow.ImageTransparency = 1
    Icon.ImageTransparency = 1

    IconClone.Parent = IconsHolder

    TweenService:Create(IconClone, IconTween, {ImageTransparency = 0}):Play()
    TweenService:Create(IconClone.Shadow, IconTween, {ImageTransparency = 0}):Play()
end

function OverheadUtil:RemoveIcon(Player : Player, IconName : string)
    if table.find(self.Players[Player.Name].Icons, IconName) then
        table.remove(self.Players[Player.Name].Icons, table.find(self.Players[Player.Name].Icons, IconName))
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Head = Character.Head

        local PlayerOverhead = Head:FindFirstChild("Profile")

        local IconsHolder = PlayerOverhead.Icons
        local Icon = IconsHolder:FindFirstChild(IconName)

        if Icon then
            TweenService:Create(Icon, IconTween, {ImageTransparency = 1}):Play()
            TweenService:Create(Icon.Shadow, IconTween, {ImageTransparency = 1}):Play()
            task.wait(.3)
            Icon:Destroy()
        end
    else
        warn(`Icon {IconName} not found for {Player.Name}`)
    end
end

return OverheadUtil