-- PART 3: AIMBOT, ESP SCANNER & COMPILING ENGINE
local UIS, RS, LP, Cam = game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("Players").LocalPlayer, workspace.CurrentCamera
local Colors = {Acc = Color3.fromRGB(115,87,255)}

local Circle = Drawing.new("Circle") Circle.Color, Circle.Thickness, Circle.NumSides, Circle.Visible = Colors.Acc, 1.5, 64, false

local function line() local l = Drawing.new("Line") l.Thickness, l.Color, l.Visible = 1, Colors.Acc, false return l end
local function clean(m) if _G.Cache[m] then for _, v in pairs(_G.Cache[m].Bones) do v:Remove() end for _, v in pairs(_G.Cache[m].Box) do v:Remove() end _G.Cache[m] = nil end end

local Bones = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"Torso", "Head"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local function doESP()
    if not _G.Opts.ESP then for m, _ in pairs(_G.Cache) do clean(m) end return end
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Model") and o:FindFirstChild("Humanoid") and o ~= LP.Character and o.Humanoid.Health > 0 then
            local hrp = o:FindFirstChild("HumanoidRootPart") or o:FindFirstChild("Torso")
            if hrp then
                local _, os = Cam:WorldToViewportPoint(hrp.Position)
                if os then
                    if not _G.Cache[o] then _G.Cache[o] = {Box = {line(), line(), line(), line()}, Bones = {}} for i = 1, #Bones do table.insert(_G.Cache[o].Bones, line()) end end
                    local data, size = _G.Cache[o], hrp.Size.Y * 1.2
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
                            if osA and osB then data.Bones[i].From, data.Bones[i].To, data.Bones[i].Visible = Vector2.new(s1.X, s1.Y), Vector2.new(s2.X, s2.Y), true else data.Bones[i].Visible = false end
                        else data.Bones[i].Visible = false end
                    end
                else clean(o) end
            end
        else if _G.Cache[o] then clean(o) end end
    end
end

local function getTar()
    if _G.Opts.Lock and _G.Cur and _G.Cur.Parent and _G.Cur.Parent:FindFirstChild("Humanoid") and _G.Cur.Parent.Humanoid.Health > 0 then return _G.Cur end
    _G.Cur = nil local clst, maxD, center = nil, _G.Opts.FOV, Cam.ViewportSize / 2
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Model") and o:FindFirstChild("Humanoid") and o:FindFirstChild("Head") and o ~= LP.Character and o.Humanoid.Health > 0 then
            local sp, os = Cam:WorldToViewportPoint(o.Head.Position)
            if os then
                local w = false if _G.Opts.Wall then
                    local rp = RaycastParams.new() rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, {LP.Character, o}
                    if workspace:Raycast(Cam.CFrame.Position, o.Head.Position - Cam.CFrame.Position, rp) then w = true end
                end
                if not w then local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude if d < maxD then maxD, clst = d, o.Head end end
            end
        end
    end
    if _G.Opts.Lock then _G.Cur = clst end return clst
end

UIS.InputBegan:Connect(function(io, p) if not p and io.KeyCode == _G.Opts.Key then _G.Hold = true end end)
UIS.InputEnded:Connect(function(io) if io.KeyCode == _G.Opts.Key then _G.Hold = false if not _G.Opts.Lock then _G.Cur = nil end end end)
RS.Heartbeat:Connect(function() if _G.Opts.Switch and _G.Cur and _G.Cur.Parent.Humanoid.Health <= 0 then _G.Cur = nil end end)
RS.RenderStepped:Connect(function()
    Circle.Position, Circle.Radius, Circle.Visible = Cam.ViewportSize / 2, _G.Opts.FOV, _G.Opts.Active
    doESP()
    if _G.Opts.Active and _G.Hold then
        local t = getTar()
        if t then local cf = CFrame.new(Cam.CFrame.Position, t.Position) Cam.CFrame = _G.Opts.Smooth > 1 and Cam.CFrame:Lerp(cf, 1 / _G.Opts.Smooth) or cf end
    end
end)
