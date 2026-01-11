    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local MainWindow = Rayfield:CreateWindow({
    Name = "Main",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Troa",
    ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

    ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

    ConfigurationSaving = {
        Enabled = true,
        FolderName = Xhubv2, -- Create a custom folder for your hub/game
        FileName = "X HubUniV2"
    },

    Discord = {
        Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
        Invite = "https://discord.gg/3AhdZpXvBe", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },

    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
        Title = "XhubUniV2",
        Subtitle = "Key System",
        Note = "discord.gg/3AhdZpXvBe Key in Server", -- Use this to tell the user how to get a key
        FileName = "Xhubkey.lua", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = {"XHubBetaFreev1"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
    })


    local MainTab = MainWindow:CreateTab("Main", 4483362458) -- Title, Image

    -- aimbot gui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local TARGET_PART = "HumanoidRootPart"
local MAX_DISTANCE = 150

-- SETTINGS
getgenv().Aimbot = {
    Enabled = false,
    Key = Enum.KeyCode.L -- DEFAULT
}

-- NOTIFY
local function notify(txt)
    StarterGui:SetCore("SendNotification", {
        Title = "🛡️Aimbot",
        Text = txt,
        Duration = 3
    })
end

-- INPUT
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == getgenv().Aimbot.Key then
        getgenv().Aimbot.Enabled = not getgenv().Aimbot.Enabled
        notify(getgenv().Aimbot.Enabled and "ON" or "OFF")
    end
end)

-- TARGET
local function getTarget()
    local origin = Camera.CFrame.Position
    local direction = Camera.CFrame.LookVector * MAX_DISTANCE

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist

    local result = Workspace:Raycast(origin, direction, params)
    if result then
        local model = result.Instance:FindFirstAncestorOfClass("Model")
        local plr = Players:GetPlayerFromCharacter(model)
        if plr and model:FindFirstChild(TARGET_PART) then
            return model[TARGET_PART]
        end
    end
end

-- LOOP
RunService.RenderStepped:Connect(function()
    if not getgenv().Aimbot.Enabled then return end
    if not LocalPlayer.Character then return end

    local target = getTarget()
    if target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
    end
end)

----------------------------------------------------
-- GUI
----------------------------------------------------

-- AIMBOT TOGGLE
MainTab:CreateToggle({
    Name = "🛡️Aimbot",
    Default = false,
    Callback = function(v)
        getgenv().Aimbot.Enabled = v
        notify(v and "ON" or "OFF")
    end
})

-- KEYBIND BUTTON
local KeyButton
KeyButton = MainTab:CreateButton({
    Name = "⌨️ Aimbot Key : L",
    Callback = function()
        KeyButton:Set("Press a key...")
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                getgenv().Aimbot.Key = input.KeyCode
                KeyButton:Set("Aimbot Key : "..input.KeyCode.Name)
                notify("Key set to "..input.KeyCode.Name)
                conn:Disconnect()
            end
        end)
    end
})



local MainTab = MainWindow:CreateTab("Visual", 4483362458) -- Title, Image


-- ESP Başlangıç
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local lplr = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local playerDrawings = {}

-- ESP ayarları
getgenv().ESPSettings = {
    Enabled = true,       -- Başlangıçta aktif
    Box = false,
    Name = false,
    Distance = false,
    Health = false,
    WeaponName = false
}

local HeadOff = Vector3.new(0, 2, 0)
local LegOff = Vector3.new(0, 3, 0)
local WeaponOffset = 20 -- Weapon text box altına sabit offset

