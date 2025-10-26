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

-- زاوية مستديرة للزر
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = smallButton

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

local lightningButtonCorner = Instance.new("UICorner")
lightningButtonCorner.CornerRadius = UDim.new(0, 8)
lightningButtonCorner.Parent = lightningButton

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

-- وظيفة تأثير البرق بنمط هادئ
local function startLightningEffect()
    -- إخفاء القائمة عند البدء
    menuFrame.Visible = false
    
    -- تشغيل الموسيقى الخلفية بصوت معتدل
    local music = Instance.new("Sound")
    music.SoundId = "rbxassetid://1836280076"
    music.Volume = 0.7 -- صوت معتدل
    music.Parent = SoundService
    music:Play()
    
    -- تغيير إعدادات الإضاءة
    local lighting = game:GetService("Lighting")
    local originalBrightness = lighting.Brightness
    local originalFogEnd = lighting.FogEnd
    local originalAmbient = lighting.Ambient
    
    lighting.Brightness = 0.3
    lighting.FogEnd = 500
    lighting.Ambient = Color3.fromRGB(80, 80, 100)
    
    -- نمط البرق الهادئ: 5 ثواني برق، 6 توقف، 2 برق، 6 توقف
    local lightningPattern = {
        -- أول 5 ثواني: برق
        {start = 0, duration = 5, active = true},
        -- توقف 6 ثواني
        {start = 5, duration = 6, active = false},
        -- برق 2 ثواني
        {start = 11, duration = 2, active = true},
        -- توقف 6 ثواني
        {start = 13, duration = 6, active = false},
        -- برق 6 ثواني
        {start = 19, duration = 6, active = true},
        -- توقف 5 ثواني
        {start = 25, duration = 5, active = false},
        -- برق 4 ثواني
        {start = 30, duration = 4, active = true},
        -- توقف 4 ثواني
        {start = 34, duration = 4, active = false},
        -- برق 3 ثواني
        {start = 38, duration = 3, active = true},
        -- توقف 5 ثواني
        {start = 41, duration = 5, active = false},
        -- برق 4 ثواني
        {start = 46, duration = 4, active = true},
        -- توقف 3 ثواني
        {start = 50, duration = 3, active = false},
        -- برق 4 ثواني أخيرة
        {start = 53, duration = 4, active = true}
    }
    
    local function createLightning()
        -- صوت البرق بصوت معتدل
        local thunderSound = Instance.new("Sound")
        thunderSound.SoundId = "rbxassetid://1079408535"
        thunderSound.Volume = 0.6 -- صوت معتدل
        thunderSound.Parent = SoundService
        thunderSound:Play()
        
        -- فلاش ضوئي خفيف
        local flash = Instance.new("SurfaceLight")
        flash.Brightness = 40
        flash.Range = 100
        flash.Color = Color3.fromRGB(180, 200, 255)
        flash.Parent = lighting
        
        -- تأثير إضافي خفيف
        lighting.Ambient = Color3.fromRGB(120, 120, 180)
        
        wait(0.2)
        flash:Destroy()
        lighting.Ambient = Color3.fromRGB(80, 80, 100)
    end
    
    -- تشغيل البرق حسب النمط المحدد
    local startTime = tick()
    local endTime = startTime + cooldownTime
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        local elapsed = currentTime - startTime
        
        if currentTime >= endTime then
            connection:Disconnect()
            -- إعادة الإعدادات الأصلية
            lighting.Brightness = originalBrightness
            lighting.FogEnd = originalFogEnd
            lighting.Ambient = originalAmbient
            music:Stop()
            cooldownActive = false
            return
        end
        
        -- التحقق من النمط الزمني للبرق
        for _, pattern in ipairs(lightningPattern) do
            if elapsed >= pattern.start and elapsed < pattern.start + pattern.duration then
                -- إذا كانت هذه فترة برق، ننزل برق خفيف
                if pattern.active and math.random(1, 3) == 1 then -- برق كل 3 إطارات تقريباً
                    spawn(createLightning)
                end
                break
            end
        end
    end)
    
    -- بدء البرق فوراً
    spawn(function()
        wait(1)
        createLightning()
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

-- إغلاق القائمة عند النقر خارجها
local function closeMenuOnClickOutside(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local buttonPos = smallButton.AbsolutePosition
        local buttonSize = smallButton.AbsoluteSize
        local menuPos = menuFrame.AbsolutePosition
        local menuSize = menuFrame.AbsoluteSize
        
        local x, y = mouse.X, mouse.Y
        
        -- إذا النقر خارج الزر والقائمة
        if not (x >= buttonPos.X and x <= buttonPos.X + buttonSize.X and y >= buttonPos.Y and y <= buttonPos.Y + buttonSize.Y) and
           not (x >= menuPos.X and x <= menuPos.X + menuSize.X and y >= menuPos.Y and y <= menuPos.Y + menuSize.Y) then
            menuFrame.Visible = false
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(closeMenuOnClickOutside)

print("تم تحميل نظام البرق بنجاح! v1.0 - النسخة الهادئة")
