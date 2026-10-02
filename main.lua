--[[ Femboy Hub v2.6 | Author: Femboy | PC + Mobile | Legit Aim ]]
if _G.FB_Loaded then return end
_G.FB_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Http = game:GetService("HttpService")
local WS = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Cam = WS.CurrentCamera

local IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled
local IS_PC = UIS.KeyboardEnabled and not UIS.TouchEnabled
local IS_TABLET = UIS.TouchEnabled and UIS.KeyboardEnabled

local WIN_W = IS_MOBILE and 440 or 620
local WIN_H = IS_MOBILE and 340 or 420

local function safe(fn, d)
    local ok, r = pcall(fn)
    if ok and r ~= nil then return r end
    return d
end
local gethuiS = safe(function() return gethui() end, nil)
local writef = safe(function() return writefile end, nil)
local readf = safe(function() return readfile end, nil)
local isf = safe(function() return isfile end, nil)
local setclip = safe(function() return setclipboard end, nil)
local Parent = gethuiS or CoreGui

for _, g in ipairs({Parent, CoreGui}) do
    if g and g:FindFirstChild("FemboyHub") then g.FemboyHub:Destroy() end
end
-- убрать старый блюр
local oldBlur = Lighting:FindFirstChild("FB_MenuBlur")
if oldBlur then oldBlur:Destroy() end

-- ================= FLAGS =================
local F = {
    ESP_Enabled=false, ESP_Role=true, ESP_Name=true, ESP_Box=true,
    ESP_Tracer=false, ESP_Distance=false, ESP_Chams=false, ESP_Transparency=30,
    -- Aim (legit)
    AIM_Enabled=false, AIM_Hold=true, AIM_Visible=true, AIM_WallCheck=true,
    AIM_TeamCheck=false, AIM_Smooth=15, AIM_FOV=120,
    AIM_HitPart="Head", AIM_ShowFOV=false, AIM_ShowTarget=false,
    AIM_Legit=true, AIM_MaxDistance=500,
    -- Movement
    MOVE_Walkspeed=16, MOVE_JumpPower=50, MOVE_Fly=false, MOVE_FlySpeed=60,
    MOVE_InfiniteJump=false, MOVE_NoClip=false, MOVE_Sprint=false,
    -- Visuals
    VIS_FullBright=false, VIS_NoFog=false, VIS_XRay=false, VIS_XRayStrength=70,
    VIS_Bloom=false, VIS_BloomIntensity=1, VIS_BlurWorld=false, VIS_BlurSize=10,
    VIS_SunRays=false, VIS_SunRaysIntensity=0.2, VIS_CC=false,
    VIS_Saturation=0.2, VIS_Contrast=0.1, VIS_Brightness=0,
    VIS_Trail=false, VIS_Headless=false,
    -- Farm
    FARM_AutoCoins=false, FARM_AutoDrops=false, FARM_AutoKill=false,
    -- Fun
    FUN_Fling=false, FUN_SpinBot=false, FUN_BunnyHop=false,
    -- Misc
    MISC_AntiAFK=true, MISC_ShowFPS=false, MISC_Discord="discord.gg/femboyhub",
    THEME_Name="Pink",
    BIND_Fly="F", BIND_Aimbot="C", BIND_ESP="V", BIND_UI="RightShift",
}

local Themes = {
    Pink   = {Acc=Color3.fromRGB(255,105,180), Acc2=Color3.fromRGB(180,130,255), Acc3=Color3.fromRGB(120,220,255)},
    Cyan   = {Acc=Color3.fromRGB(120,220,255), Acc2=Color3.fromRGB(105,180,255), Acc3=Color3.fromRGB(180,255,240)},
    Purple = {Acc=Color3.fromRGB(180,130,255), Acc2=Color3.fromRGB(220,120,255), Acc3=Color3.fromRGB(255,150,220)},
    Red    = {Acc=Color3.fromRGB(255,100,120), Acc2=Color3.fromRGB(255,150,100), Acc3=Color3.fromRGB(255,200,150)},
    Green  = {Acc=Color3.fromRGB(120,230,150), Acc2=Color3.fromRGB(120,220,255), Acc3=Color3.fromRGB(200,255,150)},
    Blue   = {Acc=Color3.fromRGB(120,150,255), Acc2=Color3.fromRGB(150,120,255), Acc3=Color3.fromRGB(120,220,255)},
}

local T = {
    Bg=Color3.fromRGB(20,18,26), Bg2=Color3.fromRGB(26,23,34), Bg3=Color3.fromRGB(38,34,48),
    El=Color3.fromRGB(52,46,68), Hover=Color3.fromRGB(68,60,86),
    Tx=Color3.fromRGB(242,238,252), TxD=Color3.fromRGB(160,150,182),
    Grn=Color3.fromRGB(120,230,150), Red=Color3.fromRGB(255,100,120),
    Stroke=Color3.fromRGB(80,70,104),
    F=Enum.Font.GothamMedium, FB=Enum.Font.GothamBold, FS=Enum.Font.GothamSemibold,
}
local function applyTheme(name)
    local t = Themes[name] or Themes.Pink
    T.Acc, T.Acc2, T.Acc3 = t.Acc, t.Acc2, t.Acc3
    F.THEME_Name = name
end
applyTheme(F.THEME_Name)

local function round(o,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=o return c end
local function stroke(o,c,t,tr) local s=Instance.new("UIStroke") s.Color=c or T.Stroke s.Thickness=t or 1 s.Transparency=tr or 0 s.Parent=o return s end
local function grad(o,a,b,rot) local g=Instance.new("UIGradient") g.Color=ColorSequence.new(a,b) g.Rotation=rot or 0 g.Parent=o return g end
local function tw(o,p,t) return Tween:Create(o,TweenInfo.new(t or 0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p) end

-- Notifications
local NotifHolder = nil
local function notify(title, desc, dur, color)
    dur = dur or 3; color = color or T.Acc
    if not NotifHolder or not NotifHolder.Parent then
        NotifHolder = Instance.new("Frame")
        NotifHolder.Name = "FB_Notif"
        NotifHolder.Size = UDim2.new(0, IS_MOBILE and 200 or 260, 1, -40)
        NotifHolder.Position = UDim2.new(1, IS_MOBILE and -210 or -280, 0, 20)
        NotifHolder.BackgroundTransparency = 1
        NotifHolder.ZIndex = 500
        NotifHolder.Parent = Parent
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0, 8)
        l.VerticalAlignment = Enum.VerticalAlignment.Top
        l.Parent = NotifHolder
    end
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 52)
    n.Position = UDim2.new(1, 60, 0, 0)
    n.BackgroundColor3 = T.Bg2
    n.BackgroundTransparency = 0.15
    n.BorderSizePixel = 0
    n.ZIndex = 501
    n.Parent = NotifHolder
    round(n, 10); stroke(n, color, 1, 0.35)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, -12)
    bar.Position = UDim2.new(0, 3, 0, 6)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.ZIndex = 502
    bar.Parent = n
    round(bar, 999)
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -20, 0, 18)
    tl.Position = UDim2.new(0, 14, 0, 8)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = T.Tx
    tl.Font = T.FB
    tl.TextSize = 12
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.ZIndex = 502
    tl.Parent = n
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, -20, 0, 16)
    dl.Position = UDim2.new(0, 14, 0, 26)
    dl.BackgroundTransparency = 1
    dl.Text = desc
    dl.TextColor3 = T.TxD
    dl.Font = T.F
    dl.TextSize = 10
    dl.TextXAlignment = Enum.TextXAlignment.Left
    dl.ZIndex = 502
    dl.Parent = n
    tw(n, {Position = UDim2.new(0, 0, 0, 0)}, 0.3):Play()
    task.delay(dur, function()
        if not n or not n.Parent then return end
        local out = tw(n, {Position = UDim2.new(1, 60, 0, 0)}, 0.25)
        out:Play()
        out.Completed:Wait()
        if n then n:Destroy() end
    end)
end

