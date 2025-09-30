-- dokciNEW Premium с системой тем, уведомлений, ESP и Fly
local Guis = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Защита от повторной загрузки
if _G.DOKCI_NEW_LOADED then
	warn("Dokci NEW Cheat already loaded!")
	return
end
_G.DOKCI_NEW_LOADED = true

-- Система тем
local Themes = {
	["purple"] = {
		Background = Color3.fromRGB(20, 20, 30),
		Primary = Color3.fromRGB(103, 80, 164),
		Secondary = Color3.fromRGB(179, 157, 219),
		Accent = Color3.fromRGB(255, 105, 180),
		Success = Color3.fromRGB(76, 175, 80),
		Danger = Color3.fromRGB(244, 67, 54),
		Text = Color3.fromRGB(245, 245, 245),
		DarkText = Color3.fromRGB(30, 30, 30),
		Name = "Фиолетовая"
	},
	["black"] = {
		Background = Color3.fromRGB(10, 10, 10),
		Primary = Color3.fromRGB(40, 40, 40),
		Secondary = Color3.fromRGB(80, 80, 80),
		Accent = Color3.fromRGB(255, 255, 255),
		Success = Color3.fromRGB(0, 255, 0),
		Danger = Color3.fromRGB(255, 0, 0),
		Text = Color3.fromRGB(255, 255, 255),
		DarkText = Color3.fromRGB(200, 200, 200),
		Name = "Черная"
	},
	["white"] = {
		Background = Color3.fromRGB(240, 240, 240),
		Primary = Color3.fromRGB(255, 255, 255),
		Secondary = Color3.fromRGB(200, 200, 200),
		Accent = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(0, 200, 0),
		Danger = Color3.fromRGB(255, 0, 0),
		Text = Color3.fromRGB(0, 0, 0),
		DarkText = Color3.fromRGB(50, 50, 50),
		Name = "Белая"
	}, 
	["blue"] = {
		Background = Color3.fromRGB(0, 228, 240),
		Primary = Color3.fromRGB(0, 242, 255),
		Secondary = Color3.fromRGB(0, 163, 200),
		Accent = Color3.fromRGB(0, 0, 0),
		Success = Color3.fromRGB(0, 200, 110),
		Danger = Color3.fromRGB(255, 94, 0),
		Text = Color3.fromRGB(93, 0, 255),
		DarkText = Color3.fromRGB(5, 37, 50),
		Name = "Синия"
	},
	["red"] = {
		Background = Color3.fromRGB(147, 0, 2),
		Primary = Color3.fromRGB(255, 0, 4),
		Secondary = Color3.fromRGB(117, 0, 2),
		Accent = Color3.fromRGB(98, 0, 2),
		Success = Color3.fromRGB(34, 88, 0),
		Danger = Color3.fromRGB(255, 107, 109),
		Text = Color3.fromRGB(47, 2, 0),
		DarkText = Color3.fromRGB(255, 234, 0),
		Name = "Красная"
	}
}

local currentTheme = "purple"
local allButtons = {}
local buttonCount = 0
local buttonHeight = 54
local padding = 9

-- Переменные состояний функций
local Noclip = false
local NewSpeed = false
local GodModeEnabled = false
local AntiKillEnabled = false
local graphicsEnabled = false
local farmEnabled = false
local espEnabled = false
local flyEnabled = false

-- ESP переменные
local espObjects = {}
local espConnections = {}

-- Fly переменные
local flying = false
local bodyVelocity
local bodyGyro

-- Создаем основной GUI
local CORE = Instance.new("ScreenGui")
CORE.Enabled = true
CORE.Parent = Guis
CORE.ResetOnSpawn = false
CORE.Name = "dokciNEW_Premium"
CORE.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Фон с градиентом
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Themes[currentTheme].Background
Background.BackgroundTransparency = 1
Background.BorderSizePixel = 0
Background.Parent = CORE

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
})
Gradient.Rotation = 45
Gradient.Parent = Background

