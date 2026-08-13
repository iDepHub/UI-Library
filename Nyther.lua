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

local T = {
    Bg          = Color3.fromRGB(0,   0,   0),
    Sidebar     = Color3.fromRGB(0,   0,   0),
    Header      = Color3.fromRGB(3,   3,   3),
    Accent      = Color3.fromRGB(40,  40,  40),
    AccentDark  = Color3.fromRGB(20,  20,  20),
    Text        = Color3.fromRGB(230, 230, 230),
    TextRed     = Color3.fromRGB(140, 140, 140),
    TextDim     = Color3.fromRGB(80,  80,  80),
    Elem        = Color3.fromRGB(10,  10,  10),
    ElemHov     = Color3.fromRGB(18,  18,  18),
    Border      = Color3.fromRGB(40,  40,  40),
    BorderDim   = Color3.fromRGB(25,  25,  25),
    SliderFill  = Color3.fromRGB(40,  40,  40),
    SliderBg    = Color3.fromRGB(18,  18,  18),
    ToggleOn    = Color3.fromRGB(55,  55,  55),
    ToggleOff   = Color3.fromRGB(28,  28,  28),
    TabActive   = Color3.fromRGB(15,  15,  15),
    TabInactive = Color3.fromRGB(6,   6,   6),
}

local _accentObjs = {}
local _accentDarkObjs = {}
local _customAccentCallbacks = {}
local function _regAcc(o, p)  table.insert(_accentObjs,     {o, p}) end
local function _regDark(o, p) table.insert(_accentDarkObjs, {o, p}) end

local function setAccentColor(color)
    T.Accent     = color
    T.Border     = color
    T.SliderFill = color
    T.ToggleOn   = color
    T.AccentDark = Color3.new(color.R * 0.55, color.G * 0.55, color.B * 0.55)
    for _, e in ipairs(_accentObjs)     do pcall(function() e[1][e[2]] = color          end) end
    for _, e in ipairs(_accentDarkObjs) do pcall(function() e[1][e[2]] = T.AccentDark   end) end
    for _, fn in ipairs(_customAccentCallbacks) do pcall(fn) end
end

local function Corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
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

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "iDepHubUI"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder   = 999
screenGui.Parent         = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name              = "MainFrame"
mainFrame.Size              = UDim2.new(0, 446, 0, 394)
mainFrame.AnchorPoint       = Vector2.new(0.5, 0.5)
mainFrame.Position          = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3  = T.Bg
mainFrame.BorderSizePixel   = 0
mainFrame.ClipsDescendants  = true
mainFrame.Parent            = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color     = T.Border
mainStroke.Thickness = 1.5
mainStroke.Parent    = mainFrame
_regAcc(mainStroke, "Color")

local topBar = Instance.new("Frame")
topBar.Name             = "TopBar"
topBar.Size             = UDim2.new(1, 0, 0, 54)
topBar.BackgroundColor3 = T.Header
topBar.BorderSizePixel  = 0
topBar.ZIndex           = 5
topBar.Parent           = mainFrame

local topLine = Instance.new("Frame")
topLine.Size             = UDim2.new(1, 0, 0, 1)
topLine.Position         = UDim2.new(0, 0, 1, -1)
topLine.BackgroundColor3 = T.Border
topLine.BorderSizePixel  = 0
topLine.ZIndex           = 6
topLine.Parent           = topBar
_regAcc(topLine, "BackgroundColor3")

local LogoWrap = Instance.new("Frame")
LogoWrap.Size = UDim2.new(0, 16, 0, 16)
LogoWrap.Position = UDim2.new(0, 14, 0.5, -8)
LogoWrap.BackgroundTransparency = 1
LogoWrap.ZIndex = 7
LogoWrap.Parent = topBar

local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.BorderSizePixel = 0
Logo.BackgroundColor3 = T.Accent
Logo.Parent = LogoWrap
Corner(Logo, 3)
_regAcc(Logo, "BackgroundColor3")

