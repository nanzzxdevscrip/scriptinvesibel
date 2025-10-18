--// === PRIVATE SERVER TELEPORT SCRIPT ===
--// Buat: nanzzxdev (support Delta, Codex, Arceus X, dll)
--// Fitur:
--// ✅ Auto ambil game.PlaceId (tidak perlu tulis manual)
--// ✅ Fullscreen loading keren
--// ✅ Teleport otomatis ke private server

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Ganti ini dengan KODE PRIVATE SERVER kamu (dari link share Roblox)
local PRIVATE_CODE = "a684e76e90f6664f876d02d9cd2191a6"

-- Ambil otomatis PlaceId game saat ini
local PLACE_ID = game.PlaceId

-- Buat ScreenGui full screen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportLoadingGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
bg.BorderSizePixel = 0
bg.Parent = screenGui

-- Teks utama
local title = Instance.new("TextLabel")
title.Text = "🔄 Menghubungkan ke Private Server..."
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0.4, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = bg

-- Progress bar background
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.6, 0, 0.03, 0)
progressBg.Position = UDim2.new(0.2, 0, 0.55, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBg.BorderSizePixel = 0
progressBg.Parent = bg

-- Progress bar isi
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg

-- Persentase teks
local percent = Instance.new("TextLabel")
percent.Text = "0%"
percent.Font = Enum.Font.Gotham
percent.TextScaled = true
percent.Size = UDim2.new(1, 0, 1, 0)
percent.TextColor3 = Color3.fromRGB(255, 255, 255)
percent.BackgroundTransparency = 1
percent.Parent = progressBg

-- Animasi progress bar
local function animateProgress(duration, callback)
	local tween = TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
	tween:Play()
	
	for i = 1, 100 do
		percent.Text = i .. "%"
		wait(duration / 100)
	end
	
	tween.Completed:Connect(function()
		if callback then callback() end
	end)
end

-- Jalankan animasi loading, lalu teleport
animateProgress(3, function()
	title.Text = "✅ Terhubung! Memasuki private server..."
	wait(0.5)
	
	-- Teleport ke private server
	local success, err = pcall(function()
		TeleportService:TeleportToPrivateServer(PLACE_ID, PRIVATE_CODE, {player})
	end)

	if not success then
		title.Text = "❌ Gagal teleport: " .. tostring(err)
		progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end
end)
