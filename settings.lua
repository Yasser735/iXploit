-- iXploit Settings Module
-- iOS 26 Style Settings

local settings = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Settings data
local settingsData = {
    uiScale = 100,
    fpsCap = 60,
    graphicsQuality = "Medium",
    animationsEnabled = true,
    darkMode = true,
    vibrationHaptic = true
}

-- UI module reference
local ui

-- Initialize settings
function settings:Init()
    -- Load saved settings
    if isfile("iXploit/settings.json") then
        local data = HttpService:JSONDecode(readfile("iXploit/settings.json"))
        for key, value in pairs(data) do
            settingsData[key] = value
        end
    else
        -- Save default settings
        self:SaveSettings()
    end
    
    -- Apply settings
    self:ApplySettings()
end

-- Save settings
function settings:SaveSettings()
    if not isfolder("iXploit") then
        makefolder("iXploit")
    end
    
    writefile("iXploit/settings.json", HttpService:JSONEncode(settingsData))
end

-- Apply settings
function settings:ApplySettings()
    -- Apply UI scale
    if ui and ui.currentContainer then
        ui.currentContainer.Size = UDim2.new(settingsData.uiScale / 100, 0, settingsData.uiScale / 100, 0)
    end
    
    -- Apply FPS cap
    if settingsData.fpsCap ~= "Unlimited" then
        setfpscap(settingsData.fpsCap)
    else
        setfpscap(999)
    end
    
    -- Apply graphics quality
    local lighting = game:GetService("Lighting")
    if settingsData.graphicsQuality == "Low" then
        settings().Rendering.QualityLevel = 1
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
    elseif settingsData.graphicsQuality == "Medium" then
        settings().Rendering.QualityLevel = 5
        lighting.GlobalShadows = true
        lighting.FogEnd = 1000
    elseif settingsData.graphicsQuality == "High" then
        settings().Rendering.QualityLevel = 8
        lighting.GlobalShadows = true
        lighting.FogEnd = 500
    elseif settingsData.graphicsQuality == "Ultra" then
        settings().Rendering.QualityLevel = 10
        lighting.GlobalShadows = true
        lighting.FogEnd = 200
    end
    
    -- Apply animations
    if not settingsData.animationsEnabled and ui then
        -- Disable UI animations
        ui.ANIMATION_SPEED = 0
    end
    
    -- Apply dark mode
    if ui then
        if settingsData.darkMode then
            ui.currentTheme = ui.THEME_COLORS.dark
        else
            ui.currentTheme = ui.THEME_COLORS.light
        end
    end
end