-- ================= GUI =================
local Gui = Instance.new("ScreenGui")
Gui.Name = "FemboyHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = Parent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, WIN_W, 0, WIN_H)
Main.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
Main.BackgroundColor3 = T.Bg
Main.BackgroundTransparency = 0.25
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.ZIndex = 10
Main.Parent = Gui
round(Main, 14)
stroke(Main, T.Acc, 1.4, 0.35)
grad(Main, Color3.fromRGB(32,28,42), Color3.fromRGB(16,14,24), 135)

if IS_MOBILE then
    Main.Position = UDim2.new(0.5, -WIN_W/2, 0.15, 0)
end

local TopShine = Instance.new("Frame")
TopShine.Size = UDim2.new(1, 0, 0, 60)
TopShine.BackgroundColor3 = Color3.new(1,1,1)
TopShine.BackgroundTransparency = 0.94
TopShine.BorderSizePixel = 0
TopShine.ZIndex = 11
TopShine.Parent = Main
round(TopShine, 14)
local TSG = Instance.new("UIGradient")
TSG.Rotation = 90
TSG.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.75),NumberSequenceKeypoint.new(1,1)})
TSG.Parent = TopShine

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 2)
TopBar.BackgroundColor3 = T.Acc
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 12
TopBar.Parent = Main
local TBG = Instance.new("UIGradient")
TBG.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,T.Acc),ColorSequenceKeypoint.new(0.5,T.Acc2),ColorSequenceKeypoint.new(1,T.Acc3)})
TBG.Parent = TopBar

local TB = Instance.new("Frame")
TB.Size = UDim2.new(1, 0, 0, 40)
TB.BackgroundTransparency = 1
TB.ZIndex = 13
TB.Parent = Main

local CB = Instance.new("TextButton")
CB.Size = UDim2.new(0, 24, 0, 24)
CB.Position = UDim2.new(1, -32, 0, 8)
CB.BackgroundColor3 = T.El
CB.BackgroundTransparency = 0.4
CB.Text = "X"
CB.TextColor3 = T.Tx
CB.Font = T.FB
CB.TextSize = 12
CB.AutoButtonColor = false
CB.ZIndex = 14
CB.Parent = TB
round(CB, 999); stroke(CB, T.Stroke, 1, 0.4)
CB.MouseEnter:Connect(function() tw(CB,{BackgroundColor3=T.Red,BackgroundTransparency=0},0.15):Play() end)
CB.MouseLeave:Connect(function() tw(CB,{BackgroundColor3=T.El,BackgroundTransparency=0.4},0.15):Play() end)

local MB = Instance.new("TextButton")
MB.Size = UDim2.new(0, 24, 0, 24)
MB.Position = UDim2.new(1, -60, 0, 8)
MB.BackgroundColor3 = T.El
MB.BackgroundTransparency = 0.4
MB.Text = "-"
MB.TextColor3 = T.Tx
MB.Font = T.FB
MB.TextSize = 13
MB.AutoButtonColor = false
MB.ZIndex = 14
MB.Parent = TB
round(MB, 999); stroke(MB, T.Stroke, 1, 0.4)

local HI = Instance.new("Frame")
HI.Size = UDim2.new(0, 26, 0, 26)
HI.Position = UDim2.new(0, 14, 0, 7)
HI.BackgroundColor3 = T.Acc
HI.BorderSizePixel = 0
HI.ZIndex = 14
HI.Parent = TB
round(HI, 9); grad(HI, T.Acc, T.Acc2, 45)

local HIL = Instance.new("TextLabel")
HIL.Size = UDim2.new(1, 0, 1, 0)
HIL.BackgroundTransparency = 1
HIL.Text = "F"
HIL.TextColor3 = Color3.new(1,1,1)
HIL.Font = T.FB
HIL.TextSize = 13
HIL.ZIndex = 15
HIL.Parent = HI

local TT = Instance.new("TextLabel")
TT.Size = UDim2.new(0, 200, 1, 0)
TT.Position = UDim2.new(0, 48, 0, 0)
TT.BackgroundTransparency = 1
TT.Text = "Femboy Hub"
TT.TextColor3 = T.Tx
TT.Font = T.FB
TT.TextSize = 14
TT.TextXAlignment = Enum.TextXAlignment.Left
TT.ZIndex = 14
TT.Parent = TB

local VT = Instance.new("TextLabel")
VT.Size = UDim2.new(0, 60, 1, 0)
VT.Position = UDim2.new(0, 128, 0, 0)
VT.BackgroundTransparency = 1
VT.Text = "v2.6"
VT.TextColor3 = T.Acc
VT.Font = T.FS
VT.TextSize = 10
VT.TextXAlignment = Enum.TextXAlignment.Left
VT.ZIndex = 14
VT.Parent = TB

-- Sidebar
local Sb = Instance.new("Frame")
Sb.Size = UDim2.new(0, 140, 1, -40)
Sb.Position = UDim2.new(0, 0, 0, 40)
Sb.BackgroundColor3 = T.Bg2
Sb.BackgroundTransparency = 0.55
Sb.BorderSizePixel = 0
Sb.ZIndex = 13
Sb.Parent = Main

local SbLine = Instance.new("Frame")
SbLine.Size = UDim2.new(0, 1, 1, -16)
SbLine.Position = UDim2.new(1, -1, 0, 8)
SbLine.BackgroundColor3 = T.Stroke
SbLine.BackgroundTransparency = 0.5
SbLine.BorderSizePixel = 0
SbLine.ZIndex = 14
SbLine.Parent = Sb

local SbSc = Instance.new("ScrollingFrame")
SbSc.Size = UDim2.new(1, -6, 1, -46)
SbSc.Position = UDim2.new(0, 3, 0, 6)
SbSc.BackgroundTransparency = 1
SbSc.BorderSizePixel = 0
SbSc.ScrollBarThickness = 2
SbSc.ScrollBarImageColor3 = T.Acc
SbSc.CanvasSize = UDim2.new(0, 0, 0, 0)
SbSc.AutomaticCanvasSize = Enum.AutomaticSize.Y
SbSc.ZIndex = 14
SbSc.Parent = Sb

local SbL = Instance.new("UIListLayout")
SbL.Padding = UDim.new(0, 3)
SbL.SortOrder = Enum.SortOrder.LayoutOrder
SbL.Parent = SbSc

local SbP = Instance.new("UIPadding")
SbP.PaddingLeft = UDim.new(0, 6)
SbP.PaddingRight = UDim.new(0, 6)
SbP.PaddingTop = UDim.new(0, 2)
SbP.PaddingBottom = UDim.new(0, 8)
SbP.Parent = SbSc

local Sbf = Instance.new("TextButton")
Sbf.Size = UDim2.new(1, -12, 0, 24)
Sbf.Position = UDim2.new(0, 6, 1, -30)
Sbf.BackgroundColor3 = T.El
Sbf.BackgroundTransparency = 0.5
Sbf.Text = F.MISC_Discord
Sbf.TextColor3 = T.TxD
Sbf.Font = T.F
Sbf.TextSize = 9
Sbf.AutoButtonColor = false
Sbf.BorderSizePixel = 0
Sbf.ZIndex = 15
Sbf.Parent = Sb
round(Sbf, 8); stroke(Sbf, T.Stroke, 1, 0.5)
if setclip then
    Sbf.MouseButton1Click:Connect(function()
        setclip(F.MISC_Discord)
        notify("Discord", "Скопировано", 2, T.Acc2)
    end)
end

-- Content
local Ct = Instance.new("Frame")
Ct.Size = UDim2.new(1, -140, 1, -40)
Ct.Position = UDim2.new(0, 140, 0, 40)
Ct.BackgroundTransparency = 1
Ct.ZIndex = 13
Ct.Parent = Main

local TTabs = Instance.new("ScrollingFrame")
TTabs.Size = UDim2.new(1, -20, 0, 30)
TTabs.Position = UDim2.new(0, 10, 0, 8)
TTabs.BackgroundTransparency = 1
TTabs.BorderSizePixel = 0
TTabs.ScrollBarThickness = 2
TTabs.ScrollBarImageColor3 = T.Acc
TTabs.CanvasSize = UDim2.new(0, 0, 0, 0)
TTabs.AutomaticCanvasSize = Enum.AutomaticSize.X
TTabs.ScrollingDirection = Enum.ScrollingDirection.X
TTabs.ZIndex = 14
TTabs.Parent = Ct

