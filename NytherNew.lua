local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Lucide = nil
pcall(function()
    Lucide = loadstring(game:HttpGet("https://github.com/latte-soft/lucide-roblox/releases/latest/download/lucide-roblox.luau"))()
end)

local function getLucideAsset(iconName, size)
    if not Lucide then return nil end
    local ok, asset = pcall(function()
        return Lucide.GetAsset(iconName, size or 48)
    end)
    return ok and asset or nil
end

local Theme = {
    Base    = Color3.fromRGB(8, 8, 8),
    Panel   = Color3.fromRGB(12, 12, 12),
    Raised  = Color3.fromRGB(34, 30, 26),
    Hover   = Color3.fromRGB(44, 38, 32),
    Line    = Color3.fromRGB(56, 49, 42),
    Toggle  = Color3.fromRGB(58, 51, 44),
    Accent  = Color3.fromRGB(41, 255, 244),
    Accent2 = Color3.fromRGB(41, 255, 244),
    Hot     = Color3.fromRGB(41, 255, 244),
    Text    = Color3.fromRGB(244, 238, 229),
    Dim     = Color3.fromRGB(150, 139, 126),
    Good    = Color3.fromRGB(128, 224, 134),
}

local _accentObjs      = {}
local _accentCallbacks = {}
local tabs             = {}

local _globalAccentObjsLen = 0
local _globalAccentCbsLen  = 0

local function _regAcc(obj, prop)
    table.insert(_accentObjs, { obj, prop })
end

local function setAccentColor(color)
    Theme.Accent  = color
    Theme.Accent2 = color
    Theme.Hot     = color
    local dark = Color3.new(color.R * 0.55, color.G * 0.55, color.B * 0.55)
    for _, e in ipairs(_accentObjs) do
        pcall(function() e[1][e[2]] = color end)
    end
    for _, fn in ipairs(_accentCallbacks) do pcall(fn, color, dark) end
    for name, data in pairs(tabs) do
        if data.isActive then
            data.button.TextColor3 = color
            data.icon.ImageColor3 = color
        end
    end
end

local function Corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
    return c
end

local function SafeTween(instance, tweenInfo, properties)
    if not instance or not instance.Parent then return nil end
    local ok, tween = pcall(function()
        return TweenService:Create(instance, tweenInfo, properties)
    end)
    if ok and tween then
        tween:Play()
        return tween
    end
    return nil
end

local function Stroke(inst, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Accent
    s.Thickness = thickness or 1
    s.Parent = inst
    return s
end

local function Label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Theme.Text
    l.TextSize = size or 13
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function Icon(parent, iconName, size, color)
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(0, size or 20, 0, size or 20)
    img.ImageColor3 = color or Theme.Text
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = parent
    local asset = getLucideAsset(iconName, (size or 20) * 2)
    if asset and type(asset) == "table" and asset.Url then
        img.Image = asset.Url
        img.ImageRectSize = asset.ImageRectSize
        img.ImageRectOffset = asset.ImageRectOffset
    else
        img.Image = "rbxassetid://0"
    end
    return img
end
local Root = Instance.new("ScreenGui")
Root.Name = "EmberRoot"
Root.ResetOnSpawn = false
Root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Root.DisplayOrder = 999999
Root.IgnoreGuiInset = true

local function Adopt(gui)
    local ok, h = pcall(function() return gethui() end)
    if ok and h and typeof(h) == "Instance" then
        pcall(function() gui.Parent = h end)
        return
    end
    local ok2, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and coreGui then
        pcall(function() gui.Parent = coreGui end)
        return
    end
    local ok3, playerGui = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
    if ok3 and playerGui then
        pcall(function() gui.Parent = playerGui end)
    end
end
Adopt(Root)

local WINDOW_SIZE = UDim2.new(0, 480, 0, 400)

local Main = Instance.new("Frame")
Main.Name = "Window"
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0, 0, 0, 0)
Main.BackgroundColor3 = Theme.Base
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Root
Corner(Main, 8)

local function CenterWindow()
    local viewport = game:GetService("Workspace").CurrentCamera and game:GetService("Workspace").CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local winSize = WINDOW_SIZE
    local x = (viewport.X - winSize.X.Offset) / 2
    local y = (viewport.Y - winSize.Y.Offset) / 2
    Main.Position = UDim2.new(0, x, 0, y)
end


local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 54)
TitleBar.BackgroundColor3 = Theme.Panel
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleDiv = Instance.new("Frame")
TitleDiv.Size = UDim2.new(1, 0, 0, 1)
TitleDiv.Position = UDim2.new(0, 0, 1, -1)
TitleDiv.BackgroundColor3 = Theme.Line
TitleDiv.BorderSizePixel = 0
TitleDiv.Parent = TitleBar

local LogoWrap = Instance.new("Frame")
LogoWrap.Size = UDim2.new(0, 20, 0, 20)
LogoWrap.Position = UDim2.new(0, 20, 0, 17)
LogoWrap.Rotation = 45
LogoWrap.BackgroundTransparency = 1
LogoWrap.Parent = TitleBar

local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.BorderSizePixel = 0
Logo.Parent = LogoWrap
Corner(Logo, 5)

