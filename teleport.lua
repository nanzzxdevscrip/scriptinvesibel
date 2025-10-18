-- Teleport script untuk Steal a Brainrot
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Ganti dengan **kode private server kamu** untuk game ini:
local PRIVATE_SERVER_CODE = "a684e76e90f6664f876d02d9cd2191a6"

-- Ambil secara otomatis
local PLACE_ID = 109983668079237

-- UI Loading Fullscreen
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0

local textLabel = Instance.new("TextLabel", frame)
textLabel.AnchorPoint = Vector2.new(0.5,0.5)
textLabel.Position = UDim2.new(0.5,0,0.4,0)
textLabel.Size = UDim2.new(0.8,0,0.1,0)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextScaled = true
textLabel.TextColor3 = Color3.fromRGB(255,255,255)
textLabel.BackgroundTransparency = 1
textLabel.Text = "🔄 Menghubungkan ke Private Server..."

local barBackground = Instance.new("Frame", frame)
barBackground.AnchorPoint = Vector2.new(0.5,0)
barBackground.Position = UDim2.new(0.5,0,0.55,0)
barBackground.Size = UDim2.new(0.6,0,0.03,0)
barBackground.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBackground.BorderSizePixel = 0

local bar = Instance.new("Frame", barBackground)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.BorderSizePixel = 0

-- Animasi progress
for i=1,100 do
    bar.Size = UDim2.new(i/100,0,1,0)
    textLabel.Text = "🔄 Menghubungkan ke Private Server... "..i.."%"
    task.wait(0.03)
end

-- Teleport ke private server
local success, err = pcall(function()
    TeleportService:TeleportToPrivateServer(PLACE_ID, PRIVATE_SERVER_CODE, {player})
end)
if not success then
    textLabel.Text = "❌ Gagal menghubungkan: "..tostring(err)
    bar.BackgroundColor3 = Color3.fromRGB(255,0,0)
end