-- Player ESP
local function createPlayerESP(player)
    if player == lplr then return end

    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 2
    box.Filled = false
    box.Color = player.TeamColor.Color

    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Color3.new(1,1,1)
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.new(0,0,0)

    local dist = Drawing.new("Text")
    dist.Visible = false
    dist.Color = Color3.new(1,1,1)
    dist.Size = 10
    dist.Center = true
    dist.Outline = true
    dist.OutlineColor = Color3.new(0,0,0)

    local hpbar = Drawing.new("Line")
    hpbar.Visible = false
    hpbar.Color = Color3.new(0,1,0)
    hpbar.Thickness = 2

    local weaponText = Drawing.new("Text")
    weaponText.Visible = false
    weaponText.Color = Color3.new(1,0,0)
    weaponText.Size = 12
    weaponText.Center = true
    weaponText.Outline = true
    weaponText.OutlineColor = Color3.new(0,0,0)

    playerDrawings[player] = {box=box, name=name, dist=dist, hpbar=hpbar, weaponText=weaponText}

    local function update()
        if not getgenv().ESPSettings.Enabled then
            box.Visible = false
            name.Visible = false
            dist.Visible = false
            hpbar.Visible = false
            weaponText.Visible = false
            return
        end

        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            box.Visible = false
            name.Visible = false
            dist.Visible = false
            hpbar.Visible = false
            weaponText.Visible = false
            return
        end

        local rootPos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
        local headPos = Camera:WorldToViewportPoint(char.Head.Position + HeadOff)
        local legPos = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position - LegOff)
        local height = headPos.Y - legPos.Y
        local width = height/2

        -- Box
        box.Size = Vector2.new(width,height)
        box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
        box.Visible = onScreen and getgenv().ESPSettings.Box

        -- Name tag (box üstüne sabit)
        name.Position = Vector2.new(rootPos.X, box.Position.Y - 15)
        name.Text = player.Name
        name.Visible = onScreen and getgenv().ESPSettings.Name

        -- Distance (box altına sabit)
        dist.Position = Vector2.new(rootPos.X, box.Position.Y + height + 5)
        local magnitude = (lplr.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
        dist.Text = math.floor(magnitude).."m"
        dist.Visible = onScreen and getgenv().ESPSettings.Distance

        -- Health
        local hp = char.Humanoid.Health / char.Humanoid.MaxHealth
        hpbar.From = Vector2.new(box.Position.X + width + 5, box.Position.Y + height * (1-hp))
        hpbar.To = Vector2.new(box.Position.X + width + 5, box.Position.Y + height)
        hpbar.Visible = onScreen and getgenv().ESPSettings.Health

        -- Weapon Name (box altına sabit)
        local toolName = nil
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") then
                toolName = child.Name
                break
            end
        end

        weaponText.Position = Vector2.new(rootPos.X, box.Position.Y + height + WeaponOffset)
        weaponText.Text = toolName or ""
        weaponText.Visible = onScreen and getgenv().ESPSettings.WeaponName and toolName ~= nil
    end

    playerDrawings[player].update = RunService.RenderStepped:Connect(update)
end

-- Player ekleme
local function playerAdded(player)
    createPlayerESP(player)
    player.CharacterAdded:Connect(function()
        createPlayerESP(player)
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= lplr then playerAdded(p) end
end
Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(function(player)
    if playerDrawings[player] then
        if playerDrawings[player].update then
            playerDrawings[player].update:Disconnect()
        end
        for _, d in pairs(playerDrawings[player]) do
            if d.Remove then d:Remove() end
        end
        playerDrawings[player] = nil
    end
end)

-- Toggles
MainTab:CreateToggle({Name="👁️ESP Enabled", Default=true, Callback=function(v) getgenv().ESPSettings.Enabled=v end})
MainTab:CreateToggle({Name="👁️Box", Default=false, Callback=function(v) getgenv().ESPSettings.Box=v end})
MainTab:CreateToggle({Name="👁️Name", Default=false, Callback=function(v) getgenv().ESPSettings.Name=v end})
MainTab:CreateToggle({Name="👁️Distance", Default=false, Callback=function(v) getgenv().ESPSettings.Distance=v end})
MainTab:CreateToggle({Name="👁️Health", Default=false, Callback=function(v) getgenv().ESPSettings.Health=v end})
MainTab:CreateToggle({Name="👁️Weapon Name", Default=false, Callback=function(v) getgenv().ESPSettings.WeaponName=v end})



    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    getgenv().StretchedEnabled = false
    getgenv().StretchValue = 0.80 -- 0.70 = daha fazla, 0.85 = daha az

    local stretchConnection
    local originalCFrame

    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    getgenv().StretchValue = 0.80
    local enabled = false
    local stretchConnection

    --STRETCHED RES

    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    local stretchConnection = nil
    local StretchValue = 0.80 -- ayar

    MainTab:CreateToggle({
        Name = "Stretched Res",
        Default = false, -- geri konumda başlar
        Callback = function(state)

            if state then
                -- İLERİ (AÇIK)
                stretchConnection = RunService.RenderStepped:Connect(function()
                    Camera.CFrame =
                        Camera.CFrame * CFrame.new(
                            0, 0, 0,
                            1, 0, 0,
                            0, StretchValue, 0,
                            0, 0, 1
                        )
                end)

            else
                -- GERİ (KAPALI)
                if stretchConnection then
                    stretchConnection:Disconnect()
                    stretchConnection = nil
                end
            end
        end,
    })


     local MainTab = MainWindow:CreateTab("Player", 4483362458) -- Title, Image

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Infinite Jump
local InfiniteJumpEnabled = false -- başta kapalı

MainTab:CreateToggle({
    Name = "👟Infinite Jump",
    Default = false, -- Başlangıçta kapalı
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

-- fly No clip
local Button = MainTab:CreateButton({
   Name = "🪽Fly & Noclip",
   Callback = function(simple)
 -- Fly & Noclip (slider display fixed)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local workspace = workspace
local player = Players.LocalPlayer

local GAME_DEFAULT_WALKSPEED = 16
local MAX_VALUE = 1000
local SNAP = 5
local DISCORD_INVITE = "https://discord.gg/3AhdZpXvBe"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Xhub_GUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.Parent = game:GetService("CoreGui")

local FRAME_W, FRAME_H = 300, 220
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
mainFrame.Position = UDim2.new(0.5, -FRAME_W/2, 0.45, -FRAME_H/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(12,12,12)
mainFrame.BackgroundTransparency = 0.18
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,10)
mainFrame.Active = true

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1,0,0,34)
titleBar.BackgroundTransparency = 1
local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.6, -12, 1, 0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XHubUniv2"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Name = "Minimize"; minBtn.Size = UDim2.new(0,28,0,24); minBtn.Position = UDim2.new(1,-72,0,5)
minBtn.BackgroundColor3 = Color3.fromRGB(70,70,70); minBtn.Text = "—"; minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 16
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Name = "Close"; closeBtn.Size = UDim2.new(0,28,0,24); closeBtn.Position = UDim2.new(1,-36,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(140,20,20); closeBtn.Text = "X"; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local body = Instance.new("Frame", mainFrame)
body.Name = "Body"; body.Size = UDim2.new(1,0,1,-34); body.Position = UDim2.new(0,0,0,34); body.BackgroundTransparency = 1

local controlsFrame = Instance.new("Frame", body)
controlsFrame.Name = "Controls"; controlsFrame.Size = UDim2.new(1,-16,0,140); controlsFrame.Position = UDim2.new(0,8,0,8)
controlsFrame.BackgroundTransparency = 1; controlsFrame.Visible = true

local function createSliderRow(parent, y, labelText, default)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,36); row.Position = UDim2.new(0,0,0,y); row.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0,70,1,0)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = labelText; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -140, 0, 10)
    track.Position = UDim2.new(0,80,0,13)
    track.BackgroundColor3 = Color3.fromRGB(120,120,120); track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(0,6)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default or 0) / MAX_VALUE, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(190,190,190)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,6)
    local knob = Instance.new("ImageButton", track)
    knob.Size = UDim2.new(0,18,0,18); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default or 0) / MAX_VALUE, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(230,230,230); knob.BorderSizePixel = 0; knob.AutoButtonColor = false
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0,9)
    local sampleSize = TextService:GetTextSize("1000", 14, Enum.Font.Gotham, Vector2.new(1000,1000))
    local boxWidth = math.clamp(math.ceil(sampleSize.X) + 6, 36, 56)
    local valueBox = Instance.new("TextBox", row)
    valueBox.Size = UDim2.new(0, boxWidth, 0, 24)
    valueBox.Position = UDim2.new(1, -(boxWidth + 8), 0, 6)
    valueBox.BackgroundTransparency = 0.3
    valueBox.Text = tostring(default or 0)
    valueBox.ClearTextOnFocus = false; valueBox.Font = Enum.Font.Gotham; valueBox.TextSize = 13
    valueBox.TextColor3 = Color3.new(1,1,1); valueBox.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0,6)
    return { Row = row, Label = lbl, ValueBox = valueBox, Track = track, Fill = fill, Knob = knob, Value = default or 0, Dragging = false, SavedValue = default or 0 }