local LogoGrad = Instance.new("UIGradient")
LogoGrad.Color = ColorSequence.new(Theme.Accent, Theme.Accent)
LogoGrad.Rotation = 45
LogoGrad.Parent = Logo
table.insert(_accentCallbacks, function(c)
    LogoGrad.Color = ColorSequence.new(c, c)
end)

local LogoCore = Instance.new("Frame")
LogoCore.Size = UDim2.new(0, 8, 0, 8)
LogoCore.Position = UDim2.new(0.5, -4, 0.5, -4)
LogoCore.BackgroundColor3 = Theme.Base
LogoCore.BorderSizePixel = 0
LogoCore.Parent = Logo
Corner(LogoCore, 2)

local Title = Label(TitleBar, "Nyther - UI Library", 16, Theme.Accent, Enum.Font.GothamBlack)
Title.Size = UDim2.new(0, 260, 0, 20)
Title.Position = UDim2.new(0, 54, 0, 16)
_regAcc(Title, "TextColor3")

local Version = Label(TitleBar, "By L#######", 9, Theme.Dim, Enum.Font.GothamMedium)
Version.Size = UDim2.new(0, 60, 0, 16)
Version.Position = UDim2.new(0, 54, 0, 34)

local Pill = Instance.new("Frame")
Pill.Size = UDim2.new(0, 116, 0, 22)
Pill.Position = UDim2.new(1, -172, 0, 16)
Pill.BackgroundColor3 = Theme.Raised
Pill.BorderSizePixel = 0
Pill.Parent = TitleBar
Corner(Pill, 11)
local PillStroke = Stroke(Pill, Theme.Accent, 0.5)
_regAcc(PillStroke, "Color")

local PillDot = Instance.new("Frame")
PillDot.Size = UDim2.new(0, 6, 0, 6)
PillDot.Position = UDim2.new(0, 10, 0.5, -3)
PillDot.BackgroundColor3 = Theme.Good
PillDot.BorderSizePixel = 0
PillDot.Parent = Pill
Corner(PillDot, 3)

local PillText = Label(Pill, "Activate", 11, Theme.Text, Enum.Font.GothamBold)
PillText.Size = UDim2.new(1, -24, 1, 0)
PillText.Position = UDim2.new(0, 22, 0, 0)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -42, 0, 13)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Theme.Dim
Close.TextSize = 15
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.ZIndex = 5
Close.Parent = TitleBar
Corner(Close, 6)

Close.MouseEnter:Connect(function()
    SafeTween(Close, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 50, 50) })
end)
Close.MouseLeave:Connect(function()
    SafeTween(Close, TweenInfo.new(0.15), { TextColor3 = Theme.Dim })
end)
Close.MouseButton1Click:Connect(function()
    if Main then Main.Visible = not Main.Visible end
end)

local Scan = Instance.new("Frame")
Scan.Size = UDim2.new(0, 90, 0, 2)
Scan.Position = UDim2.new(0, 0, 1, -2)
Scan.BorderSizePixel = 0
Scan.BackgroundColor3 = Theme.Accent
Scan.Parent = TitleBar
_regAcc(Scan, "BackgroundColor3")

local ScanGrad = Instance.new("UIGradient")
ScanGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Accent),
    ColorSequenceKeypoint.new(0.5, Theme.Accent2),
    ColorSequenceKeypoint.new(1, Theme.Accent),
})
ScanGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
})
ScanGrad.Parent = Scan
table.insert(_accentCallbacks, function(c)
    ScanGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c),
        ColorSequenceKeypoint.new(0.5, c),
        ColorSequenceKeypoint.new(1, c),
    })
end)

task.spawn(function()
    while Main and Main.Parent do
        SafeTween(Scan, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(1, -90, 1, -2) })
        task.wait(2.6)
        if not Main or not Main.Parent then break end
        SafeTween(Scan, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 0, 1, -2) })
        task.wait(2.6)
    end
end)

task.spawn(function()
    while Main and Main.Parent and PillDot and PillDot.Parent do
        SafeTween(PillDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.55 })
        task.wait(0.7)
        if not Main or not Main.Parent or not PillDot or not PillDot.Parent then break end
        SafeTween(PillDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 })
        task.wait(0.7)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if LogoWrap and LogoWrap.Parent then
        LogoWrap.Rotation = (LogoWrap.Rotation + dt * 48) % 360
    end
end)

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local closePos = Close.AbsolutePosition
        local closeSize = Close.AbsoluteSize
        local mousePos = input.Position
        if mousePos.X >= closePos.X and mousePos.X <= closePos.X + closeSize.X and
           mousePos.Y >= closePos.Y and mousePos.Y <= closePos.Y + closeSize.Y then return end
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        if not Main or not Main.Parent then dragging = false; return end
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        local vpSize = game:GetService("Workspace").CurrentCamera and
                       game:GetService("Workspace").CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        local winSize = Main.AbsoluteSize
        newX = math.clamp(newX, 0, math.max(0, vpSize.X - winSize.X))
        newY = math.clamp(newY, 0, math.max(0, vpSize.Y - winSize.Y))
        Main.Position = UDim2.new(0, newX, 0, newY)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -54)
