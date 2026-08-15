local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Lucide = nil
pcall(function()
    Lucide = loadstring(game:HttpGet("https://github.com/latte-soft/lucide-roblox/releases/latest/download/lucide-roblox.luau"))()
end)

local function getLucideAsset(iconName)
    if not Lucide then return nil end
    local ok, asset = pcall(function()
        return Lucide.GetAsset(iconName, 48)
    end)
    return ok and asset or nil
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

local function Corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
    return c
end

local function Stroke(inst, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Line
    s.Thickness = thickness or 1
    s.Parent = inst
    return s
end

local T = {
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

local _accentObjs = {}
local _accentDarkObjs = {}
local _customAccentCallbacks = {}

local function _regAcc(o, p)
    table.insert(_accentObjs, {o, p})
end

local function _regDark(o, p)
    table.insert(_accentDarkObjs, {o, p})
end

local function setAccentColor(color)
    T.Accent = color
    T.Accent2 = color
    T.Hot = color
    for _, e in ipairs(_accentObjs) do
        pcall(function() e[1][e[2]] = color end)
    end
    for _, fn in ipairs(_customAccentCallbacks) do
        pcall(fn, color)
    end
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "iDepHubUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = T.Base
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Corner(mainFrame, 8)
local mainStroke = Stroke(mainFrame, T.Line, 1.5)
_regAcc(mainStroke, "Color")

local function CenterWindow()
    local viewport = game:GetService("Workspace").CurrentCamera and game:GetService("Workspace").CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local w, h = 480, 400
    mainFrame.Position = UDim2.new(0, (viewport.X - w) / 2, 0, (viewport.Y - h) / 2)
    mainFrame.Size = UDim2.new(0, w, 0, h)
end

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 54)
topBar.BackgroundColor3 = T.Panel
topBar.BorderSizePixel = 0
topBar.ZIndex = 5
topBar.Parent = mainFrame
Corner(topBar, 8)

local topDiv = Instance.new("Frame")
topDiv.Size = UDim2.new(1, 0, 0, 1)
topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = T.Line
topDiv.BorderSizePixel = 0
topDiv.ZIndex = 6
topDiv.Parent = topBar

local LogoWrap = Instance.new("Frame")
LogoWrap.Size = UDim2.new(0, 20, 0, 20)
LogoWrap.Position = UDim2.new(0, 20, 0, 17)
LogoWrap.Rotation = 45
LogoWrap.BackgroundTransparency = 1
LogoWrap.Parent = topBar

local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.BorderSizePixel = 0
Logo.Parent = LogoWrap
Corner(Logo, 5)

local LogoGrad = Instance.new("UIGradient")
LogoGrad.Color = ColorSequence.new(T.Accent, T.Accent)
LogoGrad.Rotation = 45
LogoGrad.Parent = Logo
_regAcc(LogoGrad, "Color")

local LogoCore = Instance.new("Frame")
LogoCore.Size = UDim2.new(0, 8, 0, 8)
LogoCore.Position = UDim2.new(0.5, -4, 0.5, -4)
LogoCore.BackgroundColor3 = T.Base
LogoCore.BorderSizePixel = 0
LogoCore.Parent = Logo
Corner(LogoCore, 2)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 260, 0, 20)
titleLabel.Position = UDim2.new(0, 54, 0, 16)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "UI Library - Nyther"
titleLabel.TextColor3 = T.Accent
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 7
titleLabel.Parent = topBar
_regAcc(titleLabel, "TextColor3")

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 60, 0, 16)
versionLabel.Position = UDim2.new(0, 54, 0, 34)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "By L#######"
versionLabel.TextColor3 = T.Dim
versionLabel.TextSize = 9
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.ZIndex = 7
versionLabel.Parent = topBar

local Pill = Instance.new("Frame")
Pill.Size = UDim2.new(0, 116, 0, 22)
Pill.Position = UDim2.new(1, -172, 0, 16)
Pill.BackgroundColor3 = T.Raised
Pill.BorderSizePixel = 0
Pill.Parent = topBar
Corner(Pill, 11)
local PillStroke = Stroke(Pill, T.Accent, 0.5)
_regAcc(PillStroke, "Color")

local PillDot = Instance.new("Frame")
PillDot.Size = UDim2.new(0, 6, 0, 6)
PillDot.Position = UDim2.new(0, 10, 0.5, -3)
PillDot.BackgroundColor3 = T.Good
PillDot.BorderSizePixel = 0
PillDot.Parent = Pill
Corner(PillDot, 3)

task.spawn(function()
    while mainFrame and mainFrame.Parent and PillDot and PillDot.Parent do
        SafeTween(PillDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.55 })
        task.wait(0.7)
        if not mainFrame or not mainFrame.Parent or not PillDot or not PillDot.Parent then break end
        SafeTween(PillDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 })
        task.wait(0.7)
    end
end)

local PillText = Instance.new("TextLabel")
PillText.Size = UDim2.new(1, -24, 1, 0)
PillText.Position = UDim2.new(0, 22, 0, 0)
PillText.BackgroundTransparency = 1
PillText.Text = "Activate"
PillText.TextColor3 = T.Text
PillText.TextSize = 11
PillText.Font = Enum.Font.GothamBold
PillText.Parent = Pill

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -42, 0, 13)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = T.Dim
closeBtn.TextSize = 15
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 8
closeBtn.Parent = topBar
Corner(closeBtn, 6)

closeBtn.MouseEnter:Connect(function()
    SafeTween(closeBtn, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 50, 50) })
end)
closeBtn.MouseLeave:Connect(function()
    SafeTween(closeBtn, TweenInfo.new(0.15), { TextColor3 = T.Dim })
end)

RunService.RenderStepped:Connect(function(dt)
    if LogoWrap and LogoWrap.Parent then
        LogoWrap.Rotation = (LogoWrap.Rotation + dt * 48) % 360
    end
end)

local eyeGui = nil
local eyeFixed = false
local eyeHidden = false
local eyeLastPos = UDim2.new(0.5, -26, 0, 70)

local function getWindowSize()
    local sz = mainFrame.Size
    local isRel = sz.X.Scale ~= 0
    if isRel then
        return sz.X.Scale, sz.Y.Offset, true
    else
        return sz.X.Offset, sz.Y.Offset, false
    end
end

local function setWindowSize(w, h, isRelative)
    if isRelative then
        mainFrame.Size = UDim2.new(w, 0, 0, h)
    else
        mainFrame.Size = UDim2.new(0, w, 0, h)
    end
end

local function setEyeFixed(v)
    eyeFixed = v
end

local function applyEyeVisibility(btn, stroke, hidden)
    if hidden then
        btn.BackgroundTransparency = 1
        if stroke then stroke.Transparency = 1 end
        for _, c in ipairs(btn:GetChildren()) do
            if c:IsA("ImageLabel") then c.ImageTransparency = 1
            elseif c:IsA("TextLabel") then c.TextTransparency = 1
            end
        end
    else
        btn.BackgroundTransparency = 0.15
        if stroke then stroke.Transparency = 0 end
        for _, c in ipairs(btn:GetChildren()) do
            if c:IsA("ImageLabel") then c.ImageTransparency = 0
            elseif c:IsA("TextLabel") then c.TextTransparency = 0
            end
        end
    end
end

local function setEyeHidden(v)
    eyeHidden = v
    if not eyeGui then return end
    local btn = eyeGui:FindFirstChild("EyeBtn")
    if not btn then return end
    local stroke = btn:FindFirstChildWhichIsA("UIStroke")
    applyEyeVisibility(btn, stroke, eyeHidden)
end

local function createEyeIcon()
    if eyeGui then eyeGui:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "NytherEyeIcon"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 998

    local btn = Instance.new("TextButton")
    btn.Name = "EyeBtn"
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Position = eyeLastPos
    btn.AnchorPoint = Vector2.new(0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = sg
    Corner(btn, 13)

    local eyeStroke = Instance.new("UIStroke")
    eyeStroke.Color = T.Accent
    eyeStroke.Thickness = 1.5
    eyeStroke.Parent = btn
    _regAcc(eyeStroke, "Color")

    local eyeAsset = getLucideAsset("eye")
    if eyeAsset then
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 26, 0, 26)
        img.Position = UDim2.new(0.5, -13, 0.5, -13)
        img.BackgroundTransparency = 1
        img.Image = eyeAsset.Url
        img.ImageRectSize = eyeAsset.ImageRectSize
        img.ImageRectOffset = eyeAsset.ImageRectOffset
        img.ScaleType = Enum.ScaleType.Fit
        img.ImageColor3 = T.Accent
        img.ZIndex = 6
        img.Parent = btn
        _regAcc(img, "ImageColor3")
    else
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "👁"
        lbl.TextSize = 22
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.ZIndex = 6
        lbl.Parent = btn
    end

    local dragging, dragStart, startPos = false, nil, nil

    btn.InputBegan:Connect(function(inp)
        if eyeFixed then return end
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = btn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging or eyeFixed then return end
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if eyeFixed then return end
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                eyeLastPos = btn.Position
            end
            dragging = false
        end
    end)

    btn.MouseButton1Click:Connect(function()
        eyeLastPos = btn.Position
        mainFrame.Visible = true
        sg:Destroy()
        eyeGui = nil
    end)

    sg.Parent = game:GetService("CoreGui")
    eyeGui = sg

    applyEyeVisibility(btn, eyeStroke, eyeHidden)