end

local function createRowWithSquircle(parent, y, text)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,40); row.Position = UDim2.new(0,0,0,y); row.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0,150,1,0); lbl.Position = UDim2.new(0,6,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local squir = Instance.new("TextButton", row)
    squir.Size = UDim2.new(0,36,0,28)
    squir.Position = UDim2.new(1, -44, 0, 6)
    squir.BackgroundColor3 = Color3.fromRGB(40,40,40)
    squir.Text = "OFF"
    squir.Font = Enum.Font.GothamBold
    squir.TextSize = 13
    squir.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", squir).CornerRadius = UDim.new(0,10)
    return row, lbl, squir
end

local noclipRow, noclipLabel, noclipSquir = createRowWithSquircle(controlsFrame, 0, "Noclip")
local flyRow, flyLabel, flySquir = createRowWithSquircle(controlsFrame, 44, "Fly")
local speedRow = createSliderRow(controlsFrame, 92, "Speed", GAME_DEFAULT_WALKSPEED)
speedRow.Row.Visible = false

local deactivateBtn = Instance.new("TextButton", controlsFrame)
deactivateBtn.Size = UDim2.new(0,100,0,28)
deactivateBtn.Position = UDim2.new(0,2,0,128)
deactivateBtn.BackgroundColor3 = Color3.fromRGB(110,110,110)
deactivateBtn.Text = "Deactivate"
deactivateBtn.Font = Enum.Font.GothamBold
deactivateBtn.TextSize = 14
deactivateBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", deactivateBtn).CornerRadius = UDim.new(0,6)

local revertBtn = Instance.new("TextButton", controlsFrame)
revertBtn.Size = UDim2.new(0,86,0,28)
revertBtn.Position = UDim2.new(0, 104, 0, 128)
revertBtn.BackgroundColor3 = Color3.fromRGB(110,110,110); revertBtn.Text = "Revert"
revertBtn.Font = Enum.Font.GothamBold; revertBtn.TextSize = 14; revertBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", revertBtn).CornerRadius = UDim.new(0,6)

local resetReminder = Instance.new("TextLabel", controlsFrame)
resetReminder.Size = UDim2.new(0, 60, 0, 28)
resetReminder.Position = UDim2.new(0, 208, 0, 128)
resetReminder.BackgroundTransparency = 1
resetReminder.Text = "reset"
resetReminder.Font = Enum.Font.GothamBold
resetReminder.TextSize = 14
resetReminder.TextColor3 = Color3.new(1,1,1)
resetReminder.TextXAlignment = Enum.TextXAlignment.Left
resetReminder.Visible = false

local inviteBox = Instance.new("TextBox", mainFrame)
inviteBox.Size = UDim2.new(0.58,0,0,26); inviteBox.Position = UDim2.new(0.02,0,1,-36)
inviteBox.BackgroundTransparency = 0.3; inviteBox.Text = DISCORD_INVITE; inviteBox.ClearTextOnFocus = false
inviteBox.Font = Enum.Font.Gotham; inviteBox.TextSize = 13; inviteBox.TextColor3 = Color3.new(1,1,1)
inviteBox.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", inviteBox).CornerRadius = UDim.new(0,6)

local function resizeInviteBox()
    local pad = 16
    local size = TextService:GetTextSize(inviteBox.Text, inviteBox.TextSize, inviteBox.Font, Vector2.new(2000,100))
    local newW = math.clamp(math.ceil(size.X) + pad, 100, FRAME_W - 100)
    inviteBox.Size = UDim2.new(0, newW, 0, 26)
    inviteBox.Position = UDim2.new(0.02, 0, 1, -36)
end
resizeInviteBox()

inviteBox:GetPropertyChangedSignal("Text"):Connect(function()
    if inviteBox.Text ~= DISCORD_INVITE then
        inviteBox.Text = DISCORD_INVITE
        pcall(function()
            inviteBox:CaptureFocus()
            inviteBox.CursorPosition = #inviteBox.Text + 1
        end)
        resizeInviteBox()
    end
end)
inviteBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pcall(function()
            inviteBox:CaptureFocus()
            inviteBox.CursorPosition = #inviteBox.Text + 1
        end)
    end
end)