ContentArea.Position = UDim2.new(0, 0, 0, 54)
ContentArea.BackgroundColor3 = Theme.Base
ContentArea.BorderSizePixel = 0
ContentArea.Parent = Main

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 146, 1, 0)
TabBar.BackgroundColor3 = Theme.Base
TabBar.BorderSizePixel = 0
TabBar.Parent = ContentArea

local TabDivider = Instance.new("Frame")
TabDivider.Size = UDim2.new(0, 1, 1, 0)
TabDivider.Position = UDim2.new(0, 131, 0, 0)
TabDivider.BackgroundColor3 = Theme.Line
TabDivider.BorderSizePixel = 0
TabDivider.Parent = TabBar

local TabBarFill = Instance.new("Frame")
TabBarFill.Size = UDim2.new(0, 15, 1, 0)
TabBarFill.Position = UDim2.new(0, 132, 0, 0)
TabBarFill.BackgroundColor3 = Theme.Base
TabBarFill.BorderSizePixel = 0
TabBarFill.Parent = TabBar

local DividerScan = Instance.new("Frame")
DividerScan.Size = UDim2.new(0, 2, 0, 90)
DividerScan.Position = UDim2.new(0, 130, 0, 0)
DividerScan.BorderSizePixel = 0
DividerScan.BackgroundColor3 = Theme.Accent

local ScanGrad2 = Instance.new("UIGradient")
ScanGrad2.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Accent),
    ColorSequenceKeypoint.new(0.5, Theme.Accent2),
    ColorSequenceKeypoint.new(1, Theme.Accent),
})
ScanGrad2.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
})
ScanGrad2.Rotation = 90
ScanGrad2.Parent = DividerScan
DividerScan.Parent = TabBar
_regAcc(DividerScan, "BackgroundColor3")
table.insert(_accentCallbacks, function(c)
    ScanGrad2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c),
        ColorSequenceKeypoint.new(0.5, c),
        ColorSequenceKeypoint.new(1, c),
    })
end)

_globalAccentObjsLen = #_accentObjs
_globalAccentCbsLen  = #_accentCallbacks

task.spawn(function()
    while Main and Main.Parent and DividerScan and DividerScan.Parent do
        SafeTween(DividerScan, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 130, 1, -90) })
        task.wait(2.6)
        if not Main or not Main.Parent or not DividerScan or not DividerScan.Parent then break end
        SafeTween(DividerScan, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 130, 0, 0) })
        task.wait(2.6)
    end
end)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, 0, 1, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 0
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
TabScroll.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.Parent = TabScroll

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 8)
TabPadding.PaddingRight = UDim.new(0, 8)
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingBottom = UDim.new(0, 8)
TabPadding.Parent = TabScroll

local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -146, 1, 0)
ContentPanel.Position = UDim2.new(0, 146, 0, 0)
ContentPanel.BackgroundColor3 = Theme.Base
ContentPanel.BorderSizePixel = 0
ContentPanel.Parent = ContentArea

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 0
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
ContentScroll.Parent = ContentPanel

local ContentListLayout = Instance.new("UIListLayout")
ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentListLayout.Padding = UDim.new(0, 12)
ContentListLayout.Parent = ContentScroll

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingLeft = UDim.new(0, 16)
ContentPadding.PaddingRight = UDim.new(0, 16)
ContentPadding.PaddingTop = UDim.new(0, 16)
ContentPadding.PaddingBottom = UDim.new(0, 16)
ContentPadding.Parent = ContentScroll
local activeConnections = {}

local function ClearContent()
    for _, conn in ipairs(activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    activeConnections = {}
    for i = #_accentObjs, _globalAccentObjsLen + 1, -1 do
        _accentObjs[i] = nil
    end
    for i = #_accentCallbacks, _globalAccentCbsLen + 1, -1 do
        _accentCallbacks[i] = nil
    end
    for _, child in pairs(ContentScroll:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") and not child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
end

local function RefreshCanvas()
    ContentListLayout:ApplyLayout()
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentListLayout.AbsoluteContentSize.Y + 20)
end

local function Card(parent)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1, 0, 0, 62)
    c.BackgroundColor3 = Theme.Raised
    c.BorderSizePixel = 0
    c.Parent = parent
    Corner(c, 8)
    Stroke(c, Theme.Line, 0.5)
    return c
end

