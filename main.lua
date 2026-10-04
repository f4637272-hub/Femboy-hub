--[[ Femboy x Pumpkin UI 🎃 | v5.1 | Silent Aim + Auto Shoot + Halloween ]]
if _G.FB_Loaded then return end
_G.FB_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local WS = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Cam = WS.CurrentCamera

local IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled
local WIN_W = IS_MOBILE and 620 or 720
local WIN_H = IS_MOBILE and 380 or 430

local function safe(fn,d) local ok,r=pcall(fn) if ok and r~=nil then return r end return d end
local gethuiS = safe(function() return gethui() end, nil)
local setclip = safe(function() return setclipboard end, nil)
local Parent = gethuiS or CoreGui

for _,g in ipairs({Parent,CoreGui}) do
    if g and g:FindFirstChild("FemboyUI") then g.FemboyUI:Destroy() end
end

-- ================= FLAGS =================
local F = {
    ESP_Enabled=false, ESP_Name=false, ESP_Box=false, ESP_Tracer=false,
    ESP_Distance=false, ESP_Chams=false, ESP_Role=false,
    ESP_Gun=false, ESP_Coins=false, ESP_Traps=false, ESP_Transparency=30,
    CB_SilentAim=false, CB_AutoShoot=false, CB_KillAura=false, CB_AntiAim=false,
    CB_FOVRadius=150, CB_SilentHitPart="Head", CB_AutoShootDelay=0.15,
    CB_ShowFOVCircle=false, CB_VisibleCheck=true, CB_MaxRange=500,
    FL_Selected=false, FL_All=false, FL_Sheriff=false, FL_Murderer=false,
    FL_Power=1e5, FL_Cooldown=0.5,
    MV_Walkspeed=16, MV_JumpPower=50, MV_Fly=false, MV_FlySpeed=60,
    MV_NoClip=false, MV_InfJump=false,
    VS_FullBright=false, VS_NoFog=false, VS_XRay=false, VS_XRayStr=70,
    VS_Bloom=false, VS_CC=false, VS_Trail=false, VS_Headless=false,
    FM_AutoCoins=false, FM_AutoDrops=false, FM_AutoKill=false,
    FN_Spin=false, FN_BunnyHop=false,
    MS_AntiAFK=true, MS_ShowFPS=true,
    TH_Name="Halloween",
}

-- ================= THEME =================
local THEMES = {
    Halloween = {Acc=Color3.fromRGB(255,100,0), Acc2=Color3.fromRGB(180,0,255), Bg=Color3.fromRGB(15,12,20)},
    Pumpkin   = {Acc=Color3.fromRGB(255,140,20), Acc2=Color3.fromRGB(255,180,60), Bg=Color3.fromRGB(18,14,22)},
    Blood     = {Acc=Color3.fromRGB(220,40,40), Acc2=Color3.fromRGB(140,0,0), Bg=Color3.fromRGB(18,10,14)},
    Ghost     = {Acc=Color3.fromRGB(200,200,240), Acc2=Color3.fromRGB(150,150,200), Bg=Color3.fromRGB(18,16,24)},
    Rose      = {Acc=Color3.fromRGB(255,105,180), Acc2=Color3.fromRGB(255,150,200), Bg=Color3.fromRGB(22,18,24)},
    Cyan      = {Acc=Color3.fromRGB(120,220,255), Acc2=Color3.fromRGB(160,240,255), Bg=Color3.fromRGB(18,22,26)},
}
local T = {
    Bg=Color3.fromRGB(15,12,20), Bg2=Color3.fromRGB(25,20,35), Bg3=Color3.fromRGB(40,32,50),
    Panel=Color3.fromRGB(34,26,44), El=Color3.fromRGB(48,38,60), Hover=Color3.fromRGB(64,50,80),
    Tx=Color3.fromRGB(240,230,250), TxD=Color3.fromRGB(150,140,165),
    Grn=Color3.fromRGB(40,200,80), Red=Color3.fromRGB(220,40,40),
    Stroke=Color3.fromRGB(64,50,80),
    F=Enum.Font.GothamMedium, FB=Enum.Font.GothamBold, FS=Enum.Font.GothamSemibold,
}
local function applyTheme(name)
    local t = THEMES[name] or THEMES.Halloween
    T.Acc, T.Acc2, T.Bg = t.Acc, t.Acc2, t.Bg
    F.TH_Name = name
end
applyTheme(F.TH_Name)

