local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local SavedPosition = nil 
local BasePosition = nil 
local isFlyActive = false
local isEspActive = false
local isAboveActive = false
local SkyVelocity = nil 

local function GetChar() return LocalPlayer.Character end
local function GetHum() return GetChar() and GetChar():FindFirstChildOfClass("Humanoid") end
local function GetRoot() return GetChar() and GetChar():FindFirstChild("HumanoidRootPart") end

task.spawn(function()
    repeat task.wait(0.5) until GetRoot()
    BasePosition = GetRoot().CFrame
end)

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MeijorsHubV16"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 360) 
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", MainFrame)

local DragHandle = Instance.new("TextButton", MainFrame)
DragHandle.Size = UDim2.new(1, 0, 0, 30); DragHandle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DragHandle.Text = "  meijor's hub v16"; DragHandle.TextColor3 = Color3.new(1,1,1)
DragHandle.Font = "SourceSansBold"; DragHandle.TextSize = 16; DragHandle.TextXAlignment = "Left"
Instance.new("UICorner", DragHandle)

local CloseBtn = Instance.new("TextButton", DragHandle)
CloseBtn.Size = UDim2.new(0, 30, 1, 0); CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
Instance.new("UICorner", CloseBtn)

local MainContent = Instance.new("Frame", MainFrame)
MainContent.Size = UDim2.new(1, 0, 1, -35); MainContent.Position = UDim2.new(0, 0, 0, 35); MainContent.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", MainContent); layout.Padding = UDim.new(0, 4); layout.HorizontalAlignment = "Center"

local function createButton(txt, col, parent)
    local b = Instance.new("TextButton", parent)
    b.BackgroundColor3 = col; b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function createSection(titleText, height)
    local s = Instance.new("Frame", MainContent); s.Size = UDim2.new(0.94, 0, 0, height); s.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", s); t.Text = "— " .. titleText .. " —"; t.Size = UDim2.new(1, 0, 0, 18); t.TextColor3 = Color3.fromRGB(150, 150, 150); t.BackgroundTransparency = 1; t.TextSize = 11
    local c = Instance.new("Frame", s); c.Name = "Content"; c.Size = UDim2.new(1, 0, 1, -18); c.Position = UDim2.new(0, 0, 0, 18); c.BackgroundTransparency = 1
    return c
end

local TeleSec = createSection("TELEPORT", 120)
local grid = Instance.new("UIGridLayout", TeleSec); grid.CellSize = UDim2.new(0.48, 0, 0, 30); grid.CellPadding = UDim2.new(0, 5, 0, 5)

createButton("➡️ +10 Z", Color3.fromRGB(60, 180, 100), TeleSec).MouseButton1Click:Connect(function() 
    local root = GetRoot()
    if root then 
        root.CFrame = root.CFrame * CFrame.new(0, 0, -10) 
    end 
end)

