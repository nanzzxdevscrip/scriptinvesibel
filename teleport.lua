-- Full Auto Teleport to Private Server
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ganti sesuai private server kamu
local PRIVATE_SERVER_CODE = "a684e76e90f6664f876d02d9cd2191a6"
local PLACE_ID = game.PlaceId -- otomatis ambil game yang sama

-- buat loading screen
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Text = "Menghubungkan ke Private Server..."
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.BackgroundTransparency = 1

local BarFrame = Instance.new("Frame", Frame)
BarFrame.AnchorPoint = Vector2.new(0.5, 0)
BarFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
BarFrame.Size = UDim2.new(0.5, 0, 0.03, 0)
BarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BarFrame.BorderSizePixel = 0

local Bar = Instance.new("Frame", BarFrame)
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Bar.BorderSizePixel = 0

-- animasi progress
task.spawn(function()
	for i = 1, 100 do
		TweenService:Create(Bar, TweenInfo.new(0.05), {Size = UDim2.new(i/100, 0, 1, 0)}):Play()
		TextLabel.Text = "Menghubungkan ke Private Server... " .. i .. "%"
		task.wait(0.05)
	end
end)

-- coba teleport
task.delay(5, function()
	local success, err = pcall(function()
		TeleportService:TeleportToPrivateServer(PLACE_ID, PRIVATE_SERVER_CODE, {player})
	end)
	
	if not success then
		TextLabel.Text = "Gagal menghubungkan: " .. tostring(err)
		Bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end
end)