local function round(o,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 6) c.Parent=o return c end
local function stroke(o,c,t,tr) local s=Instance.new("UIStroke") s.Color=c or T.Stroke s.Thickness=t or 1 s.Transparency=tr or 0 s.Parent=o return s end
local function tw(o,p,t) return Tween:Create(o,TweenInfo.new(t or 0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p) end

-- Notify
local NH
local function notify(title,desc,dur,color)
    dur=dur or 3 color=color or T.Acc
    if not NH or not NH.Parent then
        NH=Instance.new("Frame") NH.Name="FB_Notif"
        NH.Size=UDim2.new(0,240,1,-40) NH.Position=UDim2.new(1,-260,0,20)
        NH.BackgroundTransparency=1 NH.ZIndex=500 NH.Parent=Parent
        local l=Instance.new("UIListLayout") l.Padding=UDim.new(0,8)
        l.VerticalAlignment=Enum.VerticalAlignment.Top l.Parent=NH
    end
    local n=Instance.new("Frame") n.Size=UDim2.new(1,0,0,48)
    n.Position=UDim2.new(1,60,0,0) n.BackgroundColor3=T.Bg2 n.BackgroundTransparency=0.1
    n.BorderSizePixel=0 n.ZIndex=501 n.Parent=NH
    round(n,8) stroke(n,color,1,0.3)
    local bar=Instance.new("Frame") bar.Size=UDim2.new(0,3,1,-12) bar.Position=UDim2.new(0,3,0,6)
    bar.BackgroundColor3=color bar.BorderSizePixel=0 bar.ZIndex=502 bar.Parent=n round(bar,999)
    local tl=Instance.new("TextLabel") tl.Size=UDim2.new(1,-20,0,18) tl.Position=UDim2.new(0,14,0,6)
    tl.BackgroundTransparency=1 tl.Text=title tl.TextColor3=T.Tx tl.Font=T.FB tl.TextSize=12
    tl.TextXAlignment=Enum.TextXAlignment.Left tl.ZIndex=502 tl.Parent=n
    local dl=Instance.new("TextLabel") dl.Size=UDim2.new(1,-20,0,16) dl.Position=UDim2.new(0,14,0,24)
    dl.BackgroundTransparency=1 dl.Text=desc dl.TextColor3=T.TxD dl.Font=T.F dl.TextSize=10
    dl.TextXAlignment=Enum.TextXAlignment.Left dl.ZIndex=502 dl.Parent=n
    tw(n,{Position=UDim2.new(0,0,0,0)},0.3):Play()
    task.delay(dur,function()
        if not n or not n.Parent then return end
        local o=tw(n,{Position=UDim2.new(1,60,0,0)},0.25) o:Play() o.Completed:Wait()
        if n then n:Destroy() end
    end)
end

-- ================= GUI =================
local Gui=Instance.new("ScreenGui")
Gui.Name="FemboyUI" Gui.ResetOnSpawn=false Gui.IgnoreGuiInset=true
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling Gui.Parent=Parent

local Main=Instance.new("Frame")
Main.Size=UDim2.new(0,WIN_W,0,WIN_H)
Main.Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
Main.BackgroundColor3=T.Bg Main.BackgroundTransparency=0.05
Main.BorderSizePixel=0 Main.Active=true Main.Draggable=true Main.ClipsDescendants=true
Main.ZIndex=10 Main.Parent=Gui
round(Main,12) stroke(Main,T.Acc,1.5,0.2)
if IS_MOBILE then Main.Position=UDim2.new(0.5,-WIN_W/2,0.1,0) end

-- Topbar
local Topbar=Instance.new("Frame")
Topbar.Size=UDim2.new(1,0,0,34) Topbar.BackgroundColor3=T.Bg2
Topbar.BackgroundTransparency=0.15 Topbar.BorderSizePixel=0 Topbar.ZIndex=11 Topbar.Parent=Main

local Logo=Instance.new("Frame")
Logo.Size=UDim2.new(0,24,0,24) Logo.Position=UDim2.new(0,10,0,5)
Logo.BackgroundColor3=T.Acc Logo.BorderSizePixel=0 Logo.ZIndex=13 Logo.Parent=Topbar
round(Logo,6)
local LogoLbl=Instance.new("TextLabel")
LogoLbl.Size=UDim2.new(1,0,1,0) LogoLbl.BackgroundTransparency=1
LogoLbl.Text="🎃" LogoLbl.TextSize=13 LogoLbl.ZIndex=14 LogoLbl.Parent=Logo

local HubName=Instance.new("TextLabel")
HubName.Size=UDim2.new(0,180,1,0) HubName.Position=UDim2.new(0,42,0,0)
HubName.BackgroundTransparency=1 HubName.Text="Femboy x Pumpkin 🎃"
HubName.TextColor3=T.Tx HubName.Font=T.FB HubName.TextSize=13
HubName.TextXAlignment=Enum.TextXAlignment.Left HubName.ZIndex=13 HubName.Parent=Topbar

local SearchBox=Instance.new("Frame")
SearchBox.Size=UDim2.new(0,180,0,22) SearchBox.Position=UDim2.new(0.5,-90,0,6)
SearchBox.BackgroundColor3=T.Bg3 SearchBox.BackgroundTransparency=0.3
SearchBox.BorderSizePixel=0 SearchBox.ZIndex=13 SearchBox.Parent=Topbar
round(SearchBox,6) stroke(SearchBox,T.Stroke,1,0.5)
local SInput=Instance.new("TextBox")
SInput.Size=UDim2.new(1,-16,1,0) SInput.Position=UDim2.new(0,8,0,0)
SInput.BackgroundTransparency=1 SInput.Text="" SInput.PlaceholderText="🔍 Search"
SInput.PlaceholderColor3=T.TxD SInput.TextColor3=T.Tx SInput.Font=T.F
SInput.TextSize=11 SInput.TextXAlignment=Enum.TextXAlignment.Left
SInput.ClearTextOnFocus=false SInput.ZIndex=14 SInput.Parent=SearchBox

local CB=Instance.new("TextButton")
CB.Size=UDim2.new(0,20,0,20) CB.Position=UDim2.new(1,-28,0,7)
CB.BackgroundColor3=T.Bg3 CB.BackgroundTransparency=0.4 CB.Text="✕"
CB.TextColor3=T.Tx CB.Font=T.FB CB.TextSize=10 CB.AutoButtonColor=false
CB.ZIndex=14 CB.Parent=Topbar round(CB,999) stroke(CB,T.Stroke,1,0.5)

-- Sidebar
local Sb=Instance.new("Frame")
Sb.Size=UDim2.new(0,44,1,-34) Sb.Position=UDim2.new(0,0,0,34)
Sb.BackgroundColor3=T.Bg2 Sb.BackgroundTransparency=0.3
Sb.BorderSizePixel=0 Sb.ZIndex=11 Sb.Parent=Main
local SbLine=Instance.new("Frame")
SbLine.Size=UDim2.new(0,1,1,0) SbLine.Position=UDim2.new(1,-1,0,0)
SbLine.BackgroundColor3=T.Stroke SbLine.BackgroundTransparency=0.5
SbLine.BorderSizePixel=0 SbLine.ZIndex=12 SbLine.Parent=Sb
local SbList=Instance.new("Frame")
SbList.Size=UDim2.new(1,0,1,0) SbList.BackgroundTransparency=1 SbList.ZIndex=12 SbList.Parent=Sb
local SbLL=Instance.new("UIListLayout")
SbLL.Padding=UDim.new(0,3) SbLL.SortOrder=Enum.SortOrder.LayoutOrder SbLL.Parent=SbList
local SbPad=Instance.new("UIPadding")
SbPad.PaddingTop=UDim.new(0,8) SbPad.PaddingLeft=UDim.new(0,6) SbPad.Parent=SbList

local Ct=Instance.new("Frame")
Ct.Size=UDim2.new(1,-44,1,-34) Ct.Position=UDim2.new(0,44,0,34)
Ct.BackgroundTransparency=1 Ct.ZIndex=11 Ct.Parent=Main

local Pages,SbItems={},{}
local ActivePage

local function mkPage(name)
    local p=Instance.new("ScrollingFrame")
    p.Name="P_"..name p.Size=UDim2.new(1,0,1,0)
    p.BackgroundTransparency=1 p.BorderSizePixel=0 p.ScrollBarThickness=3
    p.ScrollBarImageColor3=T.Acc p.CanvasSize=UDim2.new(0,0,0,0)
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y p.Visible=false
    p.ZIndex=12 p.Parent=Ct
    local l=Instance.new("UIListLayout")
    l.Padding=UDim.new(0,6) l.SortOrder=Enum.SortOrder.LayoutOrder l.Parent=p
    local pad=Instance.new("UIPadding")
    pad.PaddingTop=UDim.new(0,8) pad.PaddingLeft=UDim.new(0,10)
    pad.PaddingRight=UDim.new(0,10) pad.PaddingBottom=UDim.new(0,8) pad.Parent=p
    Pages[name]=p return p
end

local function mkCols(parent)
    local h=Instance.new("Frame")
    h.Size=UDim2.new(1,0,0,0) h.AutomaticSize=Enum.AutomaticSize.Y
    h.BackgroundTransparency=1 h.Parent=parent
    local l=Instance.new("UIListLayout")
    l.FillDirection=Enum.FillDirection.Horizontal l.Padding=UDim.new(0,8)
    l.SortOrder=Enum.SortOrder.LayoutOrder l.Parent=h
    local left=Instance.new("Frame")
    left.Size=UDim2.new(0.5,-4,0,0) left.AutomaticSize=Enum.AutomaticSize.Y
    left.BackgroundTransparency=1 left.Parent=h
    local ll=Instance.new("UIListLayout")
    ll.Padding=UDim.new(0,6) ll.SortOrder=Enum.SortOrder.LayoutOrder ll.Parent=left
    local right=Instance.new("Frame")
    right.Size=UDim2.new(0.5,-4,0,0) right.AutomaticSize=Enum.AutomaticSize.Y
    right.BackgroundTransparency=1 right.Parent=h
    local rl=Instance.new("UIListLayout")
    rl.Padding=UDim.new(0,6) rl.SortOrder=Enum.SortOrder.LayoutOrder rl.Parent=right
    return left,right
end

local function mkSection(parent,text)
    local h=Instance.new("Frame")
    h.Size=UDim2.new(1,0,0,18) h.BackgroundTransparency=1 h.Parent=parent
    local ln=Instance.new("Frame")
    ln.Size=UDim2.new(0,3,0,12) ln.Position=UDim2.new(0,0,0.5,-6)
    ln.BackgroundColor3=T.Acc ln.BorderSizePixel=0 ln.Parent=h round(ln,999)
    local lb=Instance.new("TextLabel")
    lb.Size=UDim2.new(1,-10,1,0) lb.Position=UDim2.new(0,10,0,0)
    lb.BackgroundTransparency=1 lb.Text=text lb.TextColor3=T.Tx
    lb.Font=T.FB lb.TextSize=11 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=h
    return h
end

local function mkToggle(parent,name,flag,cb)
    local R=Instance.new("Frame")
    R.Size=UDim2.new(1,0,0,26) R.BackgroundColor3=T.Panel
    R.BackgroundTransparency=0.5 R.BorderSizePixel=0 R.Parent=parent round(R,6)
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-40,1,0) L.Position=UDim2.new(0,10,0,0)
    L.BackgroundTransparency=1 L.Text=name L.TextColor3=T.Tx
    L.Font=T.F L.TextSize=11 L.TextXAlignment=Enum.TextXAlignment.Left
    L.ZIndex=R.ZIndex+2 L.Parent=R
    local Dot=Instance.new("Frame")
    Dot.Size=UDim2.new(0,8,0,8) Dot.Position=UDim2.new(1,-14,0.5,-4)
    Dot.BackgroundColor3=T.Bg3 Dot.BorderSizePixel=0 Dot.ZIndex=R.ZIndex+2 Dot.Parent=R
    round(Dot,999)
    local B=Instance.new("TextButton")
    B.Size=UDim2.new(1,0,1,0) B.BackgroundTransparency=1 B.Text=""
    B.ZIndex=R.ZIndex+4 B.Parent=R
    local function up(anim)
        local on=F[flag]
        if anim then tw(Dot,{BackgroundColor3=on and T.Acc or T.Bg3},0.2):Play()
        else Dot.BackgroundColor3=on and T.Acc or T.Bg3 end
        if cb then cb(on) end
    end
    B.MouseButton1Click:Connect(function() F[flag]=not F[flag] up(true) end)
    up(false)
    return R