end

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    createEyeIcon()
end)

local bodyFrame = Instance.new("Frame")
bodyFrame.Size = UDim2.new(1, 0, 1, -54)
bodyFrame.Position = UDim2.new(0, 0, 0, 54)
bodyFrame.BackgroundTransparency = 1
bodyFrame.BorderSizePixel = 0
bodyFrame.Parent = mainFrame

local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 22)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundColor3 = T.Base
footer.BorderSizePixel = 0
footer.ZIndex = 5
footer.Parent = mainFrame

local footerLine = Instance.new("Frame")
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.Position = UDim2.new(0, 0, 0, 0)
footerLine.BackgroundColor3 = T.Line
footerLine.BorderSizePixel = 0
footerLine.ZIndex = 6
footerLine.Parent = footer
_regAcc(footerLine, "BackgroundColor3")

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 1, 0)
footerLabel.Position = UDim2.new(0, 0, 0, 0)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "By L#######"
footerLabel.TextColor3 = T.Dim
footerLabel.TextSize = 11
footerLabel.Font = Enum.Font.GothamSemibold
footerLabel.TextXAlignment = Enum.TextXAlignment.Center
footerLabel.ZIndex = 6
footerLabel.Parent = footer
_regAcc(footerLabel, "TextColor3")

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 146, 1, 0)
sidebar.BackgroundColor3 = T.Base
sidebar.BorderSizePixel = 0
sidebar.Parent = bodyFrame

local sidebarLine = Instance.new("Frame")
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.Position = UDim2.new(0, 131, 0, 0)
sidebarLine.BackgroundColor3 = T.Line
sidebarLine.BorderSizePixel = 0
sidebarLine.Parent = bodyFrame
_regAcc(sidebarLine, "BackgroundColor3")

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = sidebar

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop = UDim.new(0, 8)
sidebarPad.PaddingLeft = UDim.new(0, 8)
sidebarPad.PaddingRight = UDim.new(0, 8)
sidebarPad.Parent = sidebar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -146, 1, 0)
contentFrame.Position = UDim2.new(0, 146, 0, 0)
contentFrame.BackgroundColor3 = T.Base
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.Parent = bodyFrame

local registeredTabs = {}

local function SelectTab(target)
    for _, td in ipairs(registeredTabs) do
        td.page.Visible = false
        td.accent.Visible = false
        SafeTween(td.btn, TweenInfo.new(0.12), { BackgroundColor3 = T.Raised })
        SafeTween(td.nameLbl, TweenInfo.new(0.12), { TextColor3 = T.Dim })
        if td.iconImg then
            SafeTween(td.iconImg, TweenInfo.new(0.12), { ImageColor3 = T.Dim })
        end
        if td.customPanel then td.customPanel.Visible = false end
    end
    target.accent.Visible = true
    SafeTween(target.btn, TweenInfo.new(0.12), { BackgroundColor3 = T.Hover })
    SafeTween(target.nameLbl, TweenInfo.new(0.12), { TextColor3 = T.Accent })
    if target.iconImg then
        SafeTween(target.iconImg, TweenInfo.new(0.12), { ImageColor3 = T.Accent })
    end
    if target.customPanel then
        target.page.Visible = false
        target.customPanel.Visible = true
    else
        target.page.Visible = true
    end
    if target.onTabSelected then target.onTabSelected() end
end

local function NewTab(name, icon, order)
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.BackgroundColor3 = T.Raised
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Parent = sidebar
    Corner(btn, 6)

    local accentBar = Instance.new("Frame")
    accentBar.Name = "Accent"
    accentBar.Size = UDim2.new(0, 3, 0, 20)
    accentBar.Position = UDim2.new(0, 0, 0.5, -10)
    accentBar.BackgroundColor3 = T.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Visible = false
    accentBar.Parent = btn
    Corner(accentBar, 2)
    _regAcc(accentBar, "BackgroundColor3")

    local iconImg = nil
    local hasVisibleIcon = false
    local lucideAsset = nil

    if type(icon) == "string" and icon ~= "" and not icon:match("^%d+$") and not icon:match("^rbxassetid://") then
        lucideAsset = getLucideAsset(icon)
    end

    if lucideAsset then
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 16, 0, 16)
        img.Position = UDim2.new(0, 10, 0.5, -8)
        img.BackgroundTransparency = 1
        img.Image = lucideAsset.Url
        img.ImageRectSize = lucideAsset.ImageRectSize
        img.ImageRectOffset = lucideAsset.ImageRectOffset
        img.ScaleType = Enum.ScaleType.Fit
        img.ImageColor3 = T.Dim
        img.Parent = btn
        iconImg = img
        hasVisibleIcon = true
    elseif (type(icon) == "number") or (type(icon) == "string" and (icon:match("^%d+$") or icon:match("^rbxassetid://"))) then
        local rawId = type(icon) == "number" and tostring(icon) or (icon:match("^%d+$") and icon or icon:gsub("rbxassetid://", ""))
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 16, 0, 16)
        img.Position = UDim2.new(0, 10, 0.5, -8)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://" .. rawId
        img.ImageColor3 = T.Dim
        img.ScaleType = Enum.ScaleType.Fit
        img.Parent = btn
        iconImg = img
        hasVisibleIcon = true
    elseif type(icon) == "string" and icon ~= "" then
        local iconLbl = Instance.new("TextLabel")
        iconLbl.Size = UDim2.new(0, 22, 1, 0)
        iconLbl.Position = UDim2.new(0, 9, 0, 0)
        iconLbl.BackgroundTransparency = 1
        iconLbl.Text = icon
        iconLbl.TextSize = 15
        iconLbl.Font = Enum.Font.GothamSemibold
        iconLbl.TextXAlignment = Enum.TextXAlignment.Center
        iconLbl.Parent = btn
        hasVisibleIcon = true
    end

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "Label"
    nameLbl.Size = hasVisibleIcon and UDim2.new(1, -36, 1, 0) or UDim2.new(1, -14, 1, 0)
    nameLbl.Position = hasVisibleIcon and UDim2.new(0, 35, 0, 0) or UDim2.new(0, 10, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = T.Dim
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentFrame
    _regAcc(page, "ScrollBarImageColor3")

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 12)
    pageLayout.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop = UDim.new(0, 16)
    pagePad.PaddingBottom = UDim.new(0, 16)
    pagePad.PaddingLeft = UDim.new(0, 16)
    pagePad.PaddingRight = UDim.new(0, 16)
    pagePad.Parent = page

    local tabData = { btn = btn, accent = accentBar, nameLbl = nameLbl, page = page, iconImg = iconImg }
    table.insert(registeredTabs, tabData)

    btn.MouseButton1Click:Connect(function() SelectTab(tabData) end)
    btn.MouseEnter:Connect(function()
        if page.Visible or (tabData.customPanel and tabData.customPanel.Visible) then return end
        SafeTween(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
    end)
    btn.MouseLeave:Connect(function()
        if page.Visible or (tabData.customPanel and tabData.customPanel.Visible) then return end
        SafeTween(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
    end)

    return page, tabData
end

local _ord = 0
local function nextOrd() _ord += 1; return _ord end

local function ElemBase(parent, h)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, h)
    f.BackgroundColor3 = T.Raised
    f.BorderSizePixel = 0
    f.LayoutOrder = nextOrd()
    f.Parent = parent
    Corner(f, 8)
    local s = Stroke(f, T.Line, 0.5)
    return f, s
end

local function NewSection(parent, title, iconName)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundTransparency = 1
    sec.BorderSizePixel = 0
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.LayoutOrder = nextOrd()
    sec.Parent = parent

    local secLayout = Instance.new("UIListLayout")
    secLayout.SortOrder = Enum.SortOrder.LayoutOrder
    secLayout.Padding = UDim.new(0, 8)
    secLayout.Parent = sec

    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 24)
    hdr.BackgroundTransparency = 1
    hdr.LayoutOrder = nextOrd()
    hdr.Parent = sec

    local iconOffset = 0
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 14, 0, 14)
            img.Position = UDim2.new(0, 3, 0.5, -7)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = hdr
            _regAcc(img, "ImageColor3")
            iconOffset = 20
        end
    end

    local hdrTxt = Instance.new("TextLabel")
    hdrTxt.Size = UDim2.new(1, -iconOffset, 1, -2)
    hdrTxt.Position = UDim2.new(0, iconOffset, 0, 0)
    hdrTxt.BackgroundTransparency = 1
    hdrTxt.Text = title
    hdrTxt.TextColor3 = T.Dim
    hdrTxt.TextSize = 11
    hdrTxt.Font = Enum.Font.GothamBold
    hdrTxt.TextXAlignment = Enum.TextXAlignment.Left
    hdrTxt.Parent = hdr

    local hdrLine = Instance.new("Frame")
    hdrLine.Size = UDim2.new(1, 0, 0, 1)
    hdrLine.Position = UDim2.new(0, 0, 1, -1)
    hdrLine.BackgroundColor3 = T.Line
    hdrLine.BorderSizePixel = 0
    hdrLine.Parent = hdr

    return sec