local function CreateSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
    local wrap = Instance.new("Frame")
    wrap.Name = labelText
    wrap.Size = UDim2.new(1, 0, 0, 48)
    wrap.BackgroundColor3 = Theme.Raised
    wrap.BorderSizePixel = 0
    wrap.Parent = parent
    Corner(wrap, 6)

    local nameLabel = Label(wrap, labelText, 11, Theme.Dim, Enum.Font.GothamBold)
    nameLabel.Size = UDim2.new(0, 100, 0, 16)
    nameLabel.Position = UDim2.new(0, 12, 0, 6)

    local valueLabel = Label(wrap, tostring(defaultVal), 11, Theme.Text, Enum.Font.GothamBold)
    valueLabel.Size = UDim2.new(0, 60, 0, 16)
    valueLabel.Position = UDim2.new(1, -72, 0, 6)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local trackContainer = Instance.new("Frame")
    trackContainer.Size = UDim2.new(1, -24, 0, 4)
    trackContainer.Position = UDim2.new(0, 12, 0, 32)
    trackContainer.BackgroundColor3 = Theme.Toggle
    trackContainer.BorderSizePixel = 0
    trackContainer.Parent = wrap
    Corner(trackContainer, 2)

    local startPct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(startPct, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = trackContainer
    Corner(fill, 2)

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Color3.new(Theme.Accent.R * 0.75, Theme.Accent.G * 0.75, Theme.Accent.B * 0.75))
    })
    fillGrad.Rotation = 90
    fillGrad.Parent = fill
    table.insert(_accentCallbacks, function(c)
        fillGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c),
            ColorSequenceKeypoint.new(1, Color3.new(c.R * 0.75, c.G * 0.75, c.B * 0.75))
        })
    end)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new(startPct, 0, 0.5, 0)
    thumb.BackgroundColor3 = Theme.Base
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 5
    thumb.Parent = trackContainer
    Corner(thumb, 8)

    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Color = Theme.Accent
    thumbStroke.Thickness = 2
    thumbStroke.Parent = thumb

    local thumbDot = Instance.new("Frame")
    thumbDot.Size = UDim2.new(0, 6, 0, 6)
    thumbDot.AnchorPoint = Vector2.new(0.5, 0.5)
    thumbDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    thumbDot.BackgroundColor3 = Theme.Accent
    thumbDot.BorderSizePixel = 0
    thumbDot.ZIndex = 6
    thumbDot.Parent = thumb
    Corner(thumbDot, 3)

    local sliderDragging = false
    local currentValue = defaultVal

    local function setPercent(pct)
        pct = math.clamp(pct, 0, 1)
        local val = math.round(minVal + (maxVal - minVal) * pct)
        currentValue = val
        valueLabel.Text = tostring(val)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        thumb.Position = UDim2.new(pct, 0, 0.5, 0)
        if callback then pcall(callback, val) end
    end

    local function getPercent(mouseX)
        local abs = trackContainer.AbsolutePosition.X
        local sz = trackContainer.AbsoluteSize.X
        return math.clamp((mouseX - abs) / sz, 0, 1)
    end

    wrap.MouseEnter:Connect(function()
        if not sliderDragging then
            SafeTween(wrap, TweenInfo.new(0.18), { BackgroundColor3 = Theme.Hover })
            SafeTween(nameLabel, TweenInfo.new(0.18), { TextColor3 = Theme.Text })
        end
    end)
    wrap.MouseLeave:Connect(function()
        if not sliderDragging then
            SafeTween(wrap, TweenInfo.new(0.18), { BackgroundColor3 = Theme.Raised })
            SafeTween(nameLabel, TweenInfo.new(0.18), { TextColor3 = Theme.Dim })
        end
    end)

    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
            setPercent(getPercent(input.Position.X))
            SafeTween(thumb, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 20, 0, 20),
            })
        end
    end

    trackContainer.InputBegan:Connect(beginDrag)
    thumb.InputBegan:Connect(beginDrag)

    table.insert(activeConnections, UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setPercent(getPercent(input.Position.X))
        end
    end))
    table.insert(activeConnections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and sliderDragging then
            sliderDragging = false
            local pct = math.clamp(thumb.Position.X.Scale, 0, 1)
            SafeTween(thumb, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(pct, 0, 0.5, 0)
            })
        end
    end))

    return {
        frame    = wrap,
        getValue = function() return currentValue end,
        setValue = function(v) setPercent(math.clamp((v - minVal) / (maxVal - minVal), 0, 1)) end,
    }
end
local function CreateToggle(parent, labelText, defaultState, callback)
    local state = defaultState or false
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 42)
    container.BackgroundColor3 = Theme.Raised
    container.BorderSizePixel = 0
    container.Parent = parent
    Corner(container, 6)
    Stroke(container, Theme.Line, 0.5)

    local label = Label(container, labelText, 12, Theme.Text, Enum.Font.GothamBold)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 36, 0, 20)
    track.Position = UDim2.new(1, -48, 0.5, -10)
    track.BackgroundColor3 = state and Theme.Accent or Theme.Toggle
    track.BorderSizePixel = 0
    track.Parent = container
    Corner(track, 10)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = state and UDim2.new(1, -8, 0.5, 0) or UDim2.new(0, 8, 0.5, 0)
    thumb.BackgroundColor3 = Theme.Base
    thumb.BorderSizePixel = 0
    thumb.Parent = track
    Corner(thumb, 8)
    Stroke(thumb, Theme.Accent, 1)

    local function setState(newState)
        state = newState
        local targetPos = state and UDim2.new(1, -8, 0.5, 0) or UDim2.new(0, 8, 0.5, 0)
        SafeTween(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = targetPos })
        SafeTween(track, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = state and Theme.Accent or Theme.Toggle
        })
        if callback then pcall(callback, state) end
    end

    local function toggle()
        setState(not state)
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container
    btn.MouseButton1Click:Connect(toggle)

    local trackBtn = Instance.new("TextButton")
    trackBtn.Size = UDim2.new(1, 0, 1, 0)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text = ""
    trackBtn.Parent = track
    trackBtn.MouseButton1Click:Connect(toggle)

    container.MouseEnter:Connect(function()
        SafeTween(container, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover})
    end)
    container.MouseLeave:Connect(function()
        SafeTween(container, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Raised})
    end)

    return {
        frame    = container,
        setState = setState,
        getState = function() return state end,
    }