-- Основное меню
local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 400, 0, 600)
Menu.Position = UDim2.new(0.5, -200, 0.5, -300)
Menu.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Menu.BackgroundTransparency = 0.2
Menu.BorderSizePixel = 0
Menu.Parent = CORE
Menu.Visible = false

-- Стеклянный эффект
local GlassEffect = Instance.new("Frame")
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.BackgroundTransparency = 0.9
GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassEffect.BorderSizePixel = 0
GlassEffect.Parent = Menu

-- Закругление меню
local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 20)
MenuCorner.Parent = Menu

-- Обводка меню
local MenuStroke = Instance.new("UIStroke")
MenuStroke.Thickness = 2
MenuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MenuStroke.Parent = Menu

-- Заголовок меню
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 80)
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.Parent = Menu

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.5, 0)
Title.BackgroundTransparency = 1
Title.Text = "dokciNEW Premium"
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0.5, 0)
Subtitle.Position = UDim2.new(0, 0, 0.5, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Ultimate Game Enhancement Suite"
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = Header

-- Контейнер для кнопок
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -20, 1, -100)
ScrollContainer.Position = UDim2.new(0, 10, 0, 90)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 6
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.Parent = Menu

-- Кнопка открытия меню
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(1, -80, 0, 20)
OpenButton.BackgroundTransparency = 0.1
OpenButton.BorderSizePixel = 0
OpenButton.Text = "⚡"
OpenButton.TextSize = 20
OpenButton.Parent = CORE

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

-- Информация о версии
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 100, 0, 20)
VersionLabel.Position = UDim2.new(1, -110, 1, -30)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "dokciNEW v4.0"
VersionLabel.TextSize = 12
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
VersionLabel.Parent = CORE