local TTL = Instance.new("UIListLayout")
TTL.FillDirection = Enum.FillDirection.Horizontal
TTL.Padding = UDim.new(0, 5)
TTL.SortOrder = Enum.SortOrder.LayoutOrder
TTL.Parent = TTabs

local TTPad = Instance.new("UIPadding")
TTPad.PaddingRight = UDim.new(0, 10)
TTPad.Parent = TTabs

TTabs.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local np = TTabs.CanvasPosition.X - (input.Position.Z * 40)
        local mx = math.max(0, TTabs.AbsoluteCanvasSize.X - TTabs.AbsoluteSize.X)
        TTabs.CanvasPosition = Vector2.new(math.clamp(np, 0, mx), 0)
    end
end)

local PH = Instance.new("Frame")
PH.Size = UDim2.new(1, -20, 1, -46)
PH.Position = UDim2.new(0, 10, 0, 42)
PH.BackgroundTransparency = 1
PH.ClipsDescendants = true
PH.ZIndex = 14
PH.Parent = Ct

local Pages, Tabs, SbItems = {}, {}, {}
local ActivePage, ActiveTab

local function mkPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = "P_"..name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = T.Acc
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = false
    p.ZIndex = 15
    p.Parent = PH
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = p
    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 2)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = p
    Pages[name] = p
    return p
end

local function mkSection(parent, text)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 20)
    h.BackgroundTransparency = 1
    h.Parent = parent
    local ln = Instance.new("Frame")
    ln.Size = UDim2.new(0, 3, 0, 12)
    ln.Position = UDim2.new(0, 0, 0.5, -6)
    ln.BackgroundColor3 = T.Acc
    ln.BorderSizePixel = 0
    ln.Parent = h
    round(ln, 999)
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -14, 1, 0)
    lb.Position = UDim2.new(0, 12, 0, 0)
    lb.BackgroundTransparency = 1
    lb.Text = text
    lb.TextColor3 = T.Tx
    lb.Font = T.FB
    lb.TextSize = 11
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = h
    return h
end

local function mkDiv(parent)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1, 0, 0, 1)
    d.BackgroundColor3 = T.Stroke
    d.BackgroundTransparency = 0.4
    d.BorderSizePixel = 0
    d.Parent = parent
    return d
end

local function mkToggle(parent, name, flag, cb)
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1, 0, 0, 34)
    R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.55
    R.BorderSizePixel = 0
    R.Parent = parent
    round(R, 8); stroke(R, T.Stroke, 1, 0.55)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = T.Tx
    L.Font = T.F
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex + 2
    L.Parent = R
    local Sw = Instance.new("Frame")
    Sw.Size = UDim2.new(0, 32, 0, 17)
    Sw.Position = UDim2.new(1, -42, 0.5, -8.5)
    Sw.BackgroundColor3 = T.Bg3
    Sw.BorderSizePixel = 0
    Sw.ZIndex = R.ZIndex + 2
    Sw.Parent = R
    round(Sw, 999); stroke(Sw, T.Stroke, 1, 0.5)
    local Kn = Instance.new("Frame")
    Kn.Size = UDim2.new(0, 12, 0, 12)
    Kn.Position = UDim2.new(0, 3, 0.5, -6)
    Kn.BackgroundColor3 = T.TxD
    Kn.BorderSizePixel = 0
    Kn.ZIndex = R.ZIndex + 3
    Kn.Parent = Sw
    round(Kn, 999)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 1, 0)
    B.BackgroundTransparency = 1
    B.Text = ""
    B.ZIndex = R.ZIndex + 4
    B.Parent = R
    local function up(anim)
        local on = F[flag]
        if anim then
            tw(Sw, {BackgroundColor3 = on and T.Acc or T.Bg3}, 0.2):Play()
            tw(Kn, {Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                BackgroundColor3 = on and T.Tx or T.TxD}, 0.2):Play()
        else
            Sw.BackgroundColor3 = on and T.Acc or T.Bg3
            Kn.Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            Kn.BackgroundColor3 = on and T.Tx or T.TxD
        end
        if cb then cb(on) end
    end
    B.MouseButton1Click:Connect(function() F[flag] = not F[flag] up(true) end)
    up(false)
    return R
end

local function mkSlider(parent, name, flag, min, max, suffix, cb)
    suffix = suffix or ""
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1, 0, 0, 42)
    R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.55
    R.BorderSizePixel = 0
    R.Parent = parent
    round(R, 8); stroke(R, T.Stroke, 1, 0.55)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -80, 0, 18)
    L.Position = UDim2.new(0, 12, 0, 3)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = T.Tx
    L.Font = T.F
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex + 2
    L.Parent = R
    local V = Instance.new("TextLabel")
    V.Size = UDim2.new(0, 70, 0, 18)
    V.Position = UDim2.new(1, -78, 0, 3)
    V.BackgroundTransparency = 1
    V.Text = tostring(F[flag]) .. suffix
    V.TextColor3 = T.Acc
    V.Font = T.FS
    V.TextSize = 11
    V.TextXAlignment = Enum.TextXAlignment.Right
    V.ZIndex = R.ZIndex + 2
    V.Parent = R
    local BB = Instance.new("Frame")
    BB.Size = UDim2.new(1, -24, 0, 7)
    BB.Position = UDim2.new(0, 12, 0, 28)
    BB.BackgroundColor3 = T.Bg3
    BB.BorderSizePixel = 0
    BB.ZIndex = R.ZIndex + 2
    BB.Parent = R
    round(BB, 999)
    local Fi = Instance.new("Frame")
    Fi.Size = UDim2.new((F[flag] - min)/(max - min), 0, 1, 0)
    Fi.BackgroundColor3 = T.Acc
    Fi.BorderSizePixel = 0
    Fi.ZIndex = R.ZIndex + 3
    Fi.Parent = BB
    round(Fi, 999); grad(Fi, T.Acc, T.Acc2, 0)
    local drag = false
    local function upi(input)
        local pos = math.clamp((input.Position.X - BB.AbsolutePosition.X)/BB.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos + 0.5)
        F[flag] = val
        V.Text = tostring(val)..suffix
        Fi.Size = UDim2.new(pos, 0, 1, 0)
        if cb then cb(val) end
    end
    BB.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true upi(i)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upi(i) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    return R
end

local function mkButton(parent, name, cb)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundColor3 = T.El
    B.BackgroundTransparency = 0.55
    B.Text = ""
    B.AutoButtonColor = false
    B.Parent = parent
    round(B, 8); stroke(B, T.Stroke, 1, 0.55)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -20, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = T.Tx
    L.Font = T.F
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = B.ZIndex + 2
    L.Parent = B
    B.MouseEnter:Connect(function() tw(B, {BackgroundColor3 = T.Hover, BackgroundTransparency = 0.35}, 0.15):Play() end)
    B.MouseLeave:Connect(function() tw(B, {BackgroundColor3 = T.El, BackgroundTransparency = 0.55}, 0.15):Play() end)
    B.MouseButton1Click:Connect(cb)
    return B
end

