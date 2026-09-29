--// =====================================================
--//   Femboy Hub | MM2 | by ViRuS/Prototip
--//   Style: Glossy Modern Dark
--// =====================================================

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local Lighting          = game:GetService("Lighting")
local HttpService       = game:GetService("HttpService")
local Workspace         = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

--// ================= ГЛЯНЦЕВАЯ ТЕМА =================
local Theme = {
    Bg       = Color3.fromRGB(16, 14, 22),
    Bg2      = Color3.fromRGB(22, 20, 30),
    Bg3      = Color3.fromRGB(32, 28, 42),
    Glass    = Color3.fromRGB(48, 42, 64),
    GlassHi  = Color3.fromRGB(70, 60, 90),
    Element  = Color3.fromRGB(40, 36, 54),
    Hover    = Color3.fromRGB(58, 50, 78),
    Text     = Color3.fromRGB(245, 240, 255),
    TextDim  = Color3.fromRGB(155, 145, 180),
    Accent   = Color3.fromRGB(255, 105, 180),
    Accent2  = Color3.fromRGB(180, 130, 255),
    Accent3  = Color3.fromRGB(120, 220, 255),
    Green    = Color3.fromRGB(120, 230, 150),
    Red      = Color3.fromRGB(255, 100, 120),
    Yellow   = Color3.fromRGB(255, 210, 120),
    Stroke   = Color3.fromRGB(80, 70, 110),
    Glow     = Color3.fromRGB(255, 105, 180),
}

local Config = {
    -- ESP
    RoleESP           = false,
    NameESP           = false,
    BoxESP            = false,
    TracerESP         = false,
    SkeletonESP       = false,
    ChamsESP          = false,
    GunESP            = false,
    CoinESP           = false,
    RoleStyle         = "Default",
    ESPColorInnocent  = Color3.fromRGB(120, 230, 150),
    ESPColorSheriff   = Color3.fromRGB(120, 200, 255),
    ESPColorMurder    = Color3.fromRGB(255, 100, 120),
    ESPTransparency   = 50,
    
    -- Visuals
    FullBright        = false,
    XRay              = false,
    XRayStrength      = 70,
    FOVCircle         = false,
    FOVRadius         = 100,
    NoFog             = false,
    Ambient           = false,
    ClockTime         = 14,
    
    -- Movement
    Walkspeed         = 16,
    JumpPower         = 50,
    Fly               = false,
    FlySpeed          = 60,
    InfiniteJump      = false,
    NoClip            = false,
    
    -- Main
    AutoFarm          = false,
    AutoCollectCoins  = false,
    AutoShoot         = false,
    Aimbot            = false,
    AimbotFOV         = 150,
    AimbotSmooth      = 30,
    TriggerBot        = false,
    
    -- Teleport
    TPDrop            = false,
    
    -- Fun
    FlingPlayers      = false,
    SpinBot           = false,
    
    -- Misc
    ShowFPS           = false,
    ShowPing          = false,
    AntiAFK           = true,
    Discord           = "discord.gg/femboyhub",
}

--// ================= УДАЛЕНИЕ СТАРОГО =================
local ok, hui = pcall(function() return gethui and gethui() end)
local parentGui = ok and hui or CoreGui
if parentGui:FindFirstChild("FemboyHub") then
    parentGui.FemboyHub:Destroy()
end

--// ================= SCREEN GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FemboyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

--// ================= ХЕЛПЕРЫ =================
local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function gradient(parent, c1, c2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

-- Стеклянный эффект (полупрозрачная панель с бликом сверху)
local function glassify(frame, roundRadius)
    frame.BackgroundColor3 = Theme.Glass
    frame.BackgroundTransparency = 0.35
    round(frame, roundRadius or 10)
    stroke(frame, Theme.Stroke, 1, 0.5)
    
    -- Верхний блик
    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(1, 0, 0.5, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.92
    shine.BorderSizePixel = 0
    shine.ZIndex = frame.ZIndex + 1
    shine.Parent = frame
    round(shine, roundRadius or 10)
    
    local shineGrad = Instance.new("UIGradient")
    shineGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    shineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 1),
    })
    shineGrad.Parent = shine
    
    return frame
end

--// ================= MAIN WINDOW =================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 680, 0, 440)
Main.Position = UDim2.new(0.5, -340, 0.5, -220)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
round(Main, 14)

-- Внешняя глянцевая обводка (glow)
local MainGlow = Instance.new("UIStroke")
MainGlow.Color = Theme.Accent
MainGlow.Thickness = 1.5
MainGlow.Transparency = 0.55
MainGlow.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Stroke
MainStroke.Thickness = 1
MainStroke.Transparency = 0.2
MainStroke.Parent = Main

-- Основной градиент окна
local MainGrad = Instance.new("UIGradient")
MainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 18, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 12, 20)),
})
MainGrad.Rotation = 135
MainGrad.Parent = Main

-- Блик сверху окна
local TopShine = Instance.new("Frame")
TopShine.Size = UDim2.new(1, 0, 0, 90)
TopShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopShine.BackgroundTransparency = 0.9
TopShine.BorderSizePixel = 0
TopShine.ZIndex = 2
TopShine.Parent = Main
round(TopShine, 14)

