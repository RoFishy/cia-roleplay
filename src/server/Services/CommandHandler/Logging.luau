-- // Services
local HttpService = game:GetService("HttpService")

-- // Config
local Config = require(script.Parent.Config)
local WebhookURL = Config.WebhookURL

-- // Logging
local Logging = {}

function Logging:LogCommand(
    Player : Player,
    Command : string,
    Args : {string}
)
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Command Executed",
            ["description"] = `**Command**: {Command}\n**Player**: {Player.Name}\n**Args**: {HttpService:JSONEncode(Args)}`,
            ["color"] = tonumber(0x0099ff),
            ["type"] = "rich"
        }}
    }

    HttpService:PostAsync(WebhookURL, HttpService:JSONEncode(data))
end

return Logging