local function mkDropdown(parent, name, flag, options, cb)
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1, 0, 0, 34)
    R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.55
    R.BorderSizePixel = 0
    R.ClipsDescendants = true
    R.Parent = parent
    round(R, 8); stroke(R, T.Stroke, 1, 0.55)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -110, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = T.Tx
    L.Font = T.F
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex + 2
    L.Parent = R
    local Cur = Instance.new("TextLabel")
    Cur.Size = UDim2.new(0, 90, 1, 0)
    Cur.Position = UDim2.new(1, -110, 0, 0)
    Cur.BackgroundTransparency = 1
    Cur.Text = F[flag] or options[1]
    Cur.TextColor3 = T.TxD
    Cur.Font = T.F
    Cur.TextSize = 11
    Cur.TextXAlignment = Enum.TextXAlignment.Right
    Cur.ZIndex = R.ZIndex + 2
    Cur.Parent = R
    local Ar = Instance.new("TextLabel")
    Ar.Size = UDim2.new(0, 20, 1, 0)
    Ar.Position = UDim2.new(1, -22, 0, 0)
    Ar.BackgroundTransparency = 1
    Ar.Text = "v"
    Ar.TextColor3 = T.TxD
    Ar.Font = T.FB
    Ar.TextSize = 11
    Ar.ZIndex = R.ZIndex + 2
    Ar.Parent = R
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 34)
    B.BackgroundTransparency = 1
    B.Text = ""
    B.ZIndex = R.ZIndex + 3
    B.Parent = R
    local opened = false
    local expSize = 34 + #options * 26
    B.MouseButton1Click:Connect(function()
        opened = not opened
        tw(R, {Size = opened and UDim2.new(1, 0, 0, expSize) or UDim2.new(1, 0, 0, 34)}, 0.25):Play()
    end)
    local Opts = Instance.new("Frame")
    Opts.Size = UDim2.new(1, -20, 0, #options * 26)
    Opts.Position = UDim2.new(0, 10, 0, 34)
    Opts.BackgroundTransparency = 1
    Opts.ZIndex = R.ZIndex + 2
    Opts.Parent = R
    local OL = Instance.new("UIListLayout")
    OL.Padding = UDim.new(0, 2)
    OL.SortOrder = Enum.SortOrder.LayoutOrder
    OL.Parent = Opts
    for _, opt in ipairs(options) do
        local OB = Instance.new("TextButton")
        OB.Size = UDim2.new(1, 0, 0, 24)
        OB.BackgroundColor3 = T.Bg3
        OB.BackgroundTransparency = 0.5
        OB.Text = ""
        OB.AutoButtonColor = false
        OB.ZIndex = R.ZIndex + 3
        OB.Parent = Opts
        round(OB, 6)
        local OLb = Instance.new("TextLabel")
        OLb.Size = UDim2.new(1, -16, 1, 0)
        OLb.Position = UDim2.new(0, 10, 0, 0)
        OLb.BackgroundTransparency = 1
        OLb.Text = opt
        OLb.TextColor3 = T.Tx
        OLb.Font = T.F
        OLb.TextSize = 11
        OLb.TextXAlignment = Enum.TextXAlignment.Left
        OLb.ZIndex = R.ZIndex + 4
        OLb.Parent = OB
        OB.MouseButton1Click:Connect(function()
            F[flag] = opt
            Cur.Text = opt
            opened = false
            tw(R, {Size = UDim2.new(1, 0, 0, 34)}, 0.25):Play()
            if cb then cb(opt) end
        end)
        OB.MouseEnter:Connect(function() OB.BackgroundColor3 = T.Hover end)
        OB.MouseLeave:Connect(function() OB.BackgroundColor3 = T.Bg3 end)
    end
    return R
end

local function mkTextbox(parent, name, flag, cb)
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1, 0, 0, 34)
    R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.55
    R.BorderSizePixel = 0
    R.Parent = parent
    round(R, 8); stroke(R, T.Stroke, 1, 0.55)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -150, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = T.Tx
    L.Font = T.F
    L.TextSize = 12
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex + 2
    L.Parent = R
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 130, 0, 24)
    Box.Position = UDim2.new(1, -140, 0.5, -12)
    Box.BackgroundColor3 = T.Bg3
    Box.Text = tostring(F[flag])
    Box.TextColor3 = T.Tx
    Box.Font = T.F
    Box.TextSize = 11
    Box.BorderSizePixel = 0
    Box.ClearTextOnFocus = false
    Box.ZIndex = R.ZIndex + 2
    Box.Parent = R
    round(Box, 6); stroke(Box, T.Stroke, 1, 0.5)
    Box.FocusLost:Connect(function()
        F[flag] = tonumber(Box.Text) or Box.Text
        if cb then cb(F[flag]) end
    end)
    return R
end

local function showPage(name)
    for pn, p in pairs(Pages) do p.Visible = (pn == name) end
    ActivePage = name
end

local function mkTopTab(name, pageName)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, IS_MOBILE and 70 or 82, 0, 26)
    B.BackgroundColor3 = T.El
    B.BackgroundTransparency = 0.55
    B.Text = ""
    B.AutoButtonColor = false
    B.Parent = TTabs
    round(B, 999); stroke(B, T.Stroke, 1, 0.6)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 1, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = T.TxD
    L.Font = T.FS
    L.TextSize = 10
    L.ZIndex = B.ZIndex + 2
    L.Parent = B
    local Un = Instance.new("Frame")
    Un.Size = UDim2.new(0, 0, 0, 2)
    Un.Position = UDim2.new(0.5, 0, 1, -3)
    Un.BackgroundColor3 = T.Acc
    Un.BorderSizePixel = 0
    Un.ZIndex = B.ZIndex + 3
    Un.Parent = B
    round(Un, 999); grad(Un, T.Acc, T.Acc2, 0)
    local function act()
        for _, d in pairs(Tabs) do
            tw(d.label, {TextColor3 = T.TxD}, 0.2):Play()
            tw(d.ul, {Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0.5, 0, 1, -3)}, 0.2):Play()
            tw(d.btn, {BackgroundTransparency = 0.55}, 0.2):Play()
        end
        tw(L, {TextColor3 = T.Tx}, 0.2):Play()
        tw(Un, {Size = UDim2.new(0.7, 0, 0, 2), Position = UDim2.new(0.15, 0, 1, -3)}, 0.25):Play()
        tw(B, {BackgroundTransparency = 0.3}, 0.2):Play()
        showPage(pageName)
        ActiveTab = name
    end
    Tabs[name] = {btn = B, label = L, ul = Un, activate = act, page = pageName}
    B.MouseButton1Click:Connect(act)
    return B
end

local function mkSbItem(name, topTab)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 26)
    B.BackgroundColor3 = T.El
    B.BackgroundTransparency = 1
    B.Text = ""
    B.AutoButtonColor = false
    B.ZIndex = 15
    B.Parent = SbSc
    round(B, 6)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -14, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = T.TxD
    L.Font = T.FS
    L.TextSize = 11
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = 16
    L.Parent = B
    B.MouseEnter:Connect(function()
        if ActivePage ~= name then
            tw(B, {BackgroundTransparency = 0.6}, 0.15):Play()
            tw(L, {TextColor3 = T.Tx}, 0.15):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if ActivePage ~= name then
            tw(B, {BackgroundTransparency = 1}, 0.15):Play()
            tw(L, {TextColor3 = T.TxD}, 0.15):Play()
        end
    end)
    B.MouseButton1Click:Connect(function()
        for _, d in pairs(SbItems) do
            tw(d.btn, {BackgroundTransparency = 1}, 0.2):Play()
            tw(d.lbl, {TextColor3 = T.TxD}, 0.2):Play()
        end
        tw(B, {BackgroundTransparency = 0.4}, 0.2):Play()
        tw(L, {TextColor3 = T.Tx}, 0.2):Play()
        if topTab and Tabs[topTab] then Tabs[topTab].activate() end
    end)
    table.insert(SbItems, {btn = B, lbl = L, name = name})
    return B
end

-- Build pages
mkSbItem("Main", "ESP")
mkSbItem("Aimbot", "Aim")
mkSbItem("Movement", "Movement")
mkSbItem("Visuals", "Visuals")
mkSbItem("Farm", "Farm")
mkSbItem("Fun/Troll", "Fun")
mkSbItem("Themes", "Themes")
mkSbItem("Settings", "Settings")
mkSbItem("Info", "Info")

for _, n in ipairs({"ESP", "Aim", "Movement", "Visuals", "Farm", "Fun", "Themes", "Settings", "Info"}) do
    mkPage(n)
end

mkTopTab("ESP", "ESP")
mkTopTab("Aim", "Aim")
mkTopTab("Move", "Movement")
mkTopTab("Visuals", "Visuals")
mkTopTab("Farm", "Farm")
mkTopTab("Fun", "Fun")
mkTopTab("Theme", "Themes")
mkTopTab("Settings", "Settings")
mkTopTab("Info", "Info")

-- ESP
local p = Pages.ESP
mkSection(p, "ESP")
mkToggle(p, "Enable ESP", "ESP_Enabled")
mkToggle(p, "Role Colors", "ESP_Role")
mkToggle(p, "Names", "ESP_Name")
mkToggle(p, "Boxes", "ESP_Box")
mkToggle(p, "Tracers", "ESP_Tracer")
mkToggle(p, "Distance", "ESP_Distance")
mkToggle(p, "Chams", "ESP_Chams")
mkDiv(p)
mkSlider(p, "Transparency", "ESP_Transparency", 0, 100, "%")

