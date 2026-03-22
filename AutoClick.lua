-- 1. SERVICES
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Nettoyage
if playerGui:FindFirstChild("MasterObbyGui") then
    playerGui.MasterObbyGui:Destroy()
end

-- 2. VARIABLES
local autoFarmActive = false
local antiAfkActive = false
local walkSpeedValue = 16
local jumpPowerValue = 50
local farmWaitTime = 0.1

-- Fonction pour trouver le bouton et sa valeur "Moved"
local function getClickElements()
    local mainGui = playerGui:FindFirstChild("MainGui")
    local btn = mainGui and mainGui:FindFirstChild("ClickButton")
    if btn then
        return btn, btn:FindFirstChild("Moved")
    end
    return nil, nil
end

-- 3. INTERFACE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MasterObbyGui"
screenGui.ResetOnSpawn = false

local logo = Instance.new("TextButton", screenGui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 20, 0, 150)
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "🖱️"
logo.TextSize = 35
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 380)
frame.Position = UDim2.new(0.5, -175, 0.5, -190)
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
title.Text = "MASTER HUB"
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
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fonctions Utilitaires UI
local function createSection(name, height)
    local sec = Instance.new("Frame", scroll)
    sec.Size = UDim2.new(0, 310, 0, height)
    sec.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", sec)
    
    local t = Instance.new("TextLabel", sec)
    t.Size = UDim2.new(0, 100, 0, 25)
    t.Position = UDim2.new(0, 10, 0, 5)
    t.Text = name
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = Color3.fromRGB(150, 150, 150)
    t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left
    return sec
end

--- SECTION FARM ---
local farmSec = createSection("AUTOMATION", 110)
local btnAF = Instance.new("TextButton", farmSec)
btnAF.Size = UDim2.new(0, 80, 0, 30)
btnAF.Position = UDim2.new(1, -90, 0, 30)
btnAF.Text = "OFF"
btnAF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAF.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAF)

local labelAF = Instance.new("TextLabel", farmSec)
labelAF.Size = UDim2.new(0, 150, 0, 30)
labelAF.Position = UDim2.new(0, 10, 0, 30)
labelAF.Text = "Auto Clicker"
labelAF.Font = Enum.Font.Gotham
labelAF.TextColor3 = Color3.new(1,1,1)
labelAF.BackgroundTransparency = 1
labelAF.TextXAlignment = Enum.TextXAlignment.Left

local labelSpeed = Instance.new("TextLabel", farmSec)
labelSpeed.Size = UDim2.new(0, 200, 0, 20)
labelSpeed.Position = UDim2.new(0, 10, 0, 65)
labelSpeed.Text = "Interval: 0.10s"
labelSpeed.TextColor3 = Color3.fromRGB(200, 200, 200)
labelSpeed.BackgroundTransparency = 1
labelSpeed.TextXAlignment = Enum.TextXAlignment.Left

local sliderFS = Instance.new("Frame", farmSec)
sliderFS.Size = UDim2.new(0, 260, 0, 6)
sliderFS.Position = UDim2.new(0.5, -130, 0, 95)
sliderFS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderFS)

local dotFS = Instance.new("Frame", sliderFS)
dotFS.Size = UDim2.new(0, 18, 0, 18)
dotFS.Position = UDim2.new(0.1, -9, 0.5, -9)
dotFS.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
Instance.new("UICorner", dotFS).CornerRadius = UDim.new(1, 0)

--- SECTION MOVEMENT ---
local moveSec = createSection("MOVEMENT", 150)
-- WalkSpeed
local labelWS = Instance.new("TextLabel", moveSec)
labelWS.Size = UDim2.new(0, 200, 0, 20)
labelWS.Position = UDim2.new(0, 10, 0, 30)
labelWS.Text = "WalkSpeed: 16"
labelWS.TextColor3 = Color3.new(1,1,1)
labelWS.BackgroundTransparency = 1

local sliderWS = Instance.new("Frame", moveSec)
sliderWS.Size = UDim2.new(0, 260, 0, 6)
sliderWS.Position = UDim2.new(0.5, -130, 0, 60)
sliderWS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderWS)