end

local function NewToggle(parent, label, sub, default, callback, iconName)
    local f, stroke = ElemBase(parent, 46)

    local labelOffset = 10
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0, 10, 0, 7)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = f
            _regAcc(img, "ImageColor3")
            labelOffset = 30
        end
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 0, 18)
    lbl.Position = UDim2.new(0, labelOffset, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -70, 0, 14)
    subLbl.Position = UDim2.new(0, labelOffset, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = T.Dim
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = f

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 36, 0, 20)
    track.Position = UDim2.new(1, -46, 0.5, -10)
    track.BackgroundColor3 = default and T.Accent or T.Toggle
    track.BorderSizePixel = 0
    track.Parent = f
    Corner(track, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -8, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
    knob.BackgroundColor3 = T.Base
    knob.BorderSizePixel = 0
    knob.Parent = track
    Corner(knob, 8)

    local knobStroke = Stroke(knob, T.Accent, 1.5)
    _regAcc(knobStroke, "Color")

    local state = default or false
    local locked = false

    local lockOverlay = Instance.new("Frame")
    lockOverlay.Name = "LockOverlay"
    lockOverlay.Size = UDim2.new(1, 0, 1, 0)
    lockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    lockOverlay.BackgroundTransparency = 0.40
    lockOverlay.BorderSizePixel = 0
    lockOverlay.ZIndex = 10
    lockOverlay.Visible = false
    lockOverlay.Parent = f
    Corner(lockOverlay, 8)

    local lockLucideAsset = getLucideAsset("lock")
    if lockLucideAsset then
        local lockIcon = Instance.new("ImageLabel")
        lockIcon.Size = UDim2.new(0, 14, 0, 14)
        lockIcon.Position = UDim2.new(0.5, -38, 0.5, -7)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = lockLucideAsset.Url
        lockIcon.ImageRectSize = lockLucideAsset.ImageRectSize
        lockIcon.ImageRectOffset = lockLucideAsset.ImageRectOffset
        lockIcon.ScaleType = Enum.ScaleType.Fit
        lockIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        lockIcon.ZIndex = 11
        lockIcon.Parent = lockOverlay
    else
        local lockIcon = Instance.new("TextLabel")
        lockIcon.Size = UDim2.new(0, 18, 1, 0)
        lockIcon.Position = UDim2.new(0.5, -42, 0, 0)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Text = "🔒"
        lockIcon.TextSize = 13
        lockIcon.Font = Enum.Font.GothamBold
        lockIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
        lockIcon.TextXAlignment = Enum.TextXAlignment.Center
        lockIcon.TextYAlignment = Enum.TextYAlignment.Center
        lockIcon.ZIndex = 11
        lockIcon.Parent = lockOverlay
    end

    local lockTxt = Instance.new("TextLabel")
    lockTxt.Size = UDim2.new(0, 56, 1, 0)
    lockTxt.Position = UDim2.new(0.5, -22, 0, 0)
    lockTxt.BackgroundTransparency = 1
    lockTxt.Text = "Locked"
    lockTxt.TextSize = 13
    lockTxt.Font = Enum.Font.GothamBold
    lockTxt.TextColor3 = Color3.fromRGB(200, 200, 200)
    lockTxt.TextXAlignment = Enum.TextXAlignment.Left
    lockTxt.TextYAlignment = Enum.TextYAlignment.Center
    lockTxt.ZIndex = 11
    lockTxt.Parent = lockOverlay

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    local function setState(newState)
        state = newState
        SafeTween(track, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
            BackgroundColor3 = state and T.Accent or T.Toggle
        })
        SafeTween(knob, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
            Position = state and UDim2.new(1, -8, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
        })
    end

    local function setLocked(isLocked)
        locked = isLocked
        lockOverlay.Visible = isLocked
    end

    table.insert(_customAccentCallbacks, function()
        if state then
            track.BackgroundColor3 = T.Accent
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if locked then return end
        setState(not state)
        if callback then callback(state) end
    end)
    btn.MouseEnter:Connect(function()
        if locked then return end
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
        SafeTween(stroke, TweenInfo.new(0.1), { Color = Color3.fromRGB(48, 48, 48) })
    end)
    btn.MouseLeave:Connect(function()
        if locked then return end
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
        SafeTween(stroke, TweenInfo.new(0.1), { Color = T.Line })
    end)

    return f, setState, setLocked
end

local function NewSlider(parent, label, sub, minVal, maxVal, default, callback, iconName)
    local f, stroke = ElemBase(parent, 52)

    local labelOffset = 10
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0, 10, 0, 8)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = f
            _regAcc(img, "ImageColor3")
            labelOffset = 30
        end
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.62, 0, 0, 18)
    lbl.Position = UDim2.new(0, labelOffset, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(0.62, 0, 0, 14)
    subLbl.Position = UDim2.new(0, labelOffset, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = T.Dim
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = f

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.38, -12, 0, 18)
    valLbl.Position = UDim2.new(0.62, 0, 0, 8)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = T.Accent
    valLbl.TextSize = 13
    valLbl.Font = Enum.Font.GothamSemibold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = f
    _regAcc(valLbl, "TextColor3")

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, -20, 0, 4)
    trackBg.Position = UDim2.new(0, 10, 1, -16)
    trackBg.BackgroundColor3 = T.Toggle
    trackBg.BorderSizePixel = 0
    trackBg.Parent = f
    Corner(trackBg, 2)

    local pct0 = (default - minVal) / (maxVal - minVal)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct0, 0, 1, 0)
    fill.BackgroundColor3 = T.Accent
    fill.BorderSizePixel = 0
    fill.Parent = trackBg
    Corner(fill, 2)

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Accent),
        ColorSequenceKeypoint.new(1, Color3.new(T.Accent.R * 0.75, T.Accent.G * 0.75, T.Accent.B * 0.75))
    })
    fillGrad.Rotation = 90
    fillGrad.Parent = fill
    _regAcc(fillGrad, "Color")
    table.insert(_customAccentCallbacks, function(c)
        fillGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c),
            ColorSequenceKeypoint.new(1, Color3.new(c.R * 0.75, c.G * 0.75, c.B * 0.75))
        })
    end)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(pct0, 0, 0.5, 0)
    knob.BackgroundColor3 = T.Base
    knob.BorderSizePixel = 0
    knob.Parent = trackBg
    Corner(knob, 8)

    local knobStroke = Stroke(knob, T.Accent, 2)
    _regAcc(knobStroke, "Color")

    local knobDot = Instance.new("Frame")
    knobDot.Size = UDim2.new(0, 6, 0, 6)
    knobDot.AnchorPoint = Vector2.new(0.5, 0.5)
    knobDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    knobDot.BackgroundColor3 = T.Accent
    knobDot.BorderSizePixel = 0
    knobDot.Parent = knob
    Corner(knobDot, 3)

    local trackBtn = Instance.new("TextButton")
    trackBtn.Size = UDim2.new(1, 0, 5, 0)
    trackBtn.Position = UDim2.new(0, 0, -2, 0)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text = ""
    trackBtn.Parent = trackBg

    local draggingSl = false

    local function updateSl(x)
        local relX = math.clamp((x - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + relX * (maxVal - minVal) + 0.5)
        local p = (value - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        valLbl.Text = tostring(value)
        if callback then callback(value) end
    end

    trackBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSl = true
            SafeTween(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 20, 0, 20) })
            updateSl(inp.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if draggingSl and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            updateSl(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if draggingSl then
                draggingSl = false
                SafeTween(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 16, 0, 16) })
            end
        end
    end)

    f.MouseEnter:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
    end)
    f.MouseLeave:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
    end)

    return f
end

local function NewButton(parent, label, sub, callback, iconName)
    local f, stroke = ElemBase(parent, 40)

    local labelOffset = 10
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0, 10, 0, 6)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = f
            _regAcc(img, "ImageColor3")
            labelOffset = 30
        end
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 0, 18)
    lbl.Position = UDim2.new(0, labelOffset, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -50, 0, 14)
    subLbl.Position = UDim2.new(0, labelOffset, 0, 23)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = T.Dim
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = f

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 28, 1, 0)
    arrow.Position = UDim2.new(1, -34, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = T.Dim
    arrow.TextSize = 22
    arrow.Font = Enum.Font.GothamSemibold
    arrow.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    btn.MouseButton1Click:Connect(function()
        SafeTween(f, TweenInfo.new(0.05), { BackgroundColor3 = T.Hover })
        task.delay(0.12, function()
            SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
        end)
        if callback then callback() end
    end)
    btn.MouseEnter:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
        SafeTween(stroke, TweenInfo.new(0.1), { Color = T.Accent })
    end)
    btn.MouseLeave:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
        SafeTween(stroke, TweenInfo.new(0.1), { Color = T.Line })
    end)

    return f
end

