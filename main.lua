--// =====================================================
--//   Femboy Hub | MM2 | by ViRuS/Prototip
--//   Style: Modern Dark (Pulse-like)
--// =====================================================

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local Lighting          = game:GetService("Lighting")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

--// ================= ТЕМА =================
local Theme = {
    Bg       = Color3.fromRGB(18, 16, 24),
    Bg2      = Color3.fromRGB(24, 22, 32),
    Bg3      = Color3.fromRGB(34, 30, 44),
    Element  = Color3.fromRGB(40, 36, 52),
    Hover    = Color3.fromRGB(52, 46, 68),
    Text     = Color3.fromRGB(240, 235, 250),
    TextDim  = Color3.fromRGB(150, 140, 170),
    Accent   = Color3.fromRGB(255, 105, 180), -- pink
    Accent2  = Color3.fromRGB(180, 130, 255), -- purple
    Accent3  = Color3.fromRGB(120, 220, 255), -- cyan
    Green    = Color3.fromRGB(120, 230, 150),
    Red      = Color3.fromRGB(255, 100, 120),
    Yellow   = Color3.fromRGB(255, 210, 120),
    Stroke   = Color3.fromRGB(60, 55, 80),
}

--// ================= КОНФИГ =================
local Config = {
    -- ESP
    RoleESP           = false,
    NameESP           = false,
    BoxESP            = false,
    HealthESP         = false,
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
    AimbotSmooth      = 0.3,
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
for _, gui in ipairs({CoreGui, (gethui and gethui() or nil)}) do
    if gui and gui:FindFirstChild("FemboyHub") then
        gui.FemboyHub:Destroy()
    end
end

--// ================= SCREEN GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FemboyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = gethui() end)
if not ScreenGui.Parent then ScreenGui.Parent = CoreGui end

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

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Stroke
MainStroke.Thickness = 1
MainStroke.Parent = Main

-- Градиентный акцент по верху
local TopGlow = Instance.new("Frame")
TopGlow.Size = UDim2.new(1, 0, 0, 2)
TopGlow.BackgroundColor3 = Theme.Accent
TopGlow.BorderSizePixel = 0
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
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SbLine = Instance.new("Frame")
SbLine.Size = UDim2.new(0, 1, 1, 0)
SbLine.Position = UDim2.new(1, -1, 0, 0)
SbLine.BackgroundColor3 = Theme.Stroke
SbLine.BorderSizePixel = 0
SbLine.Parent = Sidebar

-- Заголовок
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundTransparency = 1
Header.Parent = Sidebar

local HubIcon = Instance.new("Frame")
HubIcon.Size = UDim2.new(0, 34, 0, 34)
HubIcon.Position = UDim2.new(0, 14, 0, 13)
HubIcon.BackgroundColor3 = Theme.Element
HubIcon.BorderSizePixel = 0
HubIcon.Parent = Header

local HICorner = Instance.new("UICorner")
HICorner.CornerRadius = UDim.new(0, 9)
HICorner.Parent = HubIcon

local HILbl = Instance.new("TextLabel")
HILbl.Size = UDim2.new(1, 0, 1, 0)
HILbl.BackgroundTransparency = 1
HILbl.Text = "🌸"
HILbl.TextSize = 20
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
HubSub.Parent = Header

-- Список разделов
local SbList = Instance.new("ScrollingFrame")
SbList.Size = UDim2.new(1, 0, 1, -110)
SbList.Position = UDim2.new(0, 0, 0, 66)
SbList.BackgroundTransparency = 1
SbList.BorderSizePixel = 0
SbList.ScrollBarThickness = 2
SbList.ScrollBarImageColor3 = Theme.Accent
SbList.CanvasSize = UDim2.new(0, 0, 0, 0)
SbList.AutomaticCanvasSize = Enum.AutomaticSize.Y
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

-- Футер Discord
local Footer = Instance.new("TextButton")
Footer.Size = UDim2.new(1, -16, 0, 30)
Footer.Position = UDim2.new(0, 8, 1, -38)
Footer.BackgroundColor3 = Theme.Bg2
Footer.Text = Config.Discord
Footer.TextColor3 = Theme.TextDim
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 11
Footer.BorderSizePixel = 0
Footer.AutoButtonColor = false
Footer.Parent = Sidebar

local FCorner = Instance.new("UICorner")
FCorner.CornerRadius = UDim.new(0, 6)
FCorner.Parent = Footer

pcall(function()
    Footer.MouseButton1Click:Connect(function()
        setclipboard(Config.Discord)
    end)
end)

--// ================= CONTENT =================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -161, 1, 0)
Content.Position = UDim2.new(0, 161, 0, 0)
Content.BackgroundColor3 = Theme.Bg2
Content.BorderSizePixel = 0
Content.Parent = Main

local CCorner = Instance.new("UICorner")
CCorner.CornerRadius = UDim.new(0, 12)
CCorner.Parent = Content

-- Top Tabs
local TopTabs = Instance.new("Frame")
TopTabs.Size = UDim2.new(1, -24, 0, 40)
TopTabs.Position = UDim2.new(0, 12, 0, 12)
TopTabs.BackgroundTransparency = 1
TopTabs.Parent = Content

local TTList = Instance.new("UIListLayout")
TTList.FillDirection = Enum.FillDirection.Horizontal
TTList.Padding = UDim.new(0, 6)
TTList.SortOrder = Enum.SortOrder.LayoutOrder
TTList.Parent = TopTabs

-- Pages area
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -24, 1, -76)
Pages.Position = UDim2.new(0, 12, 0, 64)
Pages.BackgroundTransparency = 1
Pages.ClipsDescendants = true
Pages.Parent = Content