createButton("🔍 Near Player", Color3.fromRGB(200, 140, 50), TeleSec).MouseButton1Click:Connect(function()
    local near, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (GetRoot().Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d near = p.Character.HumanoidRootPart end
        end
    end
    if near then GetRoot().CFrame = near.CFrame * CFrame.new(0, 5, 0) end
end)

createButton("🏠 Base", Color3.fromRGB(120, 80, 220), TeleSec).MouseButton1Click:Connect(function() 
    if GetRoot() and BasePosition then 
        GetRoot().CFrame = BasePosition 
    end 
end)

createButton("⚡ Base & Back", Color3.fromRGB(220, 80, 60), TeleSec).MouseButton1Click:Connect(function()
    local r = GetRoot()
    if r and BasePosition then 
        local old = r.CFrame; r.CFrame = BasePosition; task.wait(0.7); 
        if GetRoot() then GetRoot().CFrame = old end 
    end
end)

createButton("⬆️ +25 Y", Color3.fromRGB(60, 120, 200), TeleSec).MouseButton1Click:Connect(function() if GetRoot() then GetRoot().CFrame += Vector3.new(0, 25, 0) end end)
createButton("⬇️ -25 Y", Color3.fromRGB(150, 60, 200), TeleSec).MouseButton1Click:Connect(function() if GetRoot() then GetRoot().CFrame += Vector3.new(0, -25, 0) end end)

local ToggleSec = createSection("TOGGLES", 100)
local TList = Instance.new("UIListLayout", ToggleSec); TList.Padding = UDim.new(0, 4)
local bEsp = createButton("👁️ ESP: OFF", Color3.fromRGB(180, 50, 50), ToggleSec)
local bFly = createButton("🪽 Fly Mode: OFF", Color3.fromRGB(180, 50, 50), ToggleSec)
local bAbove = createButton("☁️ Sky Walk (R/F): OFF", Color3.fromRGB(180, 50, 50), ToggleSec)
for _, b in ipairs(ToggleSec:GetChildren()) do if b:IsA("TextButton") then b.Size = UDim2.new(1, 0, 0, 28) end end


local WaySec = createSection("WAYPOINT", 40)
local WGrid = Instance.new("UIGridLayout", WaySec); WGrid.CellSize = UDim2.new(0.485,0,0,32); WGrid.CellPadding = UDim2.new(0,6,0,0)
createButton("💾 SAVE POS", Color3.fromRGB(70, 70, 70), WaySec).MouseButton1Click:Connect(function() if GetRoot() then SavedPosition = GetRoot().CFrame end end)
createButton("📍 LOAD POS", Color3.fromRGB(70, 70, 70), WaySec).MouseButton1Click:Connect(function() if GetRoot() and SavedPosition then GetRoot().CFrame = SavedPosition end end)



bAbove.MouseButton1Click:Connect(function()
    isAboveActive = not isAboveActive
    bAbove.Text = "☁️ Sky Walk (R/F): " .. (isAboveActive and "ON" or "OFF")
    bAbove.BackgroundColor3 = isAboveActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(180, 50, 50)
    
    local root = GetRoot()
    if not root then return end

    if isAboveActive then
        root.CFrame += Vector3.new(0, 50, 0)
        SkyVelocity = Instance.new("BodyVelocity", root)
        SkyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        SkyVelocity.Velocity = Vector3.new(0, 0, 0)
    else
        if SkyVelocity then SkyVelocity:Destroy(); SkyVelocity = nil end
        root.CFrame += Vector3.new(0, -50, 0)
        if GetHum() then GetHum().PlatformStand = false end
    end
end)

bFly.MouseButton1Click:Connect(function()
    isFlyActive = not isFlyActive
    bFly.Text = "🪽 Fly Mode: " .. (isFlyActive and "ON" or "OFF")
    bFly.BackgroundColor3 = isFlyActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(180, 50, 50)
    if GetHum() then GetHum().PlatformStand = isFlyActive end
end)

bEsp.MouseButton1Click:Connect(function()
    isEspActive = not isEspActive
    bEsp.Text = "👁️ ESP: " .. (isEspActive and "ON" or "OFF")
    bEsp.BackgroundColor3 = isEspActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(180, 50, 50)
end)

RunService.PreSimulation:Connect(function()
    local root = GetRoot()
    local hum = GetHum()
    if not root or not hum then return end

    if isAboveActive and SkyVelocity then
        hum.PlatformStand = true
        local moveDir = hum.MoveDirection 
        local speed = hum.WalkSpeed
        local yMove = 0
        

        if UserInputService:IsKeyDown(Enum.KeyCode.R) then yMove = 30 end
        if UserInputService:IsKeyDown(Enum.KeyCode.F) then yMove = -30 end
        
        SkyVelocity.Velocity = Vector3.new(moveDir.X * speed, yMove, moveDir.Z * speed)
    end


    if isEspActive then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ESPHighlight") then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "ESPHighlight"; h.FillColor = Color3.new(1,0,0)
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight:Destroy() end
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local dragging, dragStart, startPos
DragHandle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