local function NewInput(parent, label, placeholder, callback)
    local f, stroke = ElemBase(parent, 46)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.48, -10, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(0.48, -10, 0, 14)
    subLbl.Position = UDim2.new(0, 10, 0, 25)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Escribe un valor"
    subLbl.TextColor3 = T.Dim
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = f

    local boxBg = Instance.new("Frame")
    boxBg.Size = UDim2.new(0.52, -14, 0, 28)
    boxBg.Position = UDim2.new(0.48, 0, 0.5, -14)
    boxBg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    boxBg.BorderSizePixel = 0
    boxBg.Parent = f
    Corner(boxBg, 5)

    local boxStroke = Stroke(boxBg, T.Line, 0.5)

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -12, 1, 0)
    textBox.Position = UDim2.new(0, 6, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = placeholder or "..."
    textBox.PlaceholderColor3 = T.Dim
    textBox.TextColor3 = T.Accent
    textBox.TextSize = 12
    textBox.Font = Enum.Font.GothamSemibold
    textBox.TextXAlignment = Enum.TextXAlignment.Center
    textBox.ClearTextOnFocus = false
    textBox.Parent = boxBg

    textBox.Focused:Connect(function()
        SafeTween(boxStroke, TweenInfo.new(0.1), { Color = T.Accent })
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
        SafeTween(stroke, TweenInfo.new(0.1), { Color = T.Accent })
    end)
    textBox.FocusLost:Connect(function(enterPressed)
        SafeTween(boxStroke, TweenInfo.new(0.1), { Color = T.Line })
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
        SafeTween(stroke, TweenInfo.new(0.1), { Color = T.Line })
        if callback then callback(textBox.Text) end
    end)

    f.MouseEnter:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
    end)
    f.MouseLeave:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
    end)

    return f, textBox
end

local function NewKeybind(parent, label, sub, defaultKey, callback, iconName)
    local f, stroke = ElemBase(parent, 46)

    local listening = false
    local currentKey = defaultKey

    local labelOffset = 10
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0, 10, 0, 7)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = f
            _regAcc(img, "ImageColor3")
            labelOffset = 30
        end
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -82, 0, 18)
    lbl.Position = UDim2.new(0, labelOffset, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -82, 0, 14)
    subLbl.Position = UDim2.new(0, labelOffset, 0, 25)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = T.Dim
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = f

    local keyBg = Instance.new("Frame")
    keyBg.Size = UDim2.new(0, 80, 0, 28)
    keyBg.Position = UDim2.new(1, -90, 0.5, -14)
    keyBg.BackgroundColor3 = T.Toggle
    keyBg.BorderSizePixel = 0
    keyBg.Parent = f
    Corner(keyBg, 6)

    local keyStroke = Stroke(keyBg, T.Line, 0.5)

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(1, 0, 1, 0)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = defaultKey.Name
    keyLbl.TextColor3 = T.Accent
    keyLbl.TextSize = 11
    keyLbl.Font = Enum.Font.GothamSemibold
    keyLbl.Parent = keyBg

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(1, 0, 1, 0)
    keyBtn.BackgroundTransparency = 1
    keyBtn.Text = ""
    keyBtn.Parent = keyBg

    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyLbl.Text = "..."
        keyLbl.TextColor3 = T.Text
        SafeTween(keyStroke, TweenInfo.new(0.1), { Color = T.Accent })

        local pulse = true
        local function pulseLoop()
            if not listening then return end
            SafeTween(keyBg, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.3 })
            task.wait(0.5)
            if not listening then return end
            SafeTween(keyBg, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 })
            task.wait(0.5)
            if listening then pulseLoop() end
        end
        task.spawn(pulseLoop)

        local conn
        conn = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = inp.KeyCode
                keyLbl.Text = inp.KeyCode.Name
                keyLbl.TextColor3 = T.Accent
                SafeTween(keyStroke, TweenInfo.new(0.1), { Color = T.Line })
                SafeTween(keyBg, TweenInfo.new(0.15), { BackgroundTransparency = 0 })
                listening = false
                conn:Disconnect()
            end
        end)
    end)

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp or listening then return end
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == currentKey and callback then callback() end
        end
    end)

    f.MouseEnter:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
    end)
    f.MouseLeave:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
    end)

    return f
end

