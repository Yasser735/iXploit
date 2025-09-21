-- iXploit UI Module
-- iOS 26 Liquid Glass Design

local ui = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- iOS 26 Liquid Glass Style Constants
local GLASS_BLUR = 28
local TRANSPARENCY = 0.18
local RIPPLE_SPEED = 0.3
local ANIMATION_SPEED = 0.2
local THEME_COLORS = {
    light = {
        background = Color3.fromRGB(242, 242, 247),
        text = Color3.fromRGB(0, 0, 0),
        accent = Color3.fromRGB(0, 122, 255),
        glass = Color3.fromRGB(255, 255, 255)
    },
    dark = {
        background = Color3.fromRGB(0, 0, 0),
        text = Color3.fromRGB(255, 255, 255),
        accent = Color3.fromRGB(0, 122, 255),
        glass = Color3.fromRGB(30, 30, 30)
    }
}

-- Current theme (default to dark)
local currentTheme = THEME_COLORS.dark
local currentGame = "universal"

-- Create liquid glass effect
function ui:CreateGlassEffect(parent, size, position)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = currentTheme.glass
    frame.BackgroundTransparency = TRANSPARENCY
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    -- Add blur effect
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.Position = UDim2.new(0, 0, 0, 0)
    blur.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    blur.BackgroundTransparency = 1
    blur.BorderSizePixel = 0
    blur.Parent = frame
    
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = GLASS_BLUR
    blurEffect.Parent = blur
    
    -- Add subtle shadow
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, 5, 0, 5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 16)
    shadowCorner.Parent = shadow
    
    return frame
end

-- Create ripple effect for buttons
function ui:AddRippleEffect(button)
    button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundColor3 = currentTheme.accent
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        ripple.ZIndex = button.ZIndex + 1
        ripple.Parent = button
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        
        local position = UDim2.new(
            0, (UserInputService:GetMouseLocation().X - button.AbsolutePosition.X),
            0, (UserInputService:GetMouseLocation().Y - button.AbsolutePosition.Y)
        )
        ripple.Position = position
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        local tween = TweenService:Create(ripple, TweenInfo.new(RIPPLE_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            Position = position - UDim2.new(0, maxSize/2, 0, maxSize/2),
            BackgroundTransparency = 1
        })
        
        tween:Play()
        tween.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

-- Create iOS-style button
function ui:CreateButton(text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 200, 0, 50)
    button.Position = position
    button.BackgroundColor3 = currentTheme.accent
    button.BackgroundTransparency = 0
    button.Text = text
    button.TextColor3 = currentTheme.light.text
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = self.currentContainer
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button
    
    -- Add ripple effect
    self:AddRippleEffect(button)
    
    -- Add callback
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- Create iOS-style input
function ui:CreateInput(placeholder, position, size)
    local inputFrame = self:CreateGlassEffect(self.currentContainer, size or UDim2.new(0, 300, 0, 50), position)
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, -10)
    input.Position = UDim2.new(0, 10, 0, 5)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.TextColor3 = currentTheme.text
    input.TextScaled = true
    input.Font = Enum.Font.Gotham
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = inputFrame
    
    return input
end

-- Show splash screen
function ui:ShowSplashScreen(parent, callback)
    self.currentContainer = Instance.new("Frame")
    self.currentContainer.Size = UDim2.new(1, 0, 1, 0)
    self.currentContainer.Position = UDim2.new(0, 0, 0, 0)
    self.currentContainer.BackgroundColor3 = currentTheme.background
    self.currentContainer.Parent = parent
    
    -- Create logo container
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 200, 0, 200)
    logoContainer.Position = UDim2.new(0.5, -100, 0.5, -100)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = self.currentContainer
    
    -- Create logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0.8, 0, 0.8, 0)
    logo.Position = UDim2.new(0.1, 0, 0.1, 0)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://1234567890" -- Replace with actual logo ID
    logo.Parent = logoContainer
    
    -- Create ripple effect for logo
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.BackgroundColor3 = currentTheme.accent
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = logo.ZIndex - 1
    ripple.Parent = logoContainer
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    
    -- Animate ripple
    local maxSize = math.max(logoContainer.AbsoluteSize.X, logoContainer.AbsoluteSize.Y) * 2
    
    local tween = TweenService:Create(ripple, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0.5, -maxSize/2, 0.5, -maxSize/2),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    
    -- Fade in logo
    logo.ImageTransparency = 1
    local fadeIn = TweenService:Create(logo, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0
    })
    fadeIn:Play()
    
    -- Wait for animation to complete
    game:GetService("Debris"):AddItem(ripple, 1.5)
    
    -- Call callback after delay
    spawn(function()
        wait(2)
        callback()
    end)