local TopShineGrad = Instance.new("UIGradient")
TopShineGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 1),
})
TopShineGrad.Rotation = 90
TopShineGrad.Parent = TopShine

-- Акцентная полоса сверху
local TopGlow = Instance.new("Frame")
TopGlow.Size = UDim2.new(1, 0, 0, 2)
TopGlow.BackgroundColor3 = Theme.Accent
TopGlow.BorderSizePixel = 0
TopGlow.ZIndex = 3
TopGlow.Parent = Main

local TopGlowGrad = Instance.new("UIGradient")
TopGlowGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Accent),
    ColorSequenceKeypoint.new(0.5, Theme.Accent2),
    ColorSequenceKeypoint.new(1, Theme.Accent3),
})
TopGlowGrad.Parent = TopGlow

--// ================= SIDEBAR =================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Theme.Bg
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.Parent = Main
round(Sidebar, 14)

local SbLine = Instance.new("Frame")
SbLine.Size = UDim2.new(0, 1, 1, -20)
SbLine.Position = UDim2.new(1, -1, 0, 10)
SbLine.BackgroundColor3 = Theme.Stroke
SbLine.BackgroundTransparency = 0.4
SbLine.BorderSizePixel = 0
SbLine.Parent = Sidebar

-- Заголовок
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundTransparency = 1
Header.ZIndex = 5
Header.Parent = Sidebar

local HubIcon = Instance.new("Frame")
HubIcon.Size = UDim2.new(0, 34, 0, 34)
HubIcon.Position = UDim2.new(0, 14, 0, 13)
HubIcon.BackgroundColor3 = Theme.Glass
HubIcon.BackgroundTransparency = 0.2
HubIcon.BorderSizePixel = 0
HubIcon.ZIndex = 6
HubIcon.Parent = Header
round(HubIcon, 10)
stroke(HubIcon, Theme.Accent, 1, 0.3)

local HIGrad = Instance.new("UIGradient")
HIGrad.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
HIGrad.Rotation = 45
HIGrad.Parent = HubIcon

local HILbl = Instance.new("TextLabel")
HILbl.Size = UDim2.new(1, 0, 1, 0)
HILbl.BackgroundTransparency = 1
HILbl.Text = "🌸"
HILbl.TextSize = 20
HILbl.ZIndex = 7
HILbl.Parent = HubIcon

local HubName = Instance.new("TextLabel")
HubName.Size = UDim2.new(1, -60, 0, 18)
HubName.Position = UDim2.new(0, 56, 0, 14)
HubName.BackgroundTransparency = 1
HubName.Text = "Femboy Hub"
HubName.TextColor3 = Theme.Text
HubName.Font = Enum.Font.GothamBold
HubName.TextSize = 14
HubName.TextXAlignment = Enum.TextXAlignment.Left
HubName.ZIndex = 6
HubName.Parent = Header

local HubSub = Instance.new("TextLabel")
HubSub.Size = UDim2.new(1, -60, 0, 14)
HubSub.Position = UDim2.new(0, 56, 0, 32)
HubSub.BackgroundTransparency = 1
HubSub.Text = "Murder Mystery 2"
HubSub.TextColor3 = Theme.TextDim
HubSub.Font = Enum.Font.Gotham
HubSub.TextSize = 10
HubSub.TextXAlignment = Enum.TextXAlignment.Left
HubSub.ZIndex = 6
HubSub.Parent = Header

-- Список
local SbList = Instance.new("ScrollingFrame")
SbList.Size = UDim2.new(1, 0, 1, -110)
SbList.Position = UDim2.new(0, 0, 0, 66)
SbList.BackgroundTransparency = 1
SbList.BorderSizePixel = 0
SbList.ScrollBarThickness = 2
SbList.ScrollBarImageColor3 = Theme.Accent
SbList.CanvasSize = UDim2.new(0, 0, 0, 0)
SbList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SbList.ZIndex = 5
SbList.Parent = Sidebar

local SbLayout = Instance.new("UIListLayout")
SbLayout.Padding = UDim.new(0, 3)
SbLayout.SortOrder = Enum.SortOrder.LayoutOrder
SbLayout.Parent = SbList

local SbPad = Instance.new("UIPadding")
SbPad.PaddingLeft = UDim.new(0, 8)
SbPad.PaddingRight = UDim.new(0, 8)
SbPad.PaddingTop = UDim.new(0, 4)
SbPad.PaddingBottom = UDim.new(0, 8)
SbPad.Parent = SbList

-- Footer
local Footer = Instance.new("TextButton")
Footer.Size = UDim2.new(1, -16, 0, 30)
Footer.Position = UDim2.new(0, 8, 1, -38)
Footer.BackgroundColor3 = Theme.Glass
Footer.BackgroundTransparency = 0.4
Footer.Text = Config.Discord
Footer.TextColor3 = Theme.TextDim
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 11
Footer.BorderSizePixel = 0
Footer.AutoButtonColor = false
Footer.ZIndex = 6
Footer.Parent = Sidebar
round(Footer, 8)
stroke(Footer, Theme.Stroke, 1, 0.5)

