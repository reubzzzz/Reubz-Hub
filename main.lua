local Plrs, TS, UIS, RS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")
local LP, Cam = Plrs.LocalPlayer, workspace.CurrentCamera
local Colors = {Bg = Color3.fromRGB(13,14,18), Card = Color3.fromRGB(22,24,30), Acc = Color3.fromRGB(115,87,255), Grn = Color3.fromRGB(0,220,140)}
local Opts = {Active = false, FOV = 150, Smooth = 5, Lock = false, Wall = false, Switch = false, Key = Enum.KeyCode.E, ESP = false}
local cache, cur, hold, vis = {}, nil, false, true

local Circle = Drawing.new("Circle") Circle.Color, Circle.Thickness, Circle.NumSides, Circle.Visible = Colors.Acc, 1.5, 64, false

local Gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui")) Gui.Name, Gui.ResetOnSpawn = "PremiumUI", false
local Main = Instance.new("CanvasGroup", Gui) Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 310, 0, 480), UDim2.new(0.5, -155, 0.5, -240), Colors.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(35,38,47)

local Tabs = Instance.new("Frame", Main) Tabs.Size, Tabs.BackgroundTransparency = UDim2.new(1, 0, 0, 40), 1
local BtnA = Instance.new("TextButton", Tabs) BtnA.Size, BtnA.BackgroundTransparency, BtnA.Text, BtnA.TextColor3, BtnA.Font, BtnA.TextSize = UDim2.new(0.5, 0, 1, 0), 1, "AIMBOT", Color3.new(1,1,1), Enum.Font.GothamBold, 13
local BtnE = Instance.new("TextButton", Tabs) BtnE.Size, BtnE.Position, BtnE.BackgroundTransparency, BtnE.Text, BtnE.TextColor3, BtnE.Font, BtnE.TextSize = UDim2.new(0.5, 0, 1, 0), UDim2.new(0.5, 0, 0, 0), 1, "ESP VISUALS", Color3.fromRGB(140,145,160), Enum.Font.GothamBold, 13

local PageA = Instance.new("ScrollingFrame", Main) PageA.Size, PageA.Position, PageA.BackgroundTransparency, PageA.ScrollBarThickness, PageA.ScrollBarImageColor3 = UDim2.new(1, 0, 1, -50), UDim2.new(0, 0, 0, 45), 1, 2, Colors.Acc
local PageE = Instance.new("ScrollingFrame", Main) PageE.Size, PageE.Position, PageE.BackgroundTransparency, PageE.ScrollBarThickness, PageE.ScrollBarImageColor3, PageE.Visible = UDim2.new(1, 0, 1, -50), UDim2.new(0, 0, 0, 45), 1, 2, Colors.Acc, false

local L1, L2 = Instance.new("UIListLayout", PageA), Instance.new("UIListLayout", PageE)
L1.Padding, L1.HorizontalAlignment, L2.Padding, L2.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center, UDim.new(0, 6), Enum.HorizontalAlignment.Center
L1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() PageA.CanvasSize = UDim2.new(0, 0, 0, L1.AbsoluteContentSize.Y + 15) end)
L2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() PageE.CanvasSize = UDim2.new(0, 0, 0, L2.AbsoluteContentSize.Y + 15) end)

BtnA.MouseButton1Click:Connect(function() PageA.Visible, PageE.Visible, BtnA.TextColor3, BtnE.TextColor3 = true, false, Color3.new(1,1,1), Color3.fromRGB(140,145,160) end)
BtnE.MouseButton1Click:Connect(function() PageA.Visible, PageE.Visible, BtnA.TextColor3, BtnE.TextColor3 = false, true, Color3.fromRGB(140,145,160), Color3.new(1,1,1) end)

