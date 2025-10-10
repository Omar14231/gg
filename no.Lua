local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer

-- انتظر حتى يظهر البلاير جوي
while not player:FindFirstChild("PlayerGui") do
    wait(0.1)
end

-- دالة للتأكد من ظهور العناصر على جميع الأجهزة
local function createSafeGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PrivateChatGui"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = false  -- مهم للجوال
    
    -- إعدادات خاصة للجوال
    if GuiService:IsTenFootInterface() then
        -- إعدادات للتلفزيون
        screenGui.DisplayOrder = 10
    end
    
    return screenGui
end

-- البحث عن زر الشات الأصلي وإخفاؤه
local function hideOriginalChatButton()
    local success, error = pcall(function()
        -- طريقة آمنة للبحث عن زر الشات
        local chatGui = player.PlayerGui:FindFirstChild("Chat")
        if chatGui then
            chatGui.Enabled = false
        end
        
        -- البحث في جميع العناصر
        for _, gui in pairs(player.PlayerGui:GetDescendants()) do
            if gui:IsA("Frame") or gui:IsA("TextButton") then
                if gui.Name:lower():find("chat") or (gui:IsA("TextButton") and gui.Text:lower():find("chat")) then
                    gui.Visible = false
                end
            end
        end
    end)
    
    if not success then
        print("⚠️ لا يمكن إخفاء زر الشات الأصلي")
    end
end

-- إنشاء زر الشات الجديد
local function createNewChatButton(parentGui)
    local chatButton = Instance.new("TextButton")
    chatButton.Name = "PrivateChatButton"
    chatButton.Size = UDim2.new(0, 60, 0, 60)  -- حجم أكبر للجوال
    chatButton.Position = UDim2.new(0, 30, 1, -100) -- مكان واضح
    chatButton.AnchorPoint = Vector2.new(0, 1)
    chatButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    chatButton.Text = "💬"
    chatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    chatButton.TextSize = 24  -- حجم نص أكبر
    chatButton.ZIndex = 100
    chatButton.Visible = true
    chatButton.Active = true
    chatButton.Selectable = true
    chatButton.Parent = parentGui

    -- زوايا مستديرة
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = chatButton

    -- تأثير عند الضغط
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 2
    buttonStroke.Parent = chatButton

    return chatButton
end

