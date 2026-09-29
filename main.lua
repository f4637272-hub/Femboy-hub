--[[ Femboy Hub v2.1 | ViRuS/Prototip | MM2 | Nexomia ready ]]
if _G.FB_Loaded then return end _G.FB_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Http = game:GetService("HttpService")
local WS = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local Cam = WS.CurrentCamera

local function safe(fn, d) local ok, r = pcall(fn) return (ok and r ~= nil) and r or d end
local gethuiS = safe(function() return gethui() end, nil)
local writef = safe(function() return writefile end, nil)
local readf = safe(function() return readfile end, nil)
local isf = safe(function() return isfile end, nil)
local setclip = safe(function() return setclipboard end, nil)
local Parent = gethuiS or CoreGui

for _, g in ipairs({Parent, CoreGui}) do
    if g and g:FindFirstChild("FemboyHub") then g.FemboyHub:Destroy() end
end

-- ============ FLAGS ============
local F = {
    -- ESP
    ESP_Enabled=false, ESP_Role=true, ESP_Name=true, ESP_Box=true,
    ESP_Tracer=false, ESP_Health=false, ESP_Distance=false, ESP_Chams=false,
    ESP_Transparency=30,
    ESP_ColorInnocent=Color3.fromRGB(120,230,150),
    ESP_ColorSheriff=Color3.fromRGB(120,200,255),
    ESP_ColorMurder=Color3.fromRGB(255,100,120),
    -- AIM
    AIM_Enabled=false, AIM_Visible=true, AIM_ShowFOV=false,
    AIM_FOV=150, AIM_Smooth=25, AIM_Trigger=false,
    -- MOVEMENT
    MOVE_Walkspeed=16, MOVE_JumpPower=50, MOVE_Fly=false, MOVE_FlySpeed=60,
    MOVE_InfiniteJump=false, MOVE_NoClip=false, MOVE_Sprint=false,
    -- VISUALS
    VIS_FullBright=false, VIS_NoFog=false, VIS_XRay=false, VIS_XRayStrength=70,
    VIS_FOVCircle=false, VIS_FOVRadius=100,
    -- FARM
    FARM_AutoCoins=false, FARM_AutoDrops=false,
    -- FUN
    FUN_Fling=false, FUN_SpinBot=false, FUN_BunnyHop=false, FUN_Dance=false,
    -- MISC
    MISC_AntiAFK=true, MISC_ShowFPS=false, MISC_Discord="discord.gg/femboyhub",
    -- THEME
    THEME_Name="Pink",
    -- BINDS
    BIND_Fly="F", BIND_Aimbot="C", BIND_ESP="V", BIND_UI="RightShift",
}

-- ============ THEMES ============
local Themes = {
    Pink    = {Acc=Color3.fromRGB(255,105,180), Acc2=Color3.fromRGB(180,130,255), Acc3=Color3.fromRGB(120,220,255)},
    Cyan    = {Acc=Color3.fromRGB(120,220,255), Acc2=Color3.fromRGB(105,180,255), Acc3=Color3.fromRGB(180,255,240)},
    Purple  = {Acc=Color3.fromRGB(180,130,255), Acc2=Color3.fromRGB(220,120,255), Acc3=Color3.fromRGB(255,150,220)},
    Red     = {Acc=Color3.fromRGB(255,100,120), Acc2=Color3.fromRGB(255,150,100), Acc3=Color3.fromRGB(255,200,150)},
    Green   = {Acc=Color3.fromRGB(120,230,150), Acc2=Color3.fromRGB(120,220,255), Acc3=Color3.fromRGB(200,255,150)},
    Blue    = {Acc=Color3.fromRGB(120,150,255), Acc2=Color3.fromRGB(150,120,255), Acc3=Color3.fromRGB(120,220,255)},
}

local T = {
    Bg=Color3.fromRGB(18,16,24), Bg2=Color3.fromRGB(24,21,32), Bg3=Color3.fromRGB(34,30,44),
    El=Color3.fromRGB(42,37,54), Hover=Color3.fromRGB(60,52,78),
    Tx=Color3.fromRGB(242,238,252), TxD=Color3.fromRGB(150,140,172),
    Grn=Color3.fromRGB(120,230,150), Red=Color3.fromRGB(255,100,120), Yellow=Color3.fromRGB(255,210,120),
    Stroke=Color3.fromRGB(70,62,92),
    F=Enum.Font.GothamMedium, FB=Enum.Font.GothamBold, FS=Enum.Font.GothamSemibold,
}

local function applyTheme(name)
    local t = Themes[name] or Themes.Pink
    T.Acc = t.Acc T.Acc2 = t.Acc2 T.Acc3 = t.Acc3
    F.THEME_Name = name
end
applyTheme(F.THEME_Name)

local function round(o,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=o return c end
local function stroke(o,c,t,tr) local s=Instance.new("UIStroke") s.Color=c or T.Stroke s.Thickness=t or 1 s.Transparency=tr or 0 s.Parent=o return s end
local function grad(o,a,b,rot) local g=Instance.new("UIGradient") g.Color=ColorSequence.new(a,b) g.Rotation=rot or 0 g.Parent=o return g end
local function grad3(o,a,b,c,rot)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,a),ColorSequenceKeypoint.new(0.5,b),ColorSequenceKeypoint.new(1,c)})
    g.Rotation=rot or 0 g.Parent=o return g
end
local function shine(o,r)
    local s=Instance.new("Frame") s.Size=UDim2.new(1,0,0.5,0) s.BackgroundColor3=Color3.new(1,1,1)
    s.BackgroundTransparency=0.94 s.BorderSizePixel=0 s.ZIndex=o.ZIndex+1 s.Parent=o round(s,r or 8)
    local g=Instance.new("UIGradient") g.Rotation=90
    g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.85),NumberSequenceKeypoint.new(1,1)}) g.Parent=s
    return s