local function addTog(p, txt, k)
    local C = Instance.new("Frame", p) C.Size, C.BackgroundColor3 = UDim2.new(0, 280, 0, 44), Colors.Card Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
    local L = Instance.new("TextLabel", C) L.Size, L.Position, L.BackgroundTransparency, L.Text, L.TextColor3, L.Font, L.TextSize, L.TextXAlignment = UDim2.new(0, 160, 1, 0), UDim2.new(0, 12, 0, 0), 1, txt, Color3.fromRGB(140,145,160), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left
    local S = Instance.new("TextButton", C) S.Size, S.Position, S.BackgroundColor3, S.Text = UDim2.new(0, 38, 0, 20), UDim2.new(1, -50, 0.5, -10), Color3.fromRGB(40,44,54), "" Instance.new("UICorner", S).CornerRadius = UDim.new(1, 0)
    local D = Instance.new("Frame", S) D.Size, D.Position, D.BackgroundColor3 = UDim2.new(0, 14, 0, 14), UDim2.new(0, 3, 0.5, -7), Color3.fromRGB(180,185,200) Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
    S.MouseButton1Click:Connect(function() Opts[k] = not Opts[k] local s = Opts[k]
        TS:Create(S, TweenInfo.new(0.15), {BackgroundColor3 = s and Colors.Grn or Color3.fromRGB(40,44,54)}):Play()
        TS:Create(D, TweenInfo.new(0.15), {Position = s and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        TS:Create(L, TweenInfo.new(0.15), {TextColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(140,145,160)}):Play()
    end)
end

local function addSlide(p, txt, min, max, k)
    local C = Instance.new("Frame", p) C.Size, C.BackgroundColor3 = UDim2.new(0, 280, 0, 50), Colors.Card Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
    local L = Instance.new("TextLabel", C) L.Size, L.Position, L.BackgroundTransparency, L.Text, L.TextColor3, L.Font, L.TextSize, L.TextXAlignment = UDim2.new(0, 160, 0, 25), UDim2.new(0, 12, 0, 2), 1, txt, Color3.new(1,1,1), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left
    local V = Instance.new("TextLabel", C) V.Size, V.Position, V.BackgroundTransparency, V.Text, V.TextColor3, V.Font, V.TextSize, V.TextXAlignment = UDim2.new(0, 80, 0, 25), UDim2.new(1, -92, 0, 2), 1, tostring(Opts[k]), Colors.Acc, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Right
    local B = Instance.new("TextButton", C) B.Size, B.Position, B.BackgroundColor3, B.Text = UDim2.new(0, 256, 0, 6), UDim2.new(0.5, -128, 0, 34), Color3.fromRGB(40,44,54), "" Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    local F = Instance.new("Frame", B) F.Size, F.BackgroundColor3 = UDim2.new((Opts[k] - min) / (max - min), 0, 1, 0), Colors.Acc Instance.new("UICorner", F).CornerRadius = UDim.new(1, 0)
    local m = false local function u()
        local pct = math.clamp((UIS:GetMouseLocation().X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1) F.Size = UDim2.new(pct, 0, 1, 0)
        local val = math.round(min + (pct * (max - min))) V.Text = tostring(val) Opts[k] = val
    end
    B.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then m = true u() end end)
    UIS.InputChanged:Connect(function(io) if m and (io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch) then u() end end)
    UIS.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then m = false end end)
end

addTog(PageA, "Toggle Button", "Active")
addSlide(PageA, "FOV", 10, 600, "FOV")
addSlide(PageA, "Smoothness", 1, 20, "Smooth")
addTog(PageA, "Target Lock", "Lock")
addTog(PageA, "Wall Check", "Wall")
addTog(PageA, "Switch Targets", "Switch")
addTog(PageE, "ESP", "ESP")

local drag, iStart, sPos
Tabs.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then drag, iStart, sPos = true, io.Position, Main.Position io.Changed:Connect(function() if io.UserInputState == Enum.UserInputState.End then drag = false end end) end end)
UIS.InputChanged:Connect(function(io) if drag and io.UserInputType == Enum.UserInputType.MouseMovement then local d = io.Position - iStart Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y) end end)
UIS.InputBegan:Connect(function(io, p) if not p and io.KeyCode == Enum.KeyCode.RightShift then vis = not vis Main.Visible = vis end end)

local function line() local l = Drawing.new("Line") l.Thickness, l.Color, l.Visible = 1, Colors.Acc, false return l end
local function clean(m) if cache[m] then for _, v in pairs(cache[m].Bones) do v:Remove() end for _, v in pairs(cache[m].Box) do v:Remove() end cache[m] = nil end end

