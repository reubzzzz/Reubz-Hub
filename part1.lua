-- PART 1: INITIALIZATION & BASE UI SETUP
local Plrs, TS, UIS, RS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")
local LP, Cam = Plrs.LocalPlayer, workspace.CurrentCamera
_G.Opts = {Active = false, FOV = 150, Smooth = 5, Lock = false, Wall = false, Switch = false, Key = Enum.KeyCode.E, ESP = false}
_G.Cache, _G.Cur, _G.Hold, _G.Vis = {}, nil, false, true
local Colors = {Bg = Color3.fromRGB(13,14,18), Card = Color3.fromRGB(22,24,30), Acc = Color3.fromRGB(115,87,255), Grn = Color3.fromRGB(0,220,140)}

local Gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui")) Gui.Name, Gui.ResetOnSpawn = "PremiumUI", false
local Main = Instance.new("CanvasGroup", Gui) Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 310, 0, 480), UDim2.new(0.5, -155, 0.5, -240), Colors.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10) Instance.new("UIStroke", Main).Color = Color3.fromRGB(35,38,47)

local Tabs = Instance.new("Frame", Main) Tabs.Size, Tabs.BackgroundTransparency = UDim2.new(1, 0, 0, 40), 1
local BtnA = Instance.new("TextButton", Tabs) BtnA.Size, BtnA.BackgroundTransparency, BtnA.Text, BtnA.TextColor3, BtnA.Font, BtnA.TextSize = UDim2.new(0.5, 0, 1, 0), 1, "AIMBOT", Color3.new(1,1,1), Enum.Font.GothamBold, 13
local BtnE = Instance.new("TextButton", Tabs) BtnE.Size, BtnE.Position, BtnE.BackgroundTransparency, BtnE.Text, BtnE.TextColor3, BtnE.Font, BtnE.TextSize = UDim2.new(0.5, 0, 1, 0), UDim2.new(0.5, 0, 0, 0), 1, "ESP VISUALS", Color3.fromRGB(140,145,160), Enum.Font.GothamBold, 13

_G.PageA = Instance.new("ScrollingFrame", Main) _G.PageA.Size, _G.PageA.Position, _G.PageA.BackgroundTransparency, _G.PageA.ScrollBarThickness, _G.PageA.ScrollBarImageColor3 = UDim2.new(1, 0, 1, -50), UDim2.new(0, 0, 0, 45), 1, 2, Colors.Acc
_G.PageE = Instance.new("ScrollingFrame", Main) _G.PageE.Size, _G.PageE.Position, _G.PageE.BackgroundTransparency, _G.PageE.ScrollBarThickness, _G.PageE.ScrollBarImageColor3, _G.PageE.Visible = UDim2.new(1, 0, 1, -50), UDim2.new(0, 0, 0, 45), 1, 2, Colors.Acc, false

local L1, L2 = Instance.new("UIListLayout", _G.PageA), Instance.new("UIListLayout", _G.PageE)
L1.Padding, L1.HorizontalAlignment, L2.Padding, L2.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center, UDim.new(0, 6), Enum.HorizontalAlignment.Center
L1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() _G.PageA.CanvasSize = UDim2.new(0, 0, 0, L1.AbsoluteContentSize.Y + 15) end)
L2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() _G.PageE.CanvasSize = UDim2.new(0, 0, 0, L2.AbsoluteContentSize.Y + 15) end)

BtnA.MouseButton1Click:Connect(function() _G.PageA.Visible, _G.PageE.Visible, BtnA.TextColor3, BtnE.TextColor3 = true, false, Color3.new(1,1,1), Color3.fromRGB(140,145,160) end)
BtnE.MouseButton1Click:Connect(function() _G.PageA.Visible, _G.PageE.Visible, BtnA.TextColor3, BtnE.TextColor3 = false, true, Color3.fromRGB(140,145,160), Color3.new(1,1,1) end)

function _G.addTog(p, txt, k)
    local C = Instance.new("Frame", p) C.Size, C.BackgroundColor3 = UDim2.new(0, 280, 0, 44), Colors.Card Instance.new("UICorner", C).CornerRadius = UDim.new(0, 6)
    local L = Instance.new("TextLabel", C) L.Size, L.Position, L.BackgroundTransparency, L.Text, L.TextColor3, L.Font, L.TextSize, L.TextXAlignment = UDim2.new(0, 160, 1, 0), UDim2.new(0, 12, 0, 0), 1, txt, Color3.fromRGB(140,145,160), Enum.Font.GothamMedium, 13, Enum.TextXAlignment.Left
    local S = Instance.new("TextButton", C) S.Size, S.Position, S.BackgroundColor3, S.Text = UDim2.new(0, 38, 0, 20), UDim2.new(1, -50, 0.5, -10), Color3.fromRGB(40,44,54), "" Instance.new("UICorner", S).CornerRadius = UDim.new(1, 0)
    local D = Instance.new("Frame", S) D.Size, D.Position, D.BackgroundColor3 = UDim2.new(0, 14, 0, 14), UDim2.new(0, 3, 0.5, -7), Color3.fromRGB(180,185,200) Instance.new("UICorner", D).CornerRadius = UDim.new(1, 0)
    S.MouseButton1Click:Connect(function() _G.Opts[k] = not _G.Opts[k] local s = _G.Opts[k]
        TS:Create(S, TweenInfo.new(0.15), {BackgroundColor3 = s and Colors.Grn or Color3.fromRGB(40,44,54)}):Play()
        TS:Create(D, TweenInfo.new(0.15), {Position = s and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        TS:Create(L, TweenInfo.new(0.15), {TextColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(140,145,160)}):Play()
    end)
end