end

local function CreateKeyBind(parent, labelText, defaultKey, callback)
    local currentKey = defaultKey or "None"
    local isCapturing = false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 42)
    container.BackgroundColor3 = Theme.Raised
    container.BorderSizePixel = 0
    container.Parent = parent
    Corner(container, 6)
    Stroke(container, Theme.Line, 0.5)

    local label = Label(container, labelText, 12, Theme.Text, Enum.Font.GothamBold)
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)

    local keyButton = Instance.new("TextButton")
    keyButton.Size = UDim2.new(0, 80, 0, 28)
    keyButton.Position = UDim2.new(1, -96, 0.5, -14)
    keyButton.BackgroundColor3 = Theme.Toggle
    keyButton.Text = currentKey
    keyButton.TextColor3 = Theme.Text
    keyButton.TextSize = 11
    keyButton.Font = Enum.Font.GothamBold
    keyButton.AutoButtonColor = false
    keyButton.BorderSizePixel = 0
    keyButton.Parent = container
    Corner(keyButton, 6)
    local keyStroke = Stroke(keyButton, Theme.Line, 0.5)

    local function setKey(newKey)
        currentKey = newKey
        keyButton.Text = currentKey
        if callback then pcall(callback, currentKey) end
    end

    local function startCapture()
        if isCapturing then return end
        isCapturing = true
        keyButton.Text = "..."
        SafeTween(keyButton, TweenInfo.new(0.15), { BackgroundColor3 = Theme.Accent })
        SafeTween(keyStroke, TweenInfo.new(0.15), { Color = Theme.Accent })
    end

    local function stopCapture()
        if not isCapturing then return end
        isCapturing = false
        keyButton.Text = currentKey
        SafeTween(keyButton, TweenInfo.new(0.15), { BackgroundColor3 = Theme.Toggle, BackgroundTransparency = 0 })
        SafeTween(keyStroke, TweenInfo.new(0.15), { Color = Theme.Line })
    end

    keyButton.MouseButton1Click:Connect(function()
        if isCapturing then stopCapture(); return end
        startCapture()
    end)

    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not isCapturing then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift or
           key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.RightControl or
           key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt or
           key == Enum.KeyCode.CapsLock then return end
        if key ~= Enum.KeyCode.Unknown then
            local keyName = tostring(key):gsub("Enum.KeyCode.", "")
            setKey(keyName)
            stopCapture()
        end
    end)

    container.MouseEnter:Connect(function()
        SafeTween(container, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover})
    end)
    container.MouseLeave:Connect(function()
        SafeTween(container, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Raised})
    end)

    table.insert(activeConnections, connection)

    return {
        frame        = container,
        setKey       = setKey,
        getKey       = function() return currentKey end,
        startCapture = startCapture,
        stopCapture  = stopCapture,
    }
end

local function CreateButton(parent, text, iconName, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Theme.Raised
    btn.Text = "  " .. text
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Corner(btn, 6)

    local icon = Icon(btn, iconName or "square", 16, Theme.Dim)
    icon.Position = UDim2.new(0, 12, 0.5, -8)

    btn.MouseEnter:Connect(function()
        SafeTween(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover})
        SafeTween(icon, TweenInfo.new(0.15), {ImageColor3 = Theme.Text})
    end)
    btn.MouseLeave:Connect(function()
        SafeTween(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Raised})
        SafeTween(icon, TweenInfo.new(0.15), {ImageColor3 = Theme.Dim})
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)

    return { frame = btn }
end

local function CreateLabel(parent, text, size, color, font)
    local l = Label(parent, text, size or 12, color or Theme.Dim, font or Enum.Font.GothamBold)
    l.Size = UDim2.new(1, 0, 0, 20)
    return { frame = l }
end

local notificationQueue = {}
local isShowingNotification = false
local notificationsEnabled = true

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 340, 0, 0)
NotificationContainer.Position = UDim2.new(1, -20, 0.5, 0)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.AnchorPoint = Vector2.new(1, 0.5)
NotificationContainer.Parent = Root

local function showNextNotification()
    if isShowingNotification or #notificationQueue == 0 or not notificationsEnabled then return end
    isShowingNotification = true
    local data = table.remove(notificationQueue, 1)
    local nTitle = data.title or ""
    local nText = data.text or ""
    local duration = data.duration or 3

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 68)
    notif.BackgroundColor3 = Theme.Raised
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = NotificationContainer
    Corner(notif, 8)
    Stroke(notif, Theme.Line, 0.5)

    local titleLabel = Label(notif, nTitle, 16, Theme.Accent, Enum.Font.GothamBold)
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 12, 0, 8)
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local textLabel = Label(notif, nText, 13, Theme.Text, Enum.Font.Gotham)
    textLabel.Size = UDim2.new(1, -20, 0, 20)
    textLabel.Position = UDim2.new(0, 12, 0, 32)
    textLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -28, 0, 8)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.Dim
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = notif
    closeBtn.MouseButton1Click:Connect(function()
        if notif then notif:Destroy() end
        isShowingNotification = false
        task.wait(0.1)
        showNextNotification()
    end)

    SafeTween(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    NotificationContainer.Size = UDim2.new(0, 340, 0, 68)

    task.wait(duration)
    if notif and notif.Parent then
        SafeTween(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 0)
        })
        task.wait(0.25)
        if notif then notif:Destroy() end
    end
    isShowingNotification = false
    NotificationContainer.Size = UDim2.new(0, 340, 0, 0)
    task.wait(0.1)
    showNextNotification()