local function NewLabel(parent, text, iconName)
    local f, _ = ElemBase(parent, 30)

    local labelOffset = 10
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 14, 0, 14)
            img.Position = UDim2.new(0, 10, 0.5, -7)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Dim
            img.Parent = f
            labelOffset = 28
        end
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -(labelOffset + 10), 1, 0)
    lbl.Position = UDim2.new(0, labelOffset, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.Dim
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = f

    return f
end

local function NewColorPicker(parent, label, sub, defaultColor, callback, iconName)
    defaultColor = defaultColor or T.Accent

    local SQ_H = 120
    local HUE_W = 14
    local GAP = 12
    local PAD = 12
    local SQ_Y = 10
    local INP_H = 28
    local INP_Y = SQ_Y + SQ_H + 10
    local BODY_H = INP_Y + INP_H + 12

    local function toHexStr(c)
        return string.format("#%02X%02X%02X",
            math.floor(c.R * 255 + 0.5),
            math.floor(c.G * 255 + 0.5),
            math.floor(c.B * 255 + 0.5))
    end

    local function fromHexStr(s)
        s = s:gsub("#", ""):gsub("%s", "")
        if #s ~= 6 then return nil end
        local r = tonumber(s:sub(1, 2), 16)
        local g = tonumber(s:sub(3, 4), 16)
        local b = tonumber(s:sub(5, 6), 16)
        if not (r and g and b) then return nil end
        return Color3.fromRGB(r, g, b)
    end

    local function clampByte(n)
        n = tonumber(n)
        if not n then return nil end
        return math.clamp(math.floor(n + 0.5), 0, 255)
    end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.LayoutOrder = nextOrd()
    container.Parent = parent

    local cLayout = Instance.new("UIListLayout")
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding = UDim.new(0, 6)
    cLayout.Parent = container

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = T.Raised
    header.BorderSizePixel = 0
    header.LayoutOrder = 1
    header.Parent = container
    Corner(header, 8)
    local hStroke = Stroke(header, T.Line, 0.5)

    local labelOffset = 10
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0, 10, 0, 9)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = header
            _regAcc(img, "ImageColor3")
            labelOffset = 30
        end
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -72, 0, 18)
    lbl.Position = UDim2.new(0, labelOffset, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = header

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -72, 0, 14)
    subLbl.Position = UDim2.new(0, labelOffset, 0, 28)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = T.Dim
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
    Stroke(preview, T.Line, 0.5)

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 1, 0)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = header

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 0, BODY_H)
    body.BackgroundColor3 = T.Base
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
    wOver.Size = UDim2.new(1, 0, 1, 0)
    wOver.BackgroundColor3 = Color3.new(1, 1, 1)
    wOver.BackgroundTransparency = 0
    wOver.BorderSizePixel = 0
    wOver.ZIndex = 2
    wOver.Parent = square

    local wGrad = Instance.new("UIGradient")
    wGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    wGrad.Rotation = 0
    wGrad.Parent = wOver

    local bOver = Instance.new("Frame")
    bOver.Size = UDim2.new(1, 0, 1, 0)
    bOver.BackgroundColor3 = Color3.new(0, 0, 0)
    bOver.BackgroundTransparency = 0
    bOver.BorderSizePixel = 0
    bOver.ZIndex = 3
    bOver.Parent = square

    local bGrad = Instance.new("UIGradient")
    bGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0),
    })
    bGrad.Rotation = 90
    bGrad.Parent = bOver

    local sqKnob = Instance.new("Frame")
    sqKnob.Size = UDim2.new(0, 12, 0, 12)
    sqKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    sqKnob.Position = UDim2.new(S, 0, 1 - V, 0)
    sqKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    sqKnob.BorderSizePixel = 0
    sqKnob.ZIndex = 10
    sqKnob.Parent = square
    Corner(sqKnob, 6)

    local sqKnobStroke = Instance.new("UIStroke")
    sqKnobStroke.Color = Color3.new(0, 0, 0)
    sqKnobStroke.Thickness = 1.5
    sqKnobStroke.Parent = sqKnob

    local sqBtn = Instance.new("TextButton")
    sqBtn.Size = UDim2.new(1, 0, 1, 0)
    sqBtn.BackgroundTransparency = 1
    sqBtn.Text = ""
    sqBtn.ZIndex = 11
    sqBtn.Parent = square

    local hueBar = Instance.new("Frame")
    hueBar.Size = UDim2.new(0, HUE_W, 0, SQ_H)
    hueBar.Position = UDim2.new(1, -(PAD + HUE_W), 0, SQ_Y)
    hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
    hueBar.BorderSizePixel = 0
    hueBar.Parent = body
    Corner(hueBar, 3)

    local hueGrad = Instance.new("UIGradient")
    hueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1)),
    })
    hueGrad.Rotation = 90
    hueGrad.Parent = hueBar

    local hueKnob = Instance.new("Frame")
    hueKnob.Size = UDim2.new(1, 4, 0, 3)
    hueKnob.AnchorPoint = Vector2.new(0, 0.5)
    hueKnob.Position = UDim2.new(0, -2, H, 0)
    hueKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    hueKnob.BorderSizePixel = 0
    hueKnob.ZIndex = 10
    hueKnob.Parent = hueBar

    local hueKnobStroke = Instance.new("UIStroke")
    hueKnobStroke.Color = Color3.new(0, 0, 0)
    hueKnobStroke.Thickness = 1
    hueKnobStroke.Parent = hueKnob

    local hueBtn = Instance.new("TextButton")
    hueBtn.Size = UDim2.new(1, 0, 1, 0)
    hueBtn.BackgroundTransparency = 1
    hueBtn.Text = ""
    hueBtn.ZIndex = 11
    hueBtn.Parent = hueBar

    local function makeInputBox(posX_scale, posX_off, sizeX_scale, sizeX_off, placeholder)
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(sizeX_scale, sizeX_off, 0, INP_H)
        bg.Position = UDim2.new(posX_scale, posX_off, 0, INP_Y)
        bg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        bg.BorderSizePixel = 0
        bg.Parent = body
        Corner(bg, 5)
        Stroke(bg, T.Line, 0.5)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -6, 1, 0)
        box.Position = UDim2.new(0, 3, 0, 0)
        box.BackgroundTransparency = 1
        box.Text = placeholder
        box.PlaceholderText = placeholder
        box.TextColor3 = T.Text
        box.PlaceholderColor3 = T.Dim
        box.TextSize = 10
        box.Font = Enum.Font.GothamSemibold
        box.TextXAlignment = Enum.TextXAlignment.Center
        box.ClearTextOnFocus = false
        box.Parent = bg
        return box
    end

    local hexBox = makeInputBox(0, PAD, 1, -136, "#000000")
    local rBox = makeInputBox(1, -120, 0, 34, "R")
    local gBox = makeInputBox(1, -82, 0, 34, "G")
    local bBox = makeInputBox(1, -44, 0, 34, "B")

    local function getColor() return Color3.fromHSV(H, S, V) end

    local function refreshInputs()
        local c = getColor()
        local r = math.floor(c.R * 255 + 0.5)
        local g = math.floor(c.G * 255 + 0.5)
        local b = math.floor(c.B * 255 + 0.5)
        hexBox.Text = string.format("#%02X%02X%02X", r, g, b)
        rBox.Text = tostring(r)
        gBox.Text = tostring(g)
        bBox.Text = tostring(b)
    end

    local function refreshVisuals()
        local c = getColor()
        preview.BackgroundColor3 = c
        square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        if callback then callback(c) end
    end

    local function applyHSV(nh, ns, nv)
        H = nh
        S = ns
        V = nv
        sqKnob.Position = UDim2.new(S, 0, 1 - V, 0)
        hueKnob.Position = UDim2.new(0, -2, H, 0)
        refreshVisuals()
        refreshInputs()
    end

    local function updateFromSquare(mx, my)
        local rx = math.clamp((mx - square.AbsolutePosition.X) / square.AbsoluteSize.X, 0, 1)
        local ry = math.clamp((my - square.AbsolutePosition.Y) / square.AbsoluteSize.Y, 0, 1)
        S = rx
        V = 1 - ry
        sqKnob.Position = UDim2.new(rx, 0, ry, 0)
        refreshVisuals()
        refreshInputs()
    end

    local function updateFromHue(my)
        local ry = math.clamp((my - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
        H = ry
        hueKnob.Position = UDim2.new(0, -2, ry, 0)
        square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        refreshVisuals()
        refreshInputs()
    end

    local dragSq, dragHue = false, false

    local function isTouchOrMouse1(inp)
        return inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch
    end

    local function isMoveEvent(inp)
        return inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch
    end

    sqBtn.InputBegan:Connect(function(inp)
        if isTouchOrMouse1(inp) then
            dragSq = true
            updateFromSquare(inp.Position.X, inp.Position.Y)
        end
    end)

    hueBtn.InputBegan:Connect(function(inp)
        if isTouchOrMouse1(inp) then
            dragHue = true
            updateFromHue(inp.Position.Y)
        end
    end)
    sqBtn.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch and dragSq then
            updateFromSquare(inp.Position.X, inp.Position.Y)
        end
    end)

    hueBtn.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch and dragHue then
            updateFromHue(inp.Position.Y)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not isMoveEvent(inp) then return end
        if dragSq then updateFromSquare(inp.Position.X, inp.Position.Y) end
        if dragHue then updateFromHue(inp.Position.Y) end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if isTouchOrMouse1(inp) then
            dragSq = false
            dragHue = false
        end
    end)

    hexBox.FocusLost:Connect(function()
        local c = fromHexStr(hexBox.Text)
        if c then
            local nh, ns, nv = Color3.toHSV(c)
            applyHSV(nh, ns, nv)
        else
            refreshInputs()
        end
    end)

    local function applyRGB()
        local r = clampByte(rBox.Text)
        local g = clampByte(gBox.Text)
        local b = clampByte(bBox.Text)
        if r and g and b then
            local nh, ns, nv = Color3.toHSV(Color3.fromRGB(r, g, b))
            applyHSV(nh, ns, nv)
        else
            refreshInputs()
        end
    end

    rBox.FocusLost:Connect(applyRGB)
    gBox.FocusLost:Connect(applyRGB)
    bBox.FocusLost:Connect(applyRGB)

    local expanded = false
    headerBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        body.Visible = expanded
        SafeTween(header, TweenInfo.new(0.15), {
            BackgroundColor3 = expanded and T.Hover or T.Raised,
        })
        SafeTween(hStroke, TweenInfo.new(0.15), {
            Color = expanded and T.Accent or T.Line,
        })
    end)

    header.MouseEnter:Connect(function()
        SafeTween(header, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
        SafeTween(hStroke, TweenInfo.new(0.1), { Color = T.Accent })
    end)

    header.MouseLeave:Connect(function()
        if not expanded then
            SafeTween(header, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
        end
        SafeTween(hStroke, TweenInfo.new(0.1), { Color = T.Line })
    end)

    H, S, V = Color3.toHSV(defaultColor)
    sqKnob.Position = UDim2.new(S, 0, 1 - V, 0)
    hueKnob.Position = UDim2.new(0, -2, H, 0)
    square.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
    refreshVisuals()
    refreshInputs()

    return container
end

local function NewSearchPanel(searchTabData, opts)
    local getWeapons = opts and opts.getWeapons
    local onSend = opts and opts.onSend
    local hideAmount = opts and opts.hideAmount
    local buttonLabel = (opts and opts.buttonLabel) or "Enviar arma"

    local selectedWeapon = nil
    local selectedAmount = 1
    local weaponRowFrames = {}

    local searchOuter = Instance.new("Frame")
    searchOuter.Size = UDim2.new(1, -146, 1, 0)
    searchOuter.Position = UDim2.new(0, 146, 0, 0)
    searchOuter.BackgroundTransparency = 1
    searchOuter.BorderSizePixel = 0
    searchOuter.ClipsDescendants = false
    searchOuter.Visible = false
    searchOuter.Parent = bodyFrame

    local searchBarBg = Instance.new("Frame")
    searchBarBg.Size = UDim2.new(1, -18, 0, 32)
    searchBarBg.Position = UDim2.new(0, 9, 0, 8)
    searchBarBg.BackgroundColor3 = T.Raised
    searchBarBg.BorderSizePixel = 0
    searchBarBg.Parent = searchOuter
    Corner(searchBarBg, 6)

    local _sbStroke = Stroke(searchBarBg, T.Line, 1)
    _regAcc(_sbStroke, "Color")

    local searchIcon = Instance.new("TextLabel")
    searchIcon.Size = UDim2.new(0, 28, 1, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "🔍"
    searchIcon.TextSize = 13
    searchIcon.Font = Enum.Font.GothamSemibold
    searchIcon.TextXAlignment = Enum.TextXAlignment.Center
    searchIcon.Parent = searchBarBg

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -36, 1, 0)
    searchBox.Position = UDim2.new(0, 28, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "Buscar arma..."
    searchBox.PlaceholderColor3 = T.Dim
    searchBox.Text = ""
    searchBox.TextColor3 = T.Text
    searchBox.TextSize = 12
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchBarBg

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -18, 1, -130)
    listFrame.Position = UDim2.new(0, 9, 0, 48)
    listFrame.BackgroundColor3 = T.Raised
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 3
    listFrame.ScrollBarImageColor3 = T.Accent
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Parent = searchOuter
    _regAcc(listFrame, "ScrollBarImageColor3")
    Corner(listFrame, 6)

    local _lfStroke = Stroke(listFrame, T.Line, 1)

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listFrame

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 4)
    listPad.PaddingLeft = UDim.new(0, 4)
    listPad.PaddingRight = UDim.new(0, 4)
    listPad.Parent = listFrame

    local bottomPanel = Instance.new("Frame")
    bottomPanel.Size = UDim2.new(1, -18, 0, 68)
    bottomPanel.Position = UDim2.new(0, 9, 1, -74)
    bottomPanel.BackgroundColor3 = T.Base
    bottomPanel.BorderSizePixel = 0
    bottomPanel.Parent = searchOuter
    Corner(bottomPanel, 6)
    Stroke(bottomPanel, T.Line, 1)

    local selLabel = Instance.new("TextLabel")
    selLabel.Size = UDim2.new(1, -12, 0, 20)
    selLabel.Position = UDim2.new(0, 8, 0, 4)
    selLabel.BackgroundTransparency = 1
    selLabel.Text = "Seleccionado: ninguno"
    selLabel.TextColor3 = T.Dim
    selLabel.TextSize = 11
    selLabel.Font = Enum.Font.Gotham
    selLabel.TextXAlignment = Enum.TextXAlignment.Left
    selLabel.TextTruncate = Enum.TextTruncate.AtEnd
    selLabel.Parent = bottomPanel

    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 26, 0, 26)
    minusBtn.Position = UDim2.new(0, 8, 0, 28)
    minusBtn.BackgroundColor3 = T.Toggle
    minusBtn.BorderSizePixel = 0
    minusBtn.Text = "−"
    minusBtn.TextColor3 = T.Accent
    minusBtn.TextSize = 16
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.AutoButtonColor = false
    minusBtn.Parent = bottomPanel
    Corner(minusBtn, 4)

    local amountLabel = Instance.new("TextLabel")
    amountLabel.Size = UDim2.new(0, 40, 0, 26)
    amountLabel.Position = UDim2.new(0, 38, 0, 28)
    amountLabel.BackgroundTransparency = 1
    amountLabel.Text = "1"
    amountLabel.TextColor3 = T.Text
    amountLabel.TextSize = 13
    amountLabel.Font = Enum.Font.GothamBold
    amountLabel.TextXAlignment = Enum.TextXAlignment.Center
    amountLabel.Parent = bottomPanel

    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 26, 0, 26)
    plusBtn.Position = UDim2.new(0, 82, 0, 28)
    plusBtn.BackgroundColor3 = T.Toggle
    plusBtn.BorderSizePixel = 0
    plusBtn.Text = "+"
    plusBtn.TextColor3 = T.Accent
    plusBtn.TextSize = 16
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.AutoButtonColor = false
    plusBtn.Parent = bottomPanel
    Corner(plusBtn, 4)

    local sendBtn = Instance.new("TextButton")
    sendBtn.Size = UDim2.new(0, 110, 0, 26)
    sendBtn.Position = UDim2.new(1, -118, 0, 28)
    sendBtn.BackgroundColor3 = T.Accent
    sendBtn.BorderSizePixel = 0
    sendBtn.Text = buttonLabel
    sendBtn.TextColor3 = T.Base
    sendBtn.TextSize = 12
    sendBtn.Font = Enum.Font.GothamSemibold
    sendBtn.AutoButtonColor = false
    sendBtn.Parent = bottomPanel
    Corner(sendBtn, 4)

    sendBtn.MouseEnter:Connect(function()
        SafeTween(sendBtn, TweenInfo.new(0.1), { BackgroundColor3 = T.Hot })
    end)
    sendBtn.MouseLeave:Connect(function()
        SafeTween(sendBtn, TweenInfo.new(0.1), { BackgroundColor3 = T.Accent })
    end)

    local function SetSelected(name, rowData)
        for _, rf in ipairs(weaponRowFrames) do
            SafeTween(rf.frame, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
            rf.lbl.TextColor3 = T.Dim
        end
        selectedWeapon = name
        if name and rowData then
            SafeTween(rowData.frame, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
            rowData.lbl.TextColor3 = T.Text
            selLabel.Text = "Seleccionado: " .. name
            selLabel.TextColor3 = T.Accent
        else
            selLabel.Text = "Seleccionado: ninguno"
            selLabel.TextColor3 = T.Dim
        end
    end

    local function BuildList(filter)
        for _, rf in ipairs(weaponRowFrames) do rf.frame:Destroy() end
        weaponRowFrames = {}
        selectedWeapon = nil
        selLabel.Text = "Seleccionado: ninguno"
        selLabel.TextColor3 = T.Dim

        local weapons = getWeapons and getWeapons() or {}
        local seen, unique = {}, {}
        for _, w in ipairs(weapons) do
            if not seen[w] then seen[w] = true; table.insert(unique, w) end
        end

        local filterLower = filter and filter:lower() or ""
        for _, weaponName in ipairs(unique) do
            if filterLower == "" or weaponName:lower():find(filterLower, 1, true) then
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 28)
                row.BackgroundColor3 = T.Raised
                row.BorderSizePixel = 0
                row.Parent = listFrame
                Corner(row, 4)

                local rowLbl = Instance.new("TextLabel")
                rowLbl.Size = UDim2.new(1, -10, 1, 0)
                rowLbl.Position = UDim2.new(0, 8, 0, 0)
                rowLbl.BackgroundTransparency = 1
                rowLbl.Text = weaponName
                rowLbl.TextColor3 = T.Dim
                rowLbl.TextSize = 11
                rowLbl.Font = Enum.Font.Gotham
                rowLbl.TextXAlignment = Enum.TextXAlignment.Left
                rowLbl.TextTruncate = Enum.TextTruncate.AtEnd
                rowLbl.Parent = row

                local rowBtn = Instance.new("TextButton")
                rowBtn.Size = UDim2.new(1, 0, 1, 0)
                rowBtn.BackgroundTransparency = 1
                rowBtn.Text = ""
                rowBtn.Parent = row

                local rowData = { frame = row, lbl = rowLbl }
                table.insert(weaponRowFrames, rowData)

                rowBtn.MouseButton1Click:Connect(function() SetSelected(weaponName, rowData) end)
                rowBtn.MouseEnter:Connect(function()
                    if selectedWeapon == weaponName then return end
                    SafeTween(row, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
                end)
                rowBtn.MouseLeave:Connect(function()
                    if selectedWeapon == weaponName then return end
                    SafeTween(row, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
                end)
            end
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        BuildList(searchBox.Text)
    end)

    minusBtn.MouseButton1Click:Connect(function()
        if selectedAmount > 1 then
            selectedAmount -= 1
            amountLabel.Text = tostring(selectedAmount)
        end
    end)

    plusBtn.MouseButton1Click:Connect(function()
        if selectedAmount < 999 then
            selectedAmount += 1
            amountLabel.Text = tostring(selectedAmount)
        end
    end)

    sendBtn.MouseButton1Click:Connect(function()
        if not selectedWeapon then return end
        if onSend then onSend(selectedWeapon, selectedAmount) end
    end)

    if hideAmount then
        minusBtn.Visible = false
        amountLabel.Visible = false
        plusBtn.Visible = false
        sendBtn.Size = UDim2.new(1, -16, 0, 26)
        sendBtn.Position = UDim2.new(0, 8, 0, 28)
    end

    searchTabData.customPanel = searchOuter
    searchTabData.onTabSelected = function() BuildList(searchBox.Text) end
end

local isDragging, dragStart, frameStart = false, nil, nil

topBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = inp.Position
        frameStart = mainFrame.Position
    end
end)

topBar.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if isDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - dragStart
        local vpSize = game:GetService("Workspace").CurrentCamera and game:GetService("Workspace").CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        local winSize = mainFrame.AbsoluteSize
        local newX = math.clamp(frameStart.X.Offset + delta.X, 0, math.max(0, vpSize.X - winSize.X))
        local newY = math.clamp(frameStart.Y.Offset + delta.Y, 0, math.max(0, vpSize.Y - winSize.Y))
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale, newX,
            frameStart.Y.Scale, newY
        )
    end