local swapBtn = Instance.new("TextButton", mainFrame)
swapBtn.Size = UDim2.new(0, 56, 0, 26)
swapBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
swapBtn.Text = "swap"
swapBtn.Font = Enum.Font.GothamBold
swapBtn.TextSize = 13
swapBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", swapBtn).CornerRadius = UDim.new(0,6)

local function updateSwapPosition()
    swapBtn.Position = UDim2.new(0, inviteBox.AbsolutePosition.X + inviteBox.AbsoluteSize.X + 8 - mainFrame.AbsolutePosition.X, 1, -36)
end
inviteBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSwapPosition)
inviteBox:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateSwapPosition)
updateSwapPosition()

local darkOverlay = Instance.new("Frame", mainFrame)
darkOverlay.Size = UDim2.new(1,0,1,0)
darkOverlay.Position = UDim2.new(0,0,0,0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
darkOverlay.BackgroundTransparency = 0.6
darkOverlay.ZIndex = mainFrame.ZIndex + 50
darkOverlay.Visible = false
darkOverlay.Active = false
darkOverlay.Selectable = false

local dragSticker = Instance.new("ImageButton")
dragSticker.Size = UDim2.new(0,28,0,28); dragSticker.Position = UDim2.new(1,-34,1,-34)
dragSticker.AnchorPoint = Vector2.new(0,0); dragSticker.BackgroundColor3 = Color3.fromRGB(70,70,70)
dragSticker.Image = ""; dragSticker.Parent = mainFrame
Instance.new("UICorner", dragSticker).CornerRadius = UDim.new(0,6)
local originalStickerPos = dragSticker.Position

local function clampPositionToScreen(px, py)
    local cam = workspace.CurrentCamera
    if not cam then return px, py end
    local view = cam.ViewportSize
    local maxX = math.max(0, view.X - mainFrame.AbsoluteSize.X)
    local maxY = math.max(0, view.Y - mainFrame.AbsoluteSize.Y)
    return math.clamp(px, 0, maxX), math.clamp(py, 0, maxY)
end

local isDraggingGUI = false
local dragStartMouse = Vector2.new()
local dragStartPos = Vector2.new()

-- formatting helper (keeps display neat)
local function formatNumber(n)
    if type(n) ~= "number" then return "0" end
    local s = tostring(n)
    if s:find("%.") then
        s = s:gsub("(%.%d-)0+$", "%1")
        s = s:gsub("%.$", "")
    end
    return s
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingGUI = true
        local pos = input.Position or UserInputService:GetMouseLocation()
        dragStartMouse = Vector2.new(pos.X, pos.Y)
        dragStartPos = Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDraggingGUI = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isDraggingGUI then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local pos = input.Position or UserInputService:GetMouseLocation()
    local delta = Vector2.new(pos.X, pos.Y) - dragStartMouse
    mainFrame.Position = UDim2.new(0, dragStartPos.X + delta.X, 0, dragStartPos.Y + delta.Y)
end)