end
local function tw(o,p,t) return Tween:Create(o,TweenInfo.new(t or 0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p) end

-- Notifications
local NotifHolder = nil
local function notify(title, desc, dur, color)
    dur = dur or 3 color = color or T.Acc
    if not NotifHolder or not NotifHolder.Parent then
        NotifHolder = Instance.new("Frame")
        NotifHolder.Name = "FB_Notif"
        NotifHolder.Size = UDim2.new(0,300,1,-40)
        NotifHolder.Position = UDim2.new(1,-320,0,20)
        NotifHolder.BackgroundTransparency = 1
        NotifHolder.ZIndex = 500
        NotifHolder.Parent = Parent
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0,8)
        l.VerticalAlignment = Enum.VerticalAlignment.Top
        l.Parent = NotifHolder
    end
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1,0,0,58)
    n.Position = UDim2.new(1,60,0,0)
    n.BackgroundColor3 = T.Bg2
    n.BorderSizePixel = 0
    n.ZIndex = 501
    n.Parent = NotifHolder
    round(n,10) stroke(n,color,1,0.4)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,3,1,-12) bar.Position = UDim2.new(0,3,0,6)
    bar.BackgroundColor3 = color bar.BorderSizePixel = 0 bar.ZIndex = 502 bar.Parent = n round(bar,999)
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1,-20,0,20) tl.Position = UDim2.new(0,14,0,9)
    tl.BackgroundTransparency = 1 tl.Text = title tl.TextColor3 = T.Tx
    tl.Font = T.FB tl.TextSize = 13 tl.TextXAlignment = Enum.TextXAlignment.Left tl.ZIndex = 502 tl.Parent = n
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1,-20,0,18) dl.Position = UDim2.new(0,14,0,29)
    dl.BackgroundTransparency = 1 dl.Text = desc dl.TextColor3 = T.TxD
    dl.Font = T.F dl.TextSize = 11 dl.TextXAlignment = Enum.TextXAlignment.Left dl.ZIndex = 502 dl.Parent = n
    Tween:Create(n,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)}):Play()
    task.delay(dur,function()
        if not n or not n.Parent then return end
        local o = Tween:Create(n,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(1,60,0,0)})
        o:Play() o.Completed:Wait() if n then n:Destroy() end
    end)
end

-- ============ GUI ============
local Gui = Instance.new("ScreenGui")
Gui.Name = "FemboyHub" Gui.ResetOnSpawn = false Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling Gui.Parent = Parent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,700,0,470) Main.Position = UDim2.new(0.5,-350,0.5,-235)
Main.BackgroundColor3 = T.Bg Main.BorderSizePixel = 0
Main.Active = true Main.Draggable = true Main.ClipsDescendants = true
Main.ZIndex = 10 Main.Parent = Gui
round(Main,14) stroke(Main,T.Acc,1.4,0.55)
grad(Main,Color3.fromRGB(24,20,32),Color3.fromRGB(14,12,20),135)

local TopShine = Instance.new("Frame")
TopShine.Size = UDim2.new(1,0,0,80) TopShine.BackgroundColor3 = Color3.new(1,1,1)
TopShine.BackgroundTransparency = 0.92 TopShine.BorderSizePixel = 0
TopShine.ZIndex = 11 TopShine.Parent = Main round(TopShine,14)
local TSG = Instance.new("UIGradient") TSG.Rotation = 90
TSG.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.7),NumberSequenceKeypoint.new(1,1)}) TSG.Parent = TopShine

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,2) TopBar.BackgroundColor3 = T.Acc
TopBar.BorderSizePixel = 0 TopBar.ZIndex = 12 TopBar.Parent = Main
local TBG = Instance.new("UIGradient")
TBG.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,T.Acc),ColorSequenceKeypoint.new(0.5,T.Acc2),ColorSequenceKeypoint.new(1,T.Acc3)})
TBG.Parent = TopBar

-- TitleBar
local TB = Instance.new("Frame")
TB.Size = UDim2.new(1,0,0,48) TB.BackgroundTransparency = 1 TB.ZIndex = 13 TB.Parent = Main

local CB = Instance.new("TextButton")
CB.Size = UDim2.new(0,26,0,26) CB.Position = UDim2.new(1,-38,0,11)
CB.BackgroundColor3 = T.El CB.BackgroundTransparency = 0.3 CB.Text = "✕"
CB.TextColor3 = T.Tx CB.Font = T.FB CB.TextSize = 13 CB.AutoButtonColor = false
CB.ZIndex = 14 CB.Parent = TB round(CB,999) stroke(CB,T.Stroke,1,0.4)
CB.MouseEnter:Connect(function() tw(CB,{BackgroundColor3=T.Red,BackgroundTransparency=0},0.15):Play() end)
CB.MouseLeave:Connect(function() tw(CB,{BackgroundColor3=T.El,BackgroundTransparency=0.3},0.15):Play() end)

local MB = Instance.new("TextButton")
MB.Size = UDim2.new(0,26,0,26) MB.Position = UDim2.new(1,-68,0,11)
MB.BackgroundColor3 = T.El MB.BackgroundTransparency = 0.3 MB.Text = "−"
MB.TextColor3 = T.Tx MB.Font = T.FB MB.TextSize = 14 MB.AutoButtonColor = false
MB.ZIndex = 14 MB.Parent = TB round(MB,999) stroke(MB,T.Stroke,1,0.4)

local HI = Instance.new("Frame")
HI.Size = UDim2.new(0,30,0,30) HI.Position = UDim2.new(0,16,0,9)
HI.BackgroundColor3 = T.Acc HI.BorderSizePixel = 0 HI.ZIndex = 14 HI.Parent = TB
round(HI,10) grad(HI,T.Acc,T.Acc2,45)
local HIL = Instance.new("TextLabel")
HIL.Size = UDim2.new(1,0,1,0) HIL.BackgroundTransparency = 1
HIL.Text = "🌸" HIL.TextSize = 18 HIL.ZIndex = 15 HIL.Parent = HI

local TT = Instance.new("TextLabel")
TT.Size = UDim2.new(0,300,1,0) TT.Position = UDim2.new(0,54,0,0)
TT.BackgroundTransparency = 1 TT.Text = "Femboy Hub" TT.TextColor3 = T.Tx
TT.Font = T.FB TT.TextSize = 15 TT.TextXAlignment = Enum.TextXAlignment.Left TT.ZIndex = 14 TT.Parent = TB

local VT = Instance.new("TextLabel")
VT.Size = UDim2.new(0,60,1,0) VT.Position = UDim2.new(0,148,0,0)
VT.BackgroundTransparency = 1 VT.Text = "v2.1" VT.TextColor3 = T.Acc
VT.Font = T.FS VT.TextSize = 11 VT.TextXAlignment = Enum.TextXAlignment.Left VT.ZIndex = 14 VT.Parent = TB

-- ============ SIDEBAR ============
local Sb = Instance.new("Frame")
Sb.Size = UDim2.new(0,170,1,-48) Sb.Position = UDim2.new(0,0,0,48)
Sb.BackgroundColor3 = T.Bg2 Sb.BackgroundTransparency = 0.35
Sb.BorderSizePixel = 0 Sb.ZIndex = 13 Sb.Parent = Main

