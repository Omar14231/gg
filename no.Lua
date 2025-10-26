local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إنشاء واجهة الشاشة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LightningSystem"
screenGui.Parent = playerGui

-- زر صغير في أعلى يسار الشاشة
local smallButton = Instance.new("TextButton")
smallButton.Name = "SmallButton"
smallButton.Size = UDim2.new(0, 40, 0, 40)
smallButton.Position = UDim2.new(0, 10, 0, 10)
smallButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
smallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
smallButton.Text = "⚡"
smallButton.Font = Enum.Font.GothamBold
smallButton.TextSize = 20
smallButton.Parent = screenGui

-- القائمة المنبثقة (مخفية في البداية)
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 280, 0, 350)
menuFrame.Position = UDim2.new(0, 50, 0, 10)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- زاوية مستديرة للقائمة
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = menuFrame

-- عنوان القائمة
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "⚡ نظام البرق v1.0"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = menuFrame

-- زاوية مستديرة للعنوان
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- حقل كتابة اسم اللعبة
local gameNameBox = Instance.new("TextBox")
gameNameBox.Name = "GameNameBox"
gameNameBox.Size = UDim2.new(0.9, 0, 0, 40)
gameNameBox.Position = UDim2.new(0.05, 0, 0, 70)
gameNameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
gameNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
gameNameBox.PlaceholderText = "اكتب اسم اللعبة هنا..."
gameNameBox.Font = Enum.Font.Gotham
gameNameBox.TextSize = 14
gameNameBox.Parent = menuFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = gameNameBox

-- زر تشغيل البرق داخل القائمة
local lightningButton = Instance.new("TextButton")
lightningButton.Name = "LightningButton"
lightningButton.Size = UDim2.new(0.9, 0, 0, 45)
lightningButton.Position = UDim2.new(0.05, 0, 0, 130)
lightningButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
lightningButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lightningButton.Text = "بدء البرق ⚡"
lightningButton.Font = Enum.Font.GothamBold
lightningButton.TextSize = 16
lightningButton.Parent = menuFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = lightningButton

-- قسم الصيانة
local maintenanceFrame = Instance.new("Frame")
maintenanceFrame.Name = "MaintenanceFrame"
maintenanceFrame.Size = UDim2.new(0.9, 0, 0, 80)
maintenanceFrame.Position = UDim2.new(0.05, 0, 0, 200)
maintenanceFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
maintenanceFrame.Parent = menuFrame

local maintenanceCorner = Instance.new("UICorner")
maintenanceCorner.CornerRadius = UDim.new(0, 8)
maintenanceCorner.Parent = maintenanceFrame

local maintenanceLabel = Instance.new("TextLabel")
maintenanceLabel.Name = "MaintenanceLabel"
maintenanceLabel.Size = UDim2.new(1, 0, 1, 0)
maintenanceLabel.BackgroundTransparency = 1
maintenanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
maintenanceLabel.Text = "🛠️ النظام قيد الصيانة\n\nسيتم إصلاح الأخطاء قريباً"
maintenanceLabel.Font = Enum.Font.GothamBold
maintenanceLabel.TextSize = 14
maintenanceLabel.TextWrapped = true
maintenanceLabel.Parent = maintenanceFrame

-- متغيرات التحكم
local cooldownActive = false
local cooldownTime = 57
local remainingTime = 0

-- وظيفة فتح/إغلاق القائمة
local function toggleMenu()
    menuFrame.Visible = not menuFrame.Visible
end

-- وظيفة تحديث العداد
local function updateCooldown()
    while cooldownActive and remainingTime > 0 do
        lightningButton.Text = "⏳ " .. remainingTime .. "s"
        remainingTime -= 1
        wait(1)
    end
    
    if not cooldownActive then
        lightningButton.Text = "بدء البرق ⚡"
        lightningButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end
end

-- وظيفة تأثير البرق مع برق كثير
local function startLightningEffect()
    -- إخفاء القائمة عند البدء
    menuFrame.Visible = false
    
    -- تشغيل الموسيقى الخلفية
    local music = Instance.new("Sound")
    music.SoundId = "rbxassetid://1836280076"
    music.Parent = SoundService
    music:Play()
    
    -- تغيير إعدادات الإضاءة
    local lighting = game:GetService("Lighting")
    local originalBrightness = lighting.Brightness
    local originalFogEnd = lighting.FogEnd
    
    lighting.Brightness = 0.2
    lighting.FogEnd = 300
    
    -- تأثيرات البرق الكثيرة
    local lightningCount = 0
    local maxLightnings = 30 -- زيادة عدد البرق
    
    local function createLightning()
        if lightningCount >= maxLightnings then return end
        lightningCount += 1
        
        -- صوت البرق
        local thunderSound = Instance.new("Sound")
        thunderSound.SoundId = "rbxassetid://1079408535"
        thunderSound.Parent = SoundService
        thunderSound:Play()
        
        -- فلاش ضوئي قوي
        local flash = Instance.new("SurfaceLight")
        flash.Brightness = 80
        flash.Range = 150
        flash.Color = Color3.fromRGB(200, 220, 255)
        flash.Parent = lighting
        
        -- تأثير إضافي للفلاش
        local originalAmbient = lighting.Ambient
        lighting.Ambient = Color3.fromRGB(100, 100, 150)
        
        wait(0.1)
        flash:Destroy()
        lighting.Ambient = originalAmbient
    end
    
    -- إنشاء برق كثيف خلال 57 ثانية
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
        
        -- برق كثيف - كل 1-2 ثانية برق
        if math.random(1, 15) == 1 then
            spawn(createLightning)
        end
    end)
end

-- أحداث النقر
smallButton.MouseButton1Click:Connect(toggleMenu)

lightningButton.MouseButton1Click:Connect(function()
    if cooldownActive then return end
    
    cooldownActive = true
    remainingTime = cooldownTime
    
    -- بدء العداد والتأثيرات
    spawn(updateCooldown)
    spawn(startLightningEffect)
    
    -- تعطيل الزر مؤقتاً
    lightningButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

print("تم تحميل نظام البرق بنجاح! v1.0")