local titleLabel = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, -92, 1, 0)
titleLabel.Position           = UDim2.new(0, 40, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text               = "NYTHER"
titleLabel.TextColor3         = T.Text
titleLabel.TextSize           = 18
titleLabel.Font               = Enum.Font.GothamBlack
titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
titleLabel.TextYAlignment     = Enum.TextYAlignment.Center
titleLabel.ZIndex             = 7
titleLabel.Parent             = topBar

local statusPill = Instance.new("Frame")
statusPill.Size = UDim2.new(0, 110, 0, 20)
statusPill.Position = UDim2.new(1, -128, 0.5, -10)
statusPill.BackgroundColor3 = T.Accent
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 7
statusPill.Parent = topBar
Corner(statusPill, 10)
_regAcc(statusPill, "BackgroundColor3")

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = T.Border
pillStroke.Thickness = 1
pillStroke.Parent = statusPill
_regAcc(pillStroke, "Color")

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 5, 0, 5)
statusDot.Position = UDim2.new(0, 9, 0.5, -2.5)
statusDot.BackgroundColor3 = Color3.fromRGB(128, 224, 134)
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 8
statusDot.Parent = statusPill
Corner(statusDot, 3)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0, 18, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "SYSTEM ACTIVE"
statusText.TextColor3 = T.Header
statusText.TextSize = 9
statusText.Font = Enum.Font.GothamSemibold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.ZIndex = 8
statusText.Parent = statusPill

local scanBar = Instance.new("Frame")
scanBar.Size = UDim2.new(0, 80, 0, 2)
scanBar.Position = UDim2.new(0, 0, 1, -2)
scanBar.BackgroundColor3 = T.Accent
scanBar.BorderSizePixel = 0
scanBar.ZIndex = 6
scanBar.Parent = topBar
_regAcc(scanBar, "BackgroundColor3")

local scanGrad = Instance.new("UIGradient")
scanGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Accent),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 178, 72)),
    ColorSequenceKeypoint.new(1, T.Accent),
})
scanGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
})
scanGrad.Parent = scanBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size             = UDim2.new(0, 26, 0, 26)
closeBtn.Position         = UDim2.new(1, -33, 0.5, -13)
closeBtn.BackgroundColor3 = T.AccentDark
closeBtn.BorderSizePixel  = 0
closeBtn.Text             = "X"
closeBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize         = 14
closeBtn.Font             = Enum.Font.GothamSemibold
closeBtn.AutoButtonColor  = false
closeBtn.ZIndex           = 8
closeBtn.Parent           = topBar
Corner(closeBtn, 4)
_regDark(closeBtn, "BackgroundColor3")

closeBtn.MouseEnter:Connect(function()
    SafeTween(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = T.Accent})
end)
closeBtn.MouseLeave:Connect(function()
    SafeTween(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = T.AccentDark})
end)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

local bodyFrame = Instance.new("Frame")
bodyFrame.Size              = UDim2.new(1, 0, 1, -54)
bodyFrame.Position          = UDim2.new(0, 0, 0, 54)
bodyFrame.BackgroundTransparency = 1
bodyFrame.BorderSizePixel   = 0
bodyFrame.Parent            = mainFrame

local footer = Instance.new("Frame")
footer.Name             = "Footer"
footer.Size             = UDim2.new(1, 0, 0, 22)
footer.Position         = UDim2.new(0, 0, 1, -22)
footer.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
footer.BorderSizePixel  = 0
footer.ZIndex           = 5
footer.Parent           = mainFrame

local footerLine = Instance.new("Frame")
footerLine.Size             = UDim2.new(1, 0, 0, 1)
footerLine.Position         = UDim2.new(0, 0, 0, 0)
footerLine.BackgroundColor3 = T.Border
footerLine.BorderSizePixel  = 0
footerLine.ZIndex           = 6
footerLine.Parent           = footer
_regAcc(footerLine, "BackgroundColor3")

local footerLabel = Instance.new("TextLabel")
footerLabel.Size                  = UDim2.new(1, 0, 1, 0)
footerLabel.Position              = UDim2.new(0, 0, 0, 0)
footerLabel.BackgroundTransparency = 1
footerLabel.Text                  = "By L#######"
footerLabel.TextColor3            = T.TextRed
footerLabel.TextSize              = 11
footerLabel.Font                  = Enum.Font.GothamSemibold
footerLabel.TextXAlignment        = Enum.TextXAlignment.Center
footerLabel.ZIndex                = 6
footerLabel.Parent                = footer
_regAcc(footerLabel, "TextColor3")

local sidebar = Instance.new("Frame")
sidebar.Name             = "Sidebar"
sidebar.Size             = UDim2.new(0, 118, 1, 0)
sidebar.BackgroundColor3 = T.Sidebar
sidebar.BorderSizePixel  = 0
sidebar.Parent           = bodyFrame

local sidebarLine = Instance.new("Frame")
sidebarLine.Size             = UDim2.new(0, 1, 1, 0)
sidebarLine.Position         = UDim2.new(0, 117, 0, 0)
sidebarLine.BackgroundColor3 = T.Border
sidebarLine.BorderSizePixel  = 0
sidebarLine.Parent           = bodyFrame
_regAcc(sidebarLine, "BackgroundColor3")

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding   = UDim.new(0, 3)
tabLayout.Parent    = sidebar