local Bones = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"Torso", "Head"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local function doESP()
    if not Opts.ESP then for m, _ in pairs(cache) do clean(m) end return end
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Model") and o:FindFirstChild("Humanoid") and o ~= LP.Character and o.Humanoid.Health > 0 then
            local hrp = o:FindFirstChild("HumanoidRootPart") or o:FindFirstChild("Torso")
            if hrp then
                local _, os = Cam:WorldToViewportPoint(hrp.Position)
                if os then
                    if not cache[o] then cache[o] = {Box = {line(), line(), line(), line()}, Bones = {}} for i = 1, #Bones do table.insert(cache[o].Bones, line()) end end
                    local data, size = cache[o], hrp.Size.Y * 1.2
                    local top = Cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, size, 0))
                    local bottom = Cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, size, 0))
                    local h, w = math.abs(top.Y - bottom.Y), math.abs(top.Y - bottom.Y) * 0.6 local x, y = top.X - (w / 2), top.Y
                    for i = 1, 4 do data.Box[i].Visible = true end
                    data.Box[1].From, data.Box[1].To = Vector2.new(x, y), Vector2.new(x + w, y)
                    data.Box[2].From, data.Box[2].To = Vector2.new(x + w, y), Vector2.new(x + w, y + h)
                    data.Box[3].From, data.Box[3].To = Vector2.new(x + w, y + h), Vector2.new(x, y + h)
                    data.Box[4].From, data.Box[4].To = Vector2.new(x, y + h), Vector2.new(x, y)
                    for i, b in ipairs(Bones) do
                        local p1, p2 = o:FindFirstChild(b[1]), o:FindFirstChild(b[2])
                        if p1 and p2 then
                            local s1, osA = Cam:WorldToViewportPoint(p1.Position) local s2, osB = Cam:WorldToViewportPoint(p2.Position)
                                      if p1 and p2 then
                            local s1, osA = Cam:WorldToViewportPoint(p1.Position) 
                            local s2, osB = Cam:WorldToViewportPoint(p2.Position)
                            if osA and osB then 
                                data.Bones[i].From = Vector2.new(s1.X, s1.Y)
                                data.Bones[i].To = Vector2.new(s2.X, s2.Y)
                                data.Bones[i].Visible = true 
                            else 
                                data.Bones[i].Visible = false 
                            end
                        else 
                            data.Bones[i].Visible = false 
                        end
                    end
                else 
                    clean(o) 
                end
            end
        else 
            if cache[o] then clean(o) end 
        end
    end
end

local function getTar()
    if Opts.Lock and cur and cur.Parent and cur.Parent:FindFirstChild("Humanoid") and cur.Parent.Humanoid.Health > 0 then 
        return cur 
    end
    cur = nil 
    local clst, maxD, center = nil, Opts.FOV, Cam.ViewportSize / 2
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Model") and o:FindFirstChild("Humanoid") and o:FindFirstChild("Head") and o ~= LP.Character and o.Humanoid.Health > 0 then
            local sp, os = Cam:WorldToViewportPoint(o.Head.Position)
            if os then
                local w = false 
                if Opts.Wall then
                    local rp = RaycastParams.new() 
                    rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, {LP.Character, o}
                    if workspace:Raycast(Cam.CFrame.Position, o.Head.Position - Cam.CFrame.Position, rp) then 
                        w = true 
                    end
                end
                if not w then 
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude 
                    if d < maxD then 
                        maxD, clst = d, o.Head 
                    end 
                end
            end
        end
    end
    if Opts.Lock then cur = clst end 
    return clst
end

UIS.InputBegan:Connect(function(io, p) 
    if not p and io.KeyCode == Opts.Key then 
        hold = true 
    end 
end)

UIS.InputEnded:Connect(function(io) 
    if io.KeyCode == Opts.Key then 
        hold = false 
        if not Opts.Lock then cur = nil end 
    end 
end)

RS.Heartbeat:Connect(function() 
    if Opts.Switch and cur and cur.Parent.Humanoid.Health <= 0 then 
        cur = nil 
    end 
end)

RS.RenderStepped:Connect(function()
    Circle.Position, Circle.Radius, Circle.Visible = Cam.ViewportSize / 2, Opts.FOV, Opts.Active
    doESP()
    if Opts.Active and hold then
        local t = getTar()
        if t then 
            local cf = CFrame.new(Cam.CFrame.Position, t.Position) 
            Cam.CFrame = Opts.Smooth > 1 and Cam.CFrame:Lerp(cf, 1 / Opts.Smooth) or cf 
        end
    end
end)
