-- // === Teleport ke Private Server kamu ===
-- // Buat: nanzzxdev (Delta Roblox Compatible)
-- // Fungsi: Dari server publik langsung pindah ke private server milikmu
-- // Game tetap sama (auto ambil game.PlaceId)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- 🔑 Kode private server kamu
local PRIVATE_SERVER_CODE = "a684e76e90f6664f876d02d9cd2191a6"
-- 🧩 Ambil placeId otomatis dari game yang sama
local PLACE_ID = game.PlaceId

-- === UI Fullscreen Loading ===
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "TeleportUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local Text = Instance.new("TextLabel", Frame)
Text.AnchorPoint = Vector2.new(0.5, 0.5)
Text.Position = UDim2.new(0.5, 0, 0.45, 0)
Text.Size = UDim2.new(1, 0, 0.1, 0)
Text.Font = Enum.Font.GothamBold
Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Text.TextScaled = true
Text.BackgroundTransparency = 1
Text.Text = "🔄 Menghubungkan ke Private Server kamu..."

local BarBG = Instance.new("Frame", Frame)
BarBG.AnchorPoint = Vector2.new(0.5, 0)
BarBG.Position = UDim2.new(0.5, 0, 0.55, 0)
BarBG.Size = UDim2.new(0.6, 0, 0.03, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BarBG.BorderSizePixel = 0

local Bar = Instance.new("Frame", BarBG)
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Bar.BorderSizePixel = 0

-- Progress Bar Animation
task.spawn(function()
	for i = 1, 100 do
		Bar.Size = UDim2.new(i/100, 0, 1, 0)
		Text.Text = "🔄 Menghubungkan ke Private Server kamu... " .. i .. "%"
		task.wait(0.03)
	end
end)

-- Teleport ke Private Server setelah progress selesai
task.delay(3.5, function()
	Text.Text = "✅ Terhubung! Memasuki Private Server..."
	task.wait(0.5)
	local success, err = pcall(function()
		TeleportService:TeleportToPrivateServer(PLACE_ID, PRIVATE_SERVER_CODE, {player})
	end)
	if not success then
		Text.Text = "❌ Gagal menghubungkan: " .. tostring(err)
		Bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end
end)