end

local function Notify(title, text, duration)
    if not notificationsEnabled then return end
    table.insert(notificationQueue, {title = title, text = text, duration = duration or 3})
    if not isShowingNotification then
        task.spawn(showNextNotification)
    end
end

local function NewColorPicker(parent, labelText, subText, defaultColor, callback, updateCanvas)
    defaultColor = defaultColor or Theme.Accent

    local SQ_H   = 120
    local HUE_W  = 14
    local GAP    = 12
    local PAD    = 12
    local SQ_Y   = 10
    local INP_H  = 28
    local INP_Y  = SQ_Y + SQ_H + 10
    local BODY_H = INP_Y + INP_H + 12

    local function toHexStr(c)
        return string.format("#%02X%02X%02X",
            math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
    end
    local function fromHexStr(s)
        s = s:gsub("#",""):gsub("%s","")
        if #s ~= 6 then return nil end
        local r = tonumber(s:sub(1,2),16)
        local g = tonumber(s:sub(3,4),16)
        local b = tonumber(s:sub(5,6),16)
        if not (r and g and b) then return nil end
        return Color3.fromRGB(r,g,b)
    end
    local function clampByte(n)
        n = tonumber(n)
        if not n then return nil end
        return math.clamp(math.floor(n+0.5),0,255)
    end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent

    local cPad = Instance.new("UIPadding")
    cPad.PaddingTop = UDim.new(0, 6)
    cPad.Parent = container

    local cLayout = Instance.new("UIListLayout")
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding = UDim.new(0, 6)
    cLayout.Parent = container

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Theme.Raised
    header.BorderSizePixel = 0
    header.LayoutOrder = 1
    header.Parent = container
    Corner(header, 8)
    local hStroke = Stroke(header, Theme.Line, 0.5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -72, 0, 18)
    lbl.Position = UDim2.new(0, 14, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = header

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -72, 0, 14)
    subLbl.Position = UDim2.new(0, 14, 0, 28)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = subText or ""
    subLbl.TextColor3 = Theme.Dim
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = header

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 38, 0, 28)
    preview.Position = UDim2.new(1, -52, 0.5, -14)
    preview.BackgroundColor3 = defaultColor
    preview.BorderSizePixel = 0
    preview.Parent = header
    Corner(preview, 6)
    Stroke(preview, Theme.Line, 0.5)

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 1, 0)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = header

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 0, BODY_H)
    body.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    body.BorderSizePixel = 0
    body.ClipsDescendants = true
    body.Visible = false
    body.LayoutOrder = 2
    body.Parent = container
    Corner(body, 8)

    local H, S, V = Color3.toHSV(defaultColor)

    local square = Instance.new("Frame")
    square.Size = UDim2.new(1, -(PAD + GAP + HUE_W + PAD), 0, SQ_H)
    square.Position = UDim2.new(0, PAD, 0, SQ_Y)
    square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
    square.BorderSizePixel = 0
    square.ClipsDescendants = true
    square.Parent = body
    Corner(square, 4)

    local wOver = Instance.new("Frame")
    wOver.Size = UDim2.new(1,0,1,0); wOver.BackgroundColor3 = Color3.new(1,1,1)
    wOver.BackgroundTransparency = 0; wOver.BorderSizePixel = 0; wOver.ZIndex = 2; wOver.Parent = square
    Instance.new("UIGradient", wOver).Transparency =
        NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})

    local bOver = Instance.new("Frame")
    bOver.Size = UDim2.new(1,0,1,0); bOver.BackgroundColor3 = Color3.new(0,0,0)
    bOver.BackgroundTransparency = 0; bOver.BorderSizePixel = 0; bOver.ZIndex = 3; bOver.Parent = square
    local bGrad = Instance.new("UIGradient", bOver)
    bGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})
    bGrad.Rotation = 90

    local sqKnob = Instance.new("Frame")
    sqKnob.Size = UDim2.new(0,12,0,12); sqKnob.AnchorPoint = Vector2.new(0.5,0.5)
    sqKnob.Position = UDim2.new(S,0,1-V,0); sqKnob.BackgroundColor3 = Color3.new(1,1,1)
    sqKnob.BorderSizePixel = 0; sqKnob.ZIndex = 10; sqKnob.Parent = square
    Corner(sqKnob, 6)
    local sqKS = Instance.new("UIStroke", sqKnob)
    sqKS.Color = Color3.new(0,0,0); sqKS.Thickness = 1.5

    local sqBtn = Instance.new("TextButton")
    sqBtn.Size = UDim2.new(1,0,1,0); sqBtn.BackgroundTransparency = 1
    sqBtn.Text = ""; sqBtn.ZIndex = 11; sqBtn.Parent = square

    local hueBar = Instance.new("Frame")
    hueBar.Size = UDim2.new(0,HUE_W,0,SQ_H)
    hueBar.Position = UDim2.new(1,-(PAD+HUE_W),0,SQ_Y)
    hueBar.BackgroundColor3 = Color3.new(1,1,1); hueBar.BorderSizePixel = 0; hueBar.Parent = body
    Corner(hueBar, 3)

    local hueGrad = Instance.new("UIGradient", hueBar)
    hueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,     Color3.fromHSV(0,     1,1)),
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1,1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1,1)),
        ColorSequenceKeypoint.new(0.5,   Color3.fromHSV(0.5,   1,1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1,1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1,1)),
        ColorSequenceKeypoint.new(1,     Color3.fromHSV(0,     1,1)),
    })
    hueGrad.Rotation = 90

    local hueKnob = Instance.new("Frame")
    hueKnob.Size = UDim2.new(1,4,0,3); hueKnob.AnchorPoint = Vector2.new(0,0.5)
    hueKnob.Position = UDim2.new(0,-2,H,0); hueKnob.BackgroundColor3 = Color3.new(1,1,1)
    hueKnob.BorderSizePixel = 0; hueKnob.ZIndex = 10; hueKnob.Parent = hueBar
    local hKS = Instance.new("UIStroke", hueKnob)
    hKS.Color = Color3.new(0,0,0); hKS.Thickness = 1

    local hueBtn = Instance.new("TextButton")
    hueBtn.Size = UDim2.new(1,0,1,0); hueBtn.BackgroundTransparency = 1
    hueBtn.Text = ""; hueBtn.ZIndex = 11; hueBtn.Parent = hueBar

    local function makeInput(px_s, px_o, sx_s, sx_o, hint)
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(sx_s, sx_o, 0, INP_H)
        bg.Position = UDim2.new(px_s, px_o, 0, INP_Y)
        bg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        bg.BorderSizePixel = 0; bg.Parent = body
        Corner(bg, 5); Stroke(bg, Theme.Line, 0.5)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1,-6,1,0); box.Position = UDim2.new(0,3,0,0)
        box.BackgroundTransparency = 1; box.Text = hint; box.PlaceholderText = hint
        box.TextColor3 = Theme.Text; box.PlaceholderColor3 = Theme.Dim
        box.TextSize = 10; box.Font = Enum.Font.GothamSemibold
        box.TextXAlignment = Enum.TextXAlignment.Center
        box.ClearTextOnFocus = false; box.Parent = bg
        return box
    end

    local hexBox = makeInput(0, PAD,  1, -136, "#000000")
    local rBox   = makeInput(1, -120, 0,   34, "R")
    local gBox   = makeInput(1, -82,  0,   34, "G")
    local bBox   = makeInput(1, -44,  0,   34, "B")

    local function getColor() return Color3.fromHSV(H, S, V) end
    local function refreshInputs()
        local c = getColor()
        local r = math.floor(c.R*255+0.5)
        local g = math.floor(c.G*255+0.5)
        local b = math.floor(c.B*255+0.5)
        hexBox.Text = string.format("#%02X%02X%02X", r, g, b)
        rBox.Text = tostring(r); gBox.Text = tostring(g); bBox.Text = tostring(b)
    end
    local function refreshVisuals()
        local c = getColor()
        preview.BackgroundColor3 = c
        square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        if callback then pcall(callback, c) end
    end
    local function applyHSV(nh, ns, nv)
        H = nh; S = ns; V = nv
        sqKnob.Position  = UDim2.new(S, 0, 1-V, 0)
        hueKnob.Position = UDim2.new(0, -2, H, 0)
        refreshVisuals(); refreshInputs()
    end
    local function updateFromSquare(mx, my)
        local rx = math.clamp((mx - square.AbsolutePosition.X) / square.AbsoluteSize.X, 0, 1)
        local ry = math.clamp((my - square.AbsolutePosition.Y) / square.AbsoluteSize.Y, 0, 1)
        S = rx; V = 1 - ry
        sqKnob.Position = UDim2.new(rx, 0, ry, 0)
        refreshVisuals(); refreshInputs()
    end
    local function updateFromHue(my)
        local ry = math.clamp((my - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
        H = ry
        hueKnob.Position = UDim2.new(0, -2, ry, 0)
        square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        refreshVisuals(); refreshInputs()
    end

    local dragSq, dragHue = false, false
    sqBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragSq = true; updateFromSquare(inp.Position.X, inp.Position.Y) end
    end)
    hueBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragHue = true; updateFromHue(inp.Position.Y) end
    end)
    table.insert(activeConnections, UserInputService.InputChanged:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if dragSq  then updateFromSquare(inp.Position.X, inp.Position.Y) end
        if dragHue then updateFromHue(inp.Position.Y) end
    end))
    table.insert(activeConnections, UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragSq = false; dragHue = false end
    end))

    hexBox.FocusLost:Connect(function()
        local c = fromHexStr(hexBox.Text)
        if c then local nh,ns,nv = Color3.toHSV(c); applyHSV(nh,ns,nv) else refreshInputs() end
    end)
    local function applyRGB()
        local r,g,b = clampByte(rBox.Text), clampByte(gBox.Text), clampByte(bBox.Text)
        if r and g and b then local nh,ns,nv = Color3.toHSV(Color3.fromRGB(r,g,b)); applyHSV(nh,ns,nv)
        else refreshInputs() end
    end
    rBox.FocusLost:Connect(applyRGB); gBox.FocusLost:Connect(applyRGB); bBox.FocusLost:Connect(applyRGB)

    local expanded = false
    headerBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        body.Visible = expanded
        SafeTween(header, TweenInfo.new(0.15), { BackgroundColor3 = expanded and Theme.Hover or Theme.Raised })
        SafeTween(hStroke, TweenInfo.new(0.15), { Color = expanded and Theme.Accent or Theme.Line })
        if updateCanvas then updateCanvas() end
    end)
    header.MouseEnter:Connect(function()
        SafeTween(header, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover})
        SafeTween(hStroke, TweenInfo.new(0.15), {Color = Theme.Accent})
    end)
    header.MouseLeave:Connect(function()
        if not expanded then SafeTween(header, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Raised}) end
        SafeTween(hStroke, TweenInfo.new(0.15), {Color = Theme.Line})
    end)

    H, S, V = Color3.toHSV(defaultColor)
    sqKnob.Position = UDim2.new(S, 0, 1-V, 0)
    hueKnob.Position = UDim2.new(0, -2, H, 0)
    square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
    refreshVisuals(); refreshInputs()

    local function setColor(c)
        H, S, V = Color3.toHSV(c)
        sqKnob.Position  = UDim2.new(S, 0, 1-V, 0)
        hueKnob.Position = UDim2.new(0, -2, H, 0)
        square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        refreshVisuals(); refreshInputs()
    end

    return { frame = container, setColor = setColor }