local SbLine = Instance.new("Frame")
SbLine.Size = UDim2.new(0,1,1,-16) SbLine.Position = UDim2.new(1,-1,0,8)
SbLine.BackgroundColor3 = T.Stroke SbLine.BackgroundTransparency = 0.5
SbLine.BorderSizePixel = 0 SbLine.ZIndex = 14 SbLine.Parent = Sb

local SbSc = Instance.new("ScrollingFrame")
SbSc.Size = UDim2.new(1,-6,1,-56) SbSc.Position = UDim2.new(0,3,0,8)
SbSc.BackgroundTransparency = 1 SbSc.BorderSizePixel = 0 SbSc.ScrollBarThickness = 2
SbSc.ScrollBarImageColor3 = T.Acc SbSc.CanvasSize = UDim2.new(0,0,0,0)
SbSc.AutomaticCanvasSize = Enum.AutomaticSize.Y SbSc.ZIndex = 14 SbSc.Parent = Sb
local SbL = Instance.new("UIListLayout")
SbL.Padding = UDim.new(0,3) SbL.SortOrder = Enum.SortOrder.LayoutOrder SbL.Parent = SbSc
local SbP = Instance.new("UIPadding")
SbP.PaddingLeft = UDim.new(0,6) SbP.PaddingRight = UDim.new(0,6)
SbP.PaddingTop = UDim.new(0,2) SbP.PaddingBottom = UDim.new(0,8) SbP.Parent = SbSc

local Sbf = Instance.new("TextButton")
Sbf.Size = UDim2.new(1,-12,0,26) Sbf.Position = UDim2.new(0,6,1,-34)
Sbf.BackgroundColor3 = T.El Sbf.BackgroundTransparency = 0.4
Sbf.Text = "🔗 "..F.MISC_Discord Sbf.TextColor3 = T.TxD
Sbf.Font = T.F Sbf.TextSize = 10 Sbf.AutoButtonColor = false
Sbf.BorderSizePixel = 0 Sbf.ZIndex = 15 Sbf.Parent = Sb round(Sbf,8) stroke(Sbf,T.Stroke,1,0.5)
if setclip then
    Sbf.MouseButton1Click:Connect(function()
        setclip(F.MISC_Discord)
        notify("Discord","Скопировано",2,T.Acc2)
    end)
end

-- ============ CONTENT ============
local Ct = Instance.new("Frame")
Ct.Size = UDim2.new(1,-170,1,-48) Ct.Position = UDim2.new(0,170,0,48)
Ct.BackgroundTransparency = 1 Ct.ZIndex = 13 Ct.Parent = Main

local TTabs = Instance.new("Frame")
TTabs.Size = UDim2.new(1,-24,0,36) TTabs.Position = UDim2.new(0,12,0,10)
TTabs.BackgroundTransparency = 1 TTabs.ZIndex = 14 TTabs.Parent = Ct
local TTL = Instance.new("UIListLayout")
TTL.FillDirection = Enum.FillDirection.Horizontal TTL.Padding = UDim.new(0,5)
TTL.SortOrder = Enum.SortOrder.LayoutOrder TTL.Parent = TTabs

local PH = Instance.new("Frame")
PH.Size = UDim2.new(1,-24,1,-58) PH.Position = UDim2.new(0,12,0,52)
PH.BackgroundTransparency = 1 PH.ClipsDescendants = true PH.ZIndex = 14 PH.Parent = Ct

local Pages, Tabs, SbItems = {}, {}, {}
local ActivePage, ActiveTab

local function mkPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = "P_"..name p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1 p.BorderSizePixel = 0 p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = T.Acc p.CanvasSize = UDim2.new(0,0,0,0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y p.Visible = false
    p.ZIndex = 15 p.Parent = PH
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0,7) l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = p
    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0,10) pad.PaddingTop = UDim.new(0,2)
    pad.PaddingBottom = UDim.new(0,10) pad.Parent = p
    Pages[name] = p return p
end

local function mkSection(parent, text)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1,0,0,24) h.BackgroundTransparency = 1 h.Parent = parent
    local ln = Instance.new("Frame")
    ln.Size = UDim2.new(0,3,0,14) ln.Position = UDim2.new(0,0,0.5,-7)
    ln.BackgroundColor3 = T.Acc ln.BorderSizePixel = 0 ln.Parent = h round(ln,999)
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1,-14,1,0) lb.Position = UDim2.new(0,12,0,0)
    lb.BackgroundTransparency = 1 lb.Text = text lb.TextColor3 = T.Tx
    lb.Font = T.FB lb.TextSize = 12 lb.TextXAlignment = Enum.TextXAlignment.Left lb.Parent = h
    return h
end

local function mkDiv(parent)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1,0,0,1) d.BackgroundColor3 = T.Stroke
    d.BackgroundTransparency = 0.4 d.BorderSizePixel = 0 d.Parent = parent
    return d
end

local function mkToggle(parent, name, flag, cb)
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1,0,0,40) R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.4 R.BorderSizePixel = 0 R.Parent = parent
    round(R,9) stroke(R,T.Stroke,1,0.6) shine(R,9)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-70,1,0) L.Position = UDim2.new(0,14,0,0)
    L.BackgroundTransparency = 1 L.Text = name L.TextColor3 = T.Tx
    L.Font = T.F L.TextSize = 13 L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex+2 L.Parent = R
    local Sw = Instance.new("Frame")
    Sw.Size = UDim2.new(0,36,0,19) Sw.Position = UDim2.new(1,-50,0.5,-9.5)
    Sw.BackgroundColor3 = T.Bg3 Sw.BorderSizePixel = 0 Sw.ZIndex = R.ZIndex+2 Sw.Parent = R
    round(Sw,999) stroke(Sw,T.Stroke,1,0.5)
    local Kn = Instance.new("Frame")
    Kn.Size = UDim2.new(0,13,0,13) Kn.Position = UDim2.new(0,3,0.5,-6.5)
    Kn.BackgroundColor3 = T.TxD Kn.BorderSizePixel = 0 Kn.ZIndex = R.ZIndex+3 Kn.Parent = Sw round(Kn,999)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,0,1,0) B.BackgroundTransparency = 1 B.Text = ""
    B.ZIndex = R.ZIndex+4 B.Parent = R
    local function up(anim)
        local on = F[flag]
        if anim then
            tw(Sw,{BackgroundColor3=on and T.Acc or T.Bg3},0.2):Play()
            tw(Kn,{Position=on and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5),
                BackgroundColor3=on and T.Tx or T.TxD},0.2):Play()
        else
            Sw.BackgroundColor3 = on and T.Acc or T.Bg3
            Kn.Position = on and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5)
            Kn.BackgroundColor3 = on and T.Tx or T.TxD
        end
        if cb then cb(on) end
    end
    B.MouseButton1Click:Connect(function() F[flag]=not F[flag] up(true) end)
    up(false) return R
