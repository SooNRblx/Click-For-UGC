-- 1. SERVICES
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Nettoyage
if playerGui:FindFirstChild("MasterObbyGui") then
    playerGui.MasterObbyGui:Destroy()
end

-- 2. VARIABLES & ACCÈS AU JEU
local autoFarmActive = false
local antiAfkActive = false
local walkSpeedValue = 16
local farmWaitTime = 0.1 -- Vitesse de clic

-- On récupère l'event de clic directement depuis ton script ClickClient
local clickEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Click")

-- 3. INTERFACE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MasterObbyGui"
screenGui.ResetOnSpawn = false

local logo = Instance.new("TextButton", screenGui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 20, 0, 150)
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "⚡"
logo.TextSize = 35
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Header
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "OP AUTO-CLICKER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -34, 0, 6)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
scroll.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--- SECTION AUTO CLICK ---
local farmSection = Instance.new("Frame", scroll)
farmSection.Size = UDim2.new(0, 310, 0, 120)
farmSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", farmSection)

local labelAF = Instance.new("TextLabel", farmSection)
labelAF.Size = UDim2.new(0, 150, 0, 30)
labelAF.Position = UDim2.new(0, 10, 0, 20)
labelAF.Text = "Auto Clicker"
labelAF.Font = Enum.Font.GothamBold
labelAF.TextSize = 16
labelAF.TextColor3 = Color3.new(1, 1, 1)
labelAF.BackgroundTransparency = 1
labelAF.TextXAlignment = Enum.TextXAlignment.Left

local btnAF = Instance.new("TextButton", farmSection)
btnAF.Size = UDim2.new(0, 80, 0, 30)
btnAF.Position = UDim2.new(1, -90, 0, 20)
btnAF.Text = "OFF"
btnAF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAF.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAF)

local labelFS = Instance.new("TextLabel", farmSection)
labelFS.Size = UDim2.new(0, 200, 0, 20)
labelFS.Position = UDim2.new(0, 10, 0, 60)
labelFS.Text = "Speed: 0.10s"
labelFS.Font = Enum.Font.Gotham
labelFS.TextSize = 13
labelFS.TextColor3 = Color3.fromRGB(200, 200, 200)
labelFS.BackgroundTransparency = 1
labelFS.TextXAlignment = Enum.TextXAlignment.Left

local sliderBackFS = Instance.new("Frame", farmSection)
sliderBackFS.Size = UDim2.new(0, 260, 0, 6)
sliderBackFS.Position = UDim2.new(0.5, -130, 0, 95)
sliderBackFS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderBackFS)

local dotFS = Instance.new("Frame", sliderBackFS)
dotFS.Size = UDim2.new(0, 18, 0, 18)
dotFS.Position = UDim2.new(0.1, -9, 0.5, -9)
dotFS.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
Instance.new("UICorner", dotFS).CornerRadius = UDim.new(1, 0)

--- SECTION VITESSE ---
local speedSection = Instance.new("Frame", scroll)
speedSection.Size = UDim2.new(0, 310, 0, 80)
speedSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", speedSection)

local labelWS = Instance.new("TextLabel", speedSection)
labelWS.Size = UDim2.new(0, 200, 0, 30)
labelWS.Position = UDim2.new(0, 10, 0, 10)
labelWS.Text = "WalkSpeed: 16"
labelWS.Font = Enum.Font.Gotham
labelWS.TextSize = 15
labelWS.TextColor3 = Color3.new(1,1,1)
labelWS.BackgroundTransparency = 1

local sliderWS = Instance.new("Frame", speedSection)
sliderWS.Size = UDim2.new(0, 260, 0, 6)
sliderWS.Position = UDim2.new(0.5, -130, 0, 50)
sliderWS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderWS)

local dotWS = Instance.new("Frame", sliderWS)
dotWS.Size = UDim2.new(0, 18, 0, 18)
dotWS.Position = UDim2.new(0, 0, 0.5, -9)
dotWS.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
Instance.new("UICorner", dotWS).CornerRadius = UDim.new(1, 0)

-- 4. LOGIQUE DRAG & SLIDERS
local function makeDraggable(obj, target)
    target = target or obj
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = target.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function() dragging = false end)
end

local function setupSlider(back, dot, min, max, isDecimal, callback)
    local isSliding = false
    local function update(input)
        local relPos = math.clamp((input.Position.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
        dot.Position = UDim2.new(relPos, -9, 0.5, -9)
        local val = isDecimal and (min + (relPos * (max - min))) or math.floor(min + (relPos * (max - min)))
        callback(val)
    end
    back.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function() isSliding = false end)
end

makeDraggable(logo)
makeDraggable(frame)
makeDraggable(header, frame)

setupSlider(sliderBackFS, dotFS, 0.01, 1, true, function(v) farmWaitTime = v labelFS.Text = string.format("Speed: %.2fs", v) end)
setupSlider(sliderWS, dotWS, 16, 250, false, function(v) walkSpeedValue = v labelWS.Text = "WalkSpeed: "..v end)

-- 5. FONCTIONS & BOUCLES
logo.MouseButton1Up:Connect(function() frame.Visible = not frame.Visible end)
close.MouseButton1Click:Connect(function() frame.Visible = false end)

btnAF.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    btnAF.Text = autoFarmActive and "ON" or "OFF"
    btnAF.BackgroundColor3 = autoFarmActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(80, 80, 80)
end)

-- Boucle WalkSpeed
RunService.Stepped:Connect(function()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
    end)
end)

-- BOUCLE AUTO CLICK (Utilise le RemoteEvent directement)
task.spawn(function()
    while true do
        if autoFarmActive then
            pcall(function()
                -- On active l'event de clic du serveur directement
                -- C'est ce que fait le bouton quand tu cliques dessus
                clickEvent:FireServer()
            end)
            task.wait(farmWaitTime)
        else
            task.wait(0.5)
        end
    end
end)

-- Anti-AFK
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
