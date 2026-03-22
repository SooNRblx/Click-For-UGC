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
local farmWaitTime = 0.1 -- Vitesse du clic par défaut

-- Ciblage du bouton de ton jeu
local function getClickButton()
    local mainGui = playerGui:FindFirstChild("MainGui")
    if mainGui then
        return mainGui:FindFirstChild("ClickButton")
    end
    return nil
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
frame.Size = UDim2.new(0, 350, 0, 300)
frame.Position = UDim2.new(0.5, -175, 0.5, -150)
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
title.Text = "Master Auto-Clicker"
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
scroll.Size = UDim2.new(1, -10, 1, -85)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
scroll.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--- SECTION FARM (AUTO CLICK) ---
local farmSection = Instance.new("Frame", scroll)
farmSection.Size = UDim2.new(0, 310, 0, 140)
farmSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", farmSection)

local labelAF = Instance.new("TextLabel", farmSection)
labelAF.Size = UDim2.new(0, 150, 0, 30)
labelAF.Position = UDim2.new(0, 10, 0, 35)
labelAF.Text = "Auto Click"
labelAF.Font = Enum.Font.Gotham
labelAF.TextSize = 16
labelAF.TextColor3 = Color3.new(1, 1, 1)
labelAF.BackgroundTransparency = 1
labelAF.TextXAlignment = Enum.TextXAlignment.Left

local btnAF = Instance.new("TextButton", farmSection)
btnAF.Size = UDim2.new(0, 80, 0, 30)
btnAF.Position = UDim2.new(1, -90, 0, 35)
btnAF.Text = "OFF"
btnAF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAF.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAF)

local labelFS = Instance.new("TextLabel", farmSection)
labelFS.Size = UDim2.new(0, 200, 0, 20)
labelFS.Position = UDim2.new(0, 10, 0, 75)
labelFS.Text = "Click Interval: 0.10s"
labelFS.Font = Enum.Font.Gotham
labelFS.TextSize = 13
labelFS.TextColor3 = Color3.fromRGB(200, 200, 200)
labelFS.BackgroundTransparency = 1
labelFS.TextXAlignment = Enum.TextXAlignment.Left

local sliderBackFS = Instance.new("Frame", farmSection)
sliderBackFS.Size = UDim2.new(0, 260, 0, 6)
sliderBackFS.Position = UDim2.new(0.5, -130, 0, 110)
sliderBackFS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderBackFS)

local dotFS = Instance.new("Frame", sliderBackFS)
dotFS.Size = UDim2.new(0, 18, 0, 18)
dotFS.Position = UDim2.new(0.05, -9, 0.5, -9)
dotFS.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
Instance.new("UICorner", dotFS).CornerRadius = UDim.new(1, 0)

--- SECTION MOVEMENT ---
local moveSection = Instance.new("Frame", scroll)
moveSection.Size = UDim2.new(0, 310, 0, 180)
moveSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", moveSection)

local labelWS = Instance.new("TextLabel", moveSection)
labelWS.Size = UDim2.new(0, 200, 0, 20)
labelWS.Position = UDim2.new(0, 10, 0, 35)
labelWS.Text = "WalkSpeed: 16"
labelWS.Font = Enum.Font.Gotham
labelWS.TextSize = 15
labelWS.TextColor3 = Color3.new(1,1,1)
labelWS.BackgroundTransparency = 1

local sliderWS = Instance.new("Frame", moveSection)
sliderWS.Size = UDim2.new(0, 260, 0, 6)
sliderWS.Position = UDim2.new(0.5, -130, 0, 65)
sliderWS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderWS)

local dotWS = Instance.new("Frame", sliderWS)
dotWS.Size = UDim2.new(0, 18, 0, 18)
dotWS.Position = UDim2.new(0, 0, 0.5, -9)
dotWS.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
Instance.new("UICorner", dotWS).CornerRadius = UDim.new(1, 0)

--- SECTION MISC (ANTI AFK) ---
local miscSection = Instance.new("Frame", scroll)
miscSection.Size = UDim2.new(0, 310, 0, 80)
miscSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", miscSection)

local btnAA = Instance.new("TextButton", miscSection)
btnAA.Size = UDim2.new(0, 80, 0, 30)
btnAA.Position = UDim2.new(1, -90, 0, 25)
btnAA.Text = "OFF"
btnAA.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAA.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAA)

local labelAA = Instance.new("TextLabel", miscSection)
labelAA.Size = UDim2.new(0, 150, 0, 30)
labelAA.Position = UDim2.new(0, 10, 0, 25)
labelAA.Text = "Anti-AFK"
labelAA.TextColor3 = Color3.new(1, 1, 1)
labelAA.BackgroundTransparency = 1
labelAA.Font = Enum.Font.Gotham
labelAA.TextSize = 16
labelAA.TextXAlignment = Enum.TextXAlignment.Left

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

setupSlider(sliderBackFS, dotFS, 0.01, 1, true, function(v) farmWaitTime = v labelFS.Text = string.format("Click Interval: %.2fs", v) end)
setupSlider(sliderWS, dotWS, 16, 250, false, function(v) walkSpeedValue = v labelWS.Text = "WalkSpeed: "..v end)

-- 5. LOGIQUE BOUTONS & BOUCLES
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
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
    end)
end)

-- BOUCLE AUTO CLICK
task.spawn(function()
    while true do
        if autoFarmActive then
            local btn = getClickButton()
            if btn then
                -- Utilise firesignal si disponible, sinon simule le clic manuellement
                if firesignal then
                    firesignal(btn.MouseButton1Click)
                else
                    -- Fallback : on force l'activation
                    for _, connection in pairs(getconnections(btn.MouseButton1Click)) do
                        connection:Fire()
                    end
                end
            end
            task.wait(farmWaitTime)
        else
            task.wait(0.5)
        end
    end
end)

-- ANTI AFK
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if antiAfkActive then pcall(function() vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end) end
end)
