local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إنشاء واجهة الشاشة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainInterface"
screenGui.Parent = playerGui

-- الإطار الرئيسي في أعلى يسار الشاشة
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 50)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- زر البرق الأزرق
local lightningButton = Instance.new("TextButton")
lightningButton.Name = "LightningButton"
lightningButton.Size = UDim2.new(1, 0, 1, 0)
lightningButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
lightningButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lightningButton.Text = "⚡ البرق"
lightningButton.Font = Enum.Font.GothamBold
lightningButton.TextSize = 16
lightningButton.Parent = mainFrame

-- القائمة المنبثقة
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0, 0, 1, 5)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = mainFrame

-- عنوان القائمة
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "قائمة الأحداث v1.0"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = menuFrame

-- حقل كتابة اسم اللعبة
local gameNameBox = Instance.new("TextBox")
gameNameBox.Name = "GameNameBox"
gameNameBox.Size = UDim2.new(0.9, 0, 0, 35)
gameNameBox.Position = UDim2.new(0.05, 0, 0, 50)
gameNameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
gameNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
gameNameBox.PlaceholderText = "اكتب اسم اللعبة هنا..."
gameNameBox.Font = Enum.Font.Gotham
gameNameBox.TextSize = 14
gameNameBox.Parent = menuFrame

-- متغيرات التحكم
local cooldownActive = false
local cooldownTime = 57
local remainingTime = 0

-- وظيفة تحديث العداد
local function updateCooldown()
    while cooldownActive and remainingTime > 0 do
        lightningButton.Text = "⏳ " .. remainingTime .. "s"
        remainingTime -= 1
        wait(1)
    end
    
    if not cooldownActive then
        lightningButton.Text = "⚡ البرق"
        lightningButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    end
end

-- وظيفة تأثير البرق
local function startLightningEffect()
    -- إخفاء القائمة
    menuFrame.Visible = false
    
    -- تشغيل الموسيقى
    local music = Instance.new("Sound")
    music.SoundId = "rbxassetid://1836280076"
    music.Parent = SoundService
    music:Play()
    
    -- تغيير لون السماء
    local lighting = game:GetService("Lighting")
    local originalBrightness = lighting.Brightness
    local originalFogEnd = lighting.FogEnd
    
    lighting.Brightness = 0.3
    lighting.FogEnd = 500
    
    -- تأثيرات البرق
    local lightningCount = 0
    local maxLightnings = 10
    
    local function createLightning()
        if lightningCount >= maxLightnings then return end
        lightningCount += 1
        
        -- صوت البرق
        local thunderSound = Instance.new("Sound")
        thunderSound.SoundId = "rbxassetid://1079408535"
        thunderSound.Parent = SoundService
        thunderSound:Play()
        
        -- فلاش ضوئي
        local flash = Instance.new("SurfaceLight")
        flash.Brightness = 50
        flash.Range = 100
        flash.Color = Color3.fromRGB(200, 200, 255)
        flash.Parent = lighting
        
        wait(0.2)
        flash:Destroy()
    end
    
    -- إنشاء برق عشوائي خلال 57 ثانية
    local startTime = tick()
    local endTime = startTime + cooldownTime
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime >= endTime then
            connection:Disconnect()
            -- إعادة الإعدادات الأصلية
            lighting.Brightness = originalBrightness
            lighting.FogEnd = originalFogEnd
            music:Stop()
            cooldownActive = false
            return
        end
        
        -- فرصة عشوائية لإنشاء برق
        if math.random(1, 20) == 1 then
            createLightning()
        end
    end)
end

-- حدث النقر على زر البرق
lightningButton.MouseButton1Click:Connect(function()
    if cooldownActive then return end
    
    if menuFrame.Visible then
        menuFrame.Visible = false
    else
        menuFrame.Visible = true
    end
end)

-- زر التشغيل داخل القائمة
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Size = UDim2.new(0.9, 0, 0, 40)
startButton.Position = UDim2.new(0.05, 0, 0, 100)
startButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.Text = "بدء الأحداث ⚡"
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 16
startButton.Parent = menuFrame

startButton.MouseButton1Click:Connect(function()
    if cooldownActive then return end
    
    cooldownActive = true
    remainingTime = cooldownTime
    
    -- بدء العداد والتأثيرات
    spawn(updateCooldown)
    spawn(startLightningEffect)
    
    -- تعطيل الزر مؤقتاً
    lightningButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

-- نص الصيانة
local maintenanceLabel = Instance.new("TextLabel")
maintenanceLabel.Name = "MaintenanceLabel"
maintenanceLabel.Size = UDim2.new(1, 0, 0, 30)
maintenanceLabel.Position = UDim2.new(0, 0, 1, -30)
maintenanceLabel.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
maintenanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
maintenanceLabel.Text = "🛠️ النظام قيد الصيانة"
maintenanceLabel.Font = Enum.Font.GothamBold
maintenanceLabel.TextSize = 12
maintenanceLabel.Parent = screenGui

print("تم تحميل نظام الأحداث بنجاح! v1.0")