end

local function mkSlider(parent,name,flag,min,max,suffix,cb)
    suffix=suffix or ""
    local R=Instance.new("Frame")
    R.Size=UDim2.new(1,0,0,34) R.BackgroundColor3=T.Panel
    R.BackgroundTransparency=0.5 R.BorderSizePixel=0 R.Parent=parent round(R,6)
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-60,0,16) L.Position=UDim2.new(0,10,0,2)
    L.BackgroundTransparency=1 L.Text=name L.TextColor3=T.Tx
    L.Font=T.F L.TextSize=11 L.TextXAlignment=Enum.TextXAlignment.Left
    L.ZIndex=R.ZIndex+2 L.Parent=R
    local V=Instance.new("TextLabel")
    V.Size=UDim2.new(0,50,0,16) V.Position=UDim2.new(1,-56,0,2)
    V.BackgroundTransparency=1 V.Text=tostring(F[flag])..suffix V.TextColor3=T.Acc
    V.Font=T.FS V.TextSize=10 V.TextXAlignment=Enum.TextXAlignment.Right
    V.ZIndex=R.ZIndex+2 V.Parent=R
    local BB=Instance.new("Frame")
    BB.Size=UDim2.new(1,-20,0,3) BB.Position=UDim2.new(0,10,0,24)
    BB.BackgroundColor3=T.Bg3 BB.BorderSizePixel=0 BB.ZIndex=R.ZIndex+2 BB.Parent=R round(BB,999)
    local Fi=Instance.new("Frame")
    Fi.Size=UDim2.new((F[flag]-min)/(max-min),0,1,0) Fi.BackgroundColor3=T.Acc
    Fi.BorderSizePixel=0 Fi.ZIndex=R.ZIndex+3 Fi.Parent=BB round(Fi,999)
    local drag=false
    local function upi(input)
        local pos=math.clamp((input.Position.X-BB.AbsolutePosition.X)/BB.AbsoluteSize.X,0,1)
        local val=min+(max-min)*pos
        if max<=10 then val=math.floor(val*100+0.5)/100
        else val=math.floor(val+0.5) end
        F[flag]=val V.Text=tostring(val)..suffix Fi.Size=UDim2.new(pos,0,1,0)
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

local function mkButton(parent,name,cb)
    local B=Instance.new("TextButton")
    B.Size=UDim2.new(1,0,0,26) B.BackgroundColor3=T.Panel
    B.BackgroundTransparency=0.5 B.Text="" B.AutoButtonColor=false
    B.Parent=parent round(B,6)
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-16,1,0) L.Position=UDim2.new(0,10,0,0)
    L.BackgroundTransparency=1 L.Text=name L.TextColor3=T.Tx
    L.Font=T.F L.TextSize=11 L.TextXAlignment=Enum.TextXAlignment.Left
    L.ZIndex=B.ZIndex+2 L.Parent=B
    B.MouseEnter:Connect(function() tw(B,{BackgroundTransparency=0.25},0.15):Play() end)
    B.MouseLeave:Connect(function() tw(B,{BackgroundTransparency=0.5},0.15):Play() end)
    B.MouseButton1Click:Connect(cb)
    return B
end

