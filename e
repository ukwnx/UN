local a=game:GetService("Players")
local b=workspace.CurrentCamera
local c=a.LocalPlayer
local d=c:GetMouse()
local e=game:GetService("RunService")
local f=game:GetService("UserInputService")
local g=game:GetService("CoreGui")
local h=Instance.new("ScreenGui")
h.Parent=g
h.Name="AimbotFlyESP"
local i=Instance.new("Frame")
i.Size=UDim2.new(0,200,0,300)
i.Position=UDim2.new(0,10,0,10)
i.BackgroundColor3=Color3.fromRGB(40,40,40)
i.Parent=h
local j=Instance.new("TextLabel")
j.Text="Aimbot, Fly & ESP"
j.Size=UDim2.new(1,0,0,50)
j.BackgroundTransparency=1
j.TextColor3=Color3.fromRGB(255,255,255)
j.Font=Enum.Font.SourceSans
j.TextSize=20
j.Parent=i
local k=Instance.new("TextButton")
k.Size=UDim2.new(1,0,0,50)
k.Position=UDim2.new(0,0,0,60)
k.BackgroundColor3=Color3.fromRGB(60,60,60)
k.Text="Toggle Aimbot"
k.TextColor3=Color3.fromRGB(255,255,255)
k.Font=Enum.Font.SourceSans
k.TextSize=18
k.Parent=i
local l=Instance.new("TextButton")
l.Size=UDim2.new(1,0,0,50)
l.Position=UDim2.new(0,0,0,120)
l.BackgroundColor3=Color3.fromRGB(60,60,60)
l.Text="Toggle Flying"
l.TextColor3=Color3.fromRGB(255,255,255)
l.Font=Enum.Font.SourceSans
l.TextSize=18
l.Parent=i
local m=Instance.new("TextButton")
m.Size=UDim2.new(1,0,0,50)
m.Position=UDim2.new(0,0,0,180)
m.BackgroundColor3=Color3.fromRGB(60,60,60)
m.Text="Toggle ESP"
m.TextColor3=Color3.fromRGB(255,255,255)
m.Font=Enum.Font.SourceSans
m.TextSize=18
m.Parent=i
local n=false
local o=false
local p=false
local q=nil
local r=nil
local s=nil
local t={}
local u=function()
    local v=nil
    local w=math.huge
    for _,x in pairs(a:GetPlayers())do
        if x~=c and x.Character and x.Character:FindFirstChild("Head")then
            local y=x.Character.Head
            local z=(y.Position-c.Character.HumanoidRootPart.Position).Magnitude
            if z<w then
                w=z
                v=y
            end
        end
    end
    return v
end
local A=function()
    n=not n
    if n then
        q=e.RenderStepped:Connect(function()
            if f:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)then
                local B=u()
                if B then
                    b.CFrame=CFrame.new(b.CFrame.Position,B.Position)
                end
            end
        end)
    else
        if q then
            q:Disconnect()
            q=nil
        end
    end
end
k.MouseButton1Click:Connect(A)
local C=function()
    o=true
    local D=c.Character:FindFirstChild("Humanoid")
    if D then
        D.PlatformStand=true
    end
    s=Instance.new("BodyGyro")
    s.MaxTorque=Vector3.new(400000,400000,400000)
    s.CFrame=c.Character.HumanoidRootPart.CFrame
    s.Parent=c.Character.HumanoidRootPart
    r=Instance.new("BodyVelocity")
    r.MaxForce=Vector3.new(400000,400000,400000)
    r.Velocity=Vector3.new(0,0,0)
    r.Parent=c.Character.HumanoidRootPart
end
local E=function()
    o=false
    local D=c.Character:FindFirstChild("Humanoid")
    if D then
        D.PlatformStand=false
    end
    if r then
        r:Destroy()
        r=nil
    end
    if s then
        s:Destroy()
        s=nil
    end
end
local F=function()
    if o then
        local G=Vector3.new(0,0,0)
        local H=50
        if f:IsKeyDown(Enum.KeyCode.W)then
            G=G+b.CFrame.LookVector
        end
        if f:IsKeyDown(Enum.KeyCode.S)then
            G=G-b.CFrame.LookVector
        end
        if f:IsKeyDown(Enum.KeyCode.A)then
            G=G-b.CFrame.RightVector
        end
        if f:IsKeyDown(Enum.KeyCode.D)then
            G=G+b.CFrame.RightVector
        end
        if f:IsKeyDown(Enum.KeyCode.Space)then
            G=G+Vector3.new(0,1,0)
        end
        if f:IsKeyDown(Enum.KeyCode.LeftShift)then
            G=G-Vector3.new(0,1,0)
        end
        r.Velocity=G*H
    end
end
l.MouseButton1Click:Connect(function()
    if o then
        E()
        l.Text="Enable Flying"
    else
        C()
        l.Text="Disable Flying"
    end
end)
local I=function(J)
    if J.Character and J.Character:FindFirstChild("Head")then
        local K=Instance.new("SelectionBox")
        K.Adornee=J.Character
        K.Color3=Color3.fromRGB(255,0,0)
        K.LineThickness=0.1
        K.Parent=J.Character
        local L=Instance.new("TextLabel")
        L.Text=tostring(math.floor((J.Character.Head.Position-c.Character.HumanoidRootPart.Position).Magnitude)).." studs"
        L.Size=UDim2.new(0,100,0,25)
        L.Position=UDim2.new(0,0,0,0)
        L.BackgroundTransparency=1
        L.TextColor3=Color3.fromRGB(255,0,0)
        L.Font=Enum.Font.SourceSans
        L.TextSize=14
        L.Parent=J.Character.Head
        e.RenderStepped:Connect(function()
            if J.Character and J.Character:FindFirstChild("Head")then
                local M=(J.Character.Head.Position-c.Character.HumanoidRootPart.Position).Magnitude
                L.Text=tostring(math.floor(M)).." studs"
            else
                L:Destroy()
            end
        end)
    end
end
local N=function()
    p=not p
    if p then
        for _,J in pairs(a:GetPlayers())do
            if J~=c then
                I(J)
            end
        end
        a.PlayerAdded:Connect(function(J)
            if J~=c then
                I(J)
            end
        end)
    else
        for _,J in pairs(a:GetPlayers())do
            if J.Character and J.Character:FindFirstChild("SelectionBox")then
                J.Character.SelectionBox:Destroy()
            end
        end
    end
end
m.MouseButton1Click:Connect(N)
e.RenderStepped:Connect(function()
    F()
end)