-- СИСТЕМА УВЕДОМЛЕНИЙ
local function showNotification(message, notificationType)
    notificationType = notificationType or "info"
    
    local t = Themes[currentTheme]
    local backgroundColor = t.Primary
    local textColor = t.Text
    local icon = "⚡"
    
    if notificationType == "success" then
        backgroundColor = t.Success
        icon = "✅"
    elseif notificationType == "warning" then
        backgroundColor = t.Danger
        icon = "⚠️"
    elseif notificationType == "error" then
        backgroundColor = t.Danger
        icon = "❌"
    elseif notificationType == "info" then
        backgroundColor = t.Secondary
        icon = "ℹ️"
    end
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 70)
    notification.Position = UDim2.new(1, 350, 1, -100)
    notification.BackgroundColor3 = backgroundColor
    notification.BackgroundTransparency = 0.2
    notification.BorderSizePixel = 0
    notification.ZIndex = 100
    notification.Parent = CORE

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = notification

    local stroke = Instance.new("UIStroke")
    stroke.Color = t.Secondary
    stroke.Thickness = 2
    stroke.Parent = notification

    local glass = Instance.new("Frame")
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundTransparency = 0.9
    glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glass.BorderSizePixel = 0
    glass.Parent = notification

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = textColor
    iconLabel.TextSize = 20
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextXAlignment = Enum.TextXAlignment.Left
    iconLabel.Parent = notification

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -60, 1, -20)
    messageLabel.Position = UDim2.new(0, 50, 0, 10)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = textColor
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.GothamSemibold
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = notification

    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -100)
    })
    tweenIn:Play()

    spawn(function()
        wait(4)
        
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 350, 1, -100)
        })
        tweenOut:Play()
        
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- ФУНКЦИЯ ESP
local function toggleESP(enabled)
    espEnabled = enabled
    
    if enabled then
        showNotification("ESP: ВКЛ", "success")
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                local highlight = Instance.new("Highlight")
                highlight.Name = "dokciESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = character
                
                espObjects[player] = highlight
                
                -- Обработка появления нового персонажа
                espConnections[player] = player.CharacterAdded:Connect(function(newChar)
                    wait(1) -- Ждем появления персонажа
                    if espEnabled then
                        local newHighlight = Instance.new("Highlight")
                        newHighlight.Name = "dokciESP"
                        newHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                        newHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        newHighlight.FillTransparency = 0.5
                        newHighlight.OutlineTransparency = 0
                        newHighlight.Parent = newChar
                        
                        espObjects[player] = newHighlight
                    end
                end)
            end
        end
        
        -- Обработка новых игроков
        espConnections.playerAdded = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                if espEnabled and player ~= LocalPlayer then
                    wait(1)
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "dokciESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = character
                    
                    espObjects[player] = highlight
                end
            end)
        end)
    else
        showNotification("ESP: ВЫКЛ", "info")
        
        -- Удаляем все подсветки
        for player, highlight in pairs(espObjects) do
            if highlight then
                highlight:Destroy()
            end
        end
        
        -- Отключаем все соединения
        for _, connection in pairs(espConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        
        espObjects = {}
        espConnections = {}
    end
end

-- ФУНКЦИЯ FLY
local function toggleFly(enabled)
    flyEnabled = enabled
    
    if enabled then
        showNotification("Fly: ВКЛ (WASD + Space/Shift)", "success")
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                -- Создаем BodyVelocity и BodyGyro для полета
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                bodyVelocity.Parent = rootPart
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
                bodyGyro.P = 1000
                bodyGyro.D = 50
                bodyGyro.Parent = rootPart
                
                -- Отключаем гравитацию
                humanoid.PlatformStand = true
                
                -- Обработка управления
                local flyConnection
                flyConnection = RunService.Heartbeat:Connect(function()
                    if not flyEnabled or not bodyVelocity or not bodyGyro then
                        flyConnection:Disconnect()
                        return
                    end
                    
                    local camera = workspace.CurrentCamera
                    bodyGyro.CFrame = camera.CFrame
                    
                    local velocity = Vector3.new(0, 0, 0)
                    local speed = 50
                    
                    -- Управление WASD
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + (camera.CFrame.LookVector * speed)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity + (camera.CFrame.LookVector * -speed)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity + (camera.CFrame.RightVector * -speed)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + (camera.CFrame.RightVector * speed)
                    end
                    
                    -- Вверх/вниз (Space/Shift)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        velocity = velocity + Vector3.new(0, speed, 0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        velocity = velocity + Vector3.new(0, -speed, 0)
                    end
                    
                    bodyVelocity.Velocity = velocity
                end)
            end
        end
    else
        showNotification("Fly: ВЫКЛ", "info")
        
        -- Восстанавливаем нормальное состояние
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            
            if bodyGyro then
                bodyGyro:Destroy()
                bodyGyro = nil
            end
        end
    end
end

-- Функция применения темы
local function ApplyTheme(themeName)
	currentTheme = themeName
	local t = Themes[themeName]

	Background.BackgroundColor3 = t.Background
	Menu.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	Header.BackgroundColor3 = t.Primary
	Title.TextColor3 = t.Text
	Subtitle.TextColor3 = t.Secondary
	OpenButton.BackgroundColor3 = t.Primary
	OpenButton.TextColor3 = t.Text
	VersionLabel.TextColor3 = t.Secondary

	MenuStroke.Color = t.Secondary
	OpenStroke.Color = t.Secondary
	ScrollContainer.ScrollBarImageColor3 = t.Secondary

	for _, buttonData in pairs(allButtons) do
		if buttonData.Button and buttonData.Text then
			local buttonText = buttonData.Text.Text
			local isActive = buttonText:find("ON") or buttonText:find("ВКЛ")

			if isActive then
				buttonData.Button.BackgroundColor3 = t.Success
			else
				buttonData.Button.BackgroundColor3 = t.Primary
			end

			buttonData.Text.TextColor3 = t.Text
			buttonData.Stroke.Color = t.Secondary

			if buttonData.Status then
				if buttonData.Status.Visible then
					if isActive then
						buttonData.Status.BackgroundColor3 = t.Success
					else
						buttonData.Status.BackgroundColor3 = t.Danger
					end
				end
			end
		end
	end
end

-- Функция создания кнопок
local function NewButton(name, text)
	buttonCount = buttonCount + 1

	local ButtonContainer = Instance.new("Frame")
	ButtonContainer.Size = UDim2.new(1, 0, 0, buttonHeight)
	ButtonContainer.Position = UDim2.new(0, 0, 0, (buttonCount - 1) * (buttonHeight + padding))
	ButtonContainer.BackgroundTransparency = 1
	ButtonContainer.Parent = ScrollContainer

	local ButtonNew = Instance.new("TextButton")
	ButtonNew.Name = name
	ButtonNew.Size = UDim2.new(1, 0, 1, 0)
	ButtonNew.BackgroundColor3 = Themes[currentTheme].Primary
	ButtonNew.BackgroundTransparency = 0.1
	ButtonNew.BorderSizePixel = 0
	ButtonNew.Text = ""
	ButtonNew.AutoButtonColor = false
	ButtonNew.Parent = ButtonContainer

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 12)
	ButtonCorner.Parent = ButtonNew

	local ButtonStroke = Instance.new("UIStroke")
	ButtonStroke.Color = Themes[currentTheme].Secondary
	ButtonStroke.Thickness = 1
	ButtonStroke.Parent = ButtonNew

	local ButtonText = Instance.new("TextLabel")
	ButtonText.Size = UDim2.new(1, -20, 1, 0)
	ButtonText.Position = UDim2.new(0, 10, 0, 0)
	ButtonText.BackgroundTransparency = 1
	ButtonText.Text = text
	ButtonText.TextColor3 = Themes[currentTheme].Text
	ButtonText.TextSize = 16
	ButtonText.Font = Enum.Font.GothamSemibold
	ButtonText.TextXAlignment = Enum.TextXAlignment.Left
	ButtonText.Parent = ButtonNew

	local StatusIndicator = Instance.new("Frame")
	StatusIndicator.Size = UDim2.new(0, 6, 0, 6)
	StatusIndicator.Position = UDim2.new(1, -15, 0.5, -3)
	StatusIndicator.BackgroundColor3 = Themes[currentTheme].Danger
	StatusIndicator.BorderSizePixel = 0
	StatusIndicator.Visible = false
	StatusIndicator.Parent = ButtonNew

	local StatusCorner = Instance.new("UICorner")
	StatusCorner.CornerRadius = UDim.new(1, 0)
	StatusCorner.Parent = StatusIndicator

	ButtonNew.MouseEnter:Connect(function()
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(ButtonNew, tweenInfo, {
			BackgroundColor3 = Themes[currentTheme].Secondary,
			BackgroundTransparency = 0
		})
		tween:Play()
	end)

	ButtonNew.MouseLeave:Connect(function()
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(ButtonNew, tweenInfo, {
			BackgroundColor3 = Themes[currentTheme].Primary,
			BackgroundTransparency = 0.1
		})
		tween:Play()
	end)

	local buttonData = {
		Button = ButtonNew,
		Text = ButtonText,
		Status = StatusIndicator,
		Stroke = ButtonStroke,
		Container = ButtonContainer
	}
	table.insert(allButtons, buttonData)

	ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, buttonCount * (buttonHeight + padding))

	return buttonData