local function mkDropdown(parent,name,flag,options,cb)
    local R=Instance.new("Frame")
    R.Size=UDim2.new(1,0,0,26) R.BackgroundColor3=T.Panel
    R.BackgroundTransparency=0.5 R.BorderSizePixel=0 R.ClipsDescendants=true
    R.Parent=parent round(R,6)
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-110,1,0) L.Position=UDim2.new(0,10,0,0)
    L.BackgroundTransparency=1 L.Text=name L.TextColor3=T.Tx
    L.Font=T.F L.TextSize=11 L.TextXAlignment=Enum.TextXAlignment.Left
    L.ZIndex=R.ZIndex+2 L.Parent=R
    local Cur=Instance.new("TextLabel")
    Cur.Size=UDim2.new(0,80,1,0) Cur.Position=UDim2.new(1,-100,0,0)
    Cur.BackgroundTransparency=1 Cur.Text=F[flag] or options[1] Cur.TextColor3=T.Acc
    Cur.Font=T.FS Cur.TextSize=10 Cur.TextXAlignment=Enum.TextXAlignment.Right
    Cur.ZIndex=R.ZIndex+2 Cur.Parent=R
    local Ar=Instance.new("TextLabel")
    Ar.Size=UDim2.new(0,20,1,0) Ar.Position=UDim2.new(1,-20,0,0)
    Ar.BackgroundTransparency=1 Ar.Text="v" Ar.TextColor3=T.TxD
    Ar.Font=T.FB Ar.TextSize=10 Ar.ZIndex=R.ZIndex+2 Ar.Parent=R
    local B=Instance.new("TextButton")
    B.Size=UDim2.new(1,0,0,26) B.BackgroundTransparency=1 B.Text=""
    B.ZIndex=R.ZIndex+3 B.Parent=R
    local opened=false
    local expSize=26+#options*22
    B.MouseButton1Click:Connect(function()
        opened=not opened
        tw(R,{Size=opened and UDim2.new(1,0,0,expSize) or UDim2.new(1,0,0,26)},0.22):Play()
    end)
    local Opts=Instance.new("Frame")
    Opts.Size=UDim2.new(1,-16,0,#options*22) Opts.Position=UDim2.new(0,8,0,26)
    Opts.BackgroundTransparency=1 Opts.ZIndex=R.ZIndex+2 Opts.Parent=R
    local OL=Instance.new("UIListLayout")
    OL.Padding=UDim.new(0,2) OL.SortOrder=Enum.SortOrder.LayoutOrder OL.Parent=Opts
    for _,opt in ipairs(options) do
        local OB=Instance.new("TextButton")
        OB.Size=UDim2.new(1,0,0,20) OB.BackgroundColor3=T.Bg3
        OB.BackgroundTransparency=0.4 OB.Text="" OB.AutoButtonColor=false
        OB.ZIndex=R.ZIndex+3 OB.Parent=Opts round(OB,4)
        local OLb=Instance.new("TextLabel")
        OLb.Size=UDim2.new(1,-12,1,0) OLb.Position=UDim2.new(0,8,0,0)
        OLb.BackgroundTransparency=1 OLb.Text=opt OLb.TextColor3=T.Tx
        OLb.Font=T.F OLb.TextSize=10 OLb.TextXAlignment=Enum.TextXAlignment.Left
        OLb.ZIndex=R.ZIndex+4 OLb.Parent=OB
        OB.MouseButton1Click:Connect(function()
            F[flag]=opt Cur.Text=opt opened=false
            tw(R,{Size=UDim2.new(1,0,0,26)},0.22):Play()
            if cb then cb(opt) end
        end)
    end
    return R
end

local function mkSbItem(icon, pageName)
    local B=Instance.new("TextButton")
    B.Size=UDim2.new(0,32,0,32) B.BackgroundColor3=T.Panel
    B.BackgroundTransparency=1 B.Text="" B.AutoButtonColor=false
    B.ZIndex=13 B.Parent=SbList round(B,6)
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,0,1,0) L.BackgroundTransparency=1
    L.Text=icon L.TextColor3=T.TxD L.Font=T.FB L.TextSize=14
    L.ZIndex=14 L.Parent=B
    B.MouseEnter:Connect(function()
        if ActivePage~=pageName then
            tw(B,{BackgroundTransparency=0.5},0.15):Play()
            tw(L,{TextColor3=T.Tx},0.15):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if ActivePage~=pageName then
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
        tw(L,{TextColor3=T.Acc},0.2):Play()
        for pn,pg in pairs(Pages) do pg.Visible=(pn==pageName) end
        ActivePage=pageName
    end)
    table.insert(SbItems,{btn=B,lbl=L})
    return B
end

-- ================= BUILD =================
local p=mkPage("ESP")
local L,R=mkCols(p)
mkSection(L,"ESP")
mkToggle(L,"Enable ESP","ESP_Enabled")
mkToggle(L,"Names","ESP_Name")
mkToggle(L,"Role в нике","ESP_Role")
mkToggle(L,"Boxes","ESP_Box")
mkToggle(L,"Tracers","ESP_Tracer")
mkToggle(L,"Distance","ESP_Distance")
mkToggle(L,"Chams","ESP_Chams")
mkSlider(L,"Transparency","ESP_Transparency",0,100,"%")
mkSection(R,"Objects")
mkToggle(R,"Show Gun","ESP_Gun")
mkToggle(R,"Show Coins","ESP_Coins")
mkToggle(R,"Show Traps","ESP_Traps")

p=mkPage("Combat")
L,R=mkCols(p)
mkSection(L,"Silent Aim")
mkToggle(L,"Enable Silent Aim","CB_SilentAim")
mkToggle(L,"Visible Check","CB_VisibleCheck")
mkToggle(L,"Show FOV Circle","CB_ShowFOVCircle")
mkDropdown(L,"Hit Part","CB_SilentHitPart",{"Head","HumanoidRootPart","UpperTorso","Torso"})
mkSlider(L,"FOV Radius","CB_FOVRadius",30,600,"px")
mkSlider(L,"Max Range","CB_MaxRange",50,2000,"m")
mkSection(R,"Auto Shoot")
mkToggle(R,"Enable Auto Shoot","CB_AutoShoot")
mkSlider(R,"Shoot Delay","CB_AutoShootDelay",0.05,1,"s")
mkButton(R,"Test Shoot",function()
    local c=LP.Character
    if not c then return end
    for _,tool in ipairs(c:GetChildren()) do
        if tool:IsA("Tool") then pcall(function() tool:Activate() end) end
    end
    notify("Auto Shoot","Test",1.5)
end)
mkSection(R,"Other")
mkToggle(R,"Kill Aura","CB_KillAura")
mkToggle(R,"Anti-Aim","CB_AntiAim")