end

local currentTabId = 0

local function ActivateTab(tabName)
    for name, data in pairs(tabs) do
        if data.isActive then
            data.button.BackgroundColor3 = Theme.Raised
            data.button.TextColor3 = Theme.Dim
            data.icon.ImageColor3 = Theme.Dim
            data.isActive = false
        end
    end
    if tabs[tabName] then
        local data = tabs[tabName]
        data.button.BackgroundColor3 = Theme.Hover
        data.button.TextColor3 = Theme.Accent
        data.icon.ImageColor3 = Theme.Accent
        data.isActive = true
        ClearContent()
        if data.buildFn then
            currentTabId += 1
            data.buildFn(ContentScroll)
            ContentListLayout:ApplyLayout()
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentListLayout.AbsoluteContentSize.Y + 20)
        end
    end
end

local function CreateTab(tabName, iconName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabName
    TabBtn.Size = UDim2.new(1, -16, 0, 38)
    TabBtn.BackgroundColor3 = Theme.Raised
    TabBtn.TextColor3 = Theme.Dim
    TabBtn.Text = "   " .. tabName
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.AutoButtonColor = false
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = TabScroll
    Corner(TabBtn, 6)

    local icon = Icon(TabBtn, iconName or "square", 16, Theme.Dim)
    icon.Position = UDim2.new(0, 8, 0.5, -8)

    local data = {
        button   = TabBtn,
        icon     = icon,
        isActive = false,
        name     = tabName,
        buildFn  = nil,
    }
    tabs[tabName] = data

    TabBtn.MouseEnter:Connect(function()
        if not data.isActive then
            SafeTween(TabBtn, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Hover, TextColor3 = Theme.Text })
            SafeTween(icon, TweenInfo.new(0.2), { ImageColor3 = Theme.Text })
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if not data.isActive then
            SafeTween(TabBtn, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Raised, TextColor3 = Theme.Dim })
            SafeTween(icon, TweenInfo.new(0.2), { ImageColor3 = Theme.Dim })
        end
    end)
    TabBtn.MouseButton1Click:Connect(function()
        ActivateTab(tabName)
    end)

    local tabObj = {
        name     = tabName,
        setBuilder = function(fn)
            data.buildFn = fn
        end,
        activate = function()
            ActivateTab(tabName)
        end,
    }

    return tabObj