end

-- Функция для обновления статуса кнопок
local function setButtonStatus(button, enabled)
	local t = Themes[currentTheme]

	button.Status.BackgroundColor3 = enabled and t.Success or t.Danger
	button.Status.Visible = true

	if enabled then
		button.Button.BackgroundColor3 = t.Success
		button.Button.BackgroundTransparency = 0.2
		button.Text.Text = button.Text.Text:gsub(": OFF", ": ON"):gsub("OFF$", "ON"):gsub(": ВЫКЛ", ": ВКЛ"):gsub("ВЫКЛ$", "ВКЛ")
	else
		button.Button.BackgroundColor3 = t.Primary
		button.Button.BackgroundTransparency = 0.1
		button.Text.Text = button.Text.Text:gsub(": ON", ": OFF"):gsub("ON$", "OFF"):gsub(": ВКЛ", ": ВЫКЛ"):gsub("ВКЛ$", "ВЫКЛ")
	end
end

-- Анимации для кнопки открытия
OpenButton.MouseEnter:Connect(function()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(OpenButton, tweenInfo, {Rotation = 180})
	tween:Play()
end)

OpenButton.MouseLeave:Connect(function()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(OpenButton, tweenInfo, {Rotation = 0})
	tween:Play()
end)

-- Функции открытия/закрытия
local function openMenu()
	Menu.Visible = true
	OpenButton.Visible = false

	local bgTween = TweenService:Create(Background, TweenInfo.new(0.3), {BackgroundTransparency = 0.1})
	bgTween:Play()

	Menu.Position = UDim2.new(0.5, -200, 0.5, 300)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(Menu, tweenInfo, {Position = UDim2.new(0.5, -200, 0.5, -300)})
	tween:Play()