end

local function mkSlider(parent, name, flag, min, max, suffix, cb)
    suffix = suffix or ""
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1,0,0,50) R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.4 R.BorderSizePixel = 0 R.Parent = parent
    round(R,9) stroke(R,T.Stroke,1,0.6) shine(R,9)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-90,0,20) L.Position = UDim2.new(0,14,0,4)
    L.BackgroundTransparency = 1 L.Text = name L.TextColor3 = T.Tx
    L.Font = T.F L.TextSize = 13 L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex+2 L.Parent = R
    local V = Instance.new("TextLabel")
    V.Size = UDim2.new(0,80,0,20) V.Position = UDim2.new(1,-90,0,4)
    V.BackgroundTransparency = 1 V.Text = tostring(F[flag])..suffix V.TextColor3 = T.Acc
    V.Font = T.FS V.TextSize = 12 V.TextXAlignment = Enum.TextXAlignment.Right
    V.ZIndex = R.ZIndex+2 V.Parent = R
    local BB = Instance.new("Frame")
    BB.Size = UDim2.new(1,-28,0,4) BB.Position = UDim2.new(0,14,0,34)
    BB.BackgroundColor3 = T.Bg3 BB.BorderSizePixel = 0 BB.ZIndex = R.ZIndex+2 BB.Parent = R round(BB,999)
    local Fi = Instance.new("Frame")
    Fi.Size = UDim2.new((F[flag]-min)/(max-min),0,1,0) Fi.BackgroundColor3 = T.Acc
    Fi.BorderSizePixel = 0 Fi.ZIndex = R.ZIndex+3 Fi.Parent = BB round(Fi,999)
    grad(Fi,T.Acc,T.Acc2,0)
    local drag = false
    local function upi(input)
        local pos = math.clamp((input.Position.X-BB.AbsolutePosition.X)/BB.AbsoluteSize.X,0,1)
        local val = math.floor(min+(max-min)*pos+0.5)
        F[flag] = val V.Text = tostring(val)..suffix Fi.Size = UDim2.new(pos,0,1,0)
        if cb then cb(val) end
    end
    BB.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true upi(i) end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upi(i) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
    return R
end

local function mkButton(parent, name, cb)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,0,0,36) B.BackgroundColor3 = T.El
    B.BackgroundTransparency = 0.4 B.Text = "" B.AutoButtonColor = false B.Parent = parent
    round(B,9) stroke(B,T.Stroke,1,0.6) shine(B,9)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-20,1,0) L.Position = UDim2.new(0,14,0,0)
    L.BackgroundTransparency = 1 L.Text = name L.TextColor3 = T.Tx
    L.Font = T.F L.TextSize = 13 L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = B.ZIndex+2 L.Parent = B
    B.MouseEnter:Connect(function() tw(B,{BackgroundColor3=T.Hover,BackgroundTransparency=0.35},0.15):Play() end)
    B.MouseLeave:Connect(function() tw(B,{BackgroundColor3=T.El,BackgroundTransparency=0.4},0.15):Play() end)
    B.MouseButton1Click:Connect(cb)
    return B
end

local function mkDropdown(parent, name, flag, options, cb)
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1,0,0,40) R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.4 R.BorderSizePixel = 0 R.ClipsDescendants = true R.Parent = parent
    round(R,9) stroke(R,T.Stroke,1,0.6)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-120,1,0) L.Position = UDim2.new(0,14,0,0)
    L.BackgroundTransparency = 1 L.Text = name L.TextColor3 = T.Tx
    L.Font = T.F L.TextSize = 13 L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex+2 L.Parent = R
    local Cur = Instance.new("TextLabel")
    Cur.Size = UDim2.new(0,100,1,0) Cur.Position = UDim2.new(1,-122,0,0)
    Cur.BackgroundTransparency = 1 Cur.Text = F[flag] or options[1] Cur.TextColor3 = T.TxD
    Cur.Font = T.F Cur.TextSize = 12 Cur.TextXAlignment = Enum.TextXAlignment.Right
    Cur.ZIndex = R.ZIndex+2 Cur.Parent = R
    local Ar = Instance.new("TextLabel")
    Ar.Size = UDim2.new(0,20,1,0) Ar.Position = UDim2.new(1,-24,0,0)
    Ar.BackgroundTransparency = 1 Ar.Text = "▾" Ar.TextColor3 = T.TxD
    Ar.Font = T.FB Ar.TextSize = 12 Ar.ZIndex = R.ZIndex+2 Ar.Parent = R
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,0,0,40) B.BackgroundTransparency = 1 B.Text = ""
    B.ZIndex = R.ZIndex+3 B.Parent = R
    local opened = false
    local expSize = 40 + #options*28
    B.MouseButton1Click:Connect(function()
        opened = not opened
        tw(R,{Size=opened and UDim2.new(1,0,0,expSize) or UDim2.new(1,0,0,40)},0.25):Play()
        Ar.Text = opened and "▴" or "▾"
    end)
    local Opts = Instance.new("Frame")
    Opts.Size = UDim2.new(1,-20,0,#options*28) Opts.Position = UDim2.new(0,10,0,40)
    Opts.BackgroundTransparency = 1 Opts.ZIndex = R.ZIndex+2 Opts.Parent = R
    local OL = Instance.new("UIListLayout")
    OL.Padding = UDim.new(0,2) OL.SortOrder = Enum.SortOrder.LayoutOrder OL.Parent = Opts
    for _,opt in ipairs(options) do
        local OB = Instance.new("TextButton")
        OB.Size = UDim2.new(1,0,0,26) OB.BackgroundColor3 = T.Bg3
        OB.BackgroundTransparency = 0.4 OB.Text = "" OB.AutoButtonColor = false
        OB.ZIndex = R.ZIndex+3 OB.Parent = Opts round(OB,7)
        local OLb = Instance.new("TextLabel")
        OLb.Size = UDim2.new(1,-16,1,0) OLb.Position = UDim2.new(0,10,0,0)
        OLb.BackgroundTransparency = 1 OLb.Text = opt OLb.TextColor3 = T.Tx
        OLb.Font = T.F OLb.TextSize = 12 OLb.TextXAlignment = Enum.TextXAlignment.Left
        OLb.ZIndex = R.ZIndex+4 OLb.Parent = OB
        OB.MouseButton1Click:Connect(function()
            F[flag] = opt Cur.Text = opt opened = false
            tw(R,{Size=UDim2.new(1,0,0,40)},0.25):Play() Ar.Text = "▾"
            if cb then cb(opt) end
        end)
        OB.MouseEnter:Connect(function() OB.BackgroundColor3 = T.Hover end)
        OB.MouseLeave:Connect(function() OB.BackgroundColor3 = T.Bg3 end)
    end
    return R
end

local function mkTextbox(parent, name, flag, cb)
    local R = Instance.new("Frame")
    R.Size = UDim2.new(1,0,0,40) R.BackgroundColor3 = T.El
    R.BackgroundTransparency = 0.4 R.BorderSizePixel = 0 R.Parent = parent
    round(R,9) stroke(R,T.Stroke,1,0.6)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-160,1,0) L.Position = UDim2.new(0,14,0,0)
    L.BackgroundTransparency = 1 L.Text = name L.TextColor3 = T.Tx
    L.Font = T.F L.TextSize = 13 L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = R.ZIndex+2 L.Parent = R
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0,140,0,26) Box.Position = UDim2.new(1,-152,0.5,-13)
    Box.BackgroundColor3 = T.Bg3 Box.Text = tostring(F[flag]) Box.TextColor3 = T.Tx
    Box.Font = T.F Box.TextSize = 12 Box.BorderSizePixel = 0 Box.ClearTextOnFocus = false
    Box.ZIndex = R.ZIndex+2 Box.Parent = R round(Box,7) stroke(Box,T.Stroke,1,0.5)
    Box.FocusLost:Connect(function()
        F[flag] = tonumber(Box.Text) or Box.Text
        if cb then cb(F[flag]) end
    end)
    return R
