local PRIVATE_SERVER_LINK = "https://www.roblox.com/share?code=a684e76e90f6664f876d02d9cd2191a6&type=Server" 
-- >>> ganti teks di atas dengan link private server kamu <<<

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Utility: parse placeId and privateServerId dari link
local function parsePrivateServerLink(link)
    if not link or type(link) ~= "string" then return nil end
    -- cari placeId: biasanya setelah /games/ dan sebelum /
    local placeId = link:match("/games/(%d+)")
    -- fallback cari angka di url
    if not placeId then
        placeId = link:match("placeId=(%d+)")
    end
    -- cari privateServerId param
    local serverId = link:match("privateServerId=([%w%-]+)")
    -- terkadang param db encoded -> coba cari last part setelah '?'
    if not serverId then
        serverId = link:match("://.+/(.+)$")
    end
    return placeId and tonumber(placeId), serverId
end

local PLACE_ID, SERVER_ID = parsePrivateServerLink(PRIVATE_SERVER_LINK)

-- Jika parse gagal, beri opsi untuk set manual (user/owner bisa ganti di sini)
if not PLACE_ID or not SERVER_ID then
    -- contoh manual (ganti kalau perlu)
    -- PLACE_ID = 123456789
    -- SERVER_ID = "abcdef-12345"
    warn("Gagal parse link. Pastikan PRIVATE_SERVER_LINK benar, atau set PLACE_ID & SERVER_ID secara manual di script.")
end

-- Safety: pastikan LocalPlayer tersedia (script harus dijalankan client)
if not LocalPlayer then
    -- jika environment non-client, coba print dan stop
    error("Script ini harus dijalankan dari client (LocalScript / executor yang menjalankan code di client).")
end

-- Bikin ScreenGui loading
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportLoadingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 140)
frame.Position = UDim2.new(0.5, -210, 0.5, -70)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 0.08
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Connecting to private server..."
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansSemibold
title.TextScaled = false
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -20, 0, 20)
desc.Position = UDim2.new(0, 10, 0, 44)
desc.BackgroundTransparency = 1
desc.Text = "Preparing teleport..."
desc.TextColor3 = Color3.fromRGB(200,200,200)
desc.Font = Enum.Font.SourceSans
desc.TextSize = 14
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Parent = frame

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(1, -40, 0, 20)
barBackground.Position = UDim2.new(0, 20, 0, 80)
barBackground.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBackground.BorderSizePixel = 0
barBackground.Parent = frame
barBackground.AnchorPoint = Vector2.new(0,0)

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(80,170,255)
progressBar.BorderSizePixel = 0
progressBar.Parent = barBackground

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, 60, 0, 20)
percentLabel.Position = UDim2.new(1, -60, 1, 2)
percentLabel.AnchorPoint = Vector2.new(1,0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(220,220,220)
percentLabel.Font = Enum.Font.SourceSans
percentLabel.TextSize = 14
percentLabel.Parent = frame

-- Fungsi animate progress (0..1) lalu callback
local function animateProgress(target, duration, onComplete)
    local tweenInfo = TweenInfo.new(duration or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Size = UDim2.new(target, 0, 1, 0)}
    local tween = TweenService:Create(progressBar, tweenInfo, goal)
    tween:Play()
    local start = tick()
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        local elapsed = math.clamp((tick() - start) / duration, 0, 1)
        percentLabel.Text = tostring(math.floor(elapsed * target * 100)) .. "%"
    end)
    tween.Completed:Connect(function()
        conn:Disconnect()
        percentLabel.Text = tostring(math.floor(target * 100)) .. "%"
        if onComplete then onComplete() end
    end)
end

-- Sequence: beberapa step progress sebelum teleport
local function startTeleportSequence()
    if not PLACE_ID or not SERVER_ID then
        desc.Text = "Error: PLACE_ID atau SERVER_ID tidak terdeteksi."
        wait(2)
        screenGui:Destroy()
        return
    end

    desc.Text = "Resolving server..."
    animateProgress(0.3, 1.4, function()
        desc.Text = "Preparing connection..."
        animateProgress(0.7, 1.0, function()
            desc.Text = "Finalizing..."
            animateProgress(0.98, 0.6, function()
                -- kecil delay untuk UX
                percentLabel.Text = "100%"
                progressBar.Size = UDim2.new(1,0,1,0)
                wait(0.25)
                desc.Text = "Teleporting now..."
                -- Lakukan teleport ke private server
                local success, err = pcall(function()
                    -- TeleportToPlaceInstance expects numbers/string
                    TeleportService:TeleportToPlaceInstance(PLACE_ID, SERVER_ID, {LocalPlayer})
                end)
                if not success then
                    warn("Teleport gagal:", err)
                    desc.Text = "Teleport gagal: "..tostring(err)
                    wait(2)
                    screenGui:Destroy()
                end
            end)
        end)
    end)
end

-- Jalankan sequence (bisa juga di-trigger oleh event/button)
startTeleportSequence()

-- Optional: agar GUI hilang jika player disambung/teleported
LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then
        screenGui:Destroy()
    end
end)