end

local function closeMenu()
	local bgTween = TweenService:Create(Background, TweenInfo.new(0.3), {BackgroundTransparency = 1})
	bgTween:Play()

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local tween = TweenService:Create(Menu, tweenInfo, {Position = UDim2.new(0.5, -200, 0.5, 300)})
	tween:Play()

	wait(0.5)
	Menu.Visible = false
	OpenButton.Visible = true
end

OpenButton.MouseButton1Click:Connect(openMenu)

-- СОЗДАЕМ КНОПКИ

local CloseButton = NewButton("Close", "Закрыть меню")
CloseButton.Button.MouseButton1Click:Connect(closeMenu)

-- Кнопка смены темы
local ThemeButton = NewButton("Theme", "Тема: Фиолетовая")
ThemeButton.Button.MouseButton1Click:Connect(function()
	local themeOrder = {"purple", "black", "white", "blue", "red"}
	local currentIndex = 1

	for i, theme in ipairs(themeOrder) do
		if theme == currentTheme then
			currentIndex = i
			break
		end
	end

	local nextIndex = currentIndex % #themeOrder + 1
	local nextTheme = themeOrder[nextIndex]

	ApplyTheme(nextTheme)
	ThemeButton.Text.Text = "Тема: " .. Themes[nextTheme].Name
	setButtonStatus(ThemeButton, false)
    showNotification("Тема изменена на: " .. Themes[nextTheme].Name, "success")
end)

-- Speed Button
local SpeedButton = NewButton("Speed", "Скорость: ВЫКЛ")
SpeedButton.Button.MouseButton1Click:Connect(function()
	NewSpeed = not NewSpeed
	setButtonStatus(SpeedButton, NewSpeed)

	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = NewSpeed and 100 or 16
        showNotification("Скорость: " .. (NewSpeed and "ВКЛ" or "ВЫКЛ"), NewSpeed and "success" or "info")
	end
end)

-- God Mode Button
local GodButton = NewButton("GodMode", "Бессмертие: ВЫКЛ")
GodButton.Button.MouseButton1Click:Connect(function()
	GodModeEnabled = not GodModeEnabled
	setButtonStatus(GodButton, GodModeEnabled)

	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
	if humanoid then
		if GodModeEnabled then
			humanoid.MaxHealth = math.huge
			humanoid.Health = math.huge
            showNotification("Бессмертие: ВКЛ", "success")
		else
			humanoid.MaxHealth = 100
			humanoid.Health = 100
            showNotification("Бессмертие: ВЫКЛ", "info")
		end
	end
end)