local sidebarPad = Instance.new("UIPadding")
sidebarPad.PaddingTop   = UDim.new(0, 4)
sidebarPad.PaddingLeft  = UDim.new(0, 6)
sidebarPad.PaddingRight = UDim.new(0, 6)
sidebarPad.Parent       = sidebar

local contentFrame = Instance.new("Frame")
contentFrame.Name             = "Content"
contentFrame.Size             = UDim2.new(1, -118, 1, 0)
contentFrame.Position         = UDim2.new(0, 118, 0, 0)
contentFrame.BackgroundColor3 = T.Bg
contentFrame.BorderSizePixel  = 0
contentFrame.ClipsDescendants = true
contentFrame.Parent           = bodyFrame

local registeredTabs = {}

local function SelectTab(target)
    for _, td in ipairs(registeredTabs) do
        td.page.Visible   = false
        td.accent.Visible = false
        SafeTween(td.btn,     TweenInfo.new(0.12), {BackgroundColor3 = T.TabInactive})
        SafeTween(td.nameLbl, TweenInfo.new(0.12), {TextColor3       = T.TextDim    })
        if td.iconImg then
            SafeTween(td.iconImg, TweenInfo.new(0.12), {ImageColor3 = T.TextDim})
        end
        if td.customPanel then td.customPanel.Visible = false end
    end
    target.accent.Visible = true
    SafeTween(target.btn,     TweenInfo.new(0.12), {BackgroundColor3 = T.TabActive})
    SafeTween(target.nameLbl, TweenInfo.new(0.12), {TextColor3       = T.Text     })
    if target.iconImg then
        SafeTween(target.iconImg, TweenInfo.new(0.12), {ImageColor3 = T.Accent})
    end
    if target.customPanel then
        target.page.Visible        = false
        target.customPanel.Visible = true
    else
        target.page.Visible = true
    end
    if target.onTabSelected then target.onTabSelected() end
end

local function NewTab(name, icon, order)
    local btn = Instance.new("TextButton")
    btn.Name             = "Tab_"..name
    btn.Size             = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = T.TabInactive
    btn.BorderSizePixel  = 0
    btn.Text             = ""
    btn.AutoButtonColor  = false
    btn.LayoutOrder      = order
    btn.Parent           = sidebar
    Corner(btn, 4)

    local accentBar = Instance.new("Frame")
    accentBar.Name             = "Accent"
    accentBar.Size             = UDim2.new(0, 3, 0, 20)
    accentBar.Position         = UDim2.new(0, 0, 0.5, -10)
    accentBar.BackgroundColor3 = T.Accent
    accentBar.BorderSizePixel  = 0
    accentBar.Visible          = false
    accentBar.Parent           = btn
    Corner(accentBar, 2)
    _regAcc(accentBar, "BackgroundColor3")

    local iconImg = nil
    local hasVisibleIcon = false

    if type(icon) == "string" and icon ~= "" then
        local lucideAsset = getLucideAsset(icon)
        if lucideAsset then
            local img = Instance.new("ImageLabel")
            img.Size                 = UDim2.new(0, 18, 0, 18)
            img.Position             = UDim2.new(0, 10, 0.5, -9)
            img.BackgroundTransparency = 1
            img.Image                = lucideAsset.Url
            img.ImageRectSize        = lucideAsset.ImageRectSize
            img.ImageRectOffset      = lucideAsset.ImageRectOffset
            img.ScaleType            = Enum.ScaleType.Fit
            img.ImageColor3          = T.TextDim
            img.Parent               = btn
            iconImg = img
            hasVisibleIcon = true
        end
    end

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name                 = "Label"
    nameLbl.Size                 = hasVisibleIcon and UDim2.new(1, -36, 1, 0) or UDim2.new(1, -14, 1, 0)
    nameLbl.Position             = hasVisibleIcon and UDim2.new(0, 35, 0, 0) or UDim2.new(0, 10, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text                 = name
    nameLbl.TextColor3           = T.TextDim
    nameLbl.TextSize             = 13
    nameLbl.Font                 = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment       = Enum.TextXAlignment.Left
    nameLbl.TextTruncate         = Enum.TextTruncate.AtEnd
    nameLbl.Parent               = btn

    local page = Instance.new("ScrollingFrame")
    page.Size                  = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel        = 0
    page.ScrollBarThickness     = 3
    page.ScrollBarImageColor3   = T.Accent
    page.CanvasSize             = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    page.Visible                = false
    page.Parent                 = contentFrame
    _regAcc(page, "ScrollBarImageColor3")

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding   = UDim.new(0, 8)
    pageLayout.Parent    = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop    = UDim.new(0, 10)
    pagePad.PaddingBottom = UDim.new(0, 10)
    pagePad.PaddingLeft   = UDim.new(0, 9)
    pagePad.PaddingRight  = UDim.new(0, 10)
    pagePad.Parent        = page

    local tabData = {btn = btn, accent = accentBar, nameLbl = nameLbl, page = page, iconImg = iconImg}
    table.insert(registeredTabs, tabData)

    btn.MouseButton1Click:Connect(function() SelectTab(tabData) end)
    btn.MouseEnter:Connect(function()
        if page.Visible or (tabData.customPanel and tabData.customPanel.Visible) then return end
        SafeTween(btn, TweenInfo.new(0.1), {BackgroundColor3 = T.TabActive})
    end)
    btn.MouseLeave:Connect(function()
        if page.Visible or (tabData.customPanel and tabData.customPanel.Visible) then return end
        SafeTween(btn, TweenInfo.new(0.1), {BackgroundColor3 = T.TabInactive})
    end)

    return page, tabData
end

local _ord = 0
local function nextOrd() _ord += 1; return _ord end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or T.BorderDim
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function ElemBase(parent, h)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, h)
    f.BackgroundColor3 = T.Elem
    f.BorderSizePixel  = 0
    f.LayoutOrder      = nextOrd()
    f.Parent           = parent
    Corner(f, 4)
    local s = Stroke(f, T.BorderDim, 1)
    return f, s