UserInputService.InputChanged:Connect(function(input)
    if not isDraggingGUI then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local pos = input.Position or UserInputService:GetMouseLocation()
    local m = Vector2.new(pos.X, pos.Y)
    local delta = m - dragStartMouse
    local newPos = dragStartPos + delta
    local nx, ny = clampPositionToScreen(newPos.X, newPos.Y)
    mainFrame.Position = UDim2.new(0, nx, 0, ny)
    updateSwapPosition()
    if dragSticker.Parent == screenGui then
        dragSticker.Position = UDim2.new(0, nx + mainFrame.AbsoluteSize.X - 34, 0, ny + mainFrame.AbsoluteSize.Y + 6)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingGUI = false end end)

-- slider helpers that update display immediately
local function setSliderValueImmediate(slider, value)
    local v = math.clamp(value, 0, MAX_VALUE)
    slider.Value = v
    slider.SavedValue = v
    slider.Fill.Size = UDim2.new(v / MAX_VALUE, 0, 1, 0)
    slider.Knob.Position = UDim2.new(v / MAX_VALUE, 0, 0.5, 0)
    -- update the text display RIGHT AWAY (this fixes the bug you saw)
    pcall(function() slider.ValueBox.Text = formatNumber(v) end)
end

local function enableSliderDrag(slider)
    local track, knob = slider.Track, slider.Knob
    local dragging = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    track.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then return end
        local pos = input.Position or UserInputService:GetMouseLocation()
        local mx = pos.X
        local rel = math.clamp((mx - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
        local raw = rel * MAX_VALUE
        local value = math.floor((raw + SNAP/2) / SNAP) * SNAP
        setSliderValueImmediate(slider, value)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = input.Position or UserInputService:GetMouseLocation()
        local mx = pos.X
        local rel = math.clamp((mx - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
        local raw = rel * MAX_VALUE
        local value = math.floor((raw + SNAP/2) / SNAP) * SNAP
        setSliderValueImmediate(slider, value)
    end)
end

enableSliderDrag(speedRow)

-- keep text numeric while typing (cursor preservation)
local function sanitizeNumberStringAllowDot(s)
    local cleaned = s:gsub("[^%d%.]", "")
    local firstDot = cleaned:find("%.")
    if firstDot then
        local before = cleaned:sub(1, firstDot)
        local after = cleaned:sub(firstDot+1):gsub("%.", "")
        cleaned = before .. after
    end
    if cleaned == "" then return nil end
    local n = tonumber(cleaned)
    return n, cleaned
end

local function liveFilterDigitsAndDot(box)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        local text = box.Text or ""
        local cleaned = text:gsub("[^%d%.]", "")
        local firstDot = cleaned:find("%.")
        if firstDot then
            local before = cleaned:sub(1, firstDot)
            local after = cleaned:sub(firstDot+1):gsub("%.", "")
            cleaned = before .. after
        end
        if cleaned ~= text then
            local cur = 1
            pcall(function() cur = box.CursorPosition end)
            local removed = text:len() - cleaned:len()
            box.Text = cleaned
            pcall(function()
                local newCur = math.clamp(cur - removed, 1, math.max(1, #cleaned + 1))
                box.CursorPosition = newCur
            end)
        end
    end)
end

local function hookValueBox(slider)
    local box = slider.ValueBox
    liveFilterDigitsAndDot(box)
    box.FocusLost:Connect(function()
        local txt = box.Text or ""
        local num, _ = sanitizeNumberStringAllowDot(txt)
        if not num then
            setSliderValueImmediate(slider, slider.SavedValue)
            return
        end
        local clamped = math.clamp(num, 0, MAX_VALUE)
        setSliderValueImmediate(slider, clamped)
    end)
end
hookValueBox(speedRow)

-- fly/noclip core
local flyEnabled = false
local noclipEnabled = false
local deactivated = false
local swapMode = false

local bv, bg

local function cleanupFlyObjects()
    if bv and bv.Parent then pcall(function() bv:Destroy() end) end
    if bg and bg.Parent then pcall(function() bg:Destroy() end) end
    bv, bg = nil, nil
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() hum.PlatformStand = false end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        pcall(function() hum.WalkSpeed = GAME_DEFAULT_WALKSPEED end)
    end
end

local noclipSavedState = false
local NOCOLLIC_INTERVAL = 0.3
local noclipLoopRunning = false

local function RestoreCollisions()
    local plr = player
    if not plr or not plr.Character then return end
    for i, v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == false then
            pcall(function() v.CanCollide = true end)
        end
    end
end

local function applyNoclipToCharacterParts(char)
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            pcall(function() v.CanCollide = false end)
        end
    end
end

local function startNoclipLoop()
    if noclipLoopRunning then return end
    noclipLoopRunning = true
    spawn(function()
        while noclipLoopRunning do
            if not noclipEnabled or deactivated then
                local c = player.Character
                if c then RestoreCollisions() end
                noclipLoopRunning = false
                break
            end
            local c = player.Character
            if c then
                applyNoclipToCharacterParts(c)
            end
            wait(NOCOLLIC_INTERVAL)
        end
    end)
end

local function stopNoclipLoop()
    noclipLoopRunning = false
    local c = player.Character
    if c then RestoreCollisions() end
end

local function enableNoclip(enable)
    noclipEnabled = enable
    noclipSquir.Text = enable and "ON" or "OFF"
    if deactivated then
        return
    end
    if enable then startNoclipLoop() else stopNoclipLoop() end
end

local function enableFlyObjects(enable)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if not enable then
        cleanupFlyObjects()
        return
    end
    cleanupFlyObjects()
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0,0,0)
    bv.P = 9e4
    bv.Parent = hrp
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    pcall(function() hum.PlatformStand = true end)
end

RunService.Heartbeat:Connect(function(dt)
    if deactivated then
        if bv then bv.Velocity = Vector3.new(0,0,0) end
        return
    end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local cam = workspace.CurrentCamera
    if not hrp or not hum or not cam then return end
    if flyEnabled then
        if not bv or not bg or not bv.Parent then enableFlyObjects(true) end
        local camC = cam.CFrame
        local camLook = camC.LookVector
        local camRight = camC.RightVector
        local move = hum.MoveDirection or Vector3.new(0,0,0)
        local horizForward = Vector3.new(camLook.X, 0, camLook.Z)
        local horizRight = Vector3.new(camRight.X, 0, camRight.Z)
        if horizForward.Magnitude < 1e-6 then horizForward = Vector3.new(0,0,1) end
        if horizRight.Magnitude < 1e-6 then horizRight = Vector3.new(1,0,0) end
        horizForward = horizForward.Unit
        horizRight = horizRight.Unit
        local forwardInput = Vector3.new(move.X,0,move.Z):Dot(horizForward)
        local rightInput = Vector3.new(move.X,0,move.Z):Dot(horizRight)
        local dir = (camLook * forwardInput) + (camRight * rightInput)
        if dir.Magnitude < 1e-4 then
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity:Lerp(Vector3.new(0,0,0), math.clamp(30 * dt, 0, 1))
            end
        else
            local dirUnit = dir.Unit
            -- use slider.Value directly (kept in sync by setSliderValueImmediate)
            local speed = math.clamp(speedRow.Value or GAME_DEFAULT_WALKSPEED, 0, MAX_VALUE)
            local targetVel = dirUnit * speed
            if bv and bv.Parent then
                local current = bv.Velocity
                local lerpVel = current:Lerp(targetVel, math.clamp(30 * dt, 0, 1))
                bv.Velocity = lerpVel
            end
            if bg and bg.Parent then
                local yawLook = Vector3.new(camLook.X, 0, camLook.Z)
                if yawLook.Magnitude < 1e-6 then yawLook = Vector3.new(0,0,1) end
                local look = CFrame.new(hrp.Position, hrp.Position + yawLook)
                bg.CFrame = look
            end
        end
    else
        if bv or bg then cleanupFlyObjects() end
        if not deactivated then
            local val = GAME_DEFAULT_WALKSPEED
            hum.WalkSpeed = math.clamp(val, 0, MAX_VALUE)
        end
    end
end)

local function updateRevertVisibility()
    if swapMode then
        revertBtn.Visible = flyEnabled
        deactivateBtn.Visible = true
    else
        revertBtn.Visible = false
        deactivateBtn.Visible = false
    end
end

local function setNoclip(on) enableNoclip(on) end

local function setFly(on)
    flyEnabled = on
    flySquir.Text = on and "ON" or "OFF"
    speedRow.Row.Visible = on
    updateRevertVisibility()
    if deactivated then
        if not on then cleanupFlyObjects() end
        return
    end
    if on then enableFlyObjects(true) else
        enableFlyObjects(false)
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.WalkSpeed = GAME_DEFAULT_WALKSPEED end) end
    end
end

noclipSquir.MouseButton1Click:Connect(function() setNoclip(not noclipEnabled) end)
flySquir.MouseButton1Click:Connect(function() setFly(not flyEnabled) end)

deactivateBtn.MouseButton1Click:Connect(function()
    deactivated = not deactivated
    if deactivated then
        deactivateBtn.Text = "Activate"
        darkOverlay.Visible = true
        resetReminder.Visible = true
        swapBtn.Visible = false
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.WalkSpeed = GAME_DEFAULT_WALKSPEED end) end
        noclipSavedState = noclipEnabled
        if noclipEnabled then
            noclipEnabled = false
            stopNoclipLoop()
            noclipSquir.Text = "OFF"
        end
        cleanupFlyObjects()
    else
        deactivateBtn.Text = "Deactivate"
        darkOverlay.Visible = false
        resetReminder.Visible = false
        swapBtn.Visible = true
        if noclipSavedState then
            noclipEnabled = true
            noclipSquir.Text = "ON"
            startNoclipLoop()
        end
        if flyEnabled then enableFlyObjects(true) end
    end
end)

revertBtn.MouseButton1Click:Connect(function()
    local default = GAME_DEFAULT_WALKSPEED or 16
    setSliderValueImmediate(speedRow, default)
    if not deactivated and not flyEnabled then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = GAME_DEFAULT_WALKSPEED end
    end
end)

swapBtn.MouseButton1Click:Connect(function()
    swapMode = not swapMode
    if swapMode then
        inviteBox.Visible = false
        deactivateBtn.Visible = true
        revertBtn.Visible = flyEnabled
    else
        inviteBox.Visible = true
        deactivateBtn.Visible = false
        revertBtn.Visible = false
    end
    if deactivated and swapMode then
        resetReminder.Visible = true
    else
        resetReminder.Visible = false
    end
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    controlsFrame.Visible = not minimized
    inviteBox.Visible = not minimized and (not swapMode)
    swapBtn.Visible = not minimized and (not deactivated)
    if minimized then
        resetReminder.Visible = false
        mainFrame.Size = UDim2.new(0, FRAME_W, 0, 36)
        dragSticker.Parent = screenGui
        local absX, absY = mainFrame.AbsolutePosition.X, mainFrame.AbsolutePosition.Y
        dragSticker.Position = UDim2.new(0, absX + mainFrame.AbsoluteSize.X - 34, 0, absY + mainFrame.AbsoluteSize.Y + 6)
    else
        mainFrame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
        dragSticker.Parent = mainFrame
        dragSticker.Position = originalStickerPos
        if deactivated and swapMode then resetReminder.Visible = true end
    end
    updateSwapPosition()
end)

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local defaultsCaptured = false
local function onCharacterAdded(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if not defaultsCaptured then
            GAME_DEFAULT_WALKSPEED = hum.WalkSpeed or GAME_DEFAULT_WALKSPEED
            defaultsCaptured = true
            setSliderValueImmediate(speedRow, GAME_DEFAULT_WALKSPEED)
        end
    end
    setFly(false)
    if noclipEnabled and not deactivated then startNoclipLoop() else RestoreCollisions() end
    cleanupFlyObjects()
end

if player.Character then onCharacterAdded(player.Character) end
player.CharacterAdded:Connect(onCharacterAdded)

spawn(function()
    while screenGui.Parent do
        pcall(function()
            if deactivated then wait(0.04); return end
            local char = player.Character
            if not char then wait(0.04); return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then wait(0.04); return end
            if not flyEnabled then
                hum.WalkSpeed = GAME_DEFAULT_WALKSPEED
            end
        end)
        wait(0.04)
    end
end)

RunService:BindToRenderStep("ClampGUIPosition", Enum.RenderPriority.Camera.Value + 1, function()
    local pos = mainFrame.AbsolutePosition
    local nx, ny = clampPositionToScreen(pos.X, pos.Y)
    if nx ~= pos.X or ny ~= pos.Y then mainFrame.Position = UDim2.new(0, nx, 0, ny) end
    updateSwapPosition()
    if dragSticker.Parent == screenGui then
        local sx = mainFrame.AbsolutePosition.X + mainFrame.AbsoluteSize.X - 34
        local sy = mainFrame.AbsolutePosition.Y + mainFrame.AbsoluteSize.Y + 6
        dragSticker.Position = UDim2.new(0, sx, 0, sy)
    end
end)
   end,
})
---Fly Script bitiş 
-- RenderStepped yerine JumpRequest kullanıyoruz
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Varsayılan değerler
local WalkSpeedValue = 16
local JumpPowerValue = 50


-- Slider: WalkSpeed
MainTab:CreateSlider({
    Name = "👟Walkspeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "Walkspeed",
    CurrentValue = WalkSpeedValue,
    Callback = function(v)
        WalkSpeedValue = v
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = v
        end
    end
})

-- Slider: JumpPower
MainTab:CreateSlider({
    Name = "Doesnt Work 👟JumpPower",
    Range = {50, 500},
    Increment = 1,
    Suffix = "JumpPower",
    CurrentValue = JumpPowerValue,
    Callback = function(v)
        JumpPowerValue = v
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.JumpPower = v
        end
    end
})

-- Character Spawn olduğunda değerleri uygula
Player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = WalkSpeedValue
    humanoid.JumpPower = JumpPowerValue
end)


local MainTab = MainWindow:CreateTab("Misc", 4483362458) -- Title, Image


local Button = MainTab:CreateButton({
   Name = "infinite Yield With Ai",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/BokX1/InfiniteYieldWithAI/refs/heads/main/InfiniteYieldWithAI.Lua"))()
   end,
})



local Button = MainTab:CreateButton({
   Name = "Server Founder",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/HT2jAOuI/raw", true))()
   end,
})