-- Noclip Button
local NoclipButton = NewButton("Noclip", "Сквозь стены: ВЫКЛ")
NoclipButton.Button.MouseButton1Click:Connect(function()
	Noclip = not Noclip
	setButtonStatus(NoclipButton, Noclip)
    showNotification("Сквозь стены: " .. (Noclip and "ВКЛ" or "ВЫКЛ"), Noclip and "success" or "info")

	local character = game.Players.LocalPlayer.Character
	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = not Noclip
			end
		end
	end
end)

-- Anti-Kill Button
local AntiKillButt = NewButton("AntiKill", "Защита от убийства: ВЫКЛ")
AntiKillButt.Button.MouseButton1Click:Connect(function()
	AntiKillEnabled = not AntiKillEnabled
	setButtonStatus(AntiKillButt, AntiKillEnabled)
    showNotification("Защита от убийства: " .. (AntiKillEnabled and "ВКЛ" or "ВЫКЛ"), AntiKillEnabled and "success" or "info")
end)

-- Graphics Button
local GraphicsButton = NewButton("Graphics", "Ультра графика: ВЫКЛ")
local graphicsLoop

GraphicsButton.Button.MouseButton1Click:Connect(function()
	graphicsEnabled = not graphicsEnabled
	setButtonStatus(GraphicsButton, graphicsEnabled)
    showNotification("Ультра графика: " .. (graphicsEnabled and "ВКЛ" or "ВЫКЛ"), graphicsEnabled and "success" or "info")

	if graphicsEnabled then
		local Lighting = game:GetService("Lighting")

		for _, child in ipairs(Lighting:GetChildren()) do
			if child.ClassName == "Sky" then
				child:Destroy()
			end
		end

		local sky = Instance.new("Sky")
		sky.SkyboxBk = "rbxassetid://6444884337"
		sky.SkyboxDn = "rbxassetid://6444884337"
		sky.SkyboxFt = "rbxassetid://6444884337"
		sky.SkyboxLf = "rbxassetid://6444884337"
		sky.SkyboxRt = "rbxassetid://6444884337"
		sky.SkyboxUp = "rbxassetid://6412503613"
		sky.SunTextureId = "rbxassetid://6196665106"
		sky.StarCount = 3000
		sky.SunAngularSize = 18
		sky.Parent = Lighting

		Lighting.GlobalShadows = true
		Lighting.ShadowSoftness = 0.5
		Lighting.Brightness = 3
		Lighting.ExposureCompensation = 0.54

		graphicsLoop = game:GetService("RunService").Heartbeat:Connect(function()
			if graphicsEnabled then
				Lighting.ClockTime = Lighting.ClockTime + 0.01
				if Lighting.ClockTime >= 24 then
					Lighting.ClockTime = 0
				end
			else
				graphicsLoop:Disconnect()
			end
		end)
	else
		if graphicsLoop then
			graphicsLoop:Disconnect()
		end

		local Lighting = game:GetService("Lighting")
		Lighting.Brightness = 1
		Lighting.ExposureCompensation = 0
		Lighting.ClockTime = 14
	end
end)

-- Auto Farm Button
local FarmButton = NewButton("AutoFarm", "Авто-фарм: ВЫКЛ")
FarmButton.Button.MouseButton1Click:Connect(function()
	farmEnabled = not farmEnabled
	setButtonStatus(FarmButton, farmEnabled)
    showNotification("Авто-фарм: " .. (farmEnabled and "ВКЛ" or "ВЫКЛ"), farmEnabled and "success" or "info")

	if farmEnabled then
		spawn(function()
			while farmEnabled do
				pcall(function()
					local leaderstats = game.Players.LocalPlayer:FindFirstChild("leaderstats")
					if leaderstats then
						local points = leaderstats:FindFirstChild("Points")
						if points then
							points.Value = points.Value + 1000
						end
					end
					wait(1)
				end)
			end
		end)
	end
end)