end

-- Show login page
function ui:ShowLoginPage(parent, callback)
    -- Clear previous container
    if self.currentContainer then
        self.currentContainer:Destroy()
    end
    
    self.currentContainer = Instance.new("Frame")
    self.currentContainer.Size = UDim2.new(1, 0, 1, 0)
    self.currentContainer.Position = UDim2.new(0, 0, 0, 0)
    self.currentContainer.BackgroundColor3 = currentTheme.background
    self.currentContainer.Parent = parent
    
    -- Create login container
    local loginContainer = self:CreateGlassEffect(self.currentContainer, UDim2.new(0, 400, 0, 300), UDim2.new(0.5, -200, 0.5, -150))
    
    -- Create title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "iXploit"
    title.TextColor3 = currentTheme.text
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = loginContainer
    
    -- Create username input
    local usernameInput = self:CreateInput("Username", UDim2.new(0, 50, 0, 100), UDim2.new(0, 300, 0, 50))
    usernameInput.Parent = loginContainer
    
    -- Create login button
    local loginButton = self:CreateButton("Masuk", UDim2.new(0.5, -100, 0, 200), UDim2.new(0, 200, 0, 50), function()
        if usernameInput.Text ~= "" then
            callback(usernameInput.Text)
        end
    end)
    loginButton.Parent = loginContainer
end

-- Show key system
function ui:ShowKeySystem(parent, callback)
    -- Clear previous container
    if self.currentContainer then
        self.currentContainer:Destroy()
    end
    
    self.currentContainer = Instance.new("Frame")
    self.currentContainer.Size = UDim2.new(1, 0, 1, 0)
    self.currentContainer.Position = UDim2.new(0, 0, 0, 0)
    self.currentContainer.BackgroundColor3 = currentTheme.background
    self.currentContainer.Parent = parent
    
    -- Create key container
    local keyContainer = self:CreateGlassEffect(self.currentContainer, UDim2.new(0, 400, 0, 350), UDim2.new(0.5, -200, 0.5, -175))
    
    -- Create title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "Key System"
    title.TextColor3 = currentTheme.text
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = keyContainer
    
    -- Create key input
    local keyInput = self:CreateInput("Masukkan Key", UDim2.new(0, 50, 0, 100), UDim2.new(0, 300, 0, 50))
    keyInput.Parent = keyContainer
    
    -- Create verify button
    local verifyButton = self:CreateButton("Verify Key", UDim2.new(0.5, -100, 0, 180), UDim2.new(0, 200, 0, 50), function()
        if keyInput.Text ~= "" then
            callback(keyInput.Text)
        end
    end)
    verifyButton.Parent = keyContainer
    
    -- Create get key button
    local getKeyButton = self:CreateButton("Get Key", UDim2.new(0.5, -100, 0, 250), UDim2.new(0, 200, 0, 50), function()
        -- Open link in browser
        local link = "https://link-key.com" -- Replace with actual link
        if syn and syn.write_clipboard then
            syn.write_clipboard(link)
            self:ShowNotification("Link copied to clipboard!")
        else
            self:ShowNotification("Visit: " .. link)
        end
    end)
    getKeyButton.Parent = keyContainer
end