--// ================= STORES =================
local PagesStore    = {}   -- [name] = page
local TabsStore     = {}   -- [topTabName] = {activate, page}
local SidebarItems  = {}
local ActivePage
local ActiveTopTab

--// ================= ХЕЛПЕРЫ UI =================

local function MakeRound(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

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
    d.BackgroundTransparency = 0.4
    d.BorderSizePixel = 0
    d.Parent = parent
    return d
end

local function CreateToggle(parent, name, key, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 42)
    Row.BackgroundColor3 = Theme.Element
    Row.BackgroundTransparency = 0.4
    Row.BorderSizePixel = 0
    Row.Parent = parent
    MakeRound(Row, 8)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -80, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Row
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 38, 0, 20)
    Switch.Position = UDim2.new(1, -52, 0.5, -10)
    Switch.BackgroundColor3 = Theme.Bg3
    Switch.BorderSizePixel = 0
    Switch.Parent = Row
    MakeRound(Switch, 999)
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 3, 0.5, -7)
    Knob.BackgroundColor3 = Theme.TextDim
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch
    MakeRound(Knob, 999)
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
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
    Row.BackgroundColor3 = Theme.Element
    Row.BackgroundTransparency = 0.4
    Row.BorderSizePixel = 0
    Row.Parent = parent
    MakeRound(Row, 8)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -80, 0, 22)
    Lbl.Position = UDim2.new(0, 14, 0, 4)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
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
    Value.Parent = Row
    
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -28, 0, 4)
    BarBg.Position = UDim2.new(0, 14, 0, 34)
    BarBg.BackgroundColor3 = Theme.Bg3
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Row
    MakeRound(BarBg, 999)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[key] - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg
    MakeRound(Fill, 999)
    
    local G = Instance.new("UIGradient")
    G.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Accent2),
    })
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
    Btn.BackgroundColor3 = Theme.Element
    Btn.BackgroundTransparency = 0.4
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    MakeRound(Btn, 8)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -20, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Element}):Play()
    end)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function CreateDropdown(parent, name, key, options, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 42)
    Row.BackgroundColor3 = Theme.Element
    Row.BackgroundTransparency = 0.4
    Row.BorderSizePixel = 0
    Row.ClipsDescendants = true
    Row.Parent = parent
    MakeRound(Row, 8)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -110, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
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
    Current.Parent = Row
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -22, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▾"
    Arrow.TextColor3 = Theme.TextDim
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 12
    Arrow.Parent = Row
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
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
    Options.Parent = Row
    
    local OL = Instance.new("UIListLayout")
    OL.Padding = UDim.new(0, 2)
    OL.SortOrder = Enum.SortOrder.LayoutOrder
    OL.Parent = Options
    
    for _, opt in ipairs(options) do
        local OBtn = Instance.new("TextButton")
        OBtn.Size = UDim2.new(1, 0, 0, 28)
        OBtn.BackgroundColor3 = Theme.Bg3
        OBtn.BackgroundTransparency = 0.5
        OBtn.Text = ""
        OBtn.AutoButtonColor = false
        OBtn.Parent = Options
        MakeRound(OBtn, 6)
        
        local OLbl = Instance.new("TextLabel")
        OLbl.Size = UDim2.new(1, -16, 1, 0)
        OLbl.Position = UDim2.new(0, 10, 0, 0)
        OLbl.BackgroundTransparency = 1
        OLbl.Text = opt
        OLbl.TextColor3 = Theme.Text
        OLbl.Font = Enum.Font.Gotham
        OLbl.TextSize = 12
        OLbl.TextXAlignment = Enum.TextXAlignment.Left
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
    Row.BackgroundColor3 = Theme.Element
    Row.BackgroundTransparency = 0.4
    Row.BorderSizePixel = 0
    Row.Parent = parent
    MakeRound(Row, 8)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -160, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.Text
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
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
    Box.Parent = Row
    MakeRound(Box, 6)
    
    Box.FocusLost:Connect(function()
        Config[key] = tonumber(Box.Text) or Box.Text
        if callback then callback(Config[key]) end
    end)
    
    return Row