end

local function showPage(name)
    for pn,p in pairs(Pages) do p.Visible = (pn==name) end
    ActivePage = name
end

local function mkTopTab(name, pageName)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0,96,0,30) B.BackgroundColor3 = T.El
    B.BackgroundTransparency = 0.55 B.Text = "" B.AutoButtonColor = false B.Parent = TTabs
    round(B,999) stroke(B,T.Stroke,1,0.6)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,0,1,0) L.BackgroundTransparency = 1
    L.Text = name L.TextColor3 = T.TxD L.Font = T.FS L.TextSize = 11
    L.ZIndex = B.ZIndex+2 L.Parent = B
    local Un = Instance.new("Frame")
    Un.Size = UDim2.new(0,0,0,2) Un.Position = UDim2.new(0.5,0,1,-3)
    Un.BackgroundColor3 = T.Acc Un.BorderSizePixel = 0 Un.ZIndex = B.ZIndex+3 Un.Parent = B round(Un,999)
    grad(Un,T.Acc,T.Acc2,0)
    local function act()
        for _,d in pairs(Tabs) do
            tw(d.label,{TextColor3=T.TxD},0.2):Play()
            tw(d.ul,{Size=UDim2.new(0,0,0,2),Position=UDim2.new(0.5,0,1,-3)},0.2):Play()
            tw(d.btn,{BackgroundTransparency=0.55},0.2):Play()
        end
        tw(L,{TextColor3=T.Tx},0.2):Play()
        tw(Un,{Size=UDim2.new(0.7,0,0,2),Position=UDim2.new(0.15,0,1,-3)},0.25):Play()
        tw(B,{BackgroundTransparency=0.3},0.2):Play()
        showPage(pageName) ActiveTab = name
    end
    Tabs[name] = {btn=B,label=L,ul=Un,activate=act,page=pageName}
    B.MouseButton1Click:Connect(act) return B
end

local function mkSbItem(name, topTab)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,0,0,28) B.BackgroundColor3 = T.El
    B.BackgroundTransparency = 1 B.Text = "" B.AutoButtonColor = false
    B.ZIndex = 15 B.Parent = SbSc round(B,7)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-16,1,0) L.Position = UDim2.new(0,14,0,0)
    L.BackgroundTransparency = 1 L.Text = name L.TextColor3 = T.TxD
    L.Font = T.FS L.TextSize = 12 L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = 16 L.Parent = B
    B.MouseEnter:Connect(function()
        if ActivePage~=name then
            tw(B,{BackgroundTransparency=0.6},0.15):Play()
            tw(L,{TextColor3=T.Tx},0.15):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if ActivePage~=name then
            tw(B,{BackgroundTransparency=1},0.15):Play()
            tw(L,{TextColor3=T.TxD},0.15):Play()
        end
    end)
    B.MouseButton1Click:Connect(function()
        for _,d in pairs(SbItems) do
            tw(d.btn,{BackgroundTransparency=1},0.2):Play()
            tw(d.lbl,{TextColor3=T.TxD},0.2):Play()
        end
        tw(B,{BackgroundTransparency=0.4},0.2):Play()
        tw(L,{TextColor3=T.Tx},0.2):Play()
        if topTab and Tabs[topTab] then Tabs[topTab].activate() end
    end)
    table.insert(SbItems,{btn=B,lbl=L,name=name}) return B
end

-- ============ BUILD MENU ============
mkSbItem("Main","ESP")
mkSbItem("Movement","Movement")
mkSbItem("Visuals","Visuals")
mkSbItem("Farm","Farm")
mkSbItem("Teleport","Teleport")
mkSbItem("Server","Server")
mkSbItem("Fun/Troll","Fun")
mkSbItem("Themes","Themes")
mkSbItem("Settings","Settings")
mkSbItem("Info","Info")

for _,n in ipairs({"ESP","Movement","Visuals","Farm","Teleport","Server","Fun","Themes","Settings","Info"}) do mkPage(n) end
mkTopTab("ESP","ESP")
mkTopTab("Movement","Movement")
mkTopTab("Visuals","Visuals")
mkTopTab("Farm","Farm")
mkTopTab("Teleport","Teleport")
mkTopTab("Server","Server")
mkTopTab("Fun","Fun")
mkTopTab("Themes","Themes")
mkTopTab("Settings","Settings")
mkTopTab("Info","Info")

-- ESP PAGE
local p = Pages.ESP
mkSection(p,"ESP")
mkToggle(p,"Enable ESP","ESP_Enabled")
mkToggle(p,"Role Colors","ESP_Role")
mkToggle(p,"Names","ESP_Name")
mkToggle(p,"Boxes","ESP_Box")
mkToggle(p,"Tracers","ESP_Tracer")
mkToggle(p,"Health","ESP_Health")
mkToggle(p,"Distance","ESP_Distance")
mkToggle(p,"Chams","ESP_Chams")
mkDiv(p)
mkSection(p,"Настройки")
mkSlider(p,"Transparency","ESP_Transparency",0,100,"%")