p=mkPage("Movement")
L,R=mkCols(p)
mkSection(L,"Movement")
mkSlider(L,"Walkspeed","MV_Walkspeed",16,300,"",function(v)
    local c=LP.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=v end
end)
mkSlider(L,"JumpPower","MV_JumpPower",50,400,"",function(v)
    local c=LP.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.JumpPower=v c.Humanoid.UseJumpPower=true end
end)
mkToggle(L,"Fly","MV_Fly")
mkSlider(L,"Fly Speed","MV_FlySpeed",20,400,"")
mkToggle(L,"NoClip","MV_NoClip")
mkToggle(L,"Infinite Jump","MV_InfJump")

p=mkPage("Visuals")
L,R=mkCols(p)
mkSection(L,"World")
mkToggle(L,"FullBright","VS_FullBright")
mkToggle(L,"No Fog","VS_NoFog")
mkToggle(L,"X-Ray","VS_XRay")
mkSlider(L,"X-Ray Strength","VS_XRayStr",0,100,"%")
mkSection(R,"Effects")
mkToggle(R,"Bloom","VS_Bloom")
mkToggle(R,"Color Correction","VS_CC")
mkToggle(R,"Particle Trail","VS_Trail")
mkToggle(R,"Headless","VS_Headless")

p=mkPage("Farm")
L,R=mkCols(p)
mkSection(L,"Auto")
mkToggle(L,"Auto Coins","FM_AutoCoins")
mkToggle(L,"Auto Drops","FM_AutoDrops")
mkToggle(L,"Auto Kill (murderer)","FM_AutoKill")
mkSection(R,"Teleport")
mkButton(R,"TP to Drop",function()
    for _,o in ipairs(WS:GetDescendants()) do
        if o:IsA("BasePart") and (o.Name=="GunDrop" or o.Name=="KnifeDrop" or o.Name=="Drop") then
            local c=LP.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame=o.CFrame+Vector3.new(0,2,0)
            end
            break
        end
    end
end)
mkButton(R,"TP to Lobby",function()
    local c=LP.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame=CFrame.new(0,50,0)
    end
end)

p=mkPage("FlingList")
L,R=mkCols(p)
mkSection(L,"Выбор игроков")
local flingSelected={}
local flingButtons={}
local function addPlayer(plr)
    if plr==LP or flingButtons[plr] then return end
    local B=Instance.new("TextButton")
    B.Size=UDim2.new(1,0,0,26) B.BackgroundColor3=T.Panel
    B.BackgroundTransparency=0.5 B.Text="" B.AutoButtonColor=false
    B.Parent=L round(B,6)
    local Lbl=Instance.new("TextLabel")
    Lbl.Size=UDim2.new(1,-40,1,0) Lbl.Position=UDim2.new(0,10,0,0)
    Lbl.BackgroundTransparency=1 Lbl.Text=plr.Name Lbl.TextColor3=T.Tx
    Lbl.Font=T.F Lbl.TextSize=11 Lbl.TextXAlignment=Enum.TextXAlignment.Left
    Lbl.ZIndex=B.ZIndex+2 Lbl.Parent=B
    local Dot=Instance.new("Frame")
    Dot.Size=UDim2.new(0,8,0,8) Dot.Position=UDim2.new(1,-20,0.5,-4)
    Dot.BackgroundColor3=T.Bg3 Dot.BorderSizePixel=0 Dot.ZIndex=B.ZIndex+2 Dot.Parent=B
    round(Dot,999)
    local function upd() Dot.BackgroundColor3=flingSelected[plr] and T.Acc or T.Bg3 end
    B.MouseButton1Click:Connect(function()
        flingSelected[plr]=not flingSelected[plr]
        upd()
    end)
    upd()
    flingButtons[plr]=B
end
for _,plr in ipairs(Players:GetPlayers()) do addPlayer(plr) end
Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(function(plr)
    if flingButtons[plr] then
        flingButtons[plr]:Destroy() flingButtons[plr]=nil flingSelected[plr]=nil
    end
end)
mkSection(R,"Fling")
mkToggle(R,"Fling Selected","FL_Selected")
mkToggle(R,"Fling All","FL_All")
mkToggle(R,"Fling Sheriff","FL_Sheriff")
mkToggle(R,"Fling Murderer","FL_Murderer")
mkSlider(R,"Fling Power","FL_Power",1000,500000,"")
mkSlider(R,"Cooldown","FL_Cooldown",0.1,5,"s")
mkButton(R,"Fling Selected Now",function()
    for plr,sel in pairs(flingSelected) do
        if sel and plr.Character then
            local thp=plr.Character:FindFirstChild("HumanoidRootPart")
            if thp then pcall(function() thp.Velocity=Vector3.new(1e5,1e5,1e5) end) end
        end
    end
end)

p=mkPage("Fun")
L,R=mkCols(p)
mkSection(L,"Fun")
mkToggle(L,"Spin Bot","FN_Spin")
mkToggle(L,"Bunny Hop","FN_BunnyHop")

p=mkPage("Settings")
L,R=mkCols(p)
mkSection(L,"General")
mkToggle(L,"Anti-AFK","MS_AntiAFK")
mkToggle(L,"Show FPS","MS_ShowFPS")
mkSection(R,"Theme")
mkDropdown(R,"Theme","TH_Name",{"Halloween","Pumpkin","Blood","Ghost","Rose","Cyan"},function(v)
    applyTheme(v)
    notify("Theme","Применено: "..v,2,T.Acc)
end)
mkButton(R,"Destroy UI",function()
    Gui:Destroy()
    _G.FB_Loaded=false
end)

p=mkPage("Info")
L,R=mkCols(p)
mkSection(L,"Info")
local infoLbl=Instance.new("TextLabel")
infoLbl.Size=UDim2.new(1,0,0,100) infoLbl.BackgroundColor3=T.Panel
infoLbl.BackgroundTransparency=0.5 infoLbl.TextColor3=T.Tx
infoLbl.Font=T.F infoLbl.TextSize=10 infoLbl.TextXAlignment=Enum.TextXAlignment.Left
infoLbl.TextYAlignment=Enum.TextYAlignment.Top infoLbl.TextWrapped=true
infoLbl.Text="Press Refresh" infoLbl.Parent=L round(infoLbl,6)
local ipad=Instance.new("UIPadding")
ipad.PaddingLeft=UDim.new(0,8) ipad.PaddingTop=UDim.new(0,6) ipad.Parent=infoLbl
mkSection(R,"Author")
local authLbl=Instance.new("TextLabel")
authLbl.Size=UDim2.new(1,0,0,90) authLbl.BackgroundColor3=T.Panel
authLbl.BackgroundTransparency=0.5 authLbl.TextColor3=T.Tx
authLbl.Font=T.F authLbl.TextSize=11 authLbl.TextXAlignment=Enum.TextXAlignment.Left
authLbl.TextYAlignment=Enum.TextYAlignment.Top authLbl.TextWrapped=true
authLbl.Text="🎃 Femboy x Pumpkin v5.1\nAuthor: Femboy\nSilent Aim + Auto Shoot\nDiscord: discord.gg/femboy"
authLbl.Parent=R round(authLbl,6) stroke(authLbl,T.Acc,1,0.4)
local apad=Instance.new("UIPadding")
apad.PaddingLeft=UDim.new(0,8) apad.PaddingTop=UDim.new(0,6) apad.Parent=authLbl
mkButton(R,"Refresh Info",function()
    local fps=60 pcall(function() local t0=tick() RunService.RenderStepped:Wait() fps=math.floor(1/(tick()-t0)) end)
    local ping="N/A" pcall(function() ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).."ms" end)
    infoLbl.Text="Player: "..LP.Name.."\nGame: "..game.PlaceId.."\nFPS: "..fps.."\nPing: "..ping.."\nPlayers: "..#Players:GetPlayers().."/"..Players.MaxPlayers