-- ESP Button
local ESPButton = NewButton("ESP", "ESP: ВЫКЛ")
ESPButton.Button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    setButtonStatus(ESPButton, espEnabled)
    toggleESP(espEnabled)
end)

-- Fly Button
local FlyButton = NewButton("Fly", "Fly: ВЫКЛ")
FlyButton.Button.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    setButtonStatus(FlyButton, flyEnabled)
    toggleFly(flyEnabled)
end)

-- Crash Server Button
local CrashServer = NewButton("Crash", "Server Crash")
CrashServer.Button.MouseButton1Click:Connect(function()
    showNotification("Запуск Server Crash...", "warning")
    
    spawn(function()
        for i = 1, 1000 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Position = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
            part.Anchored = false
            part.CanCollide = true
            part.Velocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
            part.Parent = workspace

            local fire = Instance.new("Fire")
            fire.Size = 10
            fire.Parent = part

            local smoke = Instance.new("Smoke")
            smoke.Size = 5
            smoke.Parent = part
            
            if i % 100 == 0 then
                wait(0.1)
            end
        end
        showNotification("Server Crash завершен", "error")
    end)
end)

-- Reset All Button
local ResetButton = NewButton("Reset", "Сбросить все настройки")
ResetButton.Button.MouseButton1Click:Connect(function()
	NewSpeed = false
	GodModeEnabled = false
	Noclip = false
	graphicsEnabled = false
	farmEnabled = false
	AntiKillEnabled = false
    espEnabled = false
    flyEnabled = false

	setButtonStatus(SpeedButton, false)
	setButtonStatus(GodButton, false)
	setButtonStatus(NoclipButton, false)
	setButtonStatus(GraphicsButton, false)
	setButtonStatus(FarmButton, false)
	setButtonStatus(AntiKillButt, false)
    setButtonStatus(ESPButton, false)
    setButtonStatus(FlyButton, false)

    -- Отключаем ESP и Fly
    toggleESP(false)
    toggleFly(false)

	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.MaxHealth = 100
		humanoid.Health = 100
	end

	local character = game.Players.LocalPlayer.Character
	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end

	if graphicsLoop then
		graphicsLoop:Disconnect()
	end

	local Lighting = game:GetService("Lighting")
	Lighting.Brightness = 1
	Lighting.ExposureCompensation = 0
	Lighting.ClockTime = 14

    showNotification("Все настройки сброшены!", "info")
	print("Все настройки сброшены!")
end)

-- Защита от убийства
local function setupAntiKill(character)
	local Humanoid = character:WaitForChild("Humanoid")

	Humanoid.HealthChanged:Connect(function()
		if AntiKillEnabled and Humanoid.Health <= 0 then
			if GodModeEnabled then
				Humanoid.Health = math.huge
			else
				Humanoid.Health = 100
			end
		end
	end)
end

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(setupAntiKill)
local currentCharacter = game:GetService("Players").LocalPlayer.Character
if currentCharacter then
	setupAntiKill(currentCharacter)
end

-- Автоматическое обновление ноклипа
game:GetService("RunService").Stepped:Connect(function()
	if Noclip then
		local character = game.Players.LocalPlayer.Character
		if character then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- Защита от удаления GUI
game:GetService("RunService").Heartbeat:Connect(function()
	if not CORE or not CORE.Parent then
		CORE.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end
end)

-- Применяем тему по умолчанию после создания всех элементов
ApplyTheme("purple")

-- Показываем уведомление о загрузке
showNotification("dokciNEW v4.0 успешно загружен!", "success")

print("🎨 dokciNEW Premium v4.0 загружен успешно!")
print("✨ Доступны 5 тем: Фиолетовая, Черная, Белая, Синия, Красная")
print("🚀 Новые функции: ESP и Fly!")