-- MOVEMENT
p = Pages.Movement
mkSection(p,"Movement")
mkSlider(p,"Walkspeed","MOVE_Walkspeed",16,200,"",function(v)
    local c = LP.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=v end
end)
mkSlider(p,"JumpPower","MOVE_JumpPower",50,300,"",function(v)
    local c = LP.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.JumpPower=v c.Humanoid.UseJumpPower=true end
end)
mkToggle(p,"Fly","MOVE_Fly")
mkSlider(p,"Fly Speed","MOVE_FlySpeed",20,300,"")
mkToggle(p,"Infinite Jump","MOVE_InfiniteJump")
mkToggle(p,"NoClip","MOVE_NoClip")
mkToggle(p,"Sprint (Shift)","MOVE_Sprint")
mkDiv(p)
mkButton(p,"Reset Character",function()
    local c = LP.Character if c then c:BreakJoints() end
end)

-- VISUALS
p = Pages.Visuals
mkSection(p,"World")
mkToggle(p,"FullBright","VIS_FullBright")
mkToggle(p,"No Fog","VIS_NoFog")
mkToggle(p,"X-Ray","VIS_XRay")
mkSlider(p,"X-Ray Strength","VIS_XRayStrength",0,100,"%")
mkDiv(p)
mkSection(p,"Aim")
mkToggle(p,"Enable Aimbot","AIM_Enabled")
mkToggle(p,"Visible Check","AIM_Visible")
mkToggle(p,"Show FOV Circle","AIM_ShowFOV")
mkToggle(p,"Trigger Bot","AIM_Trigger")
mkSlider(p,"Aimbot FOV","AIM_FOV",30,500,"")
mkSlider(p,"Aimbot Smooth","AIM_Smooth",0,100,"%")
mkDiv(p)
mkToggle(p,"Custom FOV Circle","VIS_FOVCircle")
mkSlider(p,"FOV Circle Radius","VIS_FOVRadius",30,500,"")
mkDiv(p)
mkButton(p,"Reset Lighting",function()
    Lighting.Ambient = Color3.fromRGB(70,70,70)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
end)

-- FARM
p = Pages.Farm
mkSection(p,"Farm")
mkToggle(p,"Auto Collect Coins","FARM_AutoCoins")
mkToggle(p,"Auto Pickup Drops","FARM_AutoDrops")
mkDiv(p)
mkSection(p,"Утилиты")
mkButton(p,"TP to Drop",function()
    for _,o in ipairs(WS:GetDescendants()) do
        if o:IsA("BasePart") and (o.Name=="GunDrop" or o.Name=="KnifeDrop" or o.Name=="Drop") then
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = o.CFrame + Vector3.new(0,2,0)
            end
            break
        end
    end
end)

-- TELEPORT
p = Pages.Teleport
mkSection(p,"Players")
local PlayerButtons = {}
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP then
        PlayerButtons[plr] = mkButton(p, "TP → "..plr.Name, function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                notify("Teleport", "К "..plr.Name, 2)
            end
        end)
    end
end
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LP then
        PlayerButtons[plr] = mkButton(p, "TP → "..plr.Name, function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
        end)
    end
end)
mkDiv(p)
mkSection(p,"Positions")
local savedPos = nil
mkButton(p,"Save Position",function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = LP.Character.HumanoidRootPart.CFrame
        notify("Position","Сохранено",2,T.Grn)
    end
end)
mkButton(p,"Load Position",function()
    if savedPos and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = savedPos
    end
end)

-- SERVER
p = Pages.Server
mkSection(p,"Server")
mkButton(p,"Server Hop",function()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local ok, res = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
    if ok and res and res.data then
        for _,srv in ipairs(res.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LP)
                break
            end
        end
    else
        notify("Server Hop","Не удалось",2,T.Red)
    end
end)
mkButton(p,"Rejoin",function()
    TeleportService:Teleport(game.PlaceId, LP)
end)
mkButton(p,"Copy Job ID",function()
    if setclip then
        setclip(game.JobId)
        notify("Job ID","Скопирован",2,T.Acc2)
    end
end)

-- FUN
p = Pages.Fun
mkSection(p,"Troll")
mkToggle(p,"Fling Players","FUN_Fling")
mkToggle(p,"Spin Bot","FUN_SpinBot")
mkToggle(p,"Bunny Hop","FUN_BunnyHop")
mkToggle(p,"Auto Dance","FUN_Dance")
mkDiv(p)
mkSection(p,"Physics")
mkButton(p,"Kill All (если убийца)",function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local h = plr.Character:FindFirstChild("Humanoid")
            if h then h.Health = 0 end
        end
    end
end)

-- THEMES
p = Pages.Themes
mkSection(p,"Тема")
mkDropdown(p,"Тема интерфейса","THEME_Name", {"Pink","Cyan","Purple","Red","Green","Blue"}, function(v)
    applyTheme(v)
    notify("Тема", "Применено: "..v, 2, T.Acc)
    -- Подсветка активного таба
    if ActiveTab and Tabs[ActiveTab] then Tabs[ActiveTab].activate() end
    -- Обводка главного окна
    for _,s in ipairs(Main:GetChildren()) do
        if s:IsA("UIStroke") then s.Color = T.Acc end
    end
    TBG.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,T.Acc),ColorSequenceKeypoint.new(0.5,T.Acc2),ColorSequenceKeypoint.new(1,T.Acc3)})
    grad(HI,T.Acc,T.Acc2,45)
    VT.TextColor3 = T.Acc
end)
mkDiv(p)
mkSection(p,"Keybinds")
mkTextbox(p,"Bind: Fly","BIND_Fly")
mkTextbox(p,"Bind: Aimbot","BIND_Aimbot")
mkTextbox(p,"Bind: ESP","BIND_ESP")
mkTextbox(p,"Bind: Show/Hide UI","BIND_UI")

-- SETTINGS
p = Pages.Settings
mkSection(p,"General")
mkToggle(p,"Anti-AFK","MISC_AntiAFK")
mkToggle(p,"Show FPS","MISC_ShowFPS")
mkDiv(p)
mkSection(p,"Config")
mkTextbox(p,"Discord","MISC_Discord")
mkButton(p,"Save Config",function()
    if writef then
        local data = Http:JSONEncode(F)
        writef("fb_config.json", data)
        notify("Config","Сохранено",2,T.Grn)
    else
        notify("Config","writefile недоступен",2,T.Red)
    end
end)
mkButton(p,"Load Config",function()
    if readf and isf and isf("fb_config.json") then
        local d = Http:JSONDecode(readf("fb_config.json"))
        for k,v in pairs(d) do F[k]=v end
        notify("Config","Загружено",2,T.Grn)
    else
        notify("Config","Файл не найден",2,T.Red)
    end
end)
mkDiv(p)
mkButton(p,"Destroy UI",function() Gui:Destroy() end)