end)

mkSbItem("🎃","ESP")
mkSbItem("🎯","Combat")
mkSbItem("🏃","Movement")
mkSbItem("👁","Visuals")
mkSbItem("💰","Farm")
mkSbItem("🌀","FlingList")
mkSbItem("🎭","Fun")
mkSbItem("⚙","Settings")
mkSbItem("ℹ","Info")

Pages.ESP.Visible=true
ActivePage="ESP"

-- Watermark
local WM=Instance.new("Frame")
WM.Size=UDim2.new(0,170,0,20) WM.Position=UDim2.new(0.5,-85,0,6)
WM.BackgroundColor3=T.Bg2 WM.BackgroundTransparency=0.3
WM.BorderSizePixel=0 WM.ZIndex=20 WM.Parent=Gui
round(WM,6) stroke(WM,T.Acc,1,0.3)
local WMLbl=Instance.new("TextLabel")
WMLbl.Size=UDim2.new(1,-8,1,0) WMLbl.Position=UDim2.new(0,4,0,0)
WMLbl.BackgroundTransparency=1 WMLbl.TextColor3=T.Tx
WMLbl.Font=T.FB WMLbl.TextSize=10 WMLbl.ZIndex=21 WMLbl.Parent=WM

local fpsC,fpsT,fpsV=0,0,0
RunService.RenderStepped:Connect(function(dt)
    fpsC=fpsC+1 fpsT=fpsT+dt
    if fpsT>=1 then fpsV=fpsC fpsC=0 fpsT=0 end
    if F.MS_ShowFPS then
        WM.Visible=true
        local ping=0
        pcall(function() ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        WMLbl.Text=string.format("🎃 %d fps | %d ms", fpsV, ping)
    else WM.Visible=false end
end)

-- FOV Circle
local fovCircle=Instance.new("Frame")
fovCircle.Size=UDim2.new(0,100,0,100) fovCircle.BackgroundTransparency=1
fovCircle.ZIndex=500 fovCircle.Visible=false fovCircle.Parent=Gui
round(fovCircle,999)
local fovStroke=stroke(fovCircle,T.Acc,1.5,0.2)
RunService.RenderStepped:Connect(function()
    fovCircle.Visible=F.CB_ShowFOVCircle
    local r=F.CB_FOVRadius
    fovCircle.Size=UDim2.new(0,r*2,0,r*2)
    fovCircle.Position=UDim2.new(0.5,-r,0.5,-r)
    fovStroke.Color=T.Acc
end)

-- ================= LOGIC =================

local function getRole(plr)
    if plr==LP then return "innocent" end
    local c=plr.Character
    if not c then return "innocent" end
    if c:FindFirstChild("Knife") or (plr.Backpack and plr.Backpack:FindFirstChild("Knife")) then return "murder" end
    if c:FindFirstChild("Gun") or (plr.Backpack and plr.Backpack:FindFirstChild("Gun")) then return "sheriff" end
    return "innocent"
end
local function getCol(plr)
    local r=getRole(plr)
    if r=="murder" then return Color3.fromRGB(220,40,40) end
    if r=="sheriff" then return Color3.fromRGB(0,140,255) end
    return Color3.fromRGB(40,200,80)
end

-- ESP
local espCache={}
local function createESPObj(plr)
    if plr==LP or espCache[plr] then return end
    espCache[plr]={hl=nil,box=Instance.new("Frame"),name=Instance.new("TextLabel"),
        tracer=Instance.new("Frame"),dist=Instance.new("TextLabel")}
    local d=espCache[plr]
    d.box.BackgroundTransparency=1 d.box.BorderSizePixel=0 d.box.ZIndex=1 d.box.Parent=Gui
    stroke(d.box,T.Acc,1,0)
    d.name.BackgroundTransparency=1 d.name.TextColor3=Color3.new(1,1,1)
    d.name.Font=T.FB d.name.TextSize=12 d.name.ZIndex=2 d.name.Parent=Gui
    stroke(d.name,Color3.new(0,0,0),1,0.4)
    d.dist.BackgroundTransparency=1 d.dist.TextColor3=T.TxD
    d.dist.Font=T.F d.dist.TextSize=10 d.dist.ZIndex=2 d.dist.Parent=Gui
    d.tracer.BackgroundColor3=T.Acc d.tracer.BorderSizePixel=0 d.tracer.ZIndex=1 d.tracer.Parent=Gui
end
for _,plr in ipairs(Players:GetPlayers()) do createESPObj(plr) end
Players.PlayerAdded:Connect(createESPObj)
Players.PlayerRemoving:Connect(function(plr)
    if espCache[plr] then
        for _,o in pairs(espCache[plr]) do pcall(function() o:Destroy() end) end
        espCache[plr]=nil
    end
end)

RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr==LP then continue end
        if not espCache[plr] then createESPObj(plr) end
        local d=espCache[plr]
        if not d then continue end
        local char=plr.Character
        local col=getCol(plr)
        if F.ESP_Chams and char then
            if not d.hl or d.hl.Parent~=char then
                if d.hl then d.hl:Destroy() end
                d.hl=Instance.new("Highlight")
                d.hl.Parent=char d.hl.Adornee=char
            end
            d.hl.FillColor=col d.hl.OutlineColor=col
            d.hl.FillTransparency=1-(F.ESP_Transparency/100)
            d.hl.Enabled=true
        elseif d.hl then d.hl.Enabled=false end
        if F.ESP_Enabled and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health>0 then
            local hrp=char.HumanoidRootPart
            local pos,on=Cam:WorldToViewportPoint(hrp.Position)
            if on then
                local size=Vector2.new(2000/pos.Z,2600/pos.Z)
                local bp=Vector2.new(pos.X-size.X/2,pos.Y-size.Y/2)
                d.box.Visible=F.ESP_Box
                if F.ESP_Box then
                    d.box.Position=UDim2.new(0,bp.X,0,bp.Y)
                    d.box.Size=UDim2.new(0,size.X,0,size.Y)
                    for _,s in ipairs(d.box:GetChildren()) do
                        if s:IsA("UIStroke") then s.Color=col s.Transparency=0 end
                    end
                end
                d.name.Visible=F.ESP_Name
                if F.ESP_Name then
                    local nm=plr.Name
                    if F.ESP_Role then nm=nm.." ["..getRole(plr):upper().."]" end
                    d.name.Text=nm
                    d.name.Position=UDim2.new(0,pos.X-size.X/2,0,bp.Y-16)
                    d.name.Size=UDim2.new(0,size.X,0,14)
                    d.name.TextColor3=col
                end
                d.dist.Visible=F.ESP_Distance
                if F.ESP_Distance then
                    local dist=math.floor((Cam.CFrame.Position-hrp.Position).Magnitude)
                    d.dist.Text=dist.."m"
                    d.dist.Position=UDim2.new(0,pos.X-size.X/2,0,bp.Y+size.Y+2)
                    d.dist.Size=UDim2.new(0,size.X,0,12)
                end
                d.tracer.Visible=F.ESP_Tracer
                if F.ESP_Tracer then
                    local origin=Vector2.new(Cam.ViewportSize.X/2,Cam.ViewportSize.Y)
                    local target=Vector2.new(pos.X,bp.Y+size.Y)
                    local dx,dy=target.X-origin.X,target.Y-origin.Y
                    local length=math.sqrt(dx*dx+dy*dy)
                    local angle=math.deg(math.atan2(dy,dx))
                    d.tracer.Position=UDim2.new(0,origin.X,0,origin.Y)
                    d.tracer.Size=UDim2.new(0,length,0,1)
                    d.tracer.Rotation=angle
                    d.tracer.BackgroundColor3=col
                end
            else
                d.box.Visible=false d.name.Visible=false d.dist.Visible=false d.tracer.Visible=false
            end
        else
            d.box.Visible=false d.name.Visible=false d.dist.Visible=false d.tracer.Visible=false
        end
    end
end)

