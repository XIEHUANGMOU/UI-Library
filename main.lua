local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {}

local Theme = {
	Background = Color3.fromRGB(25, 25, 25),
	SecondBackground = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(160, 160, 160),
	Hover = Color3.fromRGB(55, 55, 55),
	Border = Color3.fromRGB(50, 50, 50),
	NotificationColor = Color3.fromRGB(0, 170, 255),
}

local DefaultShadowImage = "rbxassetid://7487324495"

local function CreateShadow(parent)
	local shadow = Instance.new("ImageLabel")
	shadow.BackgroundTransparency = 1
	shadow.Image = DefaultShadowImage
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.fromScale(0.5, 0.5)
	shadow.Size = UDim2.new(1, 24, 1, 24)
	shadow.ZIndex = 0
	shadow.Name = "Shadow"
	shadow.Parent = parent
	return shadow
end

local function CreateIcon(parent, asset, size)
	local icon = Instance.new("ImageLabel")
	icon.BackgroundTransparency = 1
	icon.Name = "Icon"
	icon.Size = size or UDim2.fromOffset(20, 20)
	icon.Position = UDim2.fromOffset(8, 0)
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.Position = UDim2.new(0, 8, 0.5, 0)
	local id = tonumber(asset)
	if id then
		icon.Image = "rbxassetid://" .. tostring(id)
	elseif type(asset) == "string" then
		icon.Image = asset
	end
	icon.Parent = parent
	return icon
end

local NotifyContainer

local function CreateNotifyGui()
	if NotifyContainer then return NotifyContainer end
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Lib_Notifications"
	screenGui.Parent = CoreGui
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(0, 300, 1, -20)
	container.Position = UDim2.new(1, -320, 0, 10)
	container.AnchorPoint = Vector2.new(0, 0)
	container.Parent = screenGui

	local list = Instance.new("UIListLayout")
	list.HorizontalAlignment = Enum.HorizontalAlignment.Right
	list.VerticalAlignment = Enum.VerticalAlignment.Bottom
	list.Padding = UDim.new(0, 8)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = container

	NotifyContainer = container
	return container
end

function Library:Notify(config)
	config = config or {}
	local title = config.Title or "Notification"
	local content = config.Content or ""
	local duration = config.Duration or 5
	local image = config.Image

	local container = CreateNotifyGui()

	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.Size = UDim2.new(1, 0, 0, 70)
	notification.BackgroundColor3 = Theme.Background
	notification.BorderSizePixel = 0
	notification.ClipsDescendants = true
	notification.ZIndex = 2
	notification.LayoutOrder = os.time()

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notification

	local accentBar = Instance.new("Frame")
	accentBar.Name = "Accent"
	accentBar.Size = UDim2.new(0, 4, 1, 0)
	accentBar.BackgroundColor3 = Theme.NotificationColor
	accentBar.BorderSizePixel = 0
	accentBar.ZIndex = 3
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 4)
	barCorner.Parent = accentBar
	accentBar.Parent = notification

	if image then
		local imgLabel = Instance.new("ImageLabel")
		imgLabel.BackgroundTransparency = 1
		imgLabel.Size = UDim2.fromOffset(36, 36)
		imgLabel.Position = UDim2.fromOffset(14, 17)
		imgLabel.Image = tonumber(image) and ("rbxassetid://" .. tostring(image)) or image
		imgLabel.Name = "NotifIcon"
		imgLabel.ZIndex = 2
		imgLabel.Parent = notification
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = Theme.Text
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(1, -60, 0, 18)
	titleLabel.Position = UDim2.fromOffset(image and 60 or 16, 10)
	titleLabel.ZIndex = 2
	titleLabel.Parent = notification

	local contentLabel = Instance.new("TextLabel")
	contentLabel.Text = content
	contentLabel.Font = Enum.Font.Gotham
	contentLabel.TextSize = 12
	contentLabel.TextColor3 = Theme.SubText
	contentLabel.BackgroundTransparency = 1
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextWrapped = true
	contentLabel.Size = UDim2.new(1, -60, 0, 30)
	contentLabel.Position = UDim2.fromOffset(image and 60 or 16, 32)
	contentLabel.ZIndex = 2
	contentLabel.Parent = notification

	local shadow = CreateShadow(notification)
	shadow.Size = UDim2.new(1, 18, 1, 18)

	notification.Parent = container

	local startPos = UDim2.new(1.2, 0, notification.Position.Y.Scale, notification.Position.Y.Offset)
	notification.Position = startPos

	local tweenIn = TweenService:Create(notification, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
	tweenIn:Play()
	tweenIn.Completed:Wait()

	local breathTween = nil
	local function startBreath()
		breathTween = TweenService:Create(accentBar, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.6})
		breathTween:Play()
	end
	startBreath()

	task.delay(duration, function()
		if breathTween then
			breathTween:Cancel()
		end
		local tweenOut = TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1.2, 0, 0, 0)})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		notification:Destroy()
	end)

	return notification
