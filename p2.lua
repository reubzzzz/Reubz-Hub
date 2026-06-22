-- PART 2: UI SLIDERS & WINDOW FUNCTIONALITY
local Colors = {Bg = Color3.fromRGB(13,14,18), Card = Color3.fromRGB(22,24,30), Acc = Color3.fromRGB(115,87,255), Grn = Color3.fromRGB(0,220,140)}
local UIS, TS = game:GetService("UserInputService"), game:GetService("TweenService")

function _G.addSlide(p, txt, min, max, k)
    local C = Instance.new("Frame", p) C.Size, C.BackgroundColor3 = UDim2.new(0, 280, 0, 50), Colors.Card Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
    local L = Instance.new("TextLabel", C) L.Size, L.Position, L.BackgroundTransparency, L.Text, L.TextColor3, L.Font, L.TextSize, L.TextXAlignment = UDim2.new(0, 160, 0, 25), UDim2.new(0, 12, 0, 2), 1, txt, Color3.new(1,1,1), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left
    local V = Instance.new("TextLabel", C) V.Size, V.Position, V.BackgroundTransparency, V.Text, V.TextColor3, V.Font, V.TextSize, V.TextXAlignment = UDim2.new(0, 80, 0, 25), UDim2.new(1, -92, 0, 2), 1, tostring(_G.Opts[k]), Colors.Acc, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Right
    local B = Instance.new("TextButton", C) B.Size, B.Position, B.BackgroundColor3, B.Text = UDim2.new(0, 256, 0, 6), UDim2.new(0.5, -128, 0, 34), Color3.fromRGB(40,44,54), "" Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    local F = Instance.new("Frame", B) F.Size, F.BackgroundColor3 = UDim2.new((_G.Opts[k] - min) / (max - min), 0, 1, 0), Colors.Acc Instance.new("UICorner", F).CornerRadius = UDim.new(1, 0)
    local m = false local function u()
        local pct = math.clamp((UIS:GetMouseLocation().X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1) F.Size = UDim2.new(pct, 0, 1, 0)
        local val = math.round(min + (pct * (max - min))) V.Text = tostring(val) _G.Opts[k] = val
    end
    B.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then m = true u() end end)
    UIS.InputChanged:Connect(function(io) if m and (io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch) then u() end end)
    UIS.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then m = false end end)
end

_G.addTog(_G.PageA, "Toggle Button", "Active")
_G.addSlide(_G.PageA, "FOV", 10, 600, "FOV")
_G.addSlide(_G.PageA, "Smoothness", 1, 20, "Smooth")
_G.addTog(_G.PageA, "Target Lock", "Lock")
_G.addTog(_G.PageA, "Wall Check", "Wall")
_G.addTog(_G.PageA, "Switch Targets", "Switch")
_G.addTog(_G.PageE, "ESP", "ESP")

local Main = _G.PageA.Parent
local Tabs = Main:FindFirstChildOfClass("Frame")
local drag, iStart, sPos
Tabs.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then drag, iStart, sPos = true, io.Position, Main.Position io.Changed:Connect(function() if io.UserInputState == Enum.UserInputState.End then drag = false end end) end end)
UIS.InputChanged:Connect(function(io) if drag and io.UserInputType == Enum.UserInputType.MouseMovement then local d = io.Position - iStart Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y) end end)
UIS.InputBegan:Connect(function(io, p) if not p and io.KeyCode == Enum.KeyCode.RightShift then _G.Vis = not _G.Vis Main.Visible = _G.Vis end end)