-- AIMBOT (отдельная вкладка, легит)
p = Pages.Aim
mkSection(p, "Aimbot (Legit)")
mkToggle(p, "Enable Aimbot", "AIM_Enabled")
mkToggle(p, "Legit Mode (плавно)", "AIM_Legit")
mkToggle(p, "Hold Key to Aim", "AIM_Hold")
mkToggle(p, "Visible Check", "AIM_Visible")
mkToggle(p, "Wall Check", "AIM_WallCheck")
mkToggle(p, "Team Check", "AIM_TeamCheck")
mkDiv(p)
mkSection(p, "Target")
mkDropdown(p, "Hit Part", "AIM_HitPart", {"Head", "HumanoidRootPart", "UpperTorso", "Torso"})
mkSlider(p, "Max Distance", "AIM_MaxDistance", 50, 1000, "m")
mkDiv(p)
mkSection(p, "Sensitivity")
mkSlider(p, "Smooth (ниже = быстрее)", "AIM_Smooth", 1, 100, "%")
mkSlider(p, "FOV", "AIM_FOV", 30, 500, "px")
mkDiv(p)
mkSection(p, "Visuals")
mkToggle(p, "Show FOV Circle", "AIM_ShowFOV")
mkToggle(p, "Show Target Marker", "AIM_ShowTarget")

-- MOVEMENT
p = Pages.Movement
mkSection(p, "Movement")
mkSlider(p, "Walkspeed", "MOVE_Walkspeed", 16, 200, "", function(v)
    local c = LP.Character
    if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = v end
end)
mkSlider(p, "JumpPower", "MOVE_JumpPower", 50, 300, "", function(v)
    local c = LP.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.JumpPower = v
        c.Humanoid.UseJumpPower = true
    end
end)
mkToggle(p, "Fly", "MOVE_Fly")
mkSlider(p, "Fly Speed", "MOVE_FlySpeed", 20, 300, "")
mkToggle(p, "Infinite Jump", "MOVE_InfiniteJump")
mkToggle(p, "NoClip", "MOVE_NoClip")
mkToggle(p, "Sprint (Shift)", "MOVE_Sprint")
if IS_MOBILE or IS_TABLET then
    mkButton(p, "Fly Up (tap)", function()
        local c = LP.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = Vector3.new(0,60,0)
            bv.Parent = c.HumanoidRootPart
            task.delay(0.6, function() bv:Destroy() end)
        end
    end)
    mkButton(p, "Fly Down (tap)", function()
        local c = LP.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = Vector3.new(0,-60,0)
            bv.Parent = c.HumanoidRootPart
            task.delay(0.6, function() bv:Destroy() end)
        end
    end)
end
mkDiv(p)
mkButton(p, "Reset Character", function()
    local c = LP.Character
    if c then c:BreakJoints() end
end)

-- VISUALS
p = Pages.Visuals
mkSection(p, "World")
mkToggle(p, "FullBright", "VIS_FullBright")
mkToggle(p, "No Fog", "VIS_NoFog")
mkToggle(p, "X-Ray", "VIS_XRay")
mkSlider(p, "X-Ray Strength", "VIS_XRayStrength", 0, 100, "%")
mkDiv(p)
mkSection(p, "Post Processing")
mkToggle(p, "Bloom", "VIS_Bloom")
mkSlider(p, "Bloom Intensity", "VIS_BloomIntensity", 0, 5, "")
mkToggle(p, "Blur World", "VIS_BlurWorld")
mkSlider(p, "Blur Size", "VIS_BlurSize", 0, 56, "")
mkToggle(p, "Sun Rays", "VIS_SunRays")
mkToggle(p, "Color Correction", "VIS_CC")
mkSlider(p, "Saturation", "VIS_Saturation", -1, 1, "")
mkSlider(p, "Contrast", "VIS_Contrast", -1, 1, "")
mkSlider(p, "Brightness", "VIS_Brightness", -1, 1, "")
mkDiv(p)
mkSection(p, "Effects")
mkToggle(p, "Particle Trail", "VIS_Trail")
mkToggle(p, "Headless", "VIS_Headless")
mkDiv(p)
mkButton(p, "Reset Lighting", function()
    Lighting.Ambient = Color3.fromRGB(70,70,70)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
    for _, n in ipairs({"FB_Bloom","FB_Blur","FB_SunRays","FB_CC"}) do
        local e = Lighting:FindFirstChild(n)
        if e then e:Destroy() end
    end
end)

-- FARM
p = Pages.Farm
mkSection(p, "Auto Farm")
mkToggle(p, "Auto Collect Coins", "FARM_AutoCoins")
mkToggle(p, "Auto Pickup Drops", "FARM_AutoDrops")
mkToggle(p, "Auto Kill (if murderer)", "FARM_AutoKill")
mkDiv(p)
mkButton(p, "TP to Drop", function()
    for _, o in ipairs(WS:GetDescendants()) do
        if o:IsA("BasePart") and (o.Name == "GunDrop" or o.Name == "KnifeDrop" or o.Name == "Drop") then
            local c = LP.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame = o.CFrame + Vector3.new(0, 2, 0)
            end
            break
        end
    end
end)

-- FUN
p = Pages.Fun
mkSection(p, "Troll")
mkToggle(p, "Fling All (близкие)", "FUN_Fling")
mkToggle(p, "Spin Bot", "FUN_SpinBot")
mkToggle(p, "Bunny Hop", "FUN_BunnyHop")
mkDiv(p)
mkSection(p, "Kill")
mkButton(p, "Kill All (if murderer)", function()
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hasKnife = c:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
    if not hasKnife then
        notify("Kill All", "Ты не убийца", 2, T.Red)
        return
    end
    if not c:FindFirstChild("Knife") then
        local k = LP.Backpack:FindFirstChild("Knife")
        if k then k.Parent = c end
    end
    task.spawn(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local thp = plr.Character:FindFirstChild("HumanoidRootPart")
                local thum = plr.Character:FindFirstChild("Humanoid")
                if thp and thum and thum.Health > 0 then
                    for _ = 1, 4 do
                        pcall(function() c.HumanoidRootPart.CFrame = thp.CFrame end)
                        task.wait(0.03)
                    end
                end
            end
        end
        notify("Kill All", "Готово", 2, T.Grn)
    end)
end)

-- THEMES
p = Pages.Themes
mkSection(p, "Theme")
mkDropdown(p, "UI Theme", "THEME_Name", {"Pink","Cyan","Purple","Red","Green","Blue"}, function(v)
    applyTheme(v)
    notify("Theme", "Применено: "..v, 2, T.Acc)
    if ActiveTab and Tabs[ActiveTab] then Tabs[ActiveTab].activate() end
    for _, s in ipairs(Main:GetChildren()) do
        if s:IsA("UIStroke") then s.Color = T.Acc end
    end
    TBG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Acc),
        ColorSequenceKeypoint.new(0.5, T.Acc2),
        ColorSequenceKeypoint.new(1, T.Acc3),
    })
    grad(HI, T.Acc, T.Acc2, 45)
    VT.TextColor3 = T.Acc
end)
mkDiv(p)
mkSection(p, "Keybinds (PC)")
mkTextbox(p, "Bind: Fly", "BIND_Fly")
mkTextbox(p, "Bind: Aimbot", "BIND_Aimbot")
mkTextbox(p, "Bind: ESP", "BIND_ESP")
mkTextbox(p, "Bind: Show/Hide UI", "BIND_UI")

-- SETTINGS
p = Pages.Settings
mkSection(p, "General")
mkToggle(p, "Anti-AFK", "MISC_AntiAFK")
mkToggle(p, "Show FPS", "MISC_ShowFPS")
mkDiv(p)
mkSection(p, "Config")
mkTextbox(p, "Discord", "MISC_Discord")
mkButton(p, "Save Config", function()
    if writef then
        writef("fb_config.json", Http:JSONEncode(F))
        notify("Config", "Сохранено", 2, T.Grn)
    else
        notify("Config", "writefile недоступен", 2, T.Red)
    end
end)
mkButton(p, "Load Config", function()
    if readf and isf and isf("fb_config.json") then
        local d = Http:JSONDecode(readf("fb_config.json"))
        for k, v in pairs(d) do F[k] = v end
        notify("Config", "Загружено", 2, T.Grn)
    else
        notify("Config", "Файл не найден", 2, T.Red)
    end
end)
mkDiv(p)
mkButton(p, "Destroy UI", function()
    Gui:Destroy()
    _G.FB_Loaded = false
end)