end

local Window = {}
Window.__index = Window

local function CreateWindowFrame(self, config)
	local Name = config.Name or "Window"
	local Size = config.Size or UDim2.fromOffset(580, 420)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = Name .. "_GUI"
	ScreenGui.Parent = CoreGui
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local MainContainer = Instance.new("Frame")
	MainContainer.Name = "MainContainer"
	MainContainer.BackgroundTransparency = 1
	MainContainer.Size = Size
	MainContainer.Position = UDim2.fromScale(0.5, 0.5)
	MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	MainContainer.Parent = ScreenGui

	local canvasGroup = Instance.new("CanvasGroup")
	canvasGroup.Name = "CanvasGroup"
	canvasGroup.Size = UDim2.fromScale(1, 1)
	canvasGroup.BackgroundTransparency = 1
	canvasGroup.Parent = MainContainer

	local shadow = CreateShadow(MainContainer)

	local WindowFrame = Instance.new("Frame")
	WindowFrame.Name = "Window"
	WindowFrame.Size = UDim2.fromScale(1, 1)
	WindowFrame.Position = UDim2.fromScale(0, 0)
	WindowFrame.BackgroundColor3 = Theme.Background
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.ZIndex = 1
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = WindowFrame
	WindowFrame.Parent = canvasGroup

	self.Gui = ScreenGui
	self.MainContainer = MainContainer
	self.CanvasGroup = canvasGroup
	self.WindowFrame = WindowFrame
	self.Size = Size
	self.Minimized = false
	self.FloatingBall = nil
	self.Tabs = {}
	self.CurrentTab = nil
	self.DragStartPos = nil
	self.StartInputPos = nil
	self.IsDragging = false
	self.Name = Name
end

local function CreateTopBar(self)
	local WindowFrame = self.WindowFrame

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 36)
	TopBar.BackgroundColor3 = Theme.SecondBackground
	TopBar.BorderSizePixel = 0
	TopBar.ZIndex = 2
	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 8)
	topCorner.Parent = TopBar
	TopBar.Parent = WindowFrame

	local Title = Instance.new("TextLabel")
	Title.Text = self.Name
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextColor3 = Theme.Text
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(0, 120, 1, 0)
	Title.Position = UDim2.fromOffset(12, 0)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar

	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "Close"
	CloseButton.Size = UDim2.fromOffset(28, 28)
	CloseButton.Position = UDim2.new(1, -32, 0.5, -14)
	CloseButton.BackgroundTransparency = 1
	CloseButton.Text = "✕"
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.TextSize = 16
	CloseButton.TextColor3 = Color3.fromRGB(210, 210, 210)
	CloseButton.ZIndex = 3
	CloseButton.AutoButtonColor = false
	CloseButton.Parent = TopBar

	local MinButton = Instance.new("TextButton")
	MinButton.Name = "Minimize"
	MinButton.Size = UDim2.fromOffset(28, 28)
	MinButton.Position = UDim2.new(1, -66, 0.5, -14)
	MinButton.BackgroundTransparency = 1
	MinButton.Text = "—"
	MinButton.Font = Enum.Font.GothamBold
	MinButton.TextSize = 16
	MinButton.TextColor3 = Color3.fromRGB(210, 210, 210)
	MinButton.ZIndex = 3
	MinButton.AutoButtonColor = false
	MinButton.Parent = TopBar

	CloseButton.MouseEnter:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 90, 90)}):Play()
	end)
	CloseButton.MouseLeave:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
	end)
	CloseButton.Activated:Connect(function()
		self:Destroy()
	end)

	MinButton.MouseEnter:Connect(function()
		TweenService:Create(MinButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 200, 50)}):Play()
	end)
	MinButton.MouseLeave:Connect(function()
		TweenService:Create(MinButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
	end)
	MinButton.Activated:Connect(function()
		self:Minimize()
	end)

	local dragConnections = {}
	local function startDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.IsDragging = true
			self.StartInputPos = input.Position
			self.DragStartPos = self.MainContainer.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					self.IsDragging = false
				end
			end)
		end
	end
	local function onDrag(input)
		if self.IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - self.StartInputPos
			self.MainContainer.Position = UDim2.new(
				self.DragStartPos.X.Scale,
				self.DragStartPos.X.Offset + delta.X,
				self.DragStartPos.Y.Scale,
				self.DragStartPos.Y.Offset + delta.Y
			)
		end
	end
	TopBar.InputBegan:Connect(startDrag)
	TopBar.InputChanged:Connect(onDrag)

	self.TopBar = TopBar