-- Silent Aim
local function getBestTarget()
    local best, bestDist = nil, F.CB_FOVRadius
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myHrp = myChar.HumanoidRootPart
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health>0 then
                local dist3d = (hrp.Position-myHrp.Position).Magnitude
                if dist3d <= F.CB_MaxRange then
                    local pos, on = Cam:WorldToViewportPoint(hrp.Position)
                    if on then
                        local dist2d = (Vector2.new(pos.X,pos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                        if dist2d < bestDist then
                            if F.CB_VisibleCheck then
                                local params = RaycastParams.new()
                                params.FilterType = Enum.RaycastFilterType.Exclude
                                params.FilterDescendantsInstances = {myChar, plr.Character}
                                local dir = (hrp.Position - Cam.CFrame.Position).Unit * dist3d
                                local result = WS:Raycast(Cam.CFrame.Position, dir, params)
                                if not result then bestDist=dist2d best=plr end
                            else
                                bestDist=dist2d best=plr
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local currentTarget = nil
RunService.RenderStepped:Connect(function()
    if not F.CB_SilentAim then currentTarget = nil return end
    currentTarget = getBestTarget()
end)

local ok_mt, mt = pcall(getrawmetatable, game)
if ok_mt and mt then
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if F.CB_SilentAim and currentTarget and currentTarget.Character then
            local hitPart = currentTarget.Character:FindFirstChild(F.CB_SilentHitPart)
                or currentTarget.Character:FindFirstChild("Head")
                or currentTarget.Character:FindFirstChild("HumanoidRootPart")
            if hitPart then
                if method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList"
                    or method == "FindPartOnRayWithWhitelist" or method == "Raycast" then
                    if args[1] and typeof(args[1]) == "Ray" then
                        args[1] = Ray.new(args[1].Origin, (hitPart.Position - args[1].Origin))
                    elseif typeof(args[2]) == "Vector3" then
                        args[2] = hitPart.Position - args[2]
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

-- Auto Shoot
local lastShoot = 0
local function tryShoot()
    local c = LP.Character
    if not c then return end
    local tool = c:FindFirstChildOfClass("Tool")
    if not tool then
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _,t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then pcall(function() t.Parent=c end) tool=t break end
            end
        end
    end
    if tool then pcall(function() tool:Activate() end) end
end

RunService.Heartbeat:Connect(function()
    if not F.CB_AutoShoot then return end
    if not currentTarget then return end
    local now = tick()
    if now - lastShoot < F.CB_AutoShootDelay then return end
    lastShoot = now
    pcall(tryShoot)
end)

-- Fling
local lastFling = 0
local function flingTarget(plr)
    if plr == LP then return end
    local char = plr.Character
    if not char then return end
    local thp = char:FindFirstChild("HumanoidRootPart")
    if not thp then return end
    pcall(function() thp:SetNetworkOwner(LP) end)
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(F.FL_Power, F.FL_Power, F.FL_Power)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = thp
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(F.FL_Power, F.FL_Power, F.FL_Power)
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.Parent = thp
    task.delay(0.25, function()
        if bv and bv.Parent then bv:Destroy() end
        if bav and bav.Parent then bav:Destroy() end
        if thp and thp.Parent then pcall(function() thp.Velocity = Vector3.zero end) end
    end)
end

RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastFling < F.FL_Cooldown then return end
    local c = LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local function tryFling(plr)
        if plr==LP then return end
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
        local dist = (c.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
        if dist < 25 then lastFling = now pcall(flingTarget, plr) end
    end
    if F.FL_Selected then
        for plr,sel in pairs(flingSelected) do
            if sel then tryFling(plr) end
        end
    end
    if F.FL_All then for _,plr in ipairs(Players:GetPlayers()) do tryFling(plr) end end
    if F.FL_Sheriff then for _,plr in ipairs(Players:GetPlayers()) do if getRole(plr)=="sheriff" then tryFling(plr) end end end
    if F.FL_Murderer then for _,plr in ipairs(Players:GetPlayers()) do if getRole(plr)=="murder" then tryFling(plr) end end end
end)

-- Kill Aura
RunService.Heartbeat:Connect(function()
    if not F.CB_KillAura then return end
    local c=LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hasKnife = c:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
    if not hasKnife then return end
    if not c:FindFirstChild("Knife") then
        local k=LP.Backpack:FindFirstChild("Knife")
        if k then k.Parent=c end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local thp=plr.Character:FindFirstChild("HumanoidRootPart")
            local thum=plr.Character:FindFirstChild("Humanoid")
            if thp and thum and thum.Health>0 then
                local d=(thp.Position-c.HumanoidRootPart.Position).Magnitude
                if d<8 then c.HumanoidRootPart.CFrame=thp.CFrame end
            end
        end
    end
end)

-- Anti-Aim
local aaAngle=0
RunService.Heartbeat:Connect(function(dt)
    if not F.CB_AntiAim then return end
    local c=LP.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        aaAngle=aaAngle+math.rad(720)*dt
        c.HumanoidRootPart.CFrame=c.HumanoidRootPart.CFrame*CFrame.Angles(0,aaAngle,0)
    end
end)

-- Lighting
RunService.Heartbeat:Connect(function()
    if F.VS_FullBright then
        Lighting.Ambient=Color3.fromRGB(255,255,255)
        Lighting.Brightness=2 Lighting.ClockTime=12 Lighting.GlobalShadows=false
    end
    if F.VS_NoFog then Lighting.FogEnd=1e6 Lighting.FogStart=1e6 end
end)

RunService.RenderStepped:Connect(function()
    if not F.VS_XRay then return end
    local c=LP.Character
    if c then
        for _,pt in ipairs(c:GetDescendants()) do
            if pt:IsA("BasePart") and pt.Name~="HumanoidRootPart" then
                pt.LocalTransparencyModifier=1-(F.VS_XRayStr/100)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        local bloom=Lighting:FindFirstChild("FB_Bloom")
        if F.VS_Bloom then
            if not bloom then bloom=Instance.new("BloomEffect") bloom.Name="FB_Bloom" bloom.Parent=Lighting end
            bloom.Intensity=1 bloom.Size=24 bloom.Threshold=1
        elseif bloom then bloom:Destroy() end
        local cc=Lighting:FindFirstChild("FB_CC")
        if F.VS_CC then
            if not cc then cc=Instance.new("ColorCorrectionEffect") cc.Name="FB_CC" cc.Parent=Lighting end
            cc.Saturation=0.2 cc.Contrast=0.1
        elseif cc then cc:Destroy() end
    end
end)

task.spawn(function()
    while task.wait(1) do
        local c=LP.Character
        if c then
            local head=c:FindFirstChild("Head")
            if head then
                if F.VS_Headless then
                    head.Transparency=1
                    for _,d in ipairs(head:GetChildren()) do
                        if d:IsA("Decal") then d.Transparency=1 end
                    end
                else
                    if head.Transparency==1 then head.Transparency=0 end
                end
            end
        end
    end
end)

local trailA,trailO=nil,nil
RunService.Heartbeat:Connect(function()
    local c=LP.Character
    if not c then trailA=nil trailO=nil return end
    local hrp=c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if F.VS_Trail then
        if not trailO or trailO.Parent~=c then
            if trailO then trailO:Destroy() end
            trailA=Instance.new("Attachment",hrp) trailA.Position=Vector3.new(0,0,0)
            trailO=Instance.new("Trail")
            trailO.Attachment0=trailA trailO.Attachment1=trailA
            trailO.Lifetime=0.6 trailO.MinLength=0
            trailO.Color=ColorSequence.new(T.Acc,T.Acc2)
            trailO.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)})
            trailO.LightEmission=1 trailO.LightInfluence=0
            trailO.Parent=c
        else
            trailO.Color=ColorSequence.new(T.Acc,T.Acc2)
        end
    else
        if trailO then trailO:Destroy() trailO=nil trailA=nil end
    end