end

local function SetTitle(text)
    Title.Text = text
end

local function SetVersion(text)
    Version.Text = text
end

local function SetPillText(text)
    PillText.Text = text
end

local function Open()
    Main.Visible = true
end

local function Close2()
    Main.Visible = false
end

local function Toggle()
    Main.Visible = not Main.Visible
end

task.spawn(function()
    CenterWindow()
    SafeTween(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = WINDOW_SIZE,
    })
end)

return {
    Open           = Open,
    Close          = Close2,
    Toggle         = Toggle,
    SetTitle       = SetTitle,
    SetVersion     = SetVersion,
    SetPillText    = SetPillText,
    setAccentColor = setAccentColor,
    RefreshCanvas  = RefreshCanvas,
    Theme          = Theme,
    CreateTab      = CreateTab,
    ActivateTab    = ActivateTab,
    CreateSlider      = CreateSlider,
    CreateToggle      = CreateToggle,
    CreateKeyBind     = CreateKeyBind,
    CreateButton      = CreateButton,
    CreateLabel       = CreateLabel,
    NewColorPicker    = NewColorPicker,
    Notify            = Notify,
    Card              = Card,
    Icon              = Icon,
    Label             = Label,
    Corner            = Corner,
    SafeTween         = SafeTween,
    Stroke            = Stroke,
    Root              = Root,
    Main              = Main,
    ContentScroll     = ContentScroll,
    TabScroll         = TabScroll,
}