-- Show main UI
function ui:ShowMainUI(parent, username, settingsCallback)
    -- Clear previous container
    if self.currentContainer then
        self.currentContainer:Destroy()
    end
    
    self.currentContainer = Instance.new("Frame")
    self.currentContainer.Size = UDim2.new(1, 0, 1, 0)
    self.currentContainer.Position = UDim2.new(0, 0, 0, 0)
    self.currentContainer.BackgroundColor3 = currentTheme.background
    self.currentContainer.Parent = parent
    
    -- Create top navbar
    local navbar = self:CreateGlassEffect(self.currentContainer, UDim2.new(1, 0, 0, 70), UDim2.new(0, 0, 0, 0))
    
    -- Create logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 40, 0, 40)
    logo.Position = UDim2.new(0, 20, 0, 15)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://1234567890" -- Replace with actual logo ID
    logo.Parent = navbar
    
    -- Create username text
    local usernameText = Instance.new("TextLabel")
    usernameText.Size = UDim2.new(0, 200, 0, 40)
    usernameText.Position = UDim2.new(0, 70, 0, 15)
    usernameText.BackgroundTransparency = 1
    usernameText.Text = "Hello, " .. username
    usernameText.TextColor3 = currentTheme.text
    usernameText.TextScaled = true
    usernameText.Font = Enum.Font.Gotham
    usernameText.TextXAlignment = Enum.TextXAlignment.Left
    usernameText.Parent = navbar
    
    -- Create settings button
    local settingsButton = self:CreateButton("⚙", UDim2.new(1, -60, 0, 15), UDim2.new(0, 40, 0, 40), settingsCallback)
    settingsButton.Parent = navbar
    
    -- Check if mobile or PC
    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    
    if isMobile then
        -- Mobile layout
        self:CreateMobileLayout()
    else
        -- PC layout
        self:CreatePCLayout()
    end
end

-- Create PC layout
function ui:CreatePCLayout()
    -- Create sidebar
    local sidebar = self:CreateGlassEffect(self.currentContainer, UDim2.new(0, 250, 1, -70), UDim2.new(0, 0, 0, 70))
    
    -- Create game list
    local gameList = {
        {name = "Universal", icon = "🌍", id = "universal"},
        {name = "Steal Brainrot", icon = "🧠", id = "brainrot"},
        {name = "Fisch", icon = "🎣", id = "fisch"},
        {name = "Fish It", icon = "🐟", id = "fishit"},
        {name = "Parkour", icon = "🏃", id = "parkour"}
    }
    
    local yPos = 20
    for _, game in pairs(gameList) do
        local gameButton = Instance.new("TextButton")
        gameButton.Size = UDim2.new(1, -20, 0, 50)
        gameButton.Position = UDim2.new(0, 10, 0, yPos)
        gameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        gameButton.BackgroundTransparency = 1
        gameButton.Text = game.icon .. " " .. game.name
        gameButton.TextColor3 = currentTheme.text
        gameButton.TextScaled = true
        gameButton.Font = Enum.Font.Gotham
        gameButton.TextXAlignment = Enum.TextXAlignment.Left
        gameButton.Parent = sidebar
        
        -- Add highlight on hover
        gameButton.MouseEnter:Connect(function()
            gameButton.BackgroundTransparency = 0.9
        end)
        
        gameButton.MouseLeave:Connect(function()
            gameButton.BackgroundTransparency = 1
        end)
        
        -- Add click event
        gameButton.MouseButton1Click:Connect(function()
            self:SelectGame(game.id)
            -- Load game features
            if self.loadGameFeatures then
                self.loadGameFeatures(game.id)
            end
        end)
        
        yPos = yPos + 60
    end
    
    -- Create main panel
    self.mainPanel = self:CreateGlassEffect(self.currentContainer, UDim2.new(1, -250, 1, -70), UDim2.new(0, 250, 0, 70))
    
    -- Create features container
    self.featuresContainer = Instance.new("ScrollingFrame")
    self.featuresContainer.Size = UDim2.new(1, -20, 1, -20)
    self.featuresContainer.Position = UDim2.new(0, 10, 0, 10)
    self.featuresContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.featuresContainer.BackgroundTransparency = 1
    self.featuresContainer.BorderSizePixel = 0
    self.featuresContainer.ScrollBarThickness = 8
    self.featuresContainer.ScrollBarImageColor3 = currentTheme.accent
    self.featuresContainer.Parent = self.mainPanel
    
    -- Add padding to scrolling frame
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = self.featuresContainer
    
    -- Add layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = self.featuresContainer
end

