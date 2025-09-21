-- iXploit Main Loader
-- iOS 26 Liquid Glass UI

local iXploit = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Load all modules
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yasser735/iXploit/refs/heads/main/ui.lua"))()
local features = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/iXploit/main/features.lua"))()
local settings = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/iXploit/main/settings.lua"))()
local keysystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/iXploit/main/keysystem.lua"))()

-- Initialize iXploit
function iXploit:Init()
    -- Create main screen GUI
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "iXploit"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = game:GetService("CoreGui")
    
    -- Show splash screen first
    ui:ShowSplashScreen(self.screenGui, function()
        -- After splash, check if user is logged in
        if not self:CheckLogin() then
            ui:ShowLoginPage(self.screenGui, function(username)
                self:Login(username)
            end)
        else
            -- Check key
            if not keysystem:HasValidKey() then
                ui:ShowKeySystem(self.screenGui, function(key)
                    if keysystem:VerifyKey(key) then
                        self:ShowMainUI()
                    else
                        ui:ShowError("Invalid key!")
                    end
                end)
            else
                self:ShowMainUI()
            end
        end
    end)
end

function iXploit:CheckLogin()
    -- Check if user data exists
    if not isfolder("iXploit") then
        makefolder("iXploit")
    end
    
    if isfile("iXploit/user.json") then
        local data = HttpService:JSONDecode(readfile("iXploit/user.json"))
        self.username = data.username
        return true
    end
    
    return false
end

function iXploit:Login(username)
    self.username = username
    
    -- Save user data
    local userData = {
        username = username
    }
    writefile("iXploit/user.json", HttpService:JSONEncode(userData))
    
    -- Show key system
    ui:ShowKeySystem(self.screenGui, function(key)
        if keysystem:VerifyKey(key) then
            self:ShowMainUI()
        else
            ui:ShowError("Invalid key!")
        end
    end)
end

function iXploit:ShowMainUI()
    ui:ShowMainUI(self.screenGui, self.username, function()
        -- Settings button clicked
        settings:ShowSettings(self.screenGui)
    end)
    
    -- Auto-detect game
    self:DetectGame()
end

function iXploit:DetectGame()
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    
    -- Check supported games
    local supportedGames = {
        ["Steal Brainrot"] = "brainrot",
        ["Fisch"] = "fisch",
        ["Fish It"] = "fishit",
        ["Parkour"] = "parkour"
    }
    
    for name, id in pairs(supportedGames) do
        if string.find(gameName, name) or string.find(name, gameName) then
            ui:SelectGame(id)
            features:LoadGameFeatures(id)
            return
        end
    end
    
    -- Default to universal if no match
    ui:SelectGame("universal")
    features:LoadGameFeatures("universal")
end

-- Initialize iXploit
iXploit:Init()