end

local function NewSlider(parent, label, sub, minVal, maxVal, default, callback, iconName)
    local f, stroke = ElemBase(parent, 60)

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(0.62, 0, 0, 18)
    lbl.Position          = UDim2.new(0, 10, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text              = label
    lbl.TextColor3        = T.Text
    lbl.TextSize          = 13
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.TextTruncate      = Enum.TextTruncate.AtEnd
    lbl.Parent            = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size              = UDim2.new(0.62, 0, 0, 14)
    subLbl.Position          = UDim2.new(0, 10, 0, 25)
    subLbl.BackgroundTransparency = 1
    subLbl.Text              = sub
    subLbl.TextColor3        = T.TextDim
    subLbl.TextSize          = 12
    subLbl.Font              = Enum.Font.Gotham
    subLbl.TextXAlignment    = Enum.TextXAlignment.Left
    subLbl.TextTruncate      = Enum.TextTruncate.AtEnd
    subLbl.Parent            = f

    local valLbl = Instance.new("TextLabel")
    valLbl.Size              = UDim2.new(0.38, -12, 0, 18)
    valLbl.Position          = UDim2.new(0.62, 0, 0, 7)
    valLbl.BackgroundTransparency = 1
    valLbl.Text              = tostring(default)
    valLbl.TextColor3        = T.TextRed
    valLbl.TextSize          = 13
    valLbl.Font              = Enum.Font.GothamSemibold
    valLbl.TextXAlignment    = Enum.TextXAlignment.Right
    valLbl.Parent            = f

    local trackBg = Instance.new("Frame")
    trackBg.Size             = UDim2.new(1, -20, 0, 6)
    trackBg.Position         = UDim2.new(0, 10, 1, -16)
    trackBg.BackgroundColor3 = T.SliderBg
    trackBg.BorderSizePixel  = 0
    trackBg.Parent           = f
    Corner(trackBg, 3)

    local pct0 = (default - minVal) / (maxVal - minVal)
    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new(pct0, 0, 1, 0)
    fill.BackgroundColor3 = T.SliderFill
    fill.BorderSizePixel  = 0
    fill.Parent           = trackBg
    Corner(fill, 3)
    _regAcc(fill, "BackgroundColor3")

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 12, 0, 12)
    knob.Position         = UDim2.new(pct0, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    knob.BorderSizePixel  = 0
    knob.Parent           = trackBg
    Corner(knob, 6)

    local trackBtn = Instance.new("TextButton")
    trackBtn.Size                 = UDim2.new(1, 0, 5, 0)
    trackBtn.Position             = UDim2.new(0, 0, -2, 0)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text                 = ""
    trackBtn.Parent               = trackBg

    local draggingSl = false

    local function updateSl(x)
        local relX = math.clamp((x - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + relX * (maxVal - minVal) + 0.5)
        local p = (value - minVal) / (maxVal - minVal)
        fill.Size      = UDim2.new(p, 0, 1, 0)
        knob.Position  = UDim2.new(p, -6, 0.5, -6)
        valLbl.Text    = tostring(value)
        if callback then callback(value) end
    end

    trackBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSl = true
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
            draggingSl = false
        end
    end)

    f.MouseEnter:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), {BackgroundColor3 = T.ElemHov})
    end)
    f.MouseLeave:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), {BackgroundColor3 = T.Elem})
    end)

    return f
