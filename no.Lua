-- LocalScript في StarterPlayerScripts
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- إنشاء واجهة المستخدم
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalsTracker"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- الإحداثيات المطلوبة للجواهر
local crystalLocations = {
    {X = 192, Y = 7, Z = -279},
    {X = 166, Y = 4, Z = -210},
    {X = 128, Y = 18, Z = -61},
    {X = 66, Y = 18, Z = 1},
    {X = 192, Y = 6, Z = -269},
    {X = 68, Y = 49, Z = -123},
    {X = -102, Y = 7, Z = -90},
    {X = 22, Y = 18, Z = 26}
}

-- متغيرات التتبع
local collectedCrystals = 0
local totalCrystals = #crystalLocations
local crystals = {}
local connection

-- واجهة العد
local crystalsCounter = Instance.new("Frame")
crystalsCounter.Name = "CrystalsCounter"
crystalsCounter.Size = UDim2.new(0, 200, 0, 80)
crystalsCounter.Position = UDim2.new(1, -210, 0, 10)
crystalsCounter.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
crystalsCounter.BorderSizePixel = 0
crystalsCounter.Parent = ScreenGui

-- صورة الكريستال
local crystalImage = Instance.new("ImageLabel")
crystalImage.Name = "CrystalImage"
crystalImage.Size = UDim2.new(0, 50, 0, 50)
crystalImage.Position = UDim2.new(0, 10, 0.5, -25)
crystalImage.BackgroundTransparency = 1
crystalImage.Image = "rbxassetid://6251281936" -- صورة الكريستال
crystalImage.Parent = crystalsCounter

-- عداد الجواهر
local counterText = Instance.new("TextLabel")
counterText.Name = "CounterText"
counterText.Size = UDim2.new(0, 120, 1, 0)
counterText.Position = UDim2.new(0, 70, 0, 0)
counterText.BackgroundTransparency = 1
counterText.TextColor3 = Color3.fromRGB(255, 255, 255)
counterText.Text = collectedCrystals .. " / " .. totalCrystals
counterText.Font = Enum.Font.GothamBold
counterText.TextSize = 20
counterText.TextXAlignment = Enum.TextXAlignment.Left
counterText.Parent = crystalsCounter

-- دالة تشغيل الصوت
local function playCrystalSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://5226834046"
    sound.Volume = 0.7
    sound.Parent = workspace
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 5)
end

-- دالة إنشاء كريستال
local function createCrystal(location, index)
    local crystal = Instance.new("Part")
    crystal.Name = "Crystal_" .. index
    crystal.Size = Vector3.new(2, 3, 2)
    crystal.Position = Vector3.new(location.X, location.Y, location.Z)
    crystal.Anchored = true
    crystal.CanCollide = false
    crystal.Material = Enum.Material.Neon
    
    -- ألوان عشوائية للكريستالات
    local colors = {
        Color3.fromRGB(255, 50, 50),    -- أحمر
        Color3.fromRGB(50, 255, 50),    -- أخضر
        Color3.fromRGB(50, 50, 255),    -- أزرق
        Color3.fromRGB(255, 255, 50),   -- أصفر
        Color3.fromRGB(255, 50, 255),   -- وردي
        Color3.fromRGB(50, 255, 255),   -- تركواز
        Color3.fromRGB(255, 150, 50),   -- برتقالي
        Color3.fromRGB(150, 50, 255)    -- بنفسجي
    }
    
    crystal.BrickColor = BrickColor.new(colors[index] or colors[1])
    crystal.Parent = workspace
    
    -- نقطة ضوء
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Color = crystal.BrickColor.Color
    pointLight.Parent = crystal
    
    -- تأثير التوهج
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Top
    surfaceGui.Parent = crystal
    
    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(1, 0, 1, 0)
    glowFrame.BackgroundColor3 = crystal.BrickColor.Color
    glowFrame.BackgroundTransparency = 0.7
    glowFrame.Parent = surfaceGui
    
    -- تفعيل اللمس
    local touchPart = Instance.new("Part")
    touchPart.Name = "TouchPart"
    touchPart.Size = Vector3.new(4, 4, 4)
    touchPart.Position = crystal.Position
    touchPart.Anchored = true
    touchPart.CanCollide = false
    touchPart.Transparency = 1
    touchPart.Parent = crystal
    
    -- تأثير الطيران والتدوير
    local startY = crystal.Position.Y
    local timeOffset = math.random() * 10
    
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        local time = tick() + timeOffset
        crystal.CFrame = crystal.CFrame * CFrame.Angles(0, deltaTime * 2, 0)
        
        -- حركة الطيران الخفيفة
        local newY = startY + math.sin(time * 2) * 1.5
        crystal.Position = Vector3.new(crystal.Position.X, newY, crystal.Position.Z)
        touchPart.Position = crystal.Position
        
        -- تأثير النبض للضوء
        pointLight.Brightness = 1.5 + math.sin(time * 3) * 0.5
    end)
    
    -- حدث اللمس
    touchPart.Touched:Connect(function(hit)
        local character = hit.Parent
        if character and character:FindFirstChild("Humanoid") and character == Player.Character then
            -- التأكد من أن اللاعب هو من لمس الكريستال
            if not crystal:GetAttribute("Collected") then
                crystal:SetAttribute("Collected", true)
                
                -- إزالة الكريستال
                connection:Disconnect()
                crystal:Destroy()
                
                -- زيادة العداد
                collectedCrystals = collectedCrystals + 1
                counterText.Text = collectedCrystals .. " / " .. totalCrystals
                
                -- تشغيل الصوت
                playCrystalSound()
                
                -- تأثيرات جمع الكريستال
                showCollectionEffect(index)
                
                -- التحقق من الانتهاء
                if collectedCrystals >= totalCrystals then
                    showCompletionScreen()
                end
            end
        end
    end)
    
    return crystal