pcall(function()
    Footer.MouseButton1Click:Connect(function()
        setclipboard(Config.Discord)
    end)
end)

--// ================= CONTENT =================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -161, 1, 0)
Content.Position = UDim2.new(0, 161, 0, 0)
Content.BackgroundTransparency = 1
Content.ZIndex = 4
Content.Parent = Main

-- Top tabs
local TopTabs = Instance.new("Frame")
TopTabs.Size = UDim2.new(1, -24, 0, 40)
TopTabs.Position = UDim2.new(0, 12, 0, 12)
TopTabs.BackgroundTransparency = 1
TopTabs.ZIndex = 5
TopTabs.Parent = Content

local TTList = Instance.new("UIListLayout")
TTList.FillDirection = Enum.FillDirection.Horizontal
TTList.Padding = UDim.new(0, 6)
TTList.SortOrder = Enum.SortOrder.LayoutOrder
TTList.Parent = TopTabs

-- Pages
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -24, 1, -76)
Pages.Position = UDim2.new(0, 12, 0, 64)
Pages.BackgroundTransparency = 1
Pages.ClipsDescendants = true
Pages.ZIndex = 5
Pages.Parent = Content

--// ================= STORES =================
local PagesStore    = {}
local TabsStore     = {}
local SidebarItems  = {}
local ActivePage
local ActiveTopTab

--// ================= PAGE / ELEMENTS =================
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.ZIndex = 6
    page.Parent = Pages
    
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 8)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = page
    
    local p = Instance.new("UIPadding")
    p.PaddingRight = UDim.new(0, 8)
    p.PaddingBottom = UDim.new(0, 8)
    p.Parent = page
    
    PagesStore[name] = page
    return page
end

local function CreateSection(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 26)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function CreateDivider(parent)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1, 0, 0, 1)
    d.BackgroundColor3 = Theme.Stroke
    d.BackgroundTransparency = 0.5
    d.BorderSizePixel = 0
    d.Parent = parent
    return d
end

local function CreateToggle(parent, name, key, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 42)
    Row.BackgroundColor3 = Theme.Glass
    Row.BackgroundTransparency = 0.5
    Row.BorderSizePixel = 0
    Row.Parent = parent
    round(Row, 10)
    stroke(Row, Theme.Stroke, 1, 0.6)
    
    -- Глянцевый блик
    local Shine = Instance.new("Frame")
    Shine.Size = UDim2.new(1, 0, 0.5, 0)
    Shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shine.BackgroundTransparency = 0.94
    Shine.BorderSizePixel = 0
    Shine.ZIndex = Row.ZIndex + 1
    Shine.Parent = Row
    round(Shine, 10)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -80, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = Row.ZIndex + 2
    Lbl.Parent = Row
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 38, 0, 20)
    Switch.Position = UDim2.new(1, -52, 0.5, -10)
    Switch.BackgroundColor3 = Theme.Bg3
    Switch.BorderSizePixel = 0
    Switch.ZIndex = Row.ZIndex + 2
    Switch.Parent = Row
    round(Switch, 999)
    stroke(Switch, Theme.Stroke, 1, 0.5)
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 3, 0.5, -7)
    Knob.BackgroundColor3 = Theme.TextDim
    Knob.BorderSizePixel = 0
    Knob.ZIndex = Row.ZIndex + 3
    Knob.Parent = Switch
    round(Knob, 999)
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.ZIndex = Row.ZIndex + 4
    Btn.Parent = Row
    
    local function update()
        local on = Config[key]
        TweenService:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Theme.Accent or Theme.Bg3
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2), {
            Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = on and Theme.Text or Theme.TextDim
        }):Play()
        if callback then callback(on) end
    end
    
    Btn.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        update()
    end)
    update()
    return Row
end

local function CreateSlider(parent, name, key, min, max, suffix, callback)
    suffix = suffix or ""
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 52)
    Row.BackgroundColor3 = Theme.Glass
    Row.BackgroundTransparency = 0.5
    Row.BorderSizePixel = 0
    Row.Parent = parent
    round(Row, 10)
    stroke(Row, Theme.Stroke, 1, 0.6)
    
    local Shine = Instance.new("Frame")
    Shine.Size = UDim2.new(1, 0, 0.5, 0)
    Shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shine.BackgroundTransparency = 0.94
    Shine.BorderSizePixel = 0
    Shine.ZIndex = Row.ZIndex + 1
    Shine.Parent = Row
    round(Shine, 10)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -80, 0, 22)
    Lbl.Position = UDim2.new(0, 14, 0, 4)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = Row.ZIndex + 2
    Lbl.Parent = Row
    
    local Value = Instance.new("TextLabel")
    Value.Size = UDim2.new(0, 80, 0, 22)
    Value.Position = UDim2.new(1, -90, 0, 4)
    Value.BackgroundTransparency = 1
    Value.Text = tostring(Config[key]) .. suffix
    Value.TextColor3 = Theme.Accent
    Value.Font = Enum.Font.GothamMedium
    Value.TextSize = 12
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.ZIndex = Row.ZIndex + 2
    Value.Parent = Row
    
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -28, 0, 4)
    BarBg.Position = UDim2.new(0, 14, 0, 34)
    BarBg.BackgroundColor3 = Theme.Bg3
    BarBg.BorderSizePixel = 0
    BarBg.ZIndex = Row.ZIndex + 2
    BarBg.Parent = Row
    round(BarBg, 999)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[key] - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.ZIndex = Row.ZIndex + 3
    Fill.Parent = BarBg
    round(Fill, 999)
    
    local G = Instance.new("UIGradient")
    G.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
    G.Parent = Fill
    
    local dragging = false
    local function updateFromInput(input)
        local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos + 0.5)
        Config[key] = val
        Value.Text = tostring(val) .. suffix
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        if callback then callback(val) end
    end
    
    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return Row
