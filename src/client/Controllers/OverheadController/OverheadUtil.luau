-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- // Modules
local Modules = ReplicatedStorage:WaitForChild("Modules")
local GroupUtils = require(Modules.GroupUtils)

-- // Config
local Config = require(script.Parent.Config)

-- // TweenInfo
local IconTween = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

-- // Assets
local Assets : Folder = ReplicatedStorage.Assets
local Overhead : Folder = Assets.Overhead

local Icons = Overhead.Icons
local ProfileTemplate : BillboardGui = Overhead.Profile

-- // Util
local OverheadUtil = {}

function OverheadUtil:CreateOverhead(Player : Player, IconsToAdd : {string}?)
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

    GroupUtils:IsPlayerInGroup(Player):andThen(function(InGroup)
        if InGroup then
            GroupUtils:GetRoleInGroup(Player):andThen(function(Role)
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

    if IconsToAdd then
        for _, Icon in IconsToAdd do
            self:AddIcon(Player, Icon)
        end
    end

    GroupUtils:GetRankInGroup(Player):andThen(function(Rank)
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
end

return OverheadUtil