end)

local _notifGui = Instance.new("ScreenGui")
_notifGui.Name = "iDepHubNotifs"
_notifGui.ResetOnSpawn = false
_notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_notifGui.DisplayOrder = 1000
_notifGui.Parent = playerGui

local _notifOffset = 0
local _notifSlots = {}

local function sendNotification(title, text, duration)
    local slotY = -80 - (_notifOffset * 70)
    _notifOffset = _notifOffset + 1

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 300, 0, 60)
    card.Position = UDim2.new(1, 10, 1, slotY)
    card.BackgroundColor3 = T.Raised
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.ZIndex = 100
    card.Parent = _notifGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = T.Accent
    stroke.Thickness = 1.4
    stroke.Transparency = 0.25
    stroke.Parent = card
    _regAcc(stroke, "Color")

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -16)
    accent.Position = UDim2.new(0, 8, 0, 8)
    accent.BackgroundColor3 = T.Accent
    accent.BorderSizePixel = 0
    accent.ZIndex = 101
    accent.Parent = card
    _regAcc(accent, "BackgroundColor3")
    Corner(accent, 1)

    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -26, 0, 24)
    titleL.Position = UDim2.new(0, 20, 0, 8)
    titleL.BackgroundTransparency = 1
    titleL.Text = title
    titleL.TextColor3 = T.Text
    titleL.TextSize = 14
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.ZIndex = 102
    titleL.Parent = card

    local textL = Instance.new("TextLabel")
    textL.Size = UDim2.new(1, -26, 0, 20)
    textL.Position = UDim2.new(0, 20, 0, 33)
    textL.BackgroundTransparency = 1
    textL.Text = text
    textL.TextColor3 = T.Dim
    textL.TextSize = 12
    textL.Font = Enum.Font.Gotham
    textL.TextXAlignment = Enum.TextXAlignment.Left
    textL.TextWrapped = true
    textL.ZIndex = 102
    textL.Parent = card

    SafeTween(card, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -316, 1, slotY)
    })

    task.delay(math.max(duration or 2, 0.8), function()
        local tw = TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 1, slotY),
            BackgroundTransparency = 1,
        })
        tw:Play()
        tw.Completed:Connect(function()
            card:Destroy()
            _notifOffset = math.max(0, _notifOffset - 1)
        end)
    end)