end

local function CreateButton(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = Theme.Glass
    Btn.BackgroundTransparency = 0.5
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    round(Btn, 10)
    stroke(Btn, Theme.Stroke, 1, 0.6)
    
    local Shine = Instance.new("Frame")
    Shine.Size = UDim2.new(1, 0, 0.5, 0)
    Shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shine.BackgroundTransparency = 0.94
    Shine.BorderSizePixel = 0
    Shine.ZIndex = Btn.ZIndex + 1
    Shine.Parent = Btn
    round(Shine, 10)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -20, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = Btn.ZIndex + 2
    Lbl.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover, BackgroundTransparency = 0.35}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Glass, BackgroundTransparency = 0.5}):Play()
    end)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function CreateDropdown(parent, name, key, options, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 42)
    Row.BackgroundColor3 = Theme.Glass
    Row.BackgroundTransparency = 0.5
    Row.BorderSizePixel = 0
    Row.ClipsDescendants = true
    Row.Parent = parent
    round(Row, 10)
    stroke(Row, Theme.Stroke, 1, 0.6)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -110, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = Row.ZIndex + 2
    Lbl.Parent = Row
    
    local Current = Instance.new("TextLabel")
    Current.Size = UDim2.new(0, 100, 1, 0)
    Current.Position = UDim2.new(1, -114, 0, 0)
    Current.BackgroundTransparency = 1
    Current.Text = Config[key] or options[1]
    Current.TextColor3 = Theme.TextDim
    Current.Font = Enum.Font.Gotham
    Current.TextSize = 12
    Current.TextXAlignment = Enum.TextXAlignment.Right
    Current.ZIndex = Row.ZIndex + 2
    Current.Parent = Row
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -22, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▾"
    Arrow.TextColor3 = Theme.TextDim
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 12
    Arrow.ZIndex = Row.ZIndex + 2
    Arrow.Parent = Row
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.ZIndex = Row.ZIndex + 3
    Btn.Parent = Row
    
    local opened = false
    local expandedSize = 42 + #options * 30
    
    Btn.MouseButton1Click:Connect(function()
        opened = not opened
        TweenService:Create(Row, TweenInfo.new(0.25), {
            Size = opened and UDim2.new(1, 0, 0, expandedSize) or UDim2.new(1, 0, 0, 42)
        }):Play()
        Arrow.Text = opened and "▴" or "▾"
    end)
    
    local Options = Instance.new("Frame")
    Options.Size = UDim2.new(1, -20, 0, #options * 30)
    Options.Position = UDim2.new(0, 10, 0, 42)
    Options.BackgroundTransparency = 1
    Options.ZIndex = Row.ZIndex + 2
    Options.Parent = Row
    
    local OL = Instance.new("UIListLayout")
    OL.Padding = UDim.new(0, 2)
    OL.SortOrder = Enum.SortOrder.LayoutOrder
    OL.Parent = Options
    
    for _, opt in ipairs(options) do
        local OBtn = Instance.new("TextButton")
        OBtn.Size = UDim2.new(1, 0, 0, 28)
        OBtn.BackgroundColor3 = Theme.Bg3
        OBtn.BackgroundTransparency = 0.4
        OBtn.Text = ""
        OBtn.AutoButtonColor = false
        OBtn.ZIndex = Row.ZIndex + 3
        OBtn.Parent = Options
        round(OBtn, 8)
        
        local OLbl = Instance.new("TextLabel")
        OLbl.Size = UDim2.new(1, -16, 1, 0)
        OLbl.Position = UDim2.new(0, 10, 0, 0)
        OLbl.BackgroundTransparency = 1
        OLbl.Text = opt
        OLbl.TextColor3 = Theme.Text
        OLbl.Font = Enum.Font.Gotham
        OLbl.TextSize = 12
        OLbl.TextXAlignment = Enum.TextXAlignment.Left
        OLbl.ZIndex = Row.ZIndex + 4
        OLbl.Parent = OBtn
        
        OBtn.MouseButton1Click:Connect(function()
            Config[key] = opt
            Current.Text = opt
            opened = false
            TweenService:Create(Row, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 42)}):Play()
            Arrow.Text = "▾"
            if callback then callback(opt) end
        end)
        OBtn.MouseEnter:Connect(function() OBtn.BackgroundColor3 = Theme.Hover end)
        OBtn.MouseLeave:Connect(function() OBtn.BackgroundColor3 = Theme.Bg3 end)
    end
    
    return Row
end