-- INFO
p = Pages.Info
mkSection(p, "Info")
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 120)
infoLabel.BackgroundColor3 = T.El
infoLabel.BackgroundTransparency = 0.55
infoLabel.TextColor3 = T.Tx
infoLabel.Font = T.F
infoLabel.TextSize = 11
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextWrapped = true
infoLabel.Text = "Нажми Refresh Info"
infoLabel.Parent = p
round(infoLabel, 8); stroke(infoLabel, T.Stroke, 1, 0.55)
local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingTop = UDim.new(0, 8)
pad.Parent = infoLabel

mkSection(p, "Authors")
local cr = Instance.new("TextLabel")
cr.Size = UDim2.new(1, 0, 0, 90)
cr.BackgroundColor3 = T.El
cr.BackgroundTransparency = 0.55
cr.TextColor3 = T.Tx
cr.Font = T.F
cr.TextSize = 12
cr.TextXAlignment = Enum.TextXAlignment.Left
cr.TextYAlignment = Enum.TextYAlignment.Top
cr.TextWrapped = true
cr.Text = "Author: Femboy\nStyle: Glossy Modern v2.6\nPlatform: "..(IS_MOBILE and "Mobile" or "PC").."\nDiscord: "..F.MISC_Discord
cr.Parent = p
round(cr, 8); stroke(cr, T.Acc, 1, 0.4)
local crp = Instance.new("UIPadding")
crp.PaddingLeft = UDim.new(0, 12)
crp.PaddingTop = UDim.new(0, 8)
crp.Parent = cr

mkButton(p, "Refresh Info", function()
    local fps = 60
    pcall(function()
        local t0 = tick()
        RunService.RenderStepped:Wait()
        fps = math.floor(1/(tick()-t0))
    end)
    local mem = "N/A"
    pcall(function() mem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb()).." MB" end)
    local ping = "N/A"
    pcall(function()
        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).." ms"
    end)
    infoLabel.Text = "Player: "..LP.Name..
        "\nUserID: "..LP.UserId..
        "\nGame: "..game.PlaceId..
        "\nFPS: "..fps..
        "\nPing: "..ping..
        "\nMemory: "..mem..
        "\nPlayers: "..#Players:GetPlayers().."/"..Players.MaxPlayers
end)

Tabs.ESP.activate()

-- ================= MOBILE FAB =================
local FAB
if IS_MOBILE or IS_TABLET then
    FAB = Instance.new("TextButton")
    FAB.Name = "FB_FAB"
    FAB.Size = UDim2.new(0, 48, 0, 48)
    FAB.Position = UDim2.new(0, 16, 0.4, 0)
    FAB.BackgroundColor3 = T.Acc
    FAB.Text = "🌸"
    FAB.TextSize = 22
    FAB.Font = Enum.Font.GothamBold
    FAB.AutoButtonColor = false
    FAB.Active = true
    FAB.Draggable = true
    FAB.ZIndex = 1000
    FAB.Parent = Gui
    round(FAB, 999)
    stroke(FAB, T.Acc2, 2, 0.2)
    grad(FAB, T.Acc, T.Acc2, 45)

    local menuOpen = false
    FAB.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        if menuOpen then
            Main.Visible = true
            Main.Size = UDim2.new(0, 0, 0, 0)
            Main.Position = UDim2.new(0.5, 0, 0.5, 0)
            tw(Main, {
                Size = UDim2.new(0, WIN_W, 0, WIN_H),
                Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
            }, 0.35):Play()
            FAB.Text = "X"
        else
            tw(Main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.25):Play()
            task.wait(0.3)
            Main.Visible = false
            FAB.Text = "🌸"
        end
    end)
end

-- ================= LOGIC =================

-- ESP
local espCache = {}
local function getRole(plr)
    if plr == LP then return "innocent" end
    local c = plr.Character
    if not c then return "innocent" end
    if c:FindFirstChild("Knife") or (plr.Backpack and plr.Backpack:FindFirstChild("Knife")) then return "murder" end
    if c:FindFirstChild("Gun") or (plr.Backpack and plr.Backpack:FindFirstChild("Gun")) then return "sheriff" end
    return "innocent"
end
local function getCol(plr)
    local r = getRole(plr)
    if r == "murder" then return Color3.fromRGB(255,100,120) end
    if r == "sheriff" then return Color3.fromRGB(120,200,255) end
    return Color3.fromRGB(120,230,150)
end

local function createESPObj(plr)
    if plr == LP or espCache[plr] then return end
    espCache[plr] = {
        box = Instance.new("Frame"),
        name = Instance.new("TextLabel"),
        dist = Instance.new("TextLabel"),
        tracer = Instance.new("Frame"),
        hl = nil,
    }
    local d = espCache[plr]
    d.box.BackgroundTransparency = 1 d.box.BorderSizePixel = 0 d.box.ZIndex = 1 d.box.Parent = Gui
    stroke(d.box, Color3.fromRGB(120,230,150), 1, 0)
    d.name.BackgroundTransparency = 1 d.name.TextColor3 = Color3.new(1,1,1)
    d.name.Font = T.FB d.name.TextSize = 12 d.name.ZIndex = 2 d.name.Parent = Gui
    stroke(d.name, Color3.new(0,0,0), 1, 0.4)
    d.dist.BackgroundTransparency = 1 d.dist.TextColor3 = Color3.new(1,1,1)
    d.dist.Font = T.F d.dist.TextSize = 10 d.dist.ZIndex = 2 d.dist.Parent = Gui
    d.tracer.BackgroundColor3 = Color3.new(1,1,1) d.tracer.BorderSizePixel = 0
    d.tracer.ZIndex = 1 d.tracer.Parent = Gui
end

for _, plr in ipairs(Players:GetPlayers()) do createESPObj(plr) end
Players.PlayerAdded:Connect(createESPObj)
Players.PlayerRemoving:Connect(function(plr)
    if espCache[plr] then
        for _, o in pairs(espCache[plr]) do pcall(function() o:Destroy() end) end
        espCache[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP then continue end
        if not espCache[plr] then createESPObj(plr) end
        local d = espCache[plr]
        if not d then continue end
        local char = plr.Character
        local col = getCol(plr)
        if F.ESP_Chams and char then
            if not d.hl or d.hl.Parent ~= char then
                if d.hl then d.hl:Destroy() end
                d.hl = Instance.new("Highlight")
                d.hl.Parent = char
                d.hl.Adornee = char
            end
            d.hl.FillColor = col
            d.hl.OutlineColor = col
            d.hl.FillTransparency = 1 - (F.ESP_Transparency/100)
            d.hl.Enabled = true
        elseif d.hl then
            d.hl.Enabled = false
        end
        if F.ESP_Enabled and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local pos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local size = Vector2.new(2000/pos.Z, 2600/pos.Z)
                local bp = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                d.box.Visible = F.ESP_Box
                if F.ESP_Box then
                    d.box.Position = UDim2.new(0, bp.X, 0, bp.Y)
                    d.box.Size = UDim2.new(0, size.X, 0, size.Y)
                    for _, s in ipairs(d.box:GetChildren()) do
                        if s:IsA("UIStroke") then s.Color = col s.Transparency = 0 end
                    end
                end
                d.name.Visible = F.ESP_Name
                if F.ESP_Name then
                    d.name.Text = plr.Name
                    d.name.Position = UDim2.new(0, pos.X - size.X/2, 0, bp.Y - 16)
                    d.name.Size = UDim2.new(0, size.X, 0, 14)
                    d.name.TextColor3 = col
                end
                d.dist.Visible = F.ESP_Distance
                if F.ESP_Distance then
                    local dist = math.floor((Cam.CFrame.Position - hrp.Position).Magnitude)
                    d.dist.Text = dist.."m"
                    d.dist.Position = UDim2.new(0, pos.X - size.X/2, 0, bp.Y + size.Y + 2)
                    d.dist.Size = UDim2.new(0, size.X, 0, 12)
                    d.dist.TextColor3 = T.TxD
                end
                d.tracer.Visible = F.ESP_Tracer
                if F.ESP_Tracer then
                    local origin = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
                    local target = Vector2.new(pos.X, bp.Y + size.Y)
                    local dx, dy = target.X - origin.X, target.Y - origin.Y
                    local length = math.sqrt(dx*dx + dy*dy)
                    local angle = math.deg(math.atan2(dy, dx))
                    d.tracer.Position = UDim2.new(0, origin.X, 0, origin.Y)
                    d.tracer.Size = UDim2.new(0, length, 0, 1)
                    d.tracer.Rotation = angle
                    d.tracer.BackgroundColor3 = col
                end
            else
                d.box.Visible = false d.name.Visible = false d.dist.Visible = false d.tracer.Visible = false
            end
        else
            d.box.Visible = false d.name.Visible = false d.dist.Visible = false d.tracer.Visible = false
        end
    end
end)

-- FOV Circle
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, 100, 0, 100)
fovCircle.BackgroundTransparency = 1
fovCircle.ZIndex = 500
fovCircle.Visible = false
fovCircle.Parent = Gui
round(fovCircle, 999)
local fovStroke = stroke(fovCircle, T.Acc, 1.5, 0.2)
RunService.RenderStepped:Connect(function()
    fovCircle.Visible = F.AIM_ShowFOV
    local r = F.AIM_FOV
    fovCircle.Size = UDim2.new(0, r*2, 0, r*2)
    fovCircle.Position = UDim2.new(0.5, -r, 0.5, -r)
    fovStroke.Color = T.Acc
end)