end

--// ================= ПЕРЕКЛЮЧЕНИЕ =================
local function ShowPage(name)
    for pname, page in pairs(PagesStore) do
        page.Visible = (pname == name)
    end
    ActivePage = name
end

--// ================= TOP TABS =================
local function CreateTopTab(name, pageName)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0, 100, 0, 32)
    Tab.BackgroundColor3 = Theme.Element
    Tab.BackgroundTransparency = 0.5
    Tab.Text = ""
    Tab.AutoButtonColor = false
    Tab.Parent = TopTabs
    MakeRound(Tab, 999)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 1, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.TextDim
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextSize = 12
    Lbl.Parent = Tab
    
    local Underline = Instance.new("Frame")
    Underline.Size = UDim2.new(0, 0, 0, 2)
    Underline.Position = UDim2.new(0.5, 0, 1, -4)
    Underline.BackgroundColor3 = Theme.Accent
    Underline.BorderSizePixel = 0
    Underline.Parent = Tab
    MakeRound(Underline, 999)
    
    local function activate()
        for _, data in pairs(TabsStore) do
            TweenService:Create(data.label, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play()
            TweenService:Create(data.underline, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 0, 0, 2),
                Position = UDim2.new(0.5, 0, 1, -4)
            }):Play()
            TweenService:Create(data.button, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        end
        TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play()
        TweenService:Create(Underline, TweenInfo.new(0.25), {
            Size = UDim2.new(0.7, 0, 0, 2),
            Position = UDim2.new(0.15, 0, 1, -4)
        }):Play()
        TweenService:Create(Tab, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        ShowPage(pageName)
        ActiveTopTab = name
    end
    
    TabsStore[name] = {button = Tab, label = Lbl, underline = Underline, activate = activate, page = pageName}
    Tab.MouseButton1Click:Connect(activate)
    return Tab
end

--// ================= SIDEBAR ITEM =================
local function CreateSidebarItem(name, topTabName)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.BackgroundColor3 = Theme.Bg
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = SbList
    MakeRound(Btn, 6)
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -16, 1, 0)
    Lbl.Position = UDim2.new(0, 14, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Theme.TextDim
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        if ActivePage ~= name then
            TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
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
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play()
        
        if topTabName and TabsStore[topTabName] then
            TabsStore[topTabName].activate()
        end
    end)
    
    table.insert(SidebarItems, {btn = Btn, lbl = Lbl, name = name})
    return Btn
end

--// ================= СОЗДАЁМ РАЗДЕЛЫ =================
CreateSidebarItem("Main", "ESP")
CreateSidebarItem("Movement", "Movement")
CreateSidebarItem("Visuals", "Visuals")
CreateSidebarItem("Teleport", "Teleport")
CreateSidebarItem("Fun/Troll", "Fun")
CreateSidebarItem("Settings", "Settings")

--// Страницы
CreatePage("ESP")
CreatePage("Movement")
CreatePage("Visuals")
CreatePage("Teleport")
CreatePage("Fun")
CreatePage("Settings")

--// Top Tabs
CreateTopTab("ESP", "ESP")
CreateTopTab("Movement", "Movement")
CreateTopTab("Visuals", "Visuals")
CreateTopTab("Teleport", "Teleport")
CreateTopTab("Fun", "Fun")
CreateTopTab("Settings", "Settings")

--// ================= ESP PAGE =================
local P = PagesStore.ESP
CreateSection(P, "ESP")
CreateToggle(P, "Enable Role ESP", "RoleESP")
CreateToggle(P, "Show Names", "NameESP")
CreateToggle(P, "Show Boxes", "BoxESP")
CreateToggle(P, "Show Health", "HealthESP")
CreateToggle(P, "Show Tracers", "TracerESP")
CreateToggle(P, "Show Skeleton", "SkeletonESP")
CreateToggle(P, "Chams (Highlight)", "ChamsESP")
CreateToggle(P, "Gun ESP", "GunESP")
CreateToggle(P, "Coin ESP", "CoinESP")
CreateDivider(P)
CreateSection(P, "Настройки ESP")
CreateDropdown(P, "Role ESP Style", "RoleStyle", {"Default", "Box", "Chams", "Glow", "R6 Skeleton"})
CreateSlider(P, "ESP Transparency", "ESPTransparency", 0, 100, "%")

--// ================= MOVEMENT PAGE =================
local P = PagesStore.Movement
CreateSection(P, "Movement")
CreateSlider(P, "Walkspeed", "Walkspeed", 16, 200, "", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = v end
end)
CreateSlider(P, "JumpPower", "JumpPower", 50, 300, "", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = v; char.Humanoid.UseJumpPower = true end
end)
CreateToggle(P, "Fly", "Fly")
CreateSlider(P, "Fly Speed", "FlySpeed", 20, 300, "")
CreateToggle(P, "Infinite Jump", "InfiniteJump")
CreateToggle(P, "NoClip", "NoClip")
CreateDivider(P)
CreateSection(P, "Утилиты")
CreateButton(P, "Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)

--// ================= VISUALS PAGE =================
local P = PagesStore.Visuals
CreateSection(P, "World")
CreateToggle(P, "FullBright", "FullBright")
CreateToggle(P, "No Fog", "NoFog")
CreateToggle(P, "Custom Ambient", "Ambient")
CreateSlider(P, "Clock Time", "ClockTime", 0, 24, "h")
CreateDivider(P)
CreateSection(P, "Aim Assist")
CreateToggle(P, "FOV Circle", "FOVCircle")
CreateSlider(P, "FOV Radius", "FOVRadius", 30, 500, "")
CreateToggle(P, "Aimbot", "Aimbot")
CreateSlider(P, "Aimbot FOV", "AimbotFOV", 30, 500, "")
CreateSlider(P, "Aimbot Smooth", "AimbotSmooth", 0, 100, "%")
CreateToggle(P, "Trigger Bot", "TriggerBot")
CreateToggle(P, "Auto Shoot", "AutoShoot")
CreateDivider(P)
CreateSection(P, "Информация")
CreateToggle(P, "Show FPS", "ShowFPS")
CreateToggle(P, "Show Ping", "ShowPing")
CreateButton(P, "Сброс освещения", function()
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
end)

--// ================= TELEPORT PAGE =================
local P = PagesStore.Teleport
CreateSection(P, "Дроп")
CreateButton(P, "Телепорт на дроп", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name == "KnifeDrop" or obj.Name == "Drop" then
            if obj:IsA("BasePart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                break
            end
        end
    end
end)
CreateToggle(P, "Auto Teleport Drop", "TPDrop")
CreateDivider(P)
CreateSection(P, "Игроки")
local SelectedPlayer
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        CreateButton(P, "TP → " .. plr.Name, function()
            SelectedPlayer = plr
        end)
    end
end
CreateButton(P, "Телепорт к выбранному", function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

--// ================= FUN PAGE =================
local P = PagesStore.Fun
CreateSection(P, "Троллинг")
CreateToggle(P, "Fling Players", "FlingPlayers")
CreateToggle(P, "Spin Bot", "SpinBot")
CreateDivider(P)
CreateSection(P, "Эффекты")
CreateButton(P, "Сбросить персонажа", function()
    LocalPlayer.Character:BreakJoints()
end)
CreateButton(P, "Убить всех (только убийца)", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = 0
            end
        end
    end
end)

--// ================= SETTINGS PAGE =================
local P = PagesStore.Settings
CreateSection(P, "Общие")
CreateToggle(P, "Anti-AFK", "AntiAFK")
CreateToggle(P, "Auto Farm", "AutoFarm")
CreateToggle(P, "Auto Collect Coins", "AutoCollectCoins")
CreateDivider(P)
CreateSection(P, "Конфиг")
CreateTextbox(P, "Discord", "Discord")
CreateButton(P, "Сохранить конфиг", function()
    if writefile then
        writefile("femboyhub_config.json", HttpService:JSONEncode(Config))
    end
end)
CreateButton(P, "Загрузить конфиг", function()
    if readfile and isfile and isfile("femboyhub_config.json") then
        local data = HttpService:JSONDecode(readfile("femboyhub_config.json"))
        for k, v in pairs(data) do Config[k] = v end
    end
end)
CreateDivider(P)
CreateButton(P, "Уничтожить UI", function()
    ScreenGui:Destroy()
end)

--// ================= АКТИВАЦИЯ =================
TabsStore["ESP"].activate()

--// ================= ЛОГИКА =================

-- === ESP ===
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "FemboyHub_ESP"
ESPFolder.Parent = ScreenGui

local espData = {}

local function getRole(player)
    if player == LocalPlayer then return "innocent" end
    local char = player.Character
    if not char then return "innocent" end
    if char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then return "murder" end
    if char:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then return "sheriff" end
    return "innocent"
end

local function roleColor(player)
    local role = getRole(player)
    if role == "murder" then return Config.ESPColorMurder
    elseif role == "sheriff" then return Config.ESPColorSheriff
    else return Config.ESPColorInnocent end
end

local function clearESP(player)
    if espData[player] then
        for _, obj in pairs(espData[player]) do
            pcall(function() obj:Destroy() end)
        end
        espData[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    clearESP(player)
    espData[player] = {}
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(clearESP)

-- Рисовалки через Drawing
local drawObjects = {}

RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not drawObjects[p] then
            drawObjects[p] = {
                box = Drawing.new("Square"),
                name = Drawing.new("Text"),
                health = Drawing.new("Text"),
                tracer = Drawing.new("Line"),
                hl = nil,
            }
            drawObjects[p].box.Thickness = 1
            drawObjects[p].box.Filled = false
            drawObjects[p].box.Visible = false
            drawObjects[p].name.Size = 14
            drawObjects[p].name.Center = true
            drawObjects[p].name.Outline = true
            drawObjects[p].name.Visible = false
            drawObjects[p].health.Size = 12
            drawObjects[p].health.Center = false
            drawObjects[p].health.Outline = true
            drawObjects[p].health.Visible = false
            drawObjects[p].tracer.Thickness = 1
            drawObjects[p].tracer.Visible = false
        end
        
        local d = drawObjects[p]
        local char = p.Character
        local role = getRole(p)
        local col = roleColor(p)
        
        -- Highlight
        if Config.ChamsESP then
            if not d.hl or d.hl.Parent ~= char then
                if d.hl then d.hl:Destroy() end
                d.hl = Instance.new("Highlight")
                d.hl.FillColor = col
                d.hl.OutlineColor = col
                d.hl.FillTransparency = 1 - (Config.ESPTransparency / 100)
                d.hl.OutlineTransparency = 0
                d.hl.Parent = char or ScreenGui
                d.hl.Adornee = char
            end
            if d.hl then
                d.hl.FillColor = col
                d.hl.OutlineColor = col
                d.hl.FillTransparency = 1 - (Config.ESPTransparency / 100)
                d.hl.Enabled = true
            end
        elseif d.hl then
            d.hl.Enabled = false
        end
        
        -- Box / Name / Health / Tracer
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
                
                d.health.Text = "❤ " .. math.floor(char.Humanoid.Health)
                d.health.Position = Vector2.new(boxPos.X - 60, boxPos.Y)
                d.health.Color = Theme.Green
                d.health.Visible = Config.HealthESP
                
                d.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                d.tracer.To = Vector2.new(pos.X, boxPos.Y + size.Y)
                d.tracer.Color = col
                d.tracer.Visible = Config.TracerESP
            else
                d.box.Visible = false
                d.name.Visible = false
                d.health.Visible = false
                d.tracer.Visible = false
            end
        else
            d.box.Visible = false
            d.name.Visible = false
            d.health.Visible = false
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

-- === FullBright / NoFog / Ambient ===
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

-- === Auto Farm (упрощённый) ===
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

-- === Fling Players ===
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

-- === FPS/Ping ===
local statsLabel
RunService.RenderStepped:Connect(function()
    if Config.ShowFPS or Config.ShowPing then
        if not statsLabel then
            statsLabel = Instance.new("TextLabel")
            statsLabel.Size = UDim2.new(0, 140, 0, 22)
            statsLabel.Position = UDim2.new(0, 10, 0, 10)
            statsLabel.BackgroundColor3 = Theme.Bg
            statsLabel.BackgroundTransparency = 0.3
            statsLabel.TextColor3 = Theme.Text
            statsLabel.Font = Enum.Font.GothamBold
            statsLabel.TextSize = 11
            statsLabel.BorderSizePixel = 0
            statsLabel.Parent = ScreenGui
            MakeRound(statsLabel, 6)
        end
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = ""
        pcall(function() ping = " | " .. math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms" end)
        statsLabel.Text = (Config.ShowFPS and ("FPS: " .. fps) or "") .. (Config.ShowPing and ping or "")
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
    Note.BackgroundColor3 = Theme.Bg
    Note.BorderSizePixel = 0
    Note.Parent = ScreenGui
    MakeRound(Note, 10)
    
    local S = Instance.new("UIStroke")
    S.Color = Theme.Stroke
    S.Parent = Note
    
    local Icon = Instance.new("Frame")
    Icon.Size = UDim2.new(0, 38, 0, 38)
    Icon.Position = UDim2.new(0, 12, 0.5, -19)
    Icon.BackgroundColor3 = Theme.Element
    Icon.BorderSizePixel = 0
    Icon.Parent = Note
    MakeRound(Icon, 999)
    
    local ILbl = Instance.new("TextLabel")
    ILbl.Size = UDim2.new(1, 0, 1, 0)
    ILbl.BackgroundTransparency = 1
    ILbl.Text = "🌸"
    ILbl.TextSize = 18
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