end

local function NewBodyPartSelector(parent, label, sub, selectedParts, allParts, defaultParts, extRefreshTable, iconName)
    local RH_ROW = 30
    local RG = 6
    local LW = 46
    local CW = 72
    local CG = 5
    local PAD = 12
    local ABH = 26
    local legW = math.floor((CW - CG) / 2)

    local TOTAL_INNER_W = LW + CG + CW + CG + LW
    local CONTENT_W = TOTAL_INNER_W + PAD * 2

    local ROWS = 7
    local function rowY(r) return PAD + (r - 1) * (RH_ROW + RG) end
    local SEP_Y = rowY(ROWS + 1) - 4
    local AB_Y = SEP_Y + 8
    local BODY_H = AB_Y + ABH + PAD

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.LayoutOrder = nextOrd()
    container.Parent = parent

    local cLayout = Instance.new("UIListLayout")
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding = UDim.new(0, 6)
    cLayout.Parent = container

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = T.Raised
    header.BorderSizePixel = 0
    header.LayoutOrder = 1
    header.Parent = container
    Corner(header, 8)
    local hStroke = Stroke(header, T.Line, 0.5)

    local labelOffset = 10
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0, 10, 0, 9)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = header
            _regAcc(img, "ImageColor3")
            labelOffset = 30
        end
    end

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -72, 0, 18)
    lbl.Position = UDim2.new(0, labelOffset, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = header

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -72, 0, 14)
    subLbl.Position = UDim2.new(0, labelOffset, 0, 28)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = sub
    subLbl.TextColor3 = T.Dim
    subLbl.TextSize = 10
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = header

    local badgeBg = Instance.new("Frame")
    badgeBg.Size = UDim2.new(0, 36, 0, 26)
    badgeBg.Position = UDim2.new(1, -46, 0.5, -13)
    badgeBg.BackgroundColor3 = T.Base
    badgeBg.BorderSizePixel = 0
    badgeBg.Parent = header
    Corner(badgeBg, 6)
    Stroke(badgeBg, T.Line, 0.5)

    local countLbl = Instance.new("TextLabel")
    countLbl.Size = UDim2.new(1, 0, 1, 0)
    countLbl.BackgroundTransparency = 1
    countLbl.TextColor3 = T.Accent
    countLbl.Text = "0"
    countLbl.TextSize = 13
    countLbl.Font = Enum.Font.GothamBold
    countLbl.TextXAlignment = Enum.TextXAlignment.Center
    countLbl.Parent = badgeBg
    _regAcc(countLbl, "TextColor3")

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 0, BODY_H)
    body.BackgroundColor3 = T.Base
    body.BorderSizePixel = 0
    body.ClipsDescendants = true
    body.Visible = false
    body.LayoutOrder = 2
    body.Parent = container
    Corner(body, 8)

    local ch = Instance.new("Frame")
    ch.Size = UDim2.new(0, CONTENT_W, 1, 0)
    ch.AnchorPoint = Vector2.new(0.5, 0)
    ch.Position = UDim2.new(0.5, 0, 0, 0)
    ch.BackgroundTransparency = 1
    ch.Parent = body

    local lx = PAD
    local cx = lx + LW + CG
    local rx = cx + CW + CG
    local cxCenter = cx + math.floor(CW / 2)

    local function makeDeco(x, y, w, h)
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0, w, 0, h)
        d.Position = UDim2.new(0, x, 0, y)
        d.BackgroundColor3 = T.Line
        d.BorderSizePixel = 0
        d.Parent = ch
        Corner(d, 1)
        return d
    end

    makeDeco(cxCenter - 1, rowY(1) + RH_ROW, 2, RG)
    makeDeco(cxCenter - 1, rowY(2), 2, RH_ROW + RG + RH_ROW)
    makeDeco(cxCenter - 1, rowY(3) + RH_ROW, 2, RG)
    makeDeco(lx + LW, rowY(2) + math.floor(RH_ROW / 2) - 1, CG, 2)
    makeDeco(cx + CW, rowY(2) + math.floor(RH_ROW / 2) - 1, CG, 2)
    makeDeco(lx + LW, rowY(3) + math.floor(RH_ROW / 2) - 1, CG, 2)
    makeDeco(cx + CW, rowY(3) + math.floor(RH_ROW / 2) - 1, CG, 2)

    local localRefreshFns = {}

    local function countSelected()
        local n = 0
        for _, p in ipairs(allParts) do if selectedParts[p] then n += 1 end end
        return n
    end

    local function updateCount()
        countLbl.Text = tostring(countSelected())
    end

    local function makePartBtn(btnLabel, partName, x, y, w, h, mirrorPart)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, w, 0, h)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.Text = btnLabel
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = ch
        Corner(btn, 5)
        local bStroke = Stroke(btn, T.Line, 0.5)

        local function refresh()
            if selectedParts[partName] then
                btn.BackgroundColor3 = T.Accent
                btn.TextColor3 = T.Base
                bStroke.Color = T.Accent
            else
                btn.BackgroundColor3 = T.Raised
                btn.TextColor3 = T.Dim
                bStroke.Color = T.Line
            end
        end
        refresh()
        localRefreshFns[partName] = refresh
        if extRefreshTable then extRefreshTable[partName] = refresh end

        btn.MouseButton1Click:Connect(function()
            selectedParts[partName] = (not selectedParts[partName]) or nil
            if mirrorPart then selectedParts[mirrorPart] = selectedParts[partName] end
            refresh()
            if mirrorPart and localRefreshFns[mirrorPart] then localRefreshFns[mirrorPart]() end
            updateCount()
        end)
        btn.MouseEnter:Connect(function()
            if not selectedParts[partName] then
                SafeTween(btn, TweenInfo.new(0.08), { BackgroundColor3 = T.Hover })
            end
        end)
        btn.MouseLeave:Connect(function()
            if not selectedParts[partName] then
                SafeTween(btn, TweenInfo.new(0.08), { BackgroundColor3 = T.Raised })
            end
        end)
    end

    makePartBtn("H", "Head", cx + math.floor((CW - LW) / 2), rowY(1), LW, RH_ROW)
    makePartBtn("LUA", "LeftUpperArm", lx, rowY(2), LW, RH_ROW)
    makePartBtn("UT", "UpperTorso", cx, rowY(2), CW, RH_ROW, "Torso")
    makePartBtn("RUA", "RightUpperArm", rx, rowY(2), LW, RH_ROW)
    makePartBtn("LLA", "LeftLowerArm", lx, rowY(3), LW, RH_ROW)
    makePartBtn("LT", "LowerTorso", cx, rowY(3), CW, RH_ROW)
    makePartBtn("RLA", "RightLowerArm", rx, rowY(3), LW, RH_ROW)
    makePartBtn("LH", "LeftHand", lx, rowY(4), LW, RH_ROW)
    makePartBtn("RH", "RightHand", rx, rowY(4), LW, RH_ROW)
    makePartBtn("LUL", "LeftUpperLeg", cx, rowY(5), legW, RH_ROW)
    makePartBtn("RUL", "RightUpperLeg", cx + legW + CG, rowY(5), legW, RH_ROW)
    makePartBtn("LLL", "LeftLowerLeg", cx, rowY(6), legW, RH_ROW)
    makePartBtn("RLL", "RightLowerLeg", cx + legW + CG, rowY(6), legW, RH_ROW)
    makePartBtn("LF", "LeftFoot", cx, rowY(7), legW, RH_ROW)
    makePartBtn("RF", "RightFoot", cx + legW + CG, rowY(7), legW, RH_ROW)

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -PAD * 2, 0, 1)
    sep.Position = UDim2.new(0, PAD, 0, SEP_Y)
    sep.BackgroundColor3 = T.Line
    sep.BorderSizePixel = 0
    sep.Parent = ch

    local ABW = math.floor((TOTAL_INNER_W - CG * 2) / 3)
    local abStartX = lx

    local function makeActionBtn(btnLabel, x, callback)
        local ab = Instance.new("TextButton")
        ab.Size = UDim2.new(0, ABW, 0, ABH)
        ab.Position = UDim2.new(0, x, 0, AB_Y)
        ab.Text = btnLabel
        ab.TextSize = 10
        ab.Font = Enum.Font.GothamSemibold
        ab.BackgroundColor3 = T.Raised
        ab.TextColor3 = T.Accent
        ab.BorderSizePixel = 0
        ab.AutoButtonColor = false
        ab.Parent = ch
        Corner(ab, 5)
        Stroke(ab, T.Line, 0.5)
        _regAcc(ab, "TextColor3")

        ab.MouseEnter:Connect(function()
            SafeTween(ab, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
        end)
        ab.MouseLeave:Connect(function()
            SafeTween(ab, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
        end)
        ab.MouseButton1Click:Connect(callback)
        return ab
    end

    makeActionBtn("Select All", abStartX, function()
        for _, p in ipairs(allParts) do selectedParts[p] = true end
        for _, fn in pairs(localRefreshFns) do fn() end
        updateCount()
    end)
    makeActionBtn("Reset", abStartX + ABW + CG, function()
        for _, p in ipairs(allParts) do selectedParts[p] = defaultParts[p] or nil end
        for _, fn in pairs(localRefreshFns) do fn() end
        updateCount()
    end)
    makeActionBtn("Clear All", abStartX + (ABW + CG) * 2, function()
        for _, p in ipairs(allParts) do selectedParts[p] = nil end
        for _, fn in pairs(localRefreshFns) do fn() end
        updateCount()
    end)

    table.insert(_customAccentCallbacks, function()
        for _, fn in pairs(localRefreshFns) do fn() end
        updateCount()
    end)

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 1, 0)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = header

    local expanded = false
    headerBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        body.Visible = expanded
        SafeTween(header, TweenInfo.new(0.15), {
            BackgroundColor3 = expanded and T.Hover or T.Raised,
        })
        SafeTween(hStroke, TweenInfo.new(0.15), {
            Color = expanded and T.Accent or T.Line,
        })
    end)

    header.MouseEnter:Connect(function()
        SafeTween(header, TweenInfo.new(0.1), { BackgroundColor3 = T.Hover })
        SafeTween(hStroke, TweenInfo.new(0.1), { Color = T.Accent })
    end)
    header.MouseLeave:Connect(function()
        if not expanded then
            SafeTween(header, TweenInfo.new(0.1), { BackgroundColor3 = T.Raised })
        end
        SafeTween(hStroke, TweenInfo.new(0.1), { Color = T.Line })
    end)

    updateCount()
    return container
