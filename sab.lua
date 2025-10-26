-- Konfigurasi
local intervalGali = 2
local jarakCariKuburan = 10
local penggalianAktif = false -- Status penggalian awal

-- Fungsi untuk menggali kuburan
local function galiKuburan(kuburan)
    if kuburan and kuburan:FindFirstChild("ClickDetector") then
        fireclickdetector(kuburan.ClickDetector)
        print("Menggali kuburan:", kuburan.Name)
        wait(intervalGali)
    else
        print("Tidak dapat menemukan ClickDetector pada kuburan.")
    end
end

-- Fungsi untuk mencari kuburan terdekat
local function cariKuburanTerdekat()
    local pemain = game.Players.LocalPlayer
    local karakter = pemain.Character or pemain.CharacterAdded:Wait()
    local posisiPemain = karakter:WaitForChild("HumanoidRootPart").Position
    local kuburanTerdekat = nil
    local jarakTerdekat = jarakCariKuburan

    for i, object in pairs(game.Workspace:GetChildren()) do
        if string.lower(object.Name):find("kuburan") then
            local humanoidRootPart = object:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local jarak = (posisiPemain - humanoidRootPart.Position).Magnitude
                if jarak < jarakTerdekat then
                    kuburanTerdekat = object
                    jarakTerdekat = jarak
                end
            end
        end
    end
    return kuburanTerdekat
end

-- Fungsi loop utama (berjalan jika penggalianAktif == true)
local function loopPenggalian()
    while true do
        if penggalianAktif then
            local kuburan = cariKuburanTerdekat()
            if kuburan then
                galiKuburan(kuburan)
            else
                print("Tidak ada kuburan di sekitar. Menunggu...")
                wait(5)
            end
        else
            print("Penggalian dihentikan. Menunggu perintah...")
            wait(5) -- Jeda sejenak jika penggalian tidak aktif
        end
    end
end

-- Fungsi untuk membuat GUI (User Interface)
local function buatGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PenggalianGUI"
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.05, 0, 0.05, 0)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = screenGui

    local tombolMulai = Instance.new("TextButton")
    tombolMulai.Size = UDim2.new(0, 80, 0, 30)
    tombolMulai.Position = UDim2.new(0.1, 0, 0.1, 0)
    tombolMulai.Text = "Mulai"
    tombolMulai.BackgroundColor3 = Color3.new(0.3, 0.7, 0.3)
    tombolMulai.Parent = frame

    local tombolBerhenti = Instance.new("TextButton")
    tombolBerhenti.Size = UDim2.new(0, 80, 0, 30)
    tombolBerhenti.Position = UDim2.new(0.1, 0, 0.6, 0)
    tombolBerhenti.Text = "Berhenti"
    tombolBerhenti.BackgroundColor3 = Color3.new(0.7, 0.3, 0.3)
    tombolBerhenti.Parent = frame

    -- Event handler untuk tombol "Mulai"
    tombolMulai.MouseButton1Click:Connect(function()
        penggalianAktif = true
        print("Penggalian dimulai!")
    end)

    -- Event handler untuk tombol "Berhenti"
    tombolBerhenti.MouseButton1Click:Connect(function()
        penggalianAktif = false
        print("Penggalian dihentikan!")
    end)
end

-- Panggil fungsi untuk membuat GUI
buatGUI()

-- Mulai loop penggalian di thread terpisah
task.spawn(loopPenggalian)