local function CreateTextbox(parent, name, key, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 42)
    Row.BackgroundColor3 = Theme.Glass
    Row.BackgroundTransparency = 0.5
    Row.BorderSizePixel = 0
    Row.Parent = parent
    round(Row, 10)
    stroke(Row, Theme.Stroke, 1, 0.6)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -160, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = Row.ZIndex + 2
    Lbl.Parent = Row
    
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 140, 0, 26)
    Box.Position = UDim2.new(1, -152, 0.5, -13)
    Box.BackgroundColor3 = Theme.Bg3
    Box.Text = tostring(Config[key])
    Box.TextColor3 = Theme.Text
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 12
    Box.BorderSizePixel = 0
    Box.ClearTextOnFocus = false
    Box.ZIndex = Row.ZIndex + 2
    Box.Parent = Row
    round(Box, 8)
    stroke(Box, Theme.Stroke, 1, 0.5)
    
    Box.FocusLost:Connect(function()
        Config[key] = tonumber(Box.Text) or Box.Text
        if callback then callback(Config[key]) end
    end)
    
    return Row
end

--// ================= SWITCHING =================
local function ShowPage(name)
    for pname, page in pairs(PagesStore) do
        page.Visible = (pname == name)
    end
    ActivePage = name
end

local function CreateTopTab(name, pageName)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0, 100, 0, 32)
    Tab.BackgroundColor3 = Theme.Glass
    Tab.BackgroundTransparency = 0.6
    Tab.Text = ""
    Tab.AutoButtonColor = false
    Tab.Parent = TopTabs
    round(Tab, 999)
    stroke(Tab, Theme.Stroke, 1, 0.6)
    
    local Shine = Instance.new("Frame")
    Shine.Size = UDim2.new(1, -4, 0.5, 0)
    Shine.Position = UDim2.new(0, 2, 0, 1)
    Shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shine.BackgroundTransparency = 0.93
    Shine.BorderSizePixel = 0
    Shine.ZIndex = Tab.ZIndex + 1
    Shine.Parent = Tab
    round(Shine, 999)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 1, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.TextDim
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextSize = 12
    Lbl.ZIndex = Tab.ZIndex + 2
    Lbl.Parent = Tab
    
    local Underline = Instance.new("Frame")
    Underline.Size = UDim2.new(0, 0, 0, 2)
    Underline.Position = UDim2.new(0.5, 0, 1, -4)
    Underline.BackgroundColor3 = Theme.Accent
    Underline.BorderSizePixel = 0
    Underline.ZIndex = Tab.ZIndex + 3
    Underline.Parent = Tab
    round(Underline, 999)
    
    local UGrad = Instance.new("UIGradient")
    UGrad.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
    UGrad.Parent = Underline
    
    local function activate()
        for _, data in pairs(TabsStore) do
            TweenService:Create(data.label, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play()
            TweenService:Create(data.underline, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 0, 0, 2),
                Position = UDim2.new(0.5, 0, 1, -4)
            }):Play()
            TweenService:Create(data.button, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
        end
        TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play()
        TweenService:Create(Underline, TweenInfo.new(0.25), {
            Size = UDim2.new(0.7, 0, 0, 2),
            Position = UDim2.new(0.15, 0, 1, -4)
        }):Play()
        TweenService:Create(Tab, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        ShowPage(pageName)
        ActiveTopTab = name
    end
    
    TabsStore[name] = {button = Tab, label = Lbl, underline = Underline, activate = activate, page = pageName}
    Tab.MouseButton1Click:Connect(activate)
    return Tab
end

local function CreateSidebarItem(name, topTabName)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.BackgroundColor3 = Theme.Glass
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.ZIndex = 6
    Btn.Parent = SbList
    round(Btn, 8)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -16, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.TextDim
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 7
    Lbl.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        if ActivePage ~= name then
            TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
            TweenService:Create(Lbl, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play()
        end
    end)
    Btn.MouseLeave:Connect(function()
        if ActivePage ~= name then
            TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Lbl, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play()
        end
    end)
    
    Btn.MouseButton1Click:Connect(function()
        for _, data in pairs(SidebarItems) do
            TweenService:Create(data.btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.lbl, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play()
        end
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
        TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play()
        
        if topTabName and TabsStore[topTabName] then
            TabsStore[topTabName].activate()
        end
    end)
    
    table.insert(SidebarItems, {btn = Btn, lbl = Lbl, name = name})
    return Btn
end

--// ================= ПОСТРОЕНИЕ =================
CreateSidebarItem("Main", "ESP")
CreateSidebarItem("Movement", "Movement")
CreateSidebarItem("Visuals", "Visuals")
CreateSidebarItem("Teleport", "Teleport")
CreateSidebarItem("Fun/Troll", "Fun")
CreateSidebarItem("Settings", "Settings")

CreatePage("ESP")
CreatePage("Movement")
CreatePage("Visuals")
CreatePage("Teleport")
CreatePage("Fun")
CreatePage("Settings")

CreateTopTab("ESP", "ESP")
CreateTopTab("Movement", "Movement")
CreateTopTab("Visuals", "Visuals")
CreateTopTab("Teleport", "Teleport")
CreateTopTab("Fun", "Fun")
CreateTopTab("Settings", "Settings")

--// ================= ESP PAGE =================
local P_ESP = PagesStore.ESP
CreateSection(P_ESP, "ESP")
CreateToggle(P_ESP, "Enable Role ESP", "RoleESP")
CreateToggle(P_ESP, "Show Names", "NameESP")
CreateToggle(P_ESP, "Show Boxes", "BoxESP")
CreateToggle(P_ESP, "Show Tracers", "TracerESP")
CreateToggle(P_ESP, "Chams (Highlight)", "ChamsESP")
CreateToggle(P_ESP, "Gun ESP", "GunESP")
CreateToggle(P_ESP, "Coin ESP", "CoinESP")
CreateDivider(P_ESP)
CreateSection(P_ESP, "Настройки ESP")
CreateDropdown(P_ESP, "Role ESP Style", "RoleStyle", {"Default", "Box", "Chams", "Glow"})
CreateSlider(P_ESP, "ESP Transparency", "ESPTransparency", 0, 100, "%")

--// ================= MOVEMENT PAGE =================
local P_Move = PagesStore.Movement
CreateSection(P_Move, "Movement")
CreateSlider(P_Move, "Walkspeed", "Walkspeed", 16, 200, "", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = v end
end)
CreateSlider(P_Move, "JumpPower", "JumpPower", 50, 300, "", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = v; char.Humanoid.UseJumpPower = true end
end)
CreateToggle(P_Move, "Fly", "Fly")
CreateSlider(P_Move, "Fly Speed", "FlySpeed", 20, 300, "")
CreateToggle(P_Move, "Infinite Jump", "InfiniteJump")
CreateToggle(P_Move, "NoClip", "NoClip")
CreateDivider(P_Move)
CreateButton(P_Move, "Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)

--// ================= VISUALS PAGE =================
local P_Vis = PagesStore.Visuals
CreateSection(P_Vis, "World")
CreateToggle(P_Vis, "FullBright", "FullBright")
CreateToggle(P_Vis, "No Fog", "NoFog")
CreateToggle(P_Vis, "Custom Ambient", "Ambient")
CreateSlider(P_Vis, "Clock Time", "ClockTime", 0, 24, "h")
CreateDivider(P_Vis)
CreateSection(P_Vis, "Aim Assist")
CreateToggle(P_Vis, "FOV Circle", "FOVCircle")
CreateSlider(P_Vis, "FOV Radius", "FOVRadius", 30, 500, "")
CreateToggle(P_Vis, "Aimbot", "Aimbot")
CreateSlider(P_Vis, "Aimbot FOV", "AimbotFOV", 30, 500, "")
CreateSlider(P_Vis, "Aimbot Smooth", "AimbotSmooth", 0, 100, "%")
CreateToggle(P_Vis, "Trigger Bot", "TriggerBot")
CreateToggle(P_Vis, "Auto Shoot", "AutoShoot")
CreateDivider(P_Vis)
CreateSection(P_Vis, "Информация")
CreateToggle(P_Vis, "Show FPS", "ShowFPS")
CreateToggle(P_Vis, "Show Ping", "ShowPing")
CreateButton(P_Vis, "Сброс освещения", function()
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
end)

--// ================= TELEPORT PAGE =================
local P_TP = PagesStore.Teleport
CreateSection(P_TP, "Дроп")
CreateButton(P_TP, "Телепорт на дроп", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name == "KnifeDrop" or obj.Name == "Drop" then
            if obj:IsA("BasePart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                break
            end
        end
    end
end)
CreateToggle(P_TP, "Auto Teleport Drop", "TPDrop")
CreateDivider(P_TP)
CreateSection(P_TP, "Игроки")
local SelectedPlayer
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        CreateButton(P_TP, "Выбрать: " .. plr.Name, function()
            SelectedPlayer = plr
        end)
    end
end
CreateButton(P_TP, "Телепорт к выбранному", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

--// ================= FUN PAGE =================
local P_Fun = PagesStore.Fun
CreateSection(P_Fun, "Троллинг")
CreateToggle(P_Fun, "Fling Players", "FlingPlayers")
CreateToggle(P_Fun, "Spin Bot", "SpinBot")
CreateDivider(P_Fun)
CreateSection(P_Fun, "Эффекты")
CreateButton(P_Fun, "Сбросить персонажа", function()
    LocalPlayer.Character:BreakJoints()
end)

--// ================= SETTINGS PAGE =================
local P_Set = PagesStore.Settings
CreateSection(P_Set, "Общие")
CreateToggle(P_Set, "Anti-AFK", "AntiAFK")
CreateToggle(P_Set, "Auto Farm", "AutoFarm")
CreateToggle(P_Set, "Auto Collect Coins", "AutoCollectCoins")
CreateDivider(P_Set)
CreateSection(P_Set, "Конфиг")
CreateTextbox(P_Set, "Discord", "Discord")
CreateButton(P_Set, "Сохранить конфиг", function()
    if writefile then
        writefile("femboyhub_config.json", HttpService:JSONEncode(Config))
    end
end)
CreateButton(P_Set, "Загрузить конфиг", function()
    if readfile and isfile and isfile("femboyhub_config.json") then
        local data = HttpService:JSONDecode(readfile("femboyhub_config.json"))
        for k, v in pairs(data) do Config[k] = v end
    end
end)
CreateDivider(P_Set)
CreateButton(P_Set, "Уничтожить UI", function()
    ScreenGui:Destroy()
end)

--// ================= АКТИВАЦИЯ =================
TabsStore["ESP"].activate()

--// ================= ЛОГИКА =================

-- === ESP ===
local espData = {}
local drawObjects = {}

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESP(p) end
end

local function getRole(player)
    if player == LocalPlayer then return "innocent" end
    local char = player.Character
    if not char then return "innocent" end
    if char:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife")) then return "murder" end
    if char:FindFirstChild("Gun") or (player.Backpack and player.Backpack:FindFirstChild("Gun")) then return "sheriff" end
    return "innocent"
end

local function roleColor(player)
    local role = getRole(player)
    if role == "murder" then return Config.ESPColorMurder
    elseif role == "sheriff" then return Config.ESPColorSheriff
    else return Config.ESPColorInnocent end
end

function createESP(player)
    if player == LocalPlayer then return end
    if drawObjects[player] then return end
    drawObjects[player] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        tracer = Drawing.new("Line"),
        hl = nil,
    }
    drawObjects[player].box.Thickness = 1
    drawObjects[player].box.Filled = false
    drawObjects[player].box.Visible = false
    drawObjects[player].name.Size = 14
    drawObjects[player].name.Center = true
    drawObjects[player].name.Outline = true
    drawObjects[player].name.Visible = false
    drawObjects[player].tracer.Thickness = 1
    drawObjects[player].tracer.Visible = false
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not drawObjects[p] then createESP(p) end
        local d = drawObjects[p]
        if not d then continue end
        
        local char = p.Character
        local col = roleColor(p)
        
        -- Highlight (Chams)
        if Config.ChamsESP and char then
            if not d.hl or d.hl.Parent ~= char then
                if d.hl then d.hl:Destroy() end
                d.hl = Instance.new("Highlight")
                d.hl.FillColor = col
                d.hl.OutlineColor = col
                d.hl.Parent = char
                d.hl.Adornee = char
            end
            d.hl.FillColor = col
            d.hl.OutlineColor = col
            d.hl.FillTransparency = 1 - (Config.ESPTransparency / 100)
            d.hl.Enabled = true
        elseif d.hl then
            d.hl.Enabled = false
        end
        
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local size = Vector2.new(2000 / pos.Z, 2500 / pos.Z)
                local boxPos = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                
                d.box.Size = size
                d.box.Position = boxPos
                d.box.Color = col
                d.box.Visible = Config.BoxESP or Config.RoleESP
                
                d.name.Text = p.Name
                d.name.Position = Vector2.new(pos.X, boxPos.Y - 18)
                d.name.Color = col
                d.name.Visible = Config.NameESP
                
                d.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                d.tracer.To = Vector2.new(pos.X, boxPos.Y + size.Y)
                d.tracer.Color = col
                d.tracer.Visible = Config.TracerESP
            else
                d.box.Visible = false
                d.name.Visible = false
                d.tracer.Visible = false
            end
        else
            d.box.Visible = false
            d.name.Visible = false
            d.tracer.Visible = false
        end
    end
end)

-- === FOV Circle ===
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Color = Theme.Accent
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.NumSides = 64

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fovCircle.Radius = Config.FOVRadius
    fovCircle.Visible = Config.FOVCircle
end)

-- === Aimbot ===
local aiming = false
UserInputService.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end
end)

RunService.RenderStepped:Connect(function()
    if Config.Aimbot and aiming then
        local closest, shortest = nil, Config.AimbotFOV
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = p.Character.HumanoidRootPart
                        end
                    end
                end
            end
        end
        if closest then
            local smooth = (100 - Config.AimbotSmooth) / 100
            local targetCF = CFrame.new(Camera.CFrame.Position, closest.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
        end
    end
end)

-- === Lighting ===
RunService.Heartbeat:Connect(function()
    if Config.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
    end
    if Config.NoFog then
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 1e6
    end
    if Config.Ambient then
        Lighting.ClockTime = Config.ClockTime
    end
end)

-- === XRay ===
RunService.RenderStepped:Connect(function()
    if Config.XRay then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.LocalTransparencyModifier = 1 - (Config.XRayStrength / 100)
                end
            end
        end
    end
end)

-- === Fly ===
local flyBV
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if Config.Fly then
        if not flyBV then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyBV.Velocity = Vector3.zero
            flyBV.Parent = hrp
        end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
        flyBV.Velocity = dir * Config.FlySpeed
    else
        if flyBV then flyBV:Destroy() flyBV = nil end
    end
end)

-- === Infinite Jump ===
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- === NoClip ===
RunService.Stepped:Connect(function()
    if Config.NoClip then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

-- === Anti-AFK ===
if Config.AntiAFK then
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    end)
end

-- === Auto Collect Coins ===
RunService.Heartbeat:Connect(function()
    if not Config.AutoCollectCoins then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Coin" and obj:IsA("BasePart") then
            pcall(function() char.HumanoidRootPart.CFrame = obj.CFrame end)
        end
    end
end)

-- === Auto Farm ===
RunService.Heartbeat:Connect(function()
    if not Config.AutoFarm then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "GunDrop" or obj.Name == "KnifeDrop" or obj.Name == "Coin") then
            pcall(function() char.HumanoidRootPart.CFrame = obj.CFrame end)
        end
    end
end)

-- === Spin Bot ===
RunService.Heartbeat:Connect(function()
    if Config.SpinBot then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end
end)

-- === Fling ===
RunService.Heartbeat:Connect(function()
    if not Config.FlingPlayers then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < 5 then
                p.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- === FPS / Ping ===
local statsLabel
local fpsCounter, fpsTime, fpsValue = 0, 0, 0
RunService.RenderStepped:Connect(function(dt)
    fpsCounter += 1
    fpsTime += dt
    if fpsTime >= 1 then
        fpsValue = fpsCounter
        fpsCounter = 0
        fpsTime = 0
    end
    
    if Config.ShowFPS or Config.ShowPing then
        if not statsLabel then
            statsLabel = Instance.new("TextLabel")
            statsLabel.Size = UDim2.new(0, 150, 0, 22)
            statsLabel.Position = UDim2.new(0, 10, 0, 10)
            statsLabel.BackgroundColor3 = Theme.Glass
            statsLabel.BackgroundTransparency = 0.4
            statsLabel.TextColor3 = Theme.Text
            statsLabel.Font = Enum.Font.GothamBold
            statsLabel.TextSize = 11
            statsLabel.BorderSizePixel = 0
            statsLabel.ZIndex = 50
            statsLabel.Parent = ScreenGui
            round(statsLabel, 6)
            stroke(statsLabel, Theme.Stroke, 1, 0.5)
        end
        local ping = ""
        pcall(function()
            ping = " | " .. math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms"
        end)
        statsLabel.Text = (Config.ShowFPS and ("FPS: " .. fpsValue) or "") .. (Config.ShowPing and ping or "")
    elseif statsLabel then
        statsLabel:Destroy()
        statsLabel = nil
    end
end)

--// ================= NOTIFY =================
local function Notify(title, desc, duration)
    duration = duration or 3
    local Note = Instance.new("Frame")
    Note.Size = UDim2.new(0, 280, 0, 62)
    Note.Position = UDim2.new(0.5, -140, 0, -80)
    Note.BackgroundColor3 = Theme.Glass
    Note.BackgroundTransparency = 0.25
    Note.BorderSizePixel = 0
    Note.ZIndex = 100
    Note.Parent = ScreenGui
    round(Note, 12)
    stroke(Note, Theme.Accent, 1.2, 0.4)
    
    local NShine = Instance.new("Frame")
    NShine.Size = UDim2.new(1, 0, 0.5, 0)
    NShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NShine.BackgroundTransparency = 0.93
    NShine.BorderSizePixel = 0
    NShine.ZIndex = 101
    NShine.Parent = Note
    round(NShine, 12)
    
    local Icon = Instance.new("Frame")
    Icon.Size = UDim2.new(0, 38, 0, 38)
    Icon.Position = UDim2.new(0, 12, 0.5, -19)
    Icon.BackgroundColor3 = Theme.Glass
    Icon.BackgroundTransparency = 0.2
    Icon.BorderSizePixel = 0
    Icon.ZIndex = 102
    Icon.Parent = Note
    round(Icon, 999)
    
    local IGrad = Instance.new("UIGradient")
    IGrad.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
    IGrad.Parent = Icon
    
    local ILbl = Instance.new("TextLabel")
    ILbl.Size = UDim2.new(1, 0, 1, 0)
    ILbl.BackgroundTransparency = 1
    ILbl.Text = "🌸"
    ILbl.TextSize = 18
    ILbl.ZIndex = 103
    ILbl.Parent = Icon
    
    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, -60, 0, 20)
    T.Position = UDim2.new(0, 58, 0, 10)
    T.BackgroundTransparency = 1
    T.Text = title
    T.TextColor3 = Theme.Text
    T.Font = Enum.Font.GothamBold
    T.TextSize = 13
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.ZIndex = 102
    T.Parent = Note
    
    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -60, 0, 18)
    D.Position = UDim2.new(0, 58, 0, 28)
    D.BackgroundTransparency = 1
    D.Text = desc
    D.TextColor3 = Theme.TextDim
    D.Font = Enum.Font.Gotham
    D.TextSize = 11
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.ZIndex = 102
    D.Parent = Note
    
    TweenService:Create(Note, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -140, 0, 20)
    }):Play()
    
    task.delay(duration, function()
        local t = TweenService:Create(Note, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -140, 0, -80)
        })
        t:Play()
        t.Completed:Wait()
        Note:Destroy()
    end)
end

--// ================= АНИМАЦИЯ ПОЯВЛЕНИЯ =================
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 680, 0, 440),
    Position = UDim2.new(0.5, -340, 0.5, -220)
}):Play()

Notify("Femboy Hub", "Загружено успешно 💖", 4)

print("[Femboy Hub] loaded")