-- إنشاء نافذة الكتابة
local function createChatWindow(parentGui)
    local frame = Instance.new("Frame")
    frame.Name = "ChatWindow"
    frame.Size = UDim2.new(0.8, 0, 0, 250)  -- نسبة مئوية تناسب جميع الشاشات
    frame.Position = UDim2.new(0.1, 0, 0.3, 0)  -- في منتصف الشاشة
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 90
    frame.Parent = parentGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    -- طبقة خلفية شفافة لتغطية الشاشة
    local backgroundBlur = Instance.new("Frame")
    backgroundBlur.Name = "BackgroundBlur"
    backgroundBlur.Size = UDim2.new(1, 0, 1, 0)
    backgroundBlur.Position = UDim2.new(0, 0, 0, 0)
    backgroundBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backgroundBlur.BackgroundTransparency = 0.5
    backgroundBlur.BorderSizePixel = 0
    backgroundBlur.Visible = false
    backgroundBlur.ZIndex = 80
    backgroundBlur.Parent = parentGui

    -- عنوان النافذة
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.Text = "💬 الشات الخاص"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title

    -- حقل الكتابة
    local textBox = Instance.new("TextBox")
    textBox.Name = "ChatInput"
    textBox.Size = UDim2.new(1, -20, 0, 100)
    textBox.Position = UDim2.new(0, 10, 0, 50)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "اكتب رسالتك هنا..."
    textBox.Text = ""
    textBox.TextSize = 18
    textBox.ClearTextOnFocus = false
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextYAlignment = Enum.TextYAlignment.Top
    textBox.MultiLine = true
    textBox.ZIndex = 95
    textBox.Parent = frame

    local textCorner = Instance.new("UICorner")
    textCorner.CornerRadius = UDim.new(0, 8)
    textCorner.Parent = textBox

    -- زر الإرسال
    local sendButton = Instance.new("TextButton")
    sendButton.Name = "SendButton"
    sendButton.Size = UDim2.new(0, 120, 0, 45)
    sendButton.Position = UDim2.new(0.5, -60, 1, -60)
    sendButton.AnchorPoint = Vector2.new(0.5, 0)
    sendButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    sendButton.Text = "🔄 إرسال"
    sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendButton.TextSize = 18
    sendButton.ZIndex = 95
    sendButton.Parent = frame

    local sendCorner = Instance.new("UICorner")
    sendCorner.CornerRadius = UDim.new(0, 10)
    sendCorner.Parent = sendButton

    -- زر الإغلاق
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 120, 0, 45)
    closeButton.Position = UDim2.new(0.5, -60, 1, -10)
    closeButton.AnchorPoint = Vector2.new(0.5, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "❌ إغلاق"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.ZIndex = 95
    closeButton.Parent = frame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeButton

    return frame, textBox, sendButton, closeButton, backgroundBlur
end

-- عرض الرسالة فوق الرأس
local function showMessageAboveHead(sender, message)
    local character = sender.Character
    if not character then
        -- إذا الكاراكتر مش موجود، ننتظر
        if sender.CharacterAdded then
            sender.CharacterAdded:Wait()
            character = sender.Character
        else
            return
        end
    end
    
    local head = character:WaitForChild("Head", 5)
    if not head then return end

    -- إنشاء BillboardGui للرسالة
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PrivateMessage"
    billboardGui.Size = UDim2.new(0, 300, 0, 80)  -- حجم أكبر
    billboardGui.ExtentsOffset = Vector3.new(0, 4, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Adornee = head
    billboardGui.MaxDistance = 100  -- مسافة رؤية أكبر
    billboardGui.Enabled = true
    billboardGui.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "💬 " .. message
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 200)  -- لون مميز
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextSize = 18  -- حجم نص أكبر
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextWrapped = true  -- نص يلف
    textLabel.Parent = billboardGui

    -- تأثير الظهور
    textLabel.TextTransparency = 0.3
    local tween = TweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 0})
    tween:Play()

    -- إخفاء الرسالة بعد 15 ثانية
    delay(15, function()
        local disappearTween = TweenService:Create(textLabel, TweenInfo.new(1), {TextTransparency = 1})
        disappearTween:Play()
        wait(1)
        if billboardGui then
            billboardGui:Destroy()
        end
    end)
end

-- النظام الرئيسي
local function setupPrivateChat()
    -- إخفاء زر الشات الأصلي
    hideOriginalChatButton()
    
    -- إنشاء الواجهة الآمنة
    local parentGui = createSafeGui()
    
    -- إنشاء زر الشات الجديد
    local chatButton = createNewChatButton(parentGui)
    
    -- إنشاء نافذة الكتابة
    local chatWindow, textBox, sendButton, closeButton, backgroundBlur = createChatWindow(parentGui)
    
    -- حدث الضغط على زر الشات
    chatButton.MouseButton1Click:Connect(function()
        chatWindow.Visible = not chatWindow.Visible
        backgroundBlur.Visible = chatWindow.Visible
        if chatWindow.Visible then
            wait(0.1)
            textBox:CaptureFocus()
        end
    end)
    
    -- حدث الإرسال
    sendButton.MouseButton1Click:Connect(function()
        local message = string.gsub(textBox.Text, "^%s*(.-)%s*$", "%1")  -- إزالة المسافات
        if message and message ~= "" and #message > 0 then
            -- هنا راح نرسل الرسالة (راح نضيف النظام لاحقاً)
            showMessageAboveHead(player, message)
            textBox.Text = ""
            chatWindow.Visible = false
            backgroundBlur.Visible = false
        end
    end)
    
    -- حدث الإغلاق
    closeButton.MouseButton1Click:Connect(function()
        chatWindow.Visible = false
        backgroundBlur.Visible = false
    end)
    
    -- الإرسال بالإنتر
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local message = string.gsub(textBox.Text, "^%s*(.-)%s*$", "%1")
            if message and message ~= "" and #message > 0 then
                showMessageAboveHead(player, message)
                textBox.Text = ""
                chatWindow.Visible = false
                backgroundBlur.Visible = false
            end
        end
    end)
    
    print("✅ نظام الشات الخاص شغال على جميع الأجهزة!")
end

-- بدء النظام
setupPrivateChat()

-- رسالة تأكيد
wait(1)
print("🎯 السكريبت مفعل بنجاح!")
print("📱 يعمل على: الجوال، الكمبيوتر، التابلت")
print("💬 اضغط على زر 💬 لفتح الشات")