-- Create mobile layout
function ui:CreateMobileLayout()
    -- Create game selector
    local gameSelector = self:CreateGlassEffect(self.currentContainer, UDim2.new(1, 0, 0, 80), UDim2.new(0, 0, 0, 70))
    
    -- Create game list
    local gameList = {
        {name = "Universal", icon = "🌍", id = "universal"},
        {name = "Steal Brainrot", icon = "🧠", id = "brainrot"},
        {name = "Fisch", icon = "🎣", id = "fisch"},
        {name = "Fish It", icon = "🐟", id = "fishit"},
        {name = "Parkour", icon = "🏃", id = "parkour"}
    }
    
    -- Create scrolling frame for games
    local gameScroll = Instance.new("ScrollingFrame")
    gameScroll.Size = UDim2.new(1, -20, 1, -10)
    gameScroll.Position = UDim2.new(0, 10, 0, 5)
    gameScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gameScroll.BackgroundTransparency = 1
    gameScroll.BorderSizePixel = 0
    gameScroll.ScrollBarThickness = 0
    gameScroll.ScrollingDirection = Enum.ScrollingDirection.X
    gameScroll.Parent = gameSelector
    
    -- Add layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = gameScroll
    
    -- Create game buttons
    for _, game in pairs(gameList) do
        local gameButton = Instance.new("TextButton")
        gameButton.Size = UDim2.new(0, 70, 0, 60)
        gameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        gameButton.BackgroundTransparency = 0.9
        gameButton.Text = game.icon
        gameButton.TextColor3 = currentTheme.text
        gameButton.TextScaled = true
        gameButton.Font = Enum.Font.Gotham
        gameButton.Parent = gameScroll
        
        -- Add rounded corners
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = gameButton
        
        -- Add click event
        gameButton.MouseButton1Click:Connect(function()
            self:SelectGame(game.id)
            -- Load game features
            if self.loadGameFeatures then
                self.loadGameFeatures(game.id)
            end
        end)
    end
    
    -- Create main panel
    self.mainPanel = self:CreateGlassEffect(self.currentContainer, UDim2.new(1, 0, 1, -150), UDim2.new(0, 0, 0, 150))
    
    -- Create features container
    self.featuresContainer = Instance.new("ScrollingFrame")
    self.featuresContainer.Size = UDim2.new(1, -20, 1, -20)
    self.featuresContainer.Position = UDim2.new(0, 10, 0, 10)
    self.featuresContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.featuresContainer.BackgroundTransparency = 1
    self.featuresContainer.BorderSizePixel = 0
    self.featuresContainer.ScrollBarThickness = 8
    self.featuresContainer.ScrollBarImageColor3 = currentTheme.accent
    self.featuresContainer.Parent = self.mainPanel
    
    -- Add padding to scrolling frame
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = self.featuresContainer
    
    -- Add layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = self.featuresContainer
end

-- Select game
function ui:SelectGame(gameId)
    currentGame = gameId
    
    -- Update features container title
    if self.featuresContainer then
        -- Clear existing features
        for _, child in pairs(self.featuresContainer:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        
        -- Add title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundTransparency = 1
        title.Text = "Features: " .. gameId:sub(1,1):upper() .. gameId:sub(2)
        title.TextColor3 = currentTheme.text
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = self.featuresContainer
    end
end

-- Create toggle
function ui:CreateToggle(label, position, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.featuresContainer
    
    -- Create label
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = label
    toggleLabel.TextColor3 = currentTheme.text
    toggleLabel.TextScaled = true
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    -- Create toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 30)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = toggleButton
    
    -- Create toggle indicator
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Size = UDim2.new(0, 26, 0, 26)
    toggleIndicator.Position = UDim2.new(0, 2, 0.5, -13)
    toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    -- Add rounded corners to indicator
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 13)
    indicatorCorner.Parent = toggleIndicator
    
    -- Toggle state
    local toggled = false
    
    -- Add click event
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            -- Animate to on position
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = currentTheme.accent
            }):Play()
            
            TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 22, 0.5, -13)
            }):Play()
        else
            -- Animate to off position
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
            
            TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -13)
            }):Play()
        end
        
        -- Call callback
        if callback then
            callback(toggled)
        end
    end)
    
    return toggleFrame
end

-- Create slider
function ui:CreateSlider(label, min, max, default, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 70)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = self.featuresContainer
    
    -- Create label
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 30)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = label .. ": " .. default
    sliderLabel.TextColor3 = currentTheme.text
    sliderLabel.TextScaled = true
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    -- Create slider track
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, 0, 0, 10)
    sliderTrack.Position = UDim2.new(0, 0, 0, 40)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    -- Add rounded corners
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 5)
    trackCorner.Parent = sliderTrack
    
    -- Create slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = currentTheme.accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    -- Add rounded corners
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = sliderFill
    
    -- Create slider button
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.ZIndex = 2
    sliderButton.Parent = sliderTrack
    
    -- Add rounded corners
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = sliderButton
    
    -- Slider state
    local sliding = false
    local value = default
    
    -- Add mouse events
    sliderButton.MouseButton1Down:Connect(function()
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
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            
            local percent = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            value = min + (max - min) * percent
            
            -- Update slider position
            sliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            
            -- Update label
            sliderLabel.Text = label .. ": " .. math.floor(value)
            
            -- Call callback
            if callback then
                callback(value)
            end
        end
    end)
    
    return sliderFrame