end

local function NewButton(parent, label, sub, callback, iconName)
    local f, stroke = ElemBase(parent, 46)

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -50, 0, 18)
    lbl.Position          = UDim2.new(0, 10, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text              = label
    lbl.TextColor3        = T.Text
    lbl.TextSize          = 13
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.TextTruncate      = Enum.TextTruncate.AtEnd
    lbl.Parent            = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size              = UDim2.new(1, -50, 0, 14)
    subLbl.Position          = UDim2.new(0, 10, 0, 25)
    subLbl.BackgroundTransparency = 1
    subLbl.Text              = sub
    subLbl.TextColor3        = T.TextDim
    subLbl.TextSize          = 12
    subLbl.Font              = Enum.Font.Gotham
    subLbl.TextXAlignment    = Enum.TextXAlignment.Left
    subLbl.TextTruncate      = Enum.TextTruncate.AtEnd
    subLbl.Parent            = f

    local arrow = Instance.new("TextLabel")
    arrow.Size              = UDim2.new(0, 28, 1, 0)
    arrow.Position          = UDim2.new(1, -34, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text              = "›"
    arrow.TextColor3        = T.TextRed
    arrow.TextSize          = 22
    arrow.Font              = Enum.Font.GothamSemibold
    arrow.Parent            = f

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.Parent               = f

    btn.MouseButton1Click:Connect(function()
        SafeTween(f, TweenInfo.new(0.05), {BackgroundColor3 = T.AccentDark})
        task.delay(0.12, function()
            SafeTween(f, TweenInfo.new(0.1), {BackgroundColor3 = T.ElemHov})
        end)
        if callback then callback() end
    end)
    btn.MouseEnter:Connect(function()
        SafeTween(f,      TweenInfo.new(0.1), {BackgroundColor3 = T.ElemHov})
        SafeTween(stroke, TweenInfo.new(0.1), {Color = T.Accent})
    end)
    btn.MouseLeave:Connect(function()
        SafeTween(f,      TweenInfo.new(0.1), {BackgroundColor3 = T.Elem})
        SafeTween(stroke, TweenInfo.new(0.1), {Color = T.BorderDim})
    end)

    return f
end

local function NewKeybind(parent, label, sub, defaultKey, callback, iconName)
    local f, stroke = ElemBase(parent, 46)

    local listening = false
    local currentKey = defaultKey

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -82, 0, 18)
    lbl.Position          = UDim2.new(0, 10, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text              = label
    lbl.TextColor3        = T.Text
    lbl.TextSize          = 13
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.TextTruncate      = Enum.TextTruncate.AtEnd
    lbl.Parent            = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size              = UDim2.new(1, -82, 0, 14)
    subLbl.Position          = UDim2.new(0, 10, 0, 25)
    subLbl.BackgroundTransparency = 1
    subLbl.Text              = sub
    subLbl.TextColor3        = T.TextDim
    subLbl.TextSize          = 12
    subLbl.Font              = Enum.Font.Gotham
    subLbl.TextXAlignment    = Enum.TextXAlignment.Left
    subLbl.TextTruncate      = Enum.TextTruncate.AtEnd
    subLbl.Parent            = f

    local keyBg = Instance.new("Frame")
    keyBg.Size             = UDim2.new(0, 56, 0, 24)
    keyBg.Position         = UDim2.new(1, -65, 0.5, -12)
    keyBg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    keyBg.BorderSizePixel  = 0
    keyBg.Parent           = f
    Corner(keyBg, 4)

    local keyStroke = Stroke(keyBg, T.BorderDim, 1)

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size                 = UDim2.new(1, 0, 1, 0)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text                 = defaultKey.Name
    keyLbl.TextColor3           = T.TextRed
    keyLbl.TextSize             = 11
    keyLbl.Font                 = Enum.Font.GothamSemibold
    keyLbl.Parent               = keyBg

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size                 = UDim2.new(1, 0, 1, 0)
    keyBtn.BackgroundTransparency = 1
    keyBtn.Text                 = ""
    keyBtn.Parent               = keyBg

    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening   = true
        keyLbl.Text = "..."
        keyLbl.TextColor3 = T.Text
        SafeTween(keyStroke, TweenInfo.new(0.1), {Color = T.Accent})

        local conn
        conn = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                currentKey        = inp.KeyCode
                keyLbl.Text       = inp.KeyCode.Name
                keyLbl.TextColor3 = T.TextRed
                SafeTween(keyStroke, TweenInfo.new(0.1), {Color = T.BorderDim})
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
        SafeTween(f, TweenInfo.new(0.1), {BackgroundColor3 = T.ElemHov})
    end)
    f.MouseLeave:Connect(function()
        SafeTween(f, TweenInfo.new(0.1), {BackgroundColor3 = T.Elem})
    end)

    return f
end

local function NewLabel(parent, text, iconName)
    local f, _ = ElemBase(parent, 30)

    local lbl = Instance.new("TextLabel")
    lbl.Size                 = UDim2.new(1, -20, 1, 0)
    lbl.Position             = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                 = text
    lbl.TextColor3           = T.TextDim
    lbl.TextSize             = 12
    lbl.Font                 = Enum.Font.GothamBold
    lbl.TextXAlignment       = Enum.TextXAlignment.Left
    lbl.TextWrapped          = true
    lbl.Parent               = f

    return f
end

local function NewColorPicker(parent, label, sub, defaultColor, callback, iconName)
    defaultColor = defaultColor or Color3.fromRGB(15, 15, 15)

    local container = Instance.new("Frame")
    container.Size              = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize     = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.BorderSizePixel   = 0
    container.LayoutOrder       = nextOrd()
    container.Parent            = parent

    local cLayout = Instance.new("UIListLayout")
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding   = UDim.new(0, 0)
    cLayout.Parent    = container

    local header = Instance.new("Frame")
    header.Size             = UDim2.new(1, 0, 0, 46)
    header.BackgroundColor3 = T.Elem
    header.BorderSizePixel  = 0
    header.LayoutOrder      = 1
    header.Parent           = container
    Corner(header, 4)
    local hStroke = Stroke(header, T.BorderDim, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -70, 0, 18)
    lbl.Position          = UDim2.new(0, 10, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text              = label
    lbl.TextColor3        = T.Text
    lbl.TextSize          = 13
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.TextTruncate      = Enum.TextTruncate.AtEnd
    lbl.Parent            = header

    local subLbl = Instance.new("TextLabel")
    subLbl.Size           = UDim2.new(1, -70, 0, 12)
    subLbl.Position       = UDim2.new(0, 10, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text           = sub
    subLbl.TextColor3     = T.TextDim
    subLbl.TextSize       = 10
    subLbl.Font           = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate   = Enum.TextTruncate.AtEnd
    subLbl.Parent         = header

    local preview = Instance.new("Frame")
    preview.Size             = UDim2.new(0, 36, 0, 28)
    preview.Position         = UDim2.new(1, -46, 0, 9)
    preview.BackgroundColor3 = defaultColor
    preview.BorderSizePixel  = 0
    preview.Parent           = header
    Corner(preview, 4)
    Stroke(preview, T.BorderDim, 1)

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size                 = UDim2.new(1, 0, 1, 0)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text                 = ""
    headerBtn.Parent               = header

    local expanded = false
    headerBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            if callback then callback(defaultColor) end
        end
    end)

    header.MouseEnter:Connect(function()
        SafeTween(header, TweenInfo.new(0.1), {BackgroundColor3 = T.ElemHov})
        SafeTween(hStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(48, 48, 48)})
    end)
    header.MouseLeave:Connect(function()
        if not expanded then
            SafeTween(header, TweenInfo.new(0.1), {BackgroundColor3 = T.Elem})
        end
        SafeTween(hStroke, TweenInfo.new(0.1), {Color = T.BorderDim})
    end)

    return container
end

local function NewBodyPartSelector(parent, label, sub, selectedParts, allParts, defaultParts, extRefreshTable, iconName)
    local container = Instance.new("Frame")
    container.Size               = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize      = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.LayoutOrder        = nextOrd()
    container.Parent             = parent

    local cLayout = Instance.new("UIListLayout")
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding   = UDim.new(0, 0)
    cLayout.Parent    = container

    local header = Instance.new("Frame")
    header.Size             = UDim2.new(1, 0, 0, 46)
    header.BackgroundColor3 = T.Elem
    header.BorderSizePixel  = 0
    header.LayoutOrder      = 1
    header.Parent           = container
    Corner(header, 4)
    local hStroke = Stroke(header, T.BorderDim, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -70, 0, 18)
    lbl.Position          = UDim2.new(0, 10, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text              = label
    lbl.TextColor3        = T.Text
    lbl.TextSize          = 13
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.TextTruncate      = Enum.TextTruncate.AtEnd
    lbl.Parent            = header

    local subLbl = Instance.new("TextLabel")
    subLbl.Size           = UDim2.new(1, -70, 0, 12)
    subLbl.Position       = UDim2.new(0, 10, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text           = sub
    subLbl.TextColor3     = T.TextDim
    subLbl.TextSize       = 10
    subLbl.Font           = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate   = Enum.TextTruncate.AtEnd
    subLbl.Parent         = header

    local countLbl = Instance.new("TextLabel")
    countLbl.Size                 = UDim2.new(0, 36, 0, 28)
    countLbl.Position             = UDim2.new(1, -46, 0, 9)
    countLbl.BackgroundTransparency = 1
    countLbl.TextColor3           = T.Accent
    countLbl.Text                 = "0"
    countLbl.TextSize             = 13
    countLbl.Font                 = Enum.Font.GothamBold
    countLbl.TextXAlignment       = Enum.TextXAlignment.Center
    countLbl.Parent               = header
    _regAcc(countLbl, "TextColor3")

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size                 = UDim2.new(1, 0, 1, 0)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text                 = ""
    headerBtn.Parent               = header

    local expanded = false
    headerBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
    end)

    header.MouseEnter:Connect(function()
        SafeTween(header, TweenInfo.new(0.1), {BackgroundColor3 = T.ElemHov})
        SafeTween(hStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(48, 48, 48)})
    end)
    header.MouseLeave:Connect(function()
        if not expanded then
            SafeTween(header, TweenInfo.new(0.1), {BackgroundColor3 = T.Elem})
        end
        SafeTween(hStroke, TweenInfo.new(0.1), {Color = T.BorderDim})
    end)

    return container
end

local function sendNotification(title, text, duration)
    local card = Instance.new("TextLabel")
    card.Size = UDim2.new(0, 1, 0, 1)
    card.Text = title .. ": " .. text
    card.TextScaled = true
    return card
end
    local sec = Instance.new("Frame")
    sec.Size              = UDim2.new(1, 0, 0, 0)
    sec.BackgroundTransparency = 1
    sec.BorderSizePixel   = 0
    sec.AutomaticSize     = Enum.AutomaticSize.Y
    sec.LayoutOrder       = nextOrd()
    sec.Parent            = parent

    local secLayout = Instance.new("UIListLayout")
    secLayout.SortOrder = Enum.SortOrder.LayoutOrder
    secLayout.Padding   = UDim.new(0, 4)
    secLayout.Parent    = sec

    local hdr = Instance.new("Frame")
    hdr.Size             = UDim2.new(1, 0, 0, 24)
    hdr.BackgroundTransparency = 1
    hdr.LayoutOrder      = nextOrd()
    hdr.Parent           = sec

    local hdrTxt = Instance.new("TextLabel")
    hdrTxt.Size              = UDim2.new(1, 0, 1, -2)
    hdrTxt.BackgroundTransparency = 1
    hdrTxt.Text              = title
    hdrTxt.TextColor3        = T.TextRed
    hdrTxt.TextSize          = 11
    hdrTxt.Font              = Enum.Font.GothamSemibold
    hdrTxt.TextXAlignment    = Enum.TextXAlignment.Left
    hdrTxt.Parent            = hdr

    local hdrLine = Instance.new("Frame")
    hdrLine.Size             = UDim2.new(1, 0, 0, 1)
    hdrLine.Position         = UDim2.new(0, 0, 1, -1)
    hdrLine.BackgroundColor3 = T.AccentDark
    hdrLine.BorderSizePixel  = 0
    hdrLine.Parent           = hdr
    _regDark(hdrLine, "BackgroundColor3")

    return sec
end

local function NewToggle(parent, label, sub, default, callback, iconName)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, 46)
    f.BackgroundColor3 = T.Elem
    f.BorderSizePixel  = 0
    f.LayoutOrder      = nextOrd()
    f.Parent           = parent
    Corner(f, 4)
    local stroke = Stroke(f, T.BorderDim, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -58, 0, 18)
    lbl.Position          = UDim2.new(0, 10, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text              = label
    lbl.TextColor3        = T.Text
    lbl.TextSize          = 13
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.TextTruncate      = Enum.TextTruncate.AtEnd
    lbl.Parent            = f

    local subLbl = Instance.new("TextLabel")
    subLbl.Size              = UDim2.new(1, -58, 0, 14)
    subLbl.Position          = UDim2.new(0, 10, 0, 25)
    subLbl.BackgroundTransparency = 1
    subLbl.Text              = sub
    subLbl.TextColor3        = T.TextDim
    subLbl.TextSize          = 12
    subLbl.Font              = Enum.Font.Gotham
    subLbl.TextXAlignment    = Enum.TextXAlignment.Left
    subLbl.TextTruncate      = Enum.TextTruncate.AtEnd
    subLbl.Parent            = f

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(0, 36, 0, 19)
    track.Position         = UDim2.new(1, -46, 0.5, -9)
    track.BackgroundColor3 = default and T.ToggleOn or T.ToggleOff
    track.BorderSizePixel  = 0
    track.Parent           = f
    Corner(track, 10)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 13, 0, 13)
    knob.Position         = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    knob.BorderSizePixel  = 0
    knob.Parent           = track
    Corner(knob, 7)

    local state  = default or false
    local locked = false

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.Parent               = f

    local function setState(newState)
        state = newState
        SafeTween(track, TweenInfo.new(0.15), {
            BackgroundColor3 = state and T.ToggleOn or T.ToggleOff,
        })
        SafeTween(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
        })
    end

    local function setLocked(isLocked)
        locked = isLocked
    end

    btn.MouseButton1Click:Connect(function()
        if locked then return end
        setState(not state)
        if callback then callback(state) end
    end)
    btn.MouseEnter:Connect(function()
        if locked then return end
        SafeTween(f, TweenInfo.new(0.1), {BackgroundColor3 = T.ElemHov})
        SafeTween(stroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(48, 48, 48)})
    end)
    btn.MouseLeave:Connect(function()
        if locked then return end
        SafeTween(f, TweenInfo.new(0.1), {BackgroundColor3 = T.Elem})
        SafeTween(stroke, TweenInfo.new(0.1), {Color = T.BorderDim})
    end)

    return f, setState, setLocked