end

-- دالة تأثير جمع الكريستال
local function showCollectionEffect(crystalNumber)
    local effectGui = Instance.new("ScreenGui")
    effectGui.Parent = PlayerGui
    
    local effectText = Instance.new("TextLabel")
    effectText.Size = UDim2.new(0, 200, 0, 60)
    effectText.Position = UDim2.new(0.5, -100, 0.3, 0)
    effectText.BackgroundTransparency = 1
    effectText.TextColor3 = Color3.fromRGB(255, 255, 0)
    effectText.Text = "جوهرة " .. crystalNumber .. " ✓"
    effectText.Font = Enum.Font.GothamBold
    effectText.TextSize = 24
    effectText.TextStrokeTransparency = 0
    effectText.Parent = effectGui
    
    -- تأثير الظهور
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(effectText, tweenInfo, {
        Position = UDim2.new(0.5, -100, 0.2, 0),
        TextTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        effectGui:Destroy()
    end)
end

-- دالة شاشة الانتهاء
local function showCompletionScreen()
    local completionGui = Instance.new("ScreenGui")
    completionGui.Parent = PlayerGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.Parent = completionGui
    
    local completionFrame = Instance.new("Frame")
    completionFrame.Size = UDim2.new(0, 400, 0, 300)
    completionFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    completionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    completionFrame.BorderSizePixel = 0
    completionFrame.Parent = completionGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 80)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "🎉 مبروك! 🎉"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.Parent = completionFrame
    
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, 0, 0, 100)
    message.Position = UDim2.new(0, 0, 0, 90)
    message.BackgroundTransparency = 1
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.Text = "لقد جمعت جميع الجواهر!\n\nالطاقة كاملة!"
    message.Font = Enum.Font.Gotham
    message.TextSize = 20
    message.TextYAlignment = Enum.TextYAlignment.Center
    message.Parent = completionFrame
    
    local crystalImage = Instance.new("ImageLabel")
    crystalImage.Size = UDim2.new(0, 100, 0, 100)
    crystalImage.Position = UDim2.new(0.5, -50, 0, 180)
    crystalImage.BackgroundTransparency = 1
    crystalImage.Image = "rbxassetid://6251281936"
    crystalImage.Parent = completionFrame
    
    -- تشغيل صوت النصر
    local victorySound = Instance.new("Sound")
    victorySound.SoundId = "rbxassetid://5226834046"
    victorySound.Volume = 1.0
    victorySound.Parent = completionFrame
    victorySound:Play()
end

-- دالة بدء اللعبة
local function startCrystalGame()
    -- إنشاء جميع الكريستالات
    for i, location in ipairs(crystalLocations) do
        local crystal = createCrystal(location, i)
        table.insert(crystals, crystal)
    end
    
    print("🎮 بدأت لعبة الجواهر! هناك " .. totalCrystals .. " جوهرة يجب جمعها")
end

-- بدء اللعبة عند التحميل
startCrystalGame()

-- تنظيف عند إعادة التوليد
Player.CharacterAdded:Connect(function()
    collectedCrystals = 0
    counterText.Text = collectedCrystals .. " / " .. totalCrystals
    
    -- إعادة تعيين الكريستالات
    for _, crystal in ipairs(crystals) do
        if crystal then
            crystal:Destroy()
        end
    end
    crystals = {}
    
    wait(3) -- انتظار تحميل الشخصية
    startCrystalGame()
end)