-- Show settings UI
function settings:ShowSettings(parent)
    if not ui then
        ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/iXploit/main/ui.lua"))()
    end
    
    -- Create settings container
    local settingsContainer = ui:CreateGlassEffect(parent, UDim2.new(0, 500, 0, 600), UDim2.new(0.5, -250, 0.5, -300))
    settingsContainer.ZIndex = 100
    
    -- Create title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Settings"
    title.TextColor3 = ui.currentTheme.text
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = settingsContainer
    
    -- Create close button
    local closeButton = ui:CreateButton("✕", UDim2.new(1, -40, 0, 10), UDim2.new(0, 30, 0, 30), function()
        -- Animate out and destroy
        local tweenOut = TweenService:Create(settingsContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -250, 1, 100),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            settingsContainer:Destroy()
        end)
    end)
    closeButton.Parent = settingsContainer
    
    -- Create settings scroll frame
    local settingsScroll = Instance.new("ScrollingFrame")
    settingsScroll.Size = UDim2.new(1, -20, 1, -80)
    settingsScroll.Position = UDim2.new(0, 10, 0, 70)
    settingsScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    settingsScroll.BackgroundTransparency = 1
    settingsScroll.BorderSizePixel = 0
    settingsScroll.ScrollBarThickness = 8
    settingsScroll.ScrollBarImageColor3 = ui.currentTheme.accent
    settingsScroll.Parent = settingsContainer
    
    -- Add padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = settingsScroll
    
    -- Add layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 15)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = settingsScroll
    
    -- UI Scale slider
    local uiScaleFrame = Instance.new("Frame")
    uiScaleFrame.Size = UDim2.new(1, 0, 0, 70)
    uiScaleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    uiScaleFrame.BackgroundTransparency = 1
    uiScaleFrame.Parent = settingsScroll
    
    -- UI Scale label
    local uiScaleLabel = Instance.new("TextLabel")
    uiScaleLabel.Size = UDim2.new(1, 0, 0, 30)
    uiScaleLabel.Position = UDim2.new(0, 0, 0, 0)
    uiScaleLabel.BackgroundTransparency = 1
    uiScaleLabel.Text = "UI Scale: " .. settingsData.uiScale .. "%"
    uiScaleLabel.TextColor3 = ui.currentTheme.text
    uiScaleLabel.TextScaled = true
    uiScaleLabel.Font = Enum.Font.Gotham
    uiScaleLabel.TextXAlignment = Enum.TextXAlignment.Left
    uiScaleLabel.Parent = uiScaleFrame
    
    -- UI Scale slider track
    local uiScaleTrack = Instance.new("Frame")
    uiScaleTrack.Size = UDim2.new(1, 0, 0, 10)
    uiScaleTrack.Position = UDim2.new(0, 0, 0, 40)
    uiScaleTrack.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    uiScaleTrack.BorderSizePixel = 0
    uiScaleTrack.Parent = uiScaleFrame
    
    -- Add rounded corners
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 5)
    trackCorner.Parent = uiScaleTrack
    
    -- UI Scale slider fill
    local uiScaleFill = Instance.new("Frame")
    uiScaleFill.Size = UDim2.new((settingsData.uiScale - 50) / 100, 0, 1, 0)
    uiScaleFill.Position = UDim2.new(0, 0, 0, 0)
    uiScaleFill.BackgroundColor3 = ui.currentTheme.accent
    uiScaleFill.BorderSizePixel = 0
    uiScaleFill.Parent = uiScaleTrack
    
    -- Add rounded corners
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = uiScaleFill
    
    -- UI Scale slider button
    local uiScaleButton = Instance.new("TextButton")
    uiScaleButton.Size = UDim2.new(0, 20, 0, 20)
    uiScaleButton.Position = UDim2.new((settingsData.uiScale - 50) / 100, -10, 0.5, -10)
    uiScaleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    uiScaleButton.Text = ""
    uiScaleButton.ZIndex = 2
    uiScaleButton.Parent = uiScaleTrack
    
    -- Add rounded corners
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = uiScaleButton
    
    -- UI Scale slider state
    local sliding = false
    
    -- Add mouse events
    uiScaleButton.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = uiScaleTrack.AbsolutePosition
            local trackSize = uiScaleTrack.AbsoluteSize
            
            local percent = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local value = 50 + 100 * percent
            
            -- Update slider position
            uiScaleButton.Position = UDim2.new(percent, -10, 0.5, -10)
            uiScaleFill.Size = UDim2.new(percent, 0, 1, 0)
            
            -- Update label
            uiScaleLabel.Text = "UI Scale: " .. math.floor(value) .. "%"
            
            -- Update setting
            settingsData.uiScale = math.floor(value)
            
            -- Apply setting
            if ui and ui.currentContainer then
                ui.currentContainer.Size = UDim2.new(settingsData.uiScale / 100, 0, settingsData.uiScale / 100, 0)
            end
        end
    end)
    
    -- FPS Cap dropdown
    local fpsCapOptions = {"30", "60", "120", "Unlimited"}
    local fpsCapFrame = ui:CreateDropdown("FPS Cap", fpsCapOptions, tostring(settingsData.fpsCap), UDim2.new(0, 0, 0, 0), function(option)
        settingsData.fpsCap = option
        
        -- Apply setting
        if option ~= "Unlimited" then
            setfpscap(tonumber(option))
        else
            setfpscap(999)
        end
        
        -- Save settings
        self:SaveSettings()
    end)
    fpsCapFrame.Parent = settingsScroll
    
    -- Graphics Quality dropdown
    local graphicsOptions = {"Low", "Medium", "High", "Ultra"}
    local graphicsFrame = ui:CreateDropdown("Graphics Quality", graphicsOptions, settingsData.graphicsQuality, UDim2.new(0, 0, 0, 60), function(option)
        settingsData.graphicsQuality = option
        
        -- Apply setting
        local lighting = game:GetService("Lighting")
        if option == "Low" then
            settings().Rendering.QualityLevel = 1
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
        elseif option == "Medium" then
            settings().Rendering.QualityLevel = 5
            lighting.GlobalShadows = true
            lighting.FogEnd = 1000
        elseif option == "High" then
            settings().Rendering.QualityLevel = 8
            lighting.GlobalShadows = true
            lighting.FogEnd = 500
        elseif option == "Ultra" then
            settings().Rendering.QualityLevel = 10
            lighting.GlobalShadows = true
            lighting.FogEnd = 200
        end
        
        -- Save settings
        self:SaveSettings()
    end)
    graphicsFrame.Parent = settingsScroll
    
    -- Animations toggle
    local animationsFrame = ui:CreateToggle("Enable Animations", UDim2.new(0, 0, 0, 120), function(state)
        settingsData.animationsEnabled = state
        
        -- Apply setting
        if not state and ui then
            ui.ANIMATION_SPEED = 0
        elseif ui then
            ui.ANIMATION_SPEED = 0.2
        end
        
        -- Save settings
        self:SaveSettings()
    end)
    animationsFrame.Parent = settingsScroll
    
    -- Dark Mode toggle
    local darkModeFrame = ui:CreateToggle("Dark Mode", UDim2.new(0, 0, 0, 180), function(state)
        settingsData.darkMode = state
        
        -- Apply setting
        if ui then
            if state then
                ui.currentTheme = ui.THEME_COLORS.dark
            else
                ui.currentTheme = ui.THEME_COLORS.light
            end
        end
        
        -- Save settings
        self:SaveSettings()
    end)
    darkModeFrame.Parent = settingsScroll
    
    -- Vibration Haptic toggle
    local hapticFrame = ui:CreateToggle("Vibration Haptic", UDim2.new(0, 0, 0, 240), function(state)
        settingsData.vibrationHaptic = state
        
        -- Save settings
        self:SaveSettings()
    end)
    hapticFrame.Parent = settingsScroll
    
    -- Animate in
    settingsContainer.Position = UDim2.new(0.5, -250, 1, 100)
    local tweenIn = TweenService:Create(settingsContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -250, 0.5, -300)
    })
    tweenIn:Play()
end

-- Initialize settings
settings:Init()

return settings