end

-- Create dropdown
function ui:CreateDropdown(label, options, default, position, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 50)
    dropdownFrame.Position = position
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = self.featuresContainer
    
    -- Create label
    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = label
    dropdownLabel.TextColor3 = currentTheme.text
    dropdownLabel.TextScaled = true
    dropdownLabel.Font = Enum.Font.Gotham
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropdownLabel.Parent = dropdownFrame
    
    -- Create dropdown button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0.4, 0, 1, -10)
    dropdownButton.Position = UDim2.new(0.55, 0, 0, 5)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    dropdownButton.Text = default
    dropdownButton.TextColor3 = currentTheme.text
    dropdownButton.TextScaled = true
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    -- Add rounded corners
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = dropdownButton
    
    -- Create dropdown arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = currentTheme.text
    arrow.TextScaled = true
    arrow.Font = Enum.Font.Gotham
    arrow.Parent = dropdownButton
    
    -- Create dropdown options container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(0.4, 0, 0, 0)
    optionsContainer.Position = UDim2.new(0.55, 0, 1, 5)
    optionsContainer.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    optionsContainer.BorderSizePixel = 0
    optionsContainer.Visible = false
    optionsContainer.ZIndex = 10
    optionsContainer.Parent = dropdownFrame
    
    -- Add rounded corners
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 8)
    optionsCorner.Parent = optionsContainer
    
    -- Create options
    local optionHeight = 30
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsContainer
    
    for i, option in pairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, optionHeight)
        optionButton.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        optionButton.Text = option
        optionButton.TextColor3 = currentTheme.text
        optionButton.TextScaled = true
        optionButton.Font = Enum.Font.Gotham
        optionButton.ZIndex = 11
        optionButton.Parent = optionsContainer
        
        -- Add click event
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            optionsContainer.Visible = false
            
            -- Call callback
            if callback then
                callback(option)
            end
        end)
    end
    
    -- Toggle dropdown
    local isOpen = false
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsContainer.Visible = isOpen
        
        if isOpen then
            -- Update container size
            optionsContainer.Size = UDim2.new(0.4, 0, 0, #options * (optionHeight + 2))
            
            -- Rotate arrow
            arrow.Text = "▲"
        else
            -- Reset container size
            optionsContainer.Size = UDim2.new(0.4, 0, 0, 0)
            
            -- Rotate arrow
            arrow.Text = "▼"
        end
    end)
    
    return dropdownFrame
end

-- Create button
function ui:CreateFeatureButton(label, position, callback)
    local button = self:CreateButton(label, position, UDim2.new(1, 0, 0, 40), callback)
    button.Parent = self.featuresContainer
    return button
end

-- Show notification
function ui:ShowNotification(message)
    -- Create notification container
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(0.5, -150, 1, 100)
    notification.BackgroundColor3 = currentTheme.glass
    notification.BackgroundTransparency = TRANSPARENCY
    notification.BorderSizePixel = 0
    notification.ZIndex = 100
    notification.Parent = self.currentContainer
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = notification
    
    -- Add blur effect
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.Position = UDim2.new(0, 0, 0, 0)
    blur.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    blur.BackgroundTransparency = 1
    blur.BorderSizePixel = 0
    blur.Parent = notification
    
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = GLASS_BLUR
    blurEffect.Parent = blur
    
    -- Add message
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 1, -20)
    messageLabel.Position = UDim2.new(0, 10, 0, 10)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = currentTheme.text
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    
    -- Animate in
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 1, -100)
    })
    tweenIn:Play()
    
    -- Animate out after delay
    spawn(function()
        wait(3)
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -150, 1, 100),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Show error
function ui:ShowError(message)
    self:ShowNotification("Error: " .. message)
end

-- Set load game features callback
function ui:SetLoadGameFeaturesCallback(callback)
    self.loadGameFeatures = callback
end

return ui