-- Target marker
local targetMarker = Instance.new("Frame")
targetMarker.Size = UDim2.new(0, 40, 0, 40)
targetMarker.BackgroundTransparency = 1
targetMarker.ZIndex = 501
targetMarker.Visible = false
targetMarker.Parent = Gui
round(targetMarker, 999)
local tmStroke = stroke(targetMarker, Color3.fromRGB(255,80,80), 2, 0.1)

-- ============ LEGIT AIMBOT ============
local aiming = false
local function isAimingInput()
    if IS_PC then return aiming end
    return aiming
end

if IS_PC then
    UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end
    end)
else
    UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.Touch then aiming = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then aiming = false end
    end)
end

local function getClosestTarget()
    local closest, shortest = nil, F.AIM_FOV
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myHrp = myChar.HumanoidRootPart
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist3d = (hrp.Position - myHrp.Position).Magnitude
                if dist3d <= F.AIM_MaxDistance then
                    if not F.AIM_TeamCheck or getRole(plr) ~= getRole(LP) then
                        local pos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local dist2d = (Vector2.new(pos.X,pos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                            if dist2d < shortest then
                                if not F.AIM_Visible then
                                    shortest = dist2d
                                    closest = plr
                                else
                                    local params = RaycastParams.new()
                                    params.FilterType = Enum.RaycastFilterType.Exclude
                                    params.FilterDescendantsInstances = {myChar, plr.Character}
                                    local dir = (hrp.Position - Cam.CFrame.Position).Unit * dist3d
                                    local result = WS:Raycast(Cam.CFrame.Position, dir, params)
                                    if not result then
                                        shortest = dist2d
                                        closest = plr
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

local lastTarget = nil
RunService.RenderStepped:Connect(function(dt)
    local target = nil
    if F.AIM_Enabled and (not F.AIM_Hold or isAimingInput()) then
        target = getClosestTarget()
    end
    lastTarget = target

    -- Target marker
    if F.AIM_ShowTarget and target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos, on = Cam:WorldToViewportPoint(hrp.Position)
            if on then
                targetMarker.Visible = true
                targetMarker.Position = UDim2.new(0, pos.X - 20, 0, pos.Y - 20)
            else
                targetMarker.Visible = false
            end
        end
    else
        targetMarker.Visible = false
    end

    if not target then return end
    local char = target.Character
    if not char then return end
    local hitPart = char:FindFirstChild(F.AIM_HitPart) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not hitPart then return end

    -- LEGIT SMOOTH AIM
    local smoothFactor = F.AIM_Legit and (F.AIM_Smooth / 100) or 1
    -- clamp
    if smoothFactor < 0.01 then smoothFactor = 0.01 end
    local goal = CFrame.new(Cam.CFrame.Position, hitPart.Position)
    Cam.CFrame = Cam.CFrame:Lerp(goal, math.clamp(smoothFactor * (dt * 60), 0, 1))
end)

-- Lighting
RunService.Heartbeat:Connect(function()
    if F.VIS_FullBright then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
    end
    if F.VIS_NoFog then
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 1e6
    end
end)

-- XRay
RunService.RenderStepped:Connect(function()
    if not F.VIS_XRay then return end
    local c = LP.Character
    if c then
        for _, pt in ipairs(c:GetDescendants()) do
            if pt:IsA("BasePart") and pt.Name ~= "HumanoidRootPart" then
                pt.LocalTransparencyModifier = 1 - (F.VIS_XRayStrength/100)
            end
        end
    end
end)

-- Post processing
task.spawn(function()
    while task.wait(0.5) do
        local bloom = Lighting:FindFirstChild("FB_Bloom")
        if F.VIS_Bloom then
            if not bloom then
                bloom = Instance.new("BloomEffect")
                bloom.Name = "FB_Bloom"
                bloom.Parent = Lighting
            end
            bloom.Intensity = F.VIS_BloomIntensity
            bloom.Size = 24 bloom.Threshold = 1
        elseif bloom then bloom:Destroy() end

        local blur = Lighting:FindFirstChild("FB_Blur")
        if F.VIS_BlurWorld then
            if not blur then
                blur = Instance.new("BlurEffect")
                blur.Name = "FB_Blur"
                blur.Parent = Lighting
            end
            blur.Size = F.VIS_BlurSize
        elseif blur then blur:Destroy() end

        local sr = Lighting:FindFirstChild("FB_SunRays")
        if F.VIS_SunRays then
            if not sr then
                sr = Instance.new("SunRaysEffect")
                sr.Name = "FB_SunRays"
                sr.Parent = Lighting
            end
            sr.Intensity = F.VIS_SunRaysIntensity
            sr.Spread = 1
        elseif sr then sr:Destroy() end

        local cc = Lighting:FindFirstChild("FB_CC")
        if F.VIS_CC then
            if not cc then
                cc = Instance.new("ColorCorrectionEffect")
                cc.Name = "FB_CC"
                cc.Parent = Lighting
            end
            cc.Saturation = F.VIS_Saturation
            cc.Contrast = F.VIS_Contrast
            cc.Brightness = F.VIS_Brightness
        elseif cc then cc:Destroy() end
    end
end)

-- Headless
task.spawn(function()
    while task.wait(1) do
        local c = LP.Character
        if c then
            local head = c:FindFirstChild("Head")
            if head then
                if F.VIS_Headless then
                    head.Transparency = 1
                    for _, dd in ipairs(head:GetChildren()) do
                        if dd:IsA("Decal") then dd.Transparency = 1 end
                    end
                else
                    if head.Transparency == 1 then head.Transparency = 0 end
                end
            end
        end
    end
end)

-- Trail
local trailAttach, trailObj = nil, nil
RunService.Heartbeat:Connect(function()
    local c = LP.Character
    if not c then trailAttach = nil trailObj = nil return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if F.VIS_Trail then
        if not trailObj or trailObj.Parent ~= c then
            if trailObj then trailObj:Destroy() end
            trailAttach = Instance.new("Attachment", hrp)
            trailAttach.Position = Vector3.new(0,0,0)
            trailObj = Instance.new("Trail")
            trailObj.Attachment0 = trailAttach
            trailObj.Attachment1 = trailAttach
            trailObj.Lifetime = 0.6
            trailObj.MinLength = 0
            trailObj.Color = ColorSequence.new(T.Acc, T.Acc2)
            trailObj.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 1),
            })
            trailObj.LightEmission = 1
            trailObj.LightInfluence = 0
            trailObj.WidthScale = NumberSequence.new(1)
            trailObj.Parent = c
        else
            trailObj.Color = ColorSequence.new(T.Acc, T.Acc2)
        end
    else
        if trailObj then trailObj:Destroy() trailObj = nil trailAttach = nil end
    end