local dotWS = Instance.new("Frame", sliderWS)
dotWS.Size = UDim2.new(0, 18, 0, 18)
dotWS.Position = UDim2.new(0, 0, 0.5, -9)
dotWS.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
Instance.new("UICorner", dotWS).CornerRadius = UDim.new(1, 0)

-- JumpPower
local labelJP = Instance.new("TextLabel", moveSec)
labelJP.Size = UDim2.new(0, 200, 0, 20)
labelJP.Position = UDim2.new(0, 10, 0, 90)
labelJP.Text = "JumpPower: 50"
labelJP.TextColor3 = Color3.new(1,1,1)
labelJP.BackgroundTransparency = 1

local sliderJP = Instance.new("Frame", moveSec)
sliderJP.Size = UDim2.new(0, 260, 0, 6)
sliderJP.Position = UDim2.new(0.5, -130, 0, 120)
sliderJP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderJP)

local dotJP = Instance.new("Frame", sliderJP)
dotJP.Size = UDim2.new(0, 18, 0, 18)
dotJP.Position = UDim2.new(0, 0, 0.5, -9)
dotJP.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
Instance.new("UICorner", dotJP).CornerRadius = UDim.new(1, 0)

--- SECTION MISC ---
local miscSec = createSection("MISC", 60)
local btnAA = Instance.new("TextButton", miscSec)
btnAA.Size = UDim2.new(0, 80, 0, 30)
btnAA.Position = UDim2.new(1, -90, 0, 15)
btnAA.Text = "OFF"
btnAA.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAA.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAA)

local labelAA = Instance.new("TextLabel", miscSec)
labelAA.Size = UDim2.new(0, 150, 0, 30)
labelAA.Position = UDim2.new(0, 10, 0, 15)
labelAA.Text = "Anti-AFK"
labelAA.TextColor3 = Color3.new(1, 1, 1)
labelAA.BackgroundTransparency = 1

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

setupSlider(sliderFS, dotFS, 0.1, 1, true, function(v) farmWaitTime = v labelSpeed.Text = string.format("Interval: %.2fs", v) end)
setupSlider(sliderWS, dotWS, 16, 250, false, function(v) walkSpeedValue = v labelWS.Text = "WalkSpeed: "..v end)
setupSlider(sliderJP, dotJP, 50, 400, false, function(v) jumpPowerValue = v labelJP.Text = "JumpPower: "..v end)

-- 5. LOGIQUE D'ACTION
logo.MouseButton1Up:Connect(function() frame.Visible = not frame.Visible end)
close.MouseButton1Click:Connect(function() frame.Visible = false end)

btnAF.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    btnAF.Text = autoFarmActive and "ON" or "OFF"
    btnAF.BackgroundColor3 = autoFarmActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(80, 80, 80)
end)

btnAA.MouseButton1Click:Connect(function()
    antiAfkActive = not antiAfkActive
    btnAA.Text = antiAfkActive and "ON" or "OFF"
    btnAA.BackgroundColor3 = antiAfkActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(80, 80, 80)
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local hum = player.Character.Humanoid
        hum.WalkSpeed = walkSpeedValue
        hum.JumpPower = jumpPowerValue
        hum.UseJumpPower = true
    end)
end)

-- Boucle de Click (Logique v1 qui marchait)
task.spawn(function()
    while true do
        if autoFarmActive then
            local btn, movedVal = getClickElements()
            if btn then
                -- On force la condition de survol pour que le script ClickClient autorise le clic
                if movedVal then movedVal.Value = true end
                
                -- On simule le bouton relâché (MouseButton1Up) car c'est là que l'event est tiré
                if firesignal then
                    firesignal(btn.MouseButton1Up)
                else
                    for _, con in pairs(getconnections(btn.MouseButton1Up)) do
                        con:Fire()
                    end
                end
            end
            task.wait(farmWaitTime)
        else
            task.wait(0.5)
        end
    end
end)

-- Anti-AFK
player.Idled:Connect(function()
    if antiAfkActive then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)