end

local function CreateTabContainer(self)
	local WindowFrame = self.WindowFrame

	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(0, 125, 1, -36)
	TabContainer.Position = UDim2.fromOffset(0, 36)
	TabContainer.BackgroundColor3 = Theme.SecondBackground
	TabContainer.BorderSizePixel = 0
	TabContainer.ZIndex = 1
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 8)
	tabCorner.Parent = TabContainer
	TabContainer.Parent = WindowFrame

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout.Parent = TabContainer

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 6)
	padding.PaddingRight = UDim.new(0, 6)
	padding.Parent = TabContainer

	self.TabContainer = TabContainer
	self.TabListLayout = UIListLayout
end

local function CreateContentArea(self)
	local WindowFrame = self.WindowFrame

	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -135, 1, -42)
	Content.Position = UDim2.fromOffset(130, 38)
	Content.BackgroundTransparency = 1
	Content.ClipsDescendants = true
	Content.ZIndex = 1
	Content.Parent = WindowFrame

	self.TabContent = Content
end

function Window:SelectTab(tabData)
	if self.CurrentTab == tabData then return end
	local oldTab = self.CurrentTab
	self.CurrentTab = tabData

	if oldTab then
		local oldPage = oldTab.Page
		local fadeOut = TweenService:Create(oldPage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
		local moveOut = TweenService:Create(oldPage, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(30, 0)})
		fadeOut:Play()
		moveOut:Play()
		moveOut.Completed:Wait()
		oldPage.Visible = false
		oldPage.Position = UDim2.fromOffset(0, 0)
		oldPage.BackgroundTransparency = 0
	end

	local newPage = tabData.Page
	newPage.Visible = true
	newPage.Position = UDim2.fromOffset(-30, 0)
	newPage.BackgroundTransparency = 1
	local fadeIn = TweenService:Create(newPage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
	local moveIn = TweenService:Create(newPage, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)})
	fadeIn:Play()
	moveIn:Play()
end