end)

-- Fly
local flyBV
RunService.Heartbeat:Connect(function()
    local c=LP.Character
    if not c then return end
    local hrp=c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if F.MV_Fly then
        if not flyBV then
            flyBV=Instance.new("BodyVelocity")
            flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
            flyBV.Velocity=Vector3.zero
            flyBV.Parent=hrp
        end
        local dir=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
        if IS_MOBILE then
            local hum=c:FindFirstChild("Humanoid")
            if hum and hum.MoveDirection.Magnitude>0.1 then dir=hum.MoveDirection*60 end
        end
        flyBV.Velocity=dir*(F.MV_FlySpeed/60)
    else
        if flyBV then flyBV:Destroy() flyBV=nil end
    end
end)

UIS.JumpRequest:Connect(function()
    if F.MV_InfJump then
        local c=LP.Character
        if c and c:FindFirstChild("Humanoid") then c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if not F.MV_NoClip then return end
    local c=LP.Character
    if c then
        for _,pt in ipairs(c:GetDescendants()) do
            if pt:IsA("BasePart") then pt.CanCollide=false end
        end
    end
end)

-- Auto Farm (coins + drops)
local lastCoinTP=0
RunService.Heartbeat:Connect(function()
    if not (F.FM_AutoCoins or F.FM_AutoDrops) then return end
    local now=tick()
    if now-lastCoinTP<0.08 then return end
    lastCoinTP=now
    local c=LP.Character
    if not c then return end
    local hrp=c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local closest,shortest=nil,math.huge
    for _,obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nm=obj.Name:lower()
            local isCoin = F.FM_AutoCoins and nm:find("coin")
            local isDrop = F.FM_AutoDrops and (nm=="gundrop" or nm=="knifedrop" or nm=="drop")
            if isCoin or isDrop then
                local d=(obj.Position-hrp.Position).Magnitude
                if d<shortest then shortest=d closest=obj end
            end
        end
    end
    if closest then pcall(function() hrp.CFrame=closest.CFrame+Vector3.new(0,2.5,0) end) end
end)

RunService.Heartbeat:Connect(function()
    if not F.FM_AutoKill then return end
    local c=LP.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hasKnife=c:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
    if not hasKnife then return end
    if not c:FindFirstChild("Knife") then
        local k=LP.Backpack:FindFirstChild("Knife")
        if k then k.Parent=c end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local thp=plr.Character:FindFirstChild("HumanoidRootPart")
            local thum=plr.Character:FindFirstChild("Humanoid")
            if thp and thum and thum.Health>0 then
                c.HumanoidRootPart.CFrame=thp.CFrame
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if F.FN_Spin then
        local c=LP.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame=c.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(15),0)
        end
    end
    if F.FN_BunnyHop then
        local c=LP.Character
        if c and c:FindFirstChild("Humanoid") and c.Humanoid.FloorMaterial~=Enum.Material.Air then
            c.Humanoid.Jump=true
        end
    end
end)

if F.MS_AntiAFK then
    pcall(function()
        LP.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    end)
end

CB.MouseButton1Click:Connect(function()
    tw(Main,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.25):Play()
    task.wait(0.3)
    Gui:Destroy()
    _G.FB_Loaded=false
end)

Main.Size=UDim2.new(0,0,0,0)
Main.Position=UDim2.new(0.5,0,0.5,0)
Tween:Create(Main,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size=UDim2.new(0,WIN_W,0,WIN_H),
    Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
}):Play()

notify("🎃 Femboy x Pumpkin v5.1","Silent Aim + Auto Shoot готовы",4)
print("[Femboy x Pumpkin v5.1] loaded")