-- INFO
p = Pages.Info
mkSection(p,"Информация")
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1,0,0,120)
infoLabel.BackgroundColor3 = T.El
infoLabel.BackgroundTransparency = 0.4
infoLabel.TextColor3 = T.Tx
infoLabel.Font = T.F
infoLabel.TextSize = 12
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextWrapped = true
infoLabel.Text = "Загрузка..."
infoLabel.Parent = p
round(infoLabel,9) stroke(infoLabel,T.Stroke,1,0.6)
local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0,14)
pad.PaddingTop = UDim.new(0,10)
pad.Parent = infoLabel

mkSection(p,"Кредиты")
local cr = Instance.new("TextLabel")
cr.Size = UDim2.new(1,0,0,80)
cr.BackgroundColor3 = T.El
cr.BackgroundTransparency = 0.4
cr.TextColor3 = T.Tx
cr.Font = T.F
cr.TextSize = 12
cr.TextXAlignment = Enum.TextXAlignment.Left
cr.TextYAlignment = Enum.TextYAlignment.Top
cr.TextWrapped = true
cr.Text = "Femboy Hub v2.1\nАвтор: ViRuS/Prototip\nСтиль: Glossy Modern\nDiscord: "..F.MISC_Discord
cr.Parent = p
round(cr,9) stroke(cr,T.Stroke,1,0.6)
local crp = Instance.new("UIPadding")
crp.PaddingLeft = UDim.new(0,14)
crp.PaddingTop = UDim.new(0,10)
crp.Parent = cr

mkButton(p,"Обновить информацию",function()
    local fps = math.floor(1/RunService.RenderStepped:Wait())
    local mem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
    local ping = "N/A"
    pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).."ms" end)
    infoLabel.Text = 
        "Игрок: "..LP.Name..
        "\nUserID: "..LP.UserId..
        "\nИгра: "..game.PlaceId..
        "\nСервер: "..game.JobId..
        "\nFPS: "..fps..
        "\nПинг: "..ping..
        "\nПамять: "..mem.." MB"..
        "\nИгроков: "..#Players:GetPlayers().."/"..Players.MaxPlayers
end)

Tabs.ESP.activate()

-- ============ LOGIC ============

-- ESP
local espCache = {}
local function getRole(p)
    if p == LP then return "innocent" end
    local c = p.Character
    if not c then return "innocent" end
    if c:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then return "murder" end
    if c:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then return "sheriff" end
    return "innocent"
end
local function getCol(p)
    local r = getRole(p)
    if r == "murder" then return F.ESP_ColorMurder end
    if r == "sheriff" then return F.ESP_ColorSheriff end
    return F.ESP_ColorInnocent
end

local function createESPObj(p)
    if p == LP or espCache[p] then return end
    espCache[p] = {
        box = Instance.new("Frame"),
        name = Instance.new("TextLabel"),
        dist = Instance.new("TextLabel"),
        tracer = Instance.new("Frame"),
        hl = nil,
    }
    local d = espCache[p]
    d.box.BackgroundTransparency = 1 d.box.BorderSizePixel = 0 d.box.ZIndex = 1 d.box.Parent = Gui
    stroke(d.box, F.ESP_ColorInnocent, 1, 0)
    d.name.BackgroundTransparency = 1 d.name.TextColor3 = Color3.new(1,1,1)
    d.name.Font = T.FB d.name.TextSize = 13 d.name.ZIndex = 2 d.name.Parent = Gui
    stroke(d.name, Color3.new(0,0,0), 1, 0.4)
    d.dist.BackgroundTransparency = 1 d.dist.TextColor3 = Color3.new(1,1,1)
    d.dist.Font = T.F d.dist.TextSize = 11 d.dist.ZIndex = 2 d.dist.Parent = Gui
    d.tracer.BackgroundColor3 = Color3.new(1,1,1) d.tracer.BorderSizePixel = 0
    d.tracer.ZIndex = 1 d.tracer.Parent = Gui
end

for _,p in ipairs(Players:GetPlayers()) do createESPObj(p) end
Players.PlayerAdded:Connect(createESPObj)
Players.PlayerRemoving:Connect(function(p)
    if espCache[p] then
        for _,o in pairs(espCache[p]) do pcall(function() o:Destroy() end) end
        espCache[p] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if not espCache[p] then createESPObj(p) end
        local d = espCache[p]
        if not d then continue end
        local char = p.Character
        local col = getCol(p)
        if F.ESP_Chams and char then
            if not d.hl or d.hl.Parent ~= char then
                if d.hl then d.hl:Destroy() end
                d.hl = Instance.new("Highlight")
                d.hl.Parent = char d.hl.Adornee = char
            end
            d.hl.FillColor = col d.hl.OutlineColor = col
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
                local bp = Vector2.new(pos.X-size.X/2, pos.Y-size.Y/2)
                d.box.Visible = F.ESP_Box
                if F.ESP_Box then
                    d.box.Position = UDim2.new(0,bp.X,0,bp.Y)
                    d.box.Size = UDim2.new(0,size.X,0,size.Y)
                    for _,s in ipairs(d.box:GetChildren()) do
                        if s:IsA("UIStroke") then s.Color = col s.Transparency = 0 end
                    end
                end
                d.name.Visible = F.ESP_Name
                if F.ESP_Name then
                    d.name.Text = p.Name
                    d.name.Position = UDim2.new(0,pos.X-size.X/2,0,bp.Y-18)
                    d.name.Size = UDim2.new(0,size.X,0,16)
                    d.name.TextColor3 = col
                end
                d.dist.Visible = F.ESP_Distance
                if F.ESP_Distance then
                    local dist = math.floor((Cam.CFrame.Position-hrp.Position).Magnitude)
                    d.dist.Text = dist.."m"
                    d.dist.Position = UDim2.new(0,pos.X-size.X/2,0,bp.Y+size.Y+2)
                    d.dist.Size = UDim2.new(0,size.X,0,14)
                    d.dist.TextColor3 = T.TxD
                end
                d.tracer.Visible = F.ESP_Tracer
                if F.ESP_Tracer then
                    local origin = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
                    local target = Vector2.new(pos.X, bp.Y+size.Y)
                    local dx, dy = target.X-origin.X, target.Y-origin.Y
                    local length = math.sqrt(dx*dx+dy*dy)
                    local angle = math.deg(math.atan2(dy,dx))
                    d.tracer.Position = UDim2.new(0,origin.X,0,origin.Y)
                    d.tracer.Size = UDim2.new(0,length,0,1)
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
fovCircle.Size = UDim2.new(0,100,0,100) fovCircle.BackgroundTransparency = 1
fovCircle.ZIndex = 500 fovCircle.Visible = false fovCircle.Parent = Gui
round(fovCircle,999)
local fovStroke = stroke(fovCircle, T.Acc, 1.5, 0.2)
RunService.RenderStepped:Connect(function()
    fovCircle.Visible = F.VIS_FOVCircle or F.AIM_ShowFOV
    local r = F.VIS_FOVCircle and F.VIS_FOVRadius or F.AIM_FOV
    fovCircle.Size = UDim2.new(0,r*2,0,r*2)
    fovCircle.Position = UDim2.new(0.5, -r, 0.5, -r)
    fovStroke.Color = F.VIS_FOVCircle and T.Acc or T.Acc2
end)

-- Aim
local aiming = false
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end
end)