end

local function NewNote(parent, text, iconName)
    local noteFrame = Instance.new("Frame")
    noteFrame.Size = UDim2.new(1, 0, 0, 0)
    noteFrame.AutomaticSize = Enum.AutomaticSize.Y
    noteFrame.BackgroundColor3 = T.Raised
    noteFrame.BorderSizePixel = 0
    noteFrame.LayoutOrder = nextOrd()
    noteFrame.Parent = parent
    Corner(noteFrame, 8)

    local noteStroke = Instance.new("UIStroke")
    noteStroke.Color = T.Line
    noteStroke.Thickness = 1
    noteStroke.Parent = noteFrame

    local notePad = Instance.new("UIPadding")
    notePad.PaddingTop = UDim.new(0, 8)
    notePad.PaddingBottom = UDim.new(0, 8)
    notePad.PaddingLeft = UDim.new(0, 10)
    notePad.PaddingRight = UDim.new(0, 10)
    notePad.Parent = noteFrame

    local iconOffset = 0
    if iconName then
        local asset = getLucideAsset(iconName)
        if asset then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 14, 0, 14)
            img.Position = UDim2.new(0, 0, 0, 8)
            img.BackgroundTransparency = 1
            img.Image = asset.Url
            img.ImageRectSize = asset.ImageRectSize
            img.ImageRectOffset = asset.ImageRectOffset
            img.ScaleType = Enum.ScaleType.Fit
            img.ImageColor3 = T.Accent
            img.Parent = noteFrame
            _regAcc(img, "ImageColor3")
            iconOffset = 20
        end
    end

    local noteLbl = Instance.new("TextLabel")
    noteLbl.Size = UDim2.new(1, -iconOffset, 0, 0)
    noteLbl.Position = UDim2.new(0, iconOffset, 0, 0)
    noteLbl.AutomaticSize = Enum.AutomaticSize.Y
    noteLbl.BackgroundTransparency = 1
    noteLbl.Text = text or ""
    noteLbl.TextColor3 = T.Dim
    noteLbl.TextSize = 11
    noteLbl.Font = Enum.Font.Gotham
    noteLbl.TextXAlignment = Enum.TextXAlignment.Left
    noteLbl.TextYAlignment = Enum.TextYAlignment.Top
    noteLbl.TextWrapped = true
    noteLbl.Parent = noteFrame

    return noteFrame
end

local function createFloatButton(config)
    config = config or {}

    local guiName = config.name or "NytherFloatBtn"
    local iconName = config.icon or "circle"
    local startPos = config.position or UDim2.new(1, -90, 1, -160)
    local dispOrder = config.displayOrder or 997
    local onToggle = config.onToggle
    local isActive = config.defaultActive or false
    local isFixed = false
    local isHidden = false

    local colorOn = Color3.fromRGB(46, 204, 113)
    local colorOff = Color3.fromRGB(220, 50, 50)

    local sg = Instance.new("ScreenGui")
    sg.Name = guiName
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = dispOrder

    local btn = Instance.new("TextButton")
    btn.Name = "FloatBtn"
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Position = startPos
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = sg
    Corner(btn, 13)

    local stroke = Instance.new("UIStroke")
    stroke.Name = "UIStroke"
    stroke.Color = isActive and colorOn or colorOff
    stroke.Thickness = 1.5
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local iconObj = nil
    local lucideAsset = getLucideAsset(iconName)
    if lucideAsset then
        local img = Instance.new("ImageLabel")
        img.Name = "Icon"
        img.Size = UDim2.new(0, 26, 0, 26)
        img.Position = UDim2.new(0.5, -13, 0.5, -13)
        img.BackgroundTransparency = 1
        img.Image = lucideAsset.Url
        img.ImageRectSize = lucideAsset.ImageRectSize
        img.ImageRectOffset = lucideAsset.ImageRectOffset
        img.ScaleType = Enum.ScaleType.Fit
        img.ImageColor3 = Color3.fromRGB(255, 255, 255)
        img.ZIndex = 6
        img.Parent = btn
        iconObj = img
    else
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Icon"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = iconName
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.ZIndex = 6
        lbl.Parent = btn
        iconObj = lbl
    end

    local dragging, dragStart, startBtnPos = false, nil, nil
    btn.InputBegan:Connect(function(inp)
        if isFixed then return end
        if inp.UserInputType == Enum.UserInputType.Touch
            or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startBtnPos = btn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging or isFixed then return end
        if inp.UserInputType == Enum.UserInputType.Touch
            or inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            btn.Position = UDim2.new(
                startBtnPos.X.Scale, startBtnPos.X.Offset + d.X,
                startBtnPos.Y.Scale, startBtnPos.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch
            or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        local nc = isActive and colorOn or colorOff
        SafeTween(stroke, TweenInfo.new(0.25), { Color = nc })
        local grow = TweenService:Create(btn,
            TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, 62, 0, 62) })
        grow:Play()
        local conn
        conn = grow.Completed:Connect(function()
            conn:Disconnect()
            TweenService:Create(btn,
                TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 52, 0, 52) }):Play()
        end)
        if iconObj then
            iconObj.Rotation = 0
            local spin1 = TweenService:Create(iconObj, TweenInfo.new(0.15, Enum.EasingStyle.Linear), { Rotation = 180 })
            spin1:Play()
            local c1
            c1 = spin1.Completed:Connect(function()
                c1:Disconnect()
                iconObj.Rotation = 180
                local spin2 = TweenService:Create(iconObj, TweenInfo.new(0.15, Enum.EasingStyle.Linear), { Rotation = 360 })
                spin2:Play()
                local c2
                c2 = spin2.Completed:Connect(function()
                    c2:Disconnect()
                    iconObj.Rotation = 0
                end)
            end)
        end
        if onToggle then onToggle(isActive) end
    end)

    sg.Parent = game:GetService("CoreGui")

    local function setActive(v)
        isActive = v
        local nc = v and colorOn or colorOff
        SafeTween(stroke, TweenInfo.new(0.2), { Color = nc })
    end

    local function setFixed(v)
        isFixed = v
    end

    local function setHidden(v)
        isHidden = v
        btn.BackgroundTransparency = v and 1 or 0.15
        stroke.Transparency = v and 1 or 0
        if iconObj then
            if iconObj:IsA("ImageLabel") then
                iconObj.ImageTransparency = v and 1 or 0
            elseif iconObj:IsA("TextLabel") then
                iconObj.TextTransparency = v and 1 or 0
            end
        end
    end

    local function destroy()
        sg:Destroy()
    end

    return {
        destroy = destroy,
        setActive = setActive,
        setFixed = setFixed,
        setHidden = setHidden,
        gui = sg,
        button = btn,
    }
end

CenterWindow()

return {
    titleLabel = titleLabel,
    setAccentColor = setAccentColor,
    NewTab = NewTab,
    NewSection = NewSection,
    NewToggle = NewToggle,
    NewSlider = NewSlider,
    NewButton = NewButton,
    NewInput = NewInput,
    NewKeybind = NewKeybind,
    NewLabel = NewLabel,
    NewColorPicker = NewColorPicker,
    NewBodyPartSelector = NewBodyPartSelector,
    NewNote = NewNote,
    NewSearchPanel = NewSearchPanel,
    SelectTab = SelectTab,
    registeredTabs = registeredTabs,
    mainFrame = mainFrame,
    sendNotification = sendNotification,
    isMobile = isMobile,
    getWindowSize = getWindowSize,
    setWindowSize = setWindowSize,
    setEyeFixed = setEyeFixed,
    setEyeHidden = setEyeHidden,
    createFloatButton = createFloatButton,
}