end

local isDragging, dragStart, frameStart = false, nil, nil

topBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart  = inp.Position
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
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale, frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
        )
    end
end)

task.spawn(function()
    while topBar and topBar.Parent do
        SafeTween(scanBar, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(1, -90, 1, -2) })
        task.wait(2.6)
        if not topBar or not topBar.Parent then break end
        SafeTween(scanBar, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 0, 1, -2) })
        task.wait(2.6)
    end
end)

task.spawn(function()
    while statusDot and statusDot.Parent do
        SafeTween(statusDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.55 })
        task.wait(0.7)
        if not statusDot or not statusDot.Parent then break end
        SafeTween(statusDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 })
        task.wait(0.7)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if LogoWrap and LogoWrap.Parent then
        LogoWrap.Rotation = (LogoWrap.Rotation + dt * 24) % 360
    end
end)

local page1, tab1 = NewTab("Config", "settings", 1)
local page2, tab2 = NewTab("About", "info", 2)

SelectTab(tab1)

NewSection(page1, "CONFIGURACION", nil)
NewToggle(page1, "Example Toggle", "Toggle description", false, function(state)
    print("Toggle state:", state)
end)

NewSection(page2, "INFORMACION", nil)
local infoLbl = Instance.new("TextLabel")
infoLbl.Size                  = UDim2.new(1, -20, 0, 100)
infoLbl.Position              = UDim2.new(0, 10, 0, 10)
infoLbl.BackgroundTransparency = 1
infoLbl.Text                  = "NYTHER - Modern UI Library\nClean, minimal, and efficient"
infoLbl.TextColor3            = T.TextDim
infoLbl.TextSize              = 12
infoLbl.Font                  = Enum.Font.Gotham
infoLbl.TextXAlignment        = Enum.TextXAlignment.Left
infoLbl.TextWrapped           = true
infoLbl.Parent                = page2

return {
    titleLabel           = titleLabel,
    setAccentColor       = setAccentColor,
    NewTab               = NewTab,
    NewSection           = NewSection,
    NewToggle            = NewToggle,
    NewSlider            = NewSlider,
    NewButton            = NewButton,
    NewKeybind           = NewKeybind,
    NewLabel             = NewLabel,
    NewColorPicker       = NewColorPicker,
    NewBodyPartSelector  = NewBodyPartSelector,
    SelectTab            = SelectTab,
    registeredTabs       = registeredTabs,
    mainFrame            = mainFrame,
    sendNotification     = sendNotification,
    isMobile             = isMobile,
}