function Window:CreateTab(config)
	config = config or {}
	local tabName = config.Name or "Tab"
	local image = config.Image

	local tabButton = Instance.new("TextButton")
	tabButton.Name = tabName
	tabButton.Size = UDim2.new(1, 0, 0, 32)
	tabButton.BackgroundColor3 = Theme.SecondBackground
	tabButton.BorderSizePixel = 0
	tabButton.Text = ""
	tabButton.AutoButtonColor = false
	tabButton.ZIndex = 2
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tabButton

	local icon
	if image then
		icon = CreateIcon(tabButton, image, UDim2.fromOffset(22, 22))
		icon.Position = UDim2.new(0, 8, 0.5, 0)
	end

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Text = tabName
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Theme.SubText
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, icon and -30 or -12, 1, 0)
	label.Position = UDim2.fromOffset(icon and 36 or 12, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = tabButton

	tabButton.Parent = self.TabContainer

	local page = Instance.new("Frame")
	page.Name = tabName .. "Page"
	page.Size = UDim2.fromScale(1, 1)
	page.Position = UDim2.fromScale(0, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = self.TabContent

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 8)
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiListLayout.Parent = page

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = page

	local tabData = {
		Button = tabButton,
		Page = page,
		Name = tabName,
		Config = config,
	}
	table.insert(self.Tabs, tabData)

	tabButton.Activated:Connect(function()
		self:SelectTab(tabData)
	end)

	tabButton.MouseEnter:Connect(function()
		TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover}):Play()
		TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play()
	end)
	tabButton.MouseLeave:Connect(function()
		if self.CurrentTab ~= tabData then
			TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SecondBackground}):Play()
			TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Theme.SubText}):Play()
		end
	end)

	if #self.Tabs == 1 then
		self:SelectTab(tabData)
		TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
		TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end

	local Tab = {}
	local function defaultHoverAnimation(btn, defaultColor, hoverColor)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
		end)
	end

	function Tab:AddLabel(config)
		config = config or {}
		local text = config.Text or ""
		local image = config.Image

		local labelFrame = Instance.new("Frame")
		labelFrame.Name = "Label"
		labelFrame.Size = UDim2.new(1, 0, 0, 30)
		labelFrame.BackgroundTransparency = 1
		labelFrame.Parent = page

		if image then
			local ic = CreateIcon(labelFrame, image, UDim2.fromOffset(20, 20))
			ic.Position = UDim2.fromOffset(6, 5)
		end

		local textLabel = Instance.new("TextLabel")
		textLabel.Text = text
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextSize = 13
		textLabel.TextColor3 = Theme.Text
		textLabel.BackgroundTransparency = 1
		textLabel.Size = UDim2.new(1, image and -34 or -10, 1, 0)
		textLabel.Position = UDim2.fromOffset(image and 32 or 10, 0)
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Parent = labelFrame

		return labelFrame
	end

	function Tab:AddButton(config)
		config = config or {}
		local text = config.Text or "Button"
		local callback = config.Callback or function() end
		local image = config.Image

		local button = Instance.new("TextButton")
		button.Name = "Button"
		button.Size = UDim2.new(1, 0, 0, 36)
		button.BackgroundColor3 = Theme.SecondBackground
		button.BorderSizePixel = 0
		button.Text = ""
		button.AutoButtonColor = false
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = button

		if image then
			local ic = CreateIcon(button, image, UDim2.fromOffset(22, 22))
			ic.Position = UDim2.new(0, 8, 0.5, 0)
		end

		local label = Instance.new("TextLabel")
		label.Text = text
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextColor3 = Theme.Text
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(1, image and -40 or -14, 1, 0)
		label.Position = UDim2.fromOffset(image and 36 or 12, 0)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = button

		button.Parent = page

		defaultHoverAnimation(button, Theme.SecondBackground, Theme.Hover)

		button.Activated:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = Theme.Accent}):Play()
			task.wait(0.1)
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SecondBackground}):Play()
			callback()
		end)

		return button
	end

	function Tab:AddToggle(config)
		config = config or {}
		local text = config.Text or "Toggle"
		local default = config.Default or false
		local callback = config.Callback or function() end
		local image = config.Image

		local toggleFrame = Instance.new("Frame")
		toggleFrame.Name = "Toggle"
		toggleFrame.Size = UDim2.new(1, 0, 0, 40)
		toggleFrame.BackgroundTransparency = 1
		toggleFrame.Parent = page

		if image then
			local ic = CreateIcon(toggleFrame, image, UDim2.fromOffset(20, 20))
			ic.Position = UDim2.fromOffset(6, 10)
		end

		local label = Instance.new("TextLabel")
		label.Text = text
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextColor3 = Theme.Text
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(0, 150, 1, 0)
		label.Position = UDim2.fromOffset(image and 34 or 10, 0)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = toggleFrame

		local switch = Instance.new("TextButton")
		switch.Name = "Switch"
		switch.Size = UDim2.fromOffset(42, 22)
		switch.Position = UDim2.new(1, -52, 0.5, -11)
		switch.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(60, 60, 60)
		switch.BorderSizePixel = 0
		switch.Text = ""
		switch.AutoButtonColor = false
		local switchCorner = Instance.new("UICorner")
		switchCorner.CornerRadius = UDim.new(1, 0)
		switchCorner.Parent = switch
		switch.Parent = toggleFrame

		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.Size = UDim2.fromOffset(18, 18)
		knob.Position = default and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.BorderSizePixel = 0
		local knobCorner = Instance.new("UICorner")
		knobCorner.CornerRadius = UDim.new(1, 0)
		knobCorner.Parent = knob
		knob.Parent = switch

		local toggled = default

		local function update()
			if toggled then
				TweenService:Create(switch, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
				TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.fromOffset(22, 2)}):Play()
			else
				TweenService:Create(switch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				TweenService:Create(knob, TweenInfo.new(0.25), {Position = UDim2.fromOffset(2, 2)}):Play()
			end
		end

		switch.Activated:Connect(function()
			toggled = not toggled
			update()
			callback(toggled)
		end)

		update()

		return toggleFrame
	end

	function Tab:AddSlider(config)
		config = config or {}
		local text = config.Text or "Slider"
		local min = config.Min or 0
		local max = config.Max or 100
		local default = config.Default or min
		local callback = config.Callback or function() end
		local image = config.Image

		local sliderFrame = Instance.new("Frame")
		sliderFrame.Name = "Slider"
		sliderFrame.Size = UDim2.new(1, 0, 0, 48)
		sliderFrame.BackgroundTransparency = 1
		sliderFrame.Parent = page

		if image then
			local ic = CreateIcon(sliderFrame, image, UDim2.fromOffset(20, 20))
			ic.Position = UDim2.fromOffset(6, 14)
		end

		local label = Instance.new("TextLabel")
		label.Text = text
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextColor3 = Theme.Text
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(0, 100, 0, 20)
		label.Position = UDim2.fromOffset(image and 34 or 10, 4)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = sliderFrame

		local valueLabel = Instance.new("TextLabel")
		valueLabel.Text = tostring(default)
		valueLabel.Font = Enum.Font.Gotham
		valueLabel.TextSize = 12
		valueLabel.TextColor3 = Theme.Text
		valueLabel.BackgroundTransparency = 1
		valueLabel.Size = UDim2.new(0, 50, 0, 20)
		valueLabel.Position = UDim2.new(1, -55, 0, 4)
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Parent = sliderFrame

		local track = Instance.new("TextButton")
		track.Name = "Track"
		track.Size = UDim2.new(1, image and -94 or -70, 0, 8)
		track.Position = UDim2.fromOffset(image and 34 or 10, 28)
		track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		track.BorderSizePixel = 0
		track.Text = ""
		track.AutoButtonColor = false
		local trackCorner = Instance.new("UICorner")
		trackCorner.CornerRadius = UDim.new(0, 4)
		trackCorner.Parent = track
		track.Parent = sliderFrame

		local fill = Instance.new("Frame")
		fill.Name = "Fill"
		fill.Size = UDim2.fromScale((default - min) / (max - min), 1)
		fill.Position = UDim2.fromScale(0, 0)
		fill.BackgroundColor3 = Theme.Accent
		fill.BorderSizePixel = 0
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(0, 4)
		fillCorner.Parent = fill
		fill.Parent = track

		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.Size = UDim2.fromOffset(14, 14)
		knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.BorderSizePixel = 0
		local knobCorner = Instance.new("UICorner")
		knobCorner.CornerRadius = UDim.new(1, 0)
		knobCorner.Parent = knob
		knob.Parent = track

		local draggingSlider = false
		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggingSlider = true
				local function move(pos)
					if not draggingSlider then return end
					local relX = math.clamp((pos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					local val = math.floor(min + (max - min) * relX)
					fill.Size = UDim2.fromScale(relX, 1)
					knob.Position = UDim2.new(relX, -7, 0.5, -7)
					valueLabel.Text = tostring(val)
					callback(val)
				end
				move(input.Position)
				local inputConn
				inputConn = UserInputService.InputChanged:Connect(function(io)
					if io == input then
						move(io.Position)
					end
				end)
				local endConn
				endConn = UserInputService.InputEnded:Connect(function(io)
					if io == input then
						draggingSlider = false
						inputConn:Disconnect()
						endConn:Disconnect()
					end
				end)
			end
		end)

		return sliderFrame
	end

	function Tab:AddDropdown(config)
		config = config or {}
		local text = config.Text or "Dropdown"
		local options = config.Options or {}
		local callback = config.Callback or function() end
		local image = config.Image

		local dropdownFrame = Instance.new("Frame")
		dropdownFrame.Name = "Dropdown"
		dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
		dropdownFrame.BackgroundTransparency = 1
		dropdownFrame.Parent = page

		if image then
			local ic = CreateIcon(dropdownFrame, image, UDim2.fromOffset(20, 20))
			ic.Position = UDim2.fromOffset(6, 10)
		end

		local label = Instance.new("TextLabel")
		label.Text = text
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextColor3 = Theme.Text
		label.BackgroundTransparency = 1
		label.Size = UDim2.new(0, 100, 0, 20)
		label.Position = UDim2.fromOffset(image and 34 or 10, 10)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = dropdownFrame

		local selectedText = Instance.new("TextButton")
		selectedText.Name = "Selected"
		selectedText.Size = UDim2.new(1, image and -44 or -20, 0, 30)
		selectedText.Position = UDim2.fromOffset(image and 34 or 10, 28)
		selectedText.BackgroundColor3 = Theme.SecondBackground
		selectedText.BorderSizePixel = 0
		selectedText.Text = options[1] or "..."
		selectedText.Font = Enum.Font.Gotham
		selectedText.TextSize = 13
		selectedText.TextColor3 = Theme.Text
		selectedText.TextXAlignment = Enum.TextXAlignment.Left
		selectedText.AutoButtonColor = false
		local selCorner = Instance.new("UICorner")
		selCorner.CornerRadius = UDim.new(0, 6)
		selCorner.Parent = selectedText
		selectedText.Parent = dropdownFrame

		local listFrame = Instance.new("Frame")
		listFrame.Name = "List"
		listFrame.Size = UDim2.new(1, 0, 0, 0)
		listFrame.Position = UDim2.new(0, 0, 1, 2)
		listFrame.BackgroundColor3 = Theme.SecondBackground
		listFrame.BorderSizePixel = 0
		listFrame.ClipsDescendants = true
		listFrame.Visible = false
		listFrame.ZIndex = 5
		local listCorner = Instance.new("UICorner")
		listCorner.CornerRadius = UDim.new(0, 6)
		listCorner.Parent = listFrame
		listFrame.Parent = selectedText

		local listLayout = Instance.new("UIListLayout")
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = listFrame

		local expanded = false
		local optionButtons = {}
		local function buildOptions()
			for _, btn in ipairs(optionButtons) do
				btn:Destroy()
			end
			optionButtons = {}
			for i, opt in ipairs(options) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1, 0, 0, 28)
				optBtn.BackgroundTransparency = 1
				optBtn.Text = opt
				optBtn.Font = Enum.Font.Gotham
				optBtn.TextSize = 12
				optBtn.TextColor3 = Theme.SubText
				optBtn.TextXAlignment = Enum.TextXAlignment.Left
				optBtn.AutoButtonColor = false
				local pad = Instance.new("UIPadding")
				pad.PaddingLeft = UDim.new(0, 10)
				pad.Parent = optBtn
				optBtn.Parent = listFrame
				table.insert(optionButtons, optBtn)

				optBtn.MouseEnter:Connect(function()
					TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover, TextColor3 = Theme.Text}):Play()
				end)
				optBtn.MouseLeave:Connect(function()
					TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0,0,0) with Transparency, TextColor3 = Theme.SubText}):Play()
					optBtn.BackgroundTransparency = 1
				end)
				optBtn.Activated:Connect(function()
					selectedText.Text = opt
					callback(opt)
					expanded = false
					listFrame.Visible = false
					TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
				end)
			end
			listFrame.Size = UDim2.new(1, 0, 0, #options * 28)
		end
		buildOptions()

		selectedText.Activated:Connect(function()
			expanded = not expanded
			if expanded then
				listFrame.Visible = true
				TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, #options * 28)}):Play()
			else
				TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
				task.delay(0.2, function()
					if not expanded then
						listFrame.Visible = false
					end
				end)
			end
		end)

		return dropdownFrame
	end

	return Tab
end

function Window:Minimize()
	if self.Minimized then return end
	self.Minimized = true

	local fadeOut = TweenService:Create(self.CanvasGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
	fadeOut:Play()
	fadeOut.Completed:Wait()
	self.MainContainer.Visible = false

	local ball = Instance.new("ImageButton")
	ball.Name = "FloatingBall"
	ball.Size = UDim2.fromOffset(52, 52)
	ball.Position = UDim2.new(1, -70, 0.5, -26)
	ball.BackgroundTransparency = 1
	ball.AutoButtonColor = false
	ball.Image = "rbxassetid://7487324495"
	ball.ScaleType = Enum.ScaleType.Slice
	ball.SliceCenter = Rect.new(10, 10, 118, 118)
	ball.ZIndex = 10
	ball.Parent = self.Gui

	local ballBg = Instance.new("Frame")
	ballBg.Name = "BallBg"
	ballBg.Size = UDim2.fromScale(1, 1)
	ballBg.BackgroundColor3 = Theme.SecondBackground
	ballBg.BorderSizePixel = 0
	ballBg.ZIndex = 10
	local ballCorner = Instance.new("UICorner")
	ballCorner.CornerRadius = UDim.new(1, 0)
	ballCorner.Parent = ballBg
	ballBg.Parent = ball

	local ballIcon = Instance.new("TextLabel")
	ballIcon.Text = "⌘"
	ballIcon.Font = Enum.Font.GothamBold
	ballIcon.TextSize = 22
	ballIcon.TextColor3 = Theme.Text
	ballIcon.BackgroundTransparency = 1
	ballIcon.Size = UDim2.fromScale(1, 1)
	ballIcon.ZIndex = 11
	ballIcon.Parent = ball

	self.FloatingBall = ball

	local dragBall = false
	local ballStartPos, inputStartPosBall
	ball.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragBall = true
			inputStartPosBall = input.Position
			ballStartPos = ball.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragBall = false
					local delta = input.Position - inputStartPosBall
					if delta.Magnitude < 5 then
						self:Restore()
					end
				end
			end)
		end
	end)
	ball.InputChanged:Connect(function(input)
		if dragBall and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - inputStartPosBall
			local newX = ballStartPos.X.Offset + delta.X
			local newY = ballStartPos.Y.Offset + delta.Y
			ball.Position = UDim2.new(0, newX, 0, newY)
		end
	end)

	ball.MouseEnter:Connect(function()
		TweenService:Create(ballBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
	end)
	ball.MouseLeave:Connect(function()
		TweenService:Create(ballBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SecondBackground}):Play()
	end)
end

function Window:Restore()
	if not self.Minimized then return end
	self.Minimized = false

	if self.FloatingBall then
		local ball = self.FloatingBall
		local fadeOutBall = TweenService:Create(ball, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
		local bg = ball:FindFirstChild("BallBg")
		if bg then
			TweenService:Create(bg, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
		end
		fadeOutBall:Play()
		fadeOutBall.Completed:Wait()
		ball:Destroy()
		self.FloatingBall = nil
	end

	self.MainContainer.Visible = true
	self.CanvasGroup.GroupTransparency = 1
	local fadeIn = TweenService:Create(self.CanvasGroup, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
	fadeIn:Play()
end

function Window:Destroy()
	self:Restore()
	if self.MainContainer then
		self.MainContainer:Destroy()
	end
	if self.Gui then
		self.Gui:Destroy()
	end
end

function Library.CreateWindow(config)
	local self = setmetatable({}, Window)
	CreateWindowFrame(self, config)
	CreateTopBar(self)
	CreateTabContainer(self)
	CreateContentArea(self)
	return self
end

return Library