RunService.RenderStepped:Connect(function()
    if not F.AIM_Enabled or not aiming then return end
    local closest, shortest = nil, F.AIM_FOV
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                    if dist < shortest then shortest = dist closest = hrp end
                end
            end
        end
    end
    if closest then
        local smooth = (100 - F.AIM_Smooth)/100
        Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, closest.Position), smooth)
    end
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
        Lighting.FogEnd = 1e6 Lighting.FogStart = 1e6
    end
end)

-- XRay
RunService.RenderStepped:Connect(function()
    if not F.VIS_XRay then return end
    local c = LP.Character
    if c then
        for _,pt in ipairs(c:GetDescendants()) do
            if pt:IsA("BasePart") and pt.Name ~= "HumanoidRootPart" then
                pt.LocalTransparencyModifier = 1 - (F.VIS_XRayStrength/100)
            end
        end
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
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        flyBV.Velocity = dir * F.MOVE_FlySpeed
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
        for _,pt in ipairs(c:GetDescendants()) do
            if pt:IsA("BasePart") then pt.CanCollide = false end
        end
    end
end)

-- Sprint
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.LeftShift and F.MOVE_Sprint then
        local c = LP.Character
        if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = F.MOVE_Walkspeed + 25 end
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.LeftShift and F.MOVE_Sprint then
        local c = LP.Character
        if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = F.MOVE_Walkspeed end
    end
end)

-- Anti-AFK
if F.MISC_AntiAFK then
    pcall(function()
        LP.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

-- Auto Coins
RunService.Heartbeat:Connect(function()
    if not F.FARM_AutoCoins then return end
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    for _,o in ipairs(WS:GetDescendants()) do
        if o.Name == "Coin" and o:IsA("BasePart") then
            pcall(function() c.HumanoidRootPart.CFrame = o.CFrame end)
        end
    end
end)

-- Auto Drops
RunService.Heartbeat:Connect(function()
    if not F.FARM_AutoDrops then return end
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    for _,o in ipairs(WS:GetDescendants()) do
        if o:IsA("BasePart") and (o.Name == "GunDrop" or o.Name == "KnifeDrop" or o.Name == "Drop") then
            pcall(function() c.HumanoidRootPart.CFrame = o.CFrame end)
        end
    end
end)

-- Spin Bot
RunService.Heartbeat:Connect(function()
    if not F.FUN_SpinBot then return end
    local c = LP.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(15),0)
    end
end)

-- Fling
RunService.Heartbeat:Connect(function()
    if not F.FUN_Fling then return end
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (c.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < 6 then
                p.Character.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Bunny Hop
RunService.Heartbeat:Connect(function()
    if not F.FUN_BunnyHop then return end
    local c = LP.Character
    if c and c:FindFirstChild("Humanoid") then
        if c.Humanoid.FloorMaterial ~= Enum.Material.Air then c.Humanoid.Jump = true end
    end
end)

-- Dance
RunService.Heartbeat:Connect(function()
    if not F.FUN_Dance then return end
    local c = LP.Character
    if c then
        local hum = c:FindFirstChild("Humanoid")
        if hum then
            local anim = hum:FindFirstChild("Animator")
            if anim then
                local dance = Instance.new("Animation")
                dance.AnimationId = "rbxassetid://507771019"
                local track = anim:LoadAnimation(dance)
                track:Play()
            end
        end
    end
end)

-- Keybinds
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

-- FPS
local statsLabel
local fpsC, fpsT, fpsV = 0,0,0
RunService.RenderStepped:Connect(function(dt)
    fpsC += 1 fpsT += dt
    if fpsT >= 1 then fpsV = fpsC fpsC = 0 fpsT = 0 end
    if F.MISC_ShowFPS then
        if not statsLabel then
            statsLabel = Instance.new("TextLabel")
            statsLabel.Size = UDim2.new(0,100,0,22)
            statsLabel.Position = UDim2.new(0,10,0,10)
            statsLabel.BackgroundColor3 = T.Bg
            statsLabel.BackgroundTransparency = 0.3
            statsLabel.TextColor3 = T.Tx
            statsLabel.Font = T.FB
            statsLabel.TextSize = 11
            statsLabel.BorderSizePixel = 0
            statsLabel.ZIndex = 50
            statsLabel.Parent = Gui
            round(statsLabel,6) stroke(statsLabel,T.Stroke,1,0.5)
        end
        statsLabel.Text = "FPS: "..fpsV
    elseif statsLabel then
        statsLabel:Destroy() statsLabel = nil
    end
end)

-- Close
CB.MouseButton1Click:Connect(function()
    tw(Main,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.25):Play()
    task.wait(0.3)
    Gui:Destroy()
    _G.FB_Loaded = false
end)

-- Minimize
local minimized = false
MB.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        tw(Sb,{Position=UDim2.new(0,-170,0,48)},0.2):Play()
        tw(Ct,{Position=UDim2.new(0,0,0,48)},0.2):Play()
        tw(Main,{Size=UDim2.new(0,700,0,48)},0.25):Play()
    else
        tw(Sb,{Position=UDim2.new(0,0,0,48)},0.2):Play()
        tw(Ct,{Position=UDim2.new(0,170,0,48)},0.2):Play()
        tw(Main,{Size=UDim2.new(0,700,0,470)},0.25):Play()
    end
end)

-- Fade in
Main.Size = UDim2.new(0,0,0,0)
Main.Position = UDim2.new(0.5,0,0.5,0)
Tween:Create(Main,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size = UDim2.new(0,700,0,470),
    Position = UDim2.new(0.5,-350,0.5,-235)
}):Play()

notify("Femboy Hub v2.1","Загружено 💖",4)
print("[Femboy Hub v2.1] loaded")