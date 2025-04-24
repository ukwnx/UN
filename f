-- Main Services
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "AimbotFlyESP"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 350)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Aimbot, Fly & ESP"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSans
title.TextSize = 20
title.Parent = frame

-- Aimbot Toggle
local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Size = UDim2.new(1, 0, 0, 50)
aimbotToggle.Position = UDim2.new(0, 0, 0, 60)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimbotToggle.Text = "Toggle Aimbot"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotToggle.Font = Enum.Font.SourceSans
aimbotToggle.TextSize = 18
aimbotToggle.Parent = frame

-- Flying Toggle
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(1, 0, 0, 50)
flyToggle.Position = UDim2.new(0, 0, 0, 120)
flyToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyToggle.Text = "Toggle Flying"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Font = Enum.Font.SourceSans
flyToggle.TextSize = 18
flyToggle.Parent = frame

-- ESP Toggle
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(1, 0, 0, 50)
espToggle.Position = UDim2.new(0, 0, 0, 180)
espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espToggle.Text = "Toggle ESP"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.Font = Enum.Font.SourceSans
espToggle.TextSize = 18
espToggle.Parent = frame

-- Instructions for Aimbot
local instructionLabel = Instance.new("TextLabel")
instructionLabel.Text = "Right-click for Aimbot"
instructionLabel.Size = UDim2.new(1, 0, 0, 25)
instructionLabel.Position = UDim2.new(0, 0, 0, 250)
instructionLabel.BackgroundTransparency = 1
instructionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
instructionLabel.Font = Enum.Font.SourceSans
instructionLabel.TextSize = 16
instructionLabel.Parent = frame

-- Variables for Aimbot, Fly, and ESP
local aimbotEnabled = false
local flyEnabled = false
local espEnabled = false
local aimbotConnection = nil
local flyingBodyVelocity = nil
local bodyGyro = nil
local espParts = {}

-- Aimbot Function (Locks camera to nearest player's head)
local function getNearestPlayerHead()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local distance = (head.Position - LP.Character.HumanoidRootPart.Position).Magnitude

            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = head
            end
        end
    end

    return closestPlayer
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local targetHead = getNearestPlayerHead()
                if targetHead then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                end
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end

aimbotToggle.MouseButton1Click:Connect(toggleAimbot)

-- Fly Function (Full Control Over Movement)
local function enableFly()
    flyEnabled = true
    local humanoid = LP.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.CFrame = LP.Character.HumanoidRootPart.CFrame
    bodyGyro.Parent = LP.Character.HumanoidRootPart

    flyingBodyVelocity = Instance.new("BodyVelocity")
    flyingBodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    flyingBodyVelocity.Velocity = Vector3.new(0, 0, 0)  -- Initial velocity is zero
    flyingBodyVelocity.Parent = LP.Character.HumanoidRootPart
end

local function disableFly()
    flyEnabled = false
    local humanoid = LP.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end

    if flyingBodyVelocity then
        flyingBodyVelocity:Destroy()
        flyingBodyVelocity = nil
    end

    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
end

local function updateFly()
    if flyEnabled then
        local moveDirection = Vector3.new(0, 0, 0)
        local speed = 50
        -- Control flying movement
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)  -- Move up
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)  -- Move down
        end

        flyingBodyVelocity.Velocity = moveDirection * speed
    end
end

flyToggle.MouseButton1Click:Connect(function()
    if flyEnabled then
        disableFly()
        flyToggle.Text = "Enable Flying"
    else
        enableFly()
        flyToggle.Text = "Disable Flying"
    end
end)

-- ESP Function (Red Outline Around Players' Body and Display Distance)
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local outline = Instance.new("SelectionBox")
        outline.Adornee = player.Character
        outline.Color3 = Color3.fromRGB(255, 0, 0)  -- Red outline
        outline.LineThickness = 0.1  -- Thin line for subtle effect
        outline.Parent = player.Character

        -- Create Distance Label
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Text = tostring(math.floor((player.Character.Head.Position - LP.Character.HumanoidRootPart.Position).Magnitude)) .. " studs"
        distanceLabel.Size = UDim2.new(0, 100, 0, 25)
        distanceLabel.Position = UDim2.new(0, 0, 0, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        distanceLabel.Font = Enum.Font.SourceSans
        distanceLabel.TextSize = 14
        distanceLabel.Parent = player.Character.Head

        -- Update Distance Text
        RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Head") then
                local distance = (player.Character.Head.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                distanceLabel.Text = tostring(math.floor(distance)) .. " studs"
            else
                distanceLabel:Destroy()
            end
        end)
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP then
                createESP(player)
            end
        end

        Players.PlayerAdded:Connect(function(player)
            if player ~= LP then
                createESP(player)
            end
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("SelectionBox") then
                player.Character.SelectionBox:Destroy()
            end
        end
    end
end

espToggle.MouseButton1Click:Connect(toggleESP)

-- Update fly movement each frame
RunService.RenderStepped:Connect(function()
    updateFly()
end)