end)

-- Fly
local flyBV
RunService.Heartbeat:Connect(function()
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if F.MOVE_Fly then
        if not flyBV then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
            flyBV.Velocity = Vector3.zero
            flyBV.Parent = hrp
        end
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        if IS_MOBILE then
            local hum = c:FindFirstChild("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0.1 then
                dir = hum.MoveDirection * 60
            end
        end
        flyBV.Velocity = dir * (F.MOVE_FlySpeed / 60)
    else
        if flyBV then flyBV:Destroy() flyBV = nil end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if F.MOVE_InfiniteJump then
        local c = LP.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if not F.MOVE_NoClip then return end
    local c = LP.Character
    if c then
        for _, pt in ipairs(c:GetDescendants()) do
            if pt:IsA("BasePart") then pt.CanCollide = false end
        end
    end
end)

-- Sprint (PC)
if IS_PC then
    UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.LeftShift and F.MOVE_Sprint then
            local c = LP.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid.WalkSpeed = F.MOVE_Walkspeed + 25
            end
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.LeftShift and F.MOVE_Sprint then
            local c = LP.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid.WalkSpeed = F.MOVE_Walkspeed
            end
        end
    end)
end

-- Anti-AFK
if F.MISC_AntiAFK then
    pcall(function()
        LP.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    end)
end

-- ============ FIXED AUTO COINS ============
local lastCoinTP = 0
RunService.Heartbeat:Connect(function()
    if not (F.FARM_AutoCoins or F.FARM_AutoDrops) then return end
    local now = tick()
    if now - lastCoinTP < 0.06 then return end
    lastCoinTP = now

    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closest, shortest = nil, math.huge
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nm = obj.Name:lower()
            local isCoin = F.FARM_AutoCoins and nm:find("coin")
            local isDrop = F.FARM_AutoDrops and (nm == "gundrop" or nm == "knifedrop" or nm == "drop")
            if isCoin or isDrop then
                local d = (obj.Position - hrp.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = obj
                end
            end
        end
    end

    if closest then
        pcall(function()
            hrp.CFrame = closest.CFrame + Vector3.new(0, 2.5, 0)
        end)
    end
end)

-- ============ FIXED AUTO KILL ============
RunService.Heartbeat:Connect(function()
    if not F.FARM_AutoKill then return end
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hasKnife = c:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
    if not hasKnife then return end
    if not c:FindFirstChild("Knife") then
        local k = LP.Backpack:FindFirstChild("Knife")
        if k then k.Parent = c end
    end

    local closest, shortest = nil, 200
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local thp = plr.Character:FindFirstChild("HumanoidRootPart")
            local thum = plr.Character:FindFirstChild("Humanoid")
            if thp and thum and thum.Health > 0 then
                local d = (thp.Position - c.HumanoidRootPart.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = thp
                end
            end
        end
    end
    if closest then
        c.HumanoidRootPart.CFrame = closest.CFrame
    end
end)

-- ============ FIXED FLING ALL ============
local function flingPlayer(plr)
    if plr == LP then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = plr.Character
    if not target then return end
    local thp = target:FindFirstChild("HumanoidRootPart")
    local thum = target:FindFirstChild("Humanoid")
    if not thp or not thum then return end

    pcall(function() hrp.CFrame = thp.CFrame end)
    pcall(function() thp:SetNetworkOwner(LP) end)
    pcall(function() thp.Velocity = Vector3.new(1e5, 1e5, 1e5) end)
    pcall(function()
        local saved = thum.HipHeight
        thum.HipHeight = -50
        task.delay(0.15, function()
            if thum and thum.Parent then
                pcall(function() thum.HipHeight = saved end)
            end
        end)
    end)
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(1e5, 1e5, 1e5)
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.Parent = hrp
    task.delay(0.15, function()
        if bav then bav:Destroy() end
    end)
end

RunService.Heartbeat:Connect(function()
    if F.FUN_SpinBot then
        local c = LP.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end
    if F.FUN_Fling then
        local c = LP.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (c.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < 20 then
                    pcall(flingPlayer, plr)
                end
            end
        end
    end
    if F.FUN_BunnyHop then
        local c = LP.Character
        if c and c:FindFirstChild("Humanoid") and c.Humanoid.FloorMaterial ~= Enum.Material.Air then
            c.Humanoid.Jump = true
        end
    end
end)

-- Keybinds
if IS_PC then
    UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        local key = i.KeyCode.Name
        if key == F.BIND_Fly then
            F.MOVE_Fly = not F.MOVE_Fly
            notify("Bind", "Fly: "..tostring(F.MOVE_Fly), 1.5, T.Acc)
        elseif key == F.BIND_Aimbot then
            F.AIM_Enabled = not F.AIM_Enabled
            notify("Bind", "Aimbot: "..tostring(F.AIM_Enabled), 1.5, T.Acc)
        elseif key == F.BIND_ESP then
            F.ESP_Enabled = not F.ESP_Enabled
            notify("Bind", "ESP: "..tostring(F.ESP_Enabled), 1.5, T.Acc)
        elseif key == F.BIND_UI then
            Main.Visible = not Main.Visible
        end
    end)
end

-- FPS
local statsLabel
local fpsC, fpsT, fpsV = 0, 0, 0
RunService.RenderStepped:Connect(function(dt)
    fpsC = fpsC + 1
    fpsT = fpsT + dt
    if fpsT >= 1 then
        fpsV = fpsC fpsC = 0 fpsT = 0
    end
    if F.MISC_ShowFPS then
        if not statsLabel then
            statsLabel = Instance.new("TextLabel")
            statsLabel.Size = UDim2.new(0, 120, 0, 22)
            statsLabel.Position = UDim2.new(0.5, -60, 0, 6)
            statsLabel.BackgroundColor3 = T.Bg
            statsLabel.BackgroundTransparency = 0.45
            statsLabel.TextColor3 = T.Tx
            statsLabel.Font = T.FB
            statsLabel.TextSize = 11
            statsLabel.BorderSizePixel = 0
            statsLabel.ZIndex = 50
            statsLabel.Parent = Gui
            round(statsLabel, 8)
            stroke(statsLabel, T.Acc, 1, 0.4)
        end
        statsLabel.Text = "FPS: "..fpsV
    elseif statsLabel then
        statsLabel:Destroy() statsLabel = nil
    end
end)

-- Close
CB.MouseButton1Click:Connect(function()
    if IS_MOBILE and FAB then
        Main.Visible = false
        FAB.Text = "🌸"
    else
        tw(Main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.25):Play()
        task.wait(0.3)
        Gui:Destroy()
        _G.FB_Loaded = false
    end
end)

-- Minimize
local minimized = false
MB.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        tw(Sb, {Position = UDim2.new(0, -140, 0, 40)}, 0.2):Play()
        tw(Ct, {Position = UDim2.new(0, 0, 0, 40)}, 0.2):Play()
        tw(Main, {Size = UDim2.new(0, WIN_W, 0, 40)}, 0.25):Play()
    else
        tw(Sb, {Position = UDim2.new(0, 0, 0, 40)}, 0.2):Play()
        tw(Ct, {Position = UDim2.new(0, 140, 0, 40)}, 0.2):Play()
        tw(Main, {Size = UDim2.new(0, WIN_W, 0, WIN_H)}, 0.25):Play()
    end
end)

-- Fade in / Mobile default
if IS_MOBILE or IS_TABLET then
    Main.Visible = false
    task.delay(1, function()
        notify("Femboy Hub v2.6", "Нажми 🌸 чтобы открыть", 5)
    end)
else
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, WIN_W, 0, WIN_H),
        Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    }):Play()
    notify("Femboy Hub v2.6", "Author: Femboy", 4)
end

print("[Femboy Hub v2.6] loaded | Author: Femboy | Mobile: "..tostring(IS_MOBILE).." | PC: "..tostring(IS_PC))