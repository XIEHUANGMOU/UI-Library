-- UI Library for Roblox Executor Environment
-- Fluid Design, Dark Theme, with Shadow, Minimize Ball, Notifications

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local DEFAULT_SHADOW_IMAGE = "rbxassetid://6014262993" -- Common shadow asset
local BALL_ICON = "rbxassetid://6023426915" -- Default minimize ball icon

-- Theme colors
local Theme = {
	Background = Color3.fromRGB(25, 25, 30),
	Foreground = Color3.fromRGB(35, 35, 40),
	Accent = Color3.fromRGB(0, 120, 255),
	Text = Color3.fromRGB(220, 220, 225),
	SubText = Color3.fromRGB(160, 160, 170),
	ShadowTransparency = 0.6,
	ElementRounding = 6,
}

Library.Theme = Theme

-- Helper: add shadow to an instance
local function addShadow(parent, offsetSize)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Image = DEFAULT_SHADOW_IMAGE
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(32, 32, 64, 64)
	shadow.BackgroundTransparency = 1
	shadow.ImageTransparency = Theme.ShadowTransparency
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Size = UDim2.new(1, offsetSize * 2, 1, offsetSize * 2)
	shadow.ZIndex = 0
	shadow.Parent = parent
	return shadow
end

-- Helper: create tween with defaults
local function createTween(instance, properties, duration, easingStyle, easingDirection)
	easingStyle = easingStyle or Enum.EasingStyle.Quad
	easingDirection = easingDirection or Enum.EasingDirection.Out
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	return tween
end

-- Helper: clean connections
local function cleanConnections(connections)
	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
end

-- Notification System
local Notifications = {}
Notifications.__index = Notifications

function Notifications.new()
	local self = setmetatable({}, Notifications)
	self.Container = Instance.new("ScreenGui")
	self.Container.Name = "NotificationGui"
	self.Container.ResetOnSpawn = false
	self.Container.Parent = CoreGui

	self.ListLayout = Instance.new("UIListLayout")
	self.ListLayout.Parent = self.Container
	self.ListLayout.Padding = UDim.new(0, 10)
	self.ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	self.ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	self.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	self.Padding = Instance.new("UIPadding")
	self.Padding.Parent = self.Container
	self.Padding.PaddingRight = UDim.new(0, 20)
	self.Padding.PaddingBottom = UDim.new(0, 20)

	self.ActiveNotifications = {}
	return self
end

function Notifications:Notify(data)
	local title = data.Title or "Notification"
	local content = data.Content or ""
	local duration = data.Duration or 5
	local image = data.Image or nil

	local frame = Instance.new("Frame")
	frame.Name = "NotificationFrame"
	frame.BackgroundColor3 = Theme.Foreground
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(0, 300, 0, 80)
	frame.Position = UDim2.new(1, 50, 1, 0)
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.Parent = self.Container
	frame.ClipsDescendants = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local leftBar = Instance.new("Frame")
	leftBar.BackgroundColor3 = Theme.Accent
	leftBar.BorderSizePixel = 0
	leftBar.Size = UDim2.new(0, 4, 1, 0)
	leftBar.Parent = frame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextSize = 15
	titleLabel.Text = title
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Size = UDim2.new(1, -40, 0, 20)
	titleLabel.Position = UDim2.new(0, 15, 0, 10)
	titleLabel.Parent = frame

	local contentLabel = Instance.new("TextLabel")
	contentLabel.BackgroundTransparency = 1
	contentLabel.Font = Enum.Font.Gotham
	contentLabel.TextColor3 = Theme.SubText
	contentLabel.TextSize = 13
	contentLabel.Text = content
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextWrapped = true
	contentLabel.Size = UDim2.new(1, -40, 1, -40)
	contentLabel.Position = UDim2.new(0, 15, 0, 35)
	contentLabel.Parent = frame

	if image then
		local icon = Instance.new("ImageLabel")
		icon.BackgroundTransparency = 1
		icon.Image = image
		icon.Size = UDim2.new(0, 24, 0, 24)
		icon.Position = UDim2.new(1, -30, 0, 10)
		icon.Parent = frame
		titleLabel.Size = UDim2.new(1, -60, 0, 20)
	else
		titleLabel.Size = UDim2.new(1, -30, 0, 20)
	end

	-- Enter animation
	local targetPosition = UDim2.new(1, -10, 1, -10)
	local enterTween = createTween(frame, {Position = targetPosition}, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	enterTween:Play()

	local notification = {
		Frame = frame,
		Timer = nil,
		Connections = {}
	}
	table.insert(self.ActiveNotifications, notification)

	-- Exit logic
	local function removeNotification()
		local exitTween = createTween(frame, {Position = UDim2.new(1, 50, 1, 0), BackgroundTransparency = 0.5}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		exitTween:Play()
		exitTween.Completed:Connect(function()
			frame:Destroy()
			for i, n in ipairs(self.ActiveNotifications) do
				if n == notification then
					table.remove(self.ActiveNotifications, i)
					break
				end
			end
		end)
		if notification.Timer then
			notification.Timer:Disconnect()
		end
	end

	notification.Timer = task.delay(duration, removeNotification)

	-- Click to dismiss early
	local clickDetector = Instance.new("TextButton")
	clickDetector.BackgroundTransparency = 1
	clickDetector.Text = ""
	clickDetector.Size = UDim2.new(1, 0, 1, 0)
	clickDetector.Parent = frame
	local clickConn = clickDetector.MouseButton1Click:Connect(removeNotification)
	table.insert(notification.Connections, clickConn)

	return notification
end

-- Window Class
local Window = {}
Window.__index = Window

function Window:CreateWindow(title, options)
	local self = setmetatable({}, Window)
	options = options or {}
	self.Title = title or "Window"
	self.Theme = Theme
	self.Connections = {}
	self.Tabs = {}
	self.ActiveTab = nil
	self.Minimized = false
	self.Ball = nil

	-- Main ScreenGui
	self.Gui = Instance.new("ScreenGui")
	self.Gui.Name = title .. "Window"
	self.Gui.ResetOnSpawn = false
	self.Gui.Parent = CoreGui

	-- Main Frame
	self.MainFrame = Instance.new("Frame")
	self.MainFrame.Name = "Main"
	self.MainFrame.BackgroundColor3 = Theme.Background
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
	self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
	self.MainFrame.Parent = self.Gui
	self.MainFrame.ClipsDescendants = false

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = self.MainFrame

	-- Shadow
	self.Shadow = addShadow(self.MainFrame, 15)
	self.Shadow.Parent = self.MainFrame -- behind frame

	-- Top Bar
	self.TopBar = Instance.new("Frame")
	self.TopBar.Name = "TopBar"
	self.TopBar.BackgroundColor3 = Theme.Foreground
	self.TopBar.BorderSizePixel = 0
	self.TopBar.Size = UDim2.new(1, 0, 0, 40)
	self.TopBar.Parent = self.MainFrame

	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 8)
	topCorner.Parent = self.TopBar

	local topTitle = Instance.new("TextLabel")
	topTitle.BackgroundTransparency = 1
	topTitle.Font = Enum.Font.GothamBold
	topTitle.TextColor3 = Theme.Text
	topTitle.TextSize = 16
	topTitle.Text = title
	topTitle.TextXAlignment = Enum.TextXAlignment.Left
	topTitle.Size = UDim2.new(0, 200, 1, 0)
	topTitle.Position = UDim2.new(0, 15, 0, 0)
	topTitle.Parent = self.TopBar

	-- Close button
	self.CloseButton = Instance.new("TextButton")
	self.CloseButton.BackgroundTransparency = 1
	self.CloseButton.Font = Enum.Font.GothamBold
	self.CloseButton.TextColor3 = Color3.fromRGB(255, 90, 90)
	self.CloseButton.TextSize = 18
	self.CloseButton.Text = "✕"
	self.CloseButton.Size = UDim2.new(0, 40, 1, 0)
	self.CloseButton.Position = UDim2.new(1, -40, 0, 0)
	self.CloseButton.Parent = self.TopBar
	local closeConn = self.CloseButton.MouseButton1Click:Connect(function()
		self:Destroy()
	end)
	table.insert(self.Connections, closeConn)

	-- Minimize button
	self.MinimizeButton = Instance.new("TextButton")
	self.MinimizeButton.BackgroundTransparency = 1
	self.MinimizeButton.Font = Enum.Font.GothamBold
	self.MinimizeButton.TextColor3 = Theme.SubText
	self.MinimizeButton.TextSize = 18
	self.MinimizeButton.Text = "─"
	self.MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
	self.MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
	self.MinimizeButton.Parent = self.TopBar
	local minConn = self.MinimizeButton.MouseButton1Click:Connect(function()
		self:Minimize()
	end)
	table.insert(self.Connections, minConn)

	-- Tab Button Container
	self.TabContainer = Instance.new("Frame")
	self.TabContainer.Name = "TabContainer"
	self.TabContainer.BackgroundColor3 = Theme.Foreground
	self.TabContainer.BorderSizePixel = 0
	self.TabContainer.Size = UDim2.new(0, 160, 1, -40)
	self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
	self.TabContainer.Parent = self.MainFrame

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 8)
	tabCorner.Parent = self.TabContainer

	local tabList = Instance.new("UIListLayout")
	tabList.Parent = self.TabContainer
	tabList.Padding = UDim.new(0, 5)
	tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabList.SortOrder = Enum.SortOrder.LayoutOrder
	tabList.VerticalAlignment = Enum.VerticalAlignment.Top

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingTop = UDim.new(0, 10)
	tabPadding.PaddingBottom = UDim.new(0, 10)
	tabPadding.Parent = self.TabContainer

	-- Content Container
	self.ContentArea = Instance.new("Frame")
	self.ContentArea.Name = "ContentArea"
	self.ContentArea.BackgroundTransparency = 1
	self.ContentArea.Size = UDim2.new(1, -170, 1, -50)
	self.ContentArea.Position = UDim2.new(0, 165, 0, 45)
	self.ContentArea.Parent = self.MainFrame
	self.ContentArea.ClipsDescendants = true

	-- Mouse drag for top bar
	local dragStart, frameStart
	local topBarDrag = self.TopBar
	local dragConn = topBarDrag.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragStart = input.Position
			frameStart = self.MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragStart = nil
				end
			end)
		end
	end)
	table.insert(self.Connections, dragConn)

	local moveConn = UserInputService.InputChanged:Connect(function(input)
		if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local newPos = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
			self.MainFrame.Position = newPos
		end
	end)
	table.insert(self.Connections, moveConn)

	return self
end

function Window:CreateTab(tabName, imageId)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = tabName .. "TabButton"
	tabButton.BackgroundColor3 = Theme.Foreground
	tabButton.BackgroundTransparency = 1
	tabButton.BorderSizePixel = 0
	tabButton.Font = Enum.Font.GothamSemibold
	tabButton.TextColor3 = Theme.SubText
	tabButton.TextSize = 14
	tabButton.Text = ""
	tabButton.Size = UDim2.new(1, -20, 0, 35)
	tabButton.Parent = self.TabContainer
	tabButton.AutoButtonColor = false

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 6)
	tabCorner.Parent = tabButton

	local icon
	if imageId then
		icon = Instance.new("ImageLabel")
		icon.BackgroundTransparency = 1
		icon.Image = imageId
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Position = UDim2.new(0, 10, 0.5, -10)
		icon.Parent = tabButton
	end

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamSemibold
	label.TextColor3 = Theme.SubText
	label.TextSize = 14
	label.Text = tabName
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Position = icon and UDim2.new(0, 35, 0, 0) or UDim2.new(0, 15, 0, 0)
	label.Size = icon and UDim2.new(1, -45, 1, 0) or UDim2.new(1, -25, 1, 0)
	label.Parent = tabButton

	-- Content frame for this tab
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = tabName .. "Content"
	contentFrame.BackgroundTransparency = 1
	contentFrame.Size = UDim2.new(1, 0, 1, 0)
	contentFrame.Position = UDim2.new(1, 0, 0, 0) -- start off screen to the right
	contentFrame.Visible = false
	contentFrame.Parent = self.ContentArea

	local tabData = {
		Button = tabButton,
		Label = label,
		Icon = icon,
		Content = contentFrame,
		Active = false,
	}
	table.insert(self.Tabs, tabData)

	-- Click handler
	local tabConn = tabButton.MouseButton1Click:Connect(function()
		self:SwitchTab(tabData)
	end)
	table.insert(self.Connections, tabConn)

	-- If this is the first tab, activate it
	if #self.Tabs == 1 then
		self:SwitchTab(tabData)
	end

	-- Return Tab object for adding elements
	local TabObj = {
		ContentFrame = contentFrame,
		Window = self,
	}
	function TabObj:AddButton(data)
		return addButton(data, contentFrame, self.Window)
	end
	function TabObj:AddToggle(data)
		return addToggle(data, contentFrame, self.Window)
	end
	function TabObj:AddSlider(data)
		return addSlider(data, contentFrame, self.Window)
	end
	function TabObj:AddDropdown(data)
		return addDropdown(data, contentFrame, self.Window)
	end
	function TabObj:AddLabel(data)
		return addLabel(data, contentFrame, self.Window)
	end
	return TabObj
end

function Window:SwitchTab(tabData)
	if self.ActiveTab == tabData then return end
	-- Deactivate old tab
	if self.ActiveTab then
		local old = self.ActiveTab
		old.Active = false
		local oldTweenOut = createTween(old.Content, {Position = UDim2.new(-1, 0, 0, 0), BackgroundTransparency = 0.3}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		oldTweenOut:Play()
		oldTweenOut.Completed:Connect(function()
			old.Content.Visible = false
		end)
		old.Button.BackgroundTransparency = 1
		old.Label.TextColor3 = Theme.SubText
	end

	-- Activate new tab
	tabData.Active = true
	tabData.Content.Visible = true
	tabData.Content.Position = UDim2.new(1, 0, 0, 0)
	local newTweenIn = createTween(tabData.Content, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	newTweenIn:Play()
	tabData.Button.BackgroundTransparency = 0.8
	tabData.Button.BackgroundColor3 = Theme.Accent
	tabData.Label.TextColor3 = Color3.fromRGB(255, 255, 255)

	self.ActiveTab = tabData
end

function Window:Minimize()
	if self.Minimized then return end
	self.Minimized = true

	-- Fade out main frame
	local fadeOut = createTween(self.MainFrame, {BackgroundTransparency = 0.8}, 0.3)
	fadeOut:Play()
	fadeOut.Completed:Connect(function()
		self.MainFrame.Visible = false
	end)
	self.MainFrame.BackgroundTransparency = 0.8

	-- Create or show ball
	if not self.Ball then
		self.Ball = Instance.new("ImageButton")
		self.Ball.Name = "MinimizeBall"
		self.Ball.Image = BALL_ICON
		self.Ball.BackgroundTransparency = 1
		self.Ball.Size = UDim2.new(0, 50, 0, 50)
		self.Ball.Position = UDim2.new(1, -70, 0.5, -25)
		self.Ball.Parent = self.Gui

		local ballCorner = Instance.new("UICorner")
		ballCorner.CornerRadius = UDim.new(1, 0)
		ballCorner.Parent = self.Ball

		-- Shadow for ball
		local ballShadow = Instance.new("ImageLabel")
		ballShadow.Name = "BallShadow"
		ballShadow.Image = DEFAULT_SHADOW_IMAGE
		ballShadow.ScaleType = Enum.ScaleType.Slice
		ballShadow.SliceCenter = Rect.new(32, 32, 64, 64)
		ballShadow.BackgroundTransparency = 1
		ballShadow.ImageTransparency = Theme.ShadowTransparency
		ballShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		ballShadow.Size = UDim2.new(1, 16, 1, 16)
		ballShadow.Position = UDim2.new(0, -8, 0, -8)
		ballShadow.Parent = self.Ball
		ballShadow.ZIndex = 0

		-- Drag logic
		local ballDragStart, ballStartPos
		local ballDragConn = self.Ball.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				ballDragStart = input.Position
				ballStartPos = self.Ball.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						ballDragStart = nil
					end
				end)
			end
		end)
		table.insert(self.Connections, ballDragConn)

		local ballMoveConn = UserInputService.InputChanged:Connect(function(input)
			if ballDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - ballDragStart
				local targetPos = UDim2.new(ballStartPos.X.Scale, ballStartPos.X.Offset + delta.X, ballStartPos.Y.Scale, ballStartPos.Y.Offset + delta.Y)
				-- Damping via tween
				local dampTween = createTween(self.Ball, {Position = targetPos}, 0.1)
				dampTween:Play()
			end
		end)
		table.insert(self.Connections, ballMoveConn)

		-- Double click to restore
		local lastClick = 0
		local clickConn = self.Ball.MouseButton1Click:Connect(function()
			local now = tick()
			if now - lastClick < 0.3 then
				self:Restore()
			end
			lastClick = now
		end)
		table.insert(self.Connections, clickConn)
	end

	self.Ball.Visible = true
	self.Ball.Size = UDim2.new(0, 0, 0, 0)
	local ballEnter = createTween(self.Ball, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	ballEnter:Play()
end

function Window:Restore()
	if not self.Minimized then return end
	self.Minimized = false

	if self.Ball then
		local ballExit = createTween(self.Ball, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		ballExit:Play()
		ballExit.Completed:Connect(function()
			self.Ball.Visible = false
		end)
	end

	self.MainFrame.Visible = true
	self.MainFrame.BackgroundTransparency = 1
	local fadeIn = createTween(self.MainFrame, {BackgroundTransparency = 0}, 0.3)
	fadeIn:Play()
end

function Window:Destroy()
	-- Clean connections and tweens
	cleanConnections(self.Connections)
	if self.Ball then
		self.Ball:Destroy()
	end
	if self.Gui then
		self.Gui:Destroy()
	end
end

-- Tab Component Builders
-- Button
function addButton(data, parent, window)
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = Theme.Foreground
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamSemibold
	btn.TextColor3 = Theme.Text
	btn.TextSize = 14
	btn.Text = data.Text or "Button"
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, data.PositionY or 10)
	btn.Parent = parent
	btn.AutoButtonColor = false

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	if data.Image then
		local icon = Instance.new("ImageLabel")
		icon.BackgroundTransparency = 1
		icon.Image = data.Image
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Position = UDim2.new(0, 10, 0.5, -10)
		icon.Parent = btn
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Text = "    " .. (data.Text or "Button")
	end

	-- Hover and click animations
	btn.MouseEnter:Connect(function()
		createTween(btn, {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255,255,255)}, 0.2):Play()
	end)
	btn.MouseLeave:Connect(function()
		createTween(btn, {BackgroundColor3 = Theme.Foreground, TextColor3 = Theme.Text}, 0.2):Play()
	end)
	local clickConn = btn.MouseButton1Click:Connect(function()
		createTween(btn, {Size = UDim2.new(1, -20, 0, 33)}, 0.1):Play()
		task.wait(0.1)
		createTween(btn, {Size = UDim2.new(1, -20, 0, 35)}, 0.1):Play()
		if data.Callback then
			data.Callback()
		end
	end)
	table.insert(window.Connections, clickConn)
	return btn
end

-- Toggle
function addToggle(data, parent, window)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, -20, 0, 40)
	frame.Position = UDim2.new(0, 10, 0, data.PositionY or 50)
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextColor3 = Theme.Text
	label.TextSize = 14
	label.Text = data.Text or "Toggle"
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(0, 120, 1, 0)
	label.Parent = frame

	local toggleButton = Instance.new("TextButton")
	toggleButton.BackgroundColor3 = Color3.fromRGB(50,50,55)
	toggleButton.BorderSizePixel = 0
	toggleButton.Size = UDim2.new(0, 44, 0, 24)
	toggleButton.Position = UDim2.new(1, -50, 0.5, -12)
	toggleButton.Parent = frame
	toggleButton.AutoButtonColor = false
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 12)
	toggleCorner.Parent = toggleButton

	local knob = Instance.new("Frame")
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel = 0
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = UDim2.new(0, 2, 0.5, -10)
	knob.Parent = toggleButton
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local enabled = data.Default or false
	if enabled then
		toggleButton.BackgroundColor3 = Theme.Accent
		knob.Position = UDim2.new(1, -22, 0.5, -10)
	end

	local toggleConn = toggleButton.MouseButton1Click:Connect(function()
		enabled = not enabled
		if enabled then
			createTween(toggleButton, {BackgroundColor3 = Theme.Accent}, 0.2):Play()
			createTween(knob, {Position = UDim2.new(1, -22, 0.5, -10)}, 0.2):Play()
		else
			createTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(50,50,55)}, 0.2):Play()
			createTween(knob, {Position = UDim2.new(0, 2, 0.5, -10)}, 0.2):Play()
		end
		if data.Callback then
			data.Callback(enabled)
		end
	end)
	table.insert(window.Connections, toggleConn)
	return {SetState = function(self, state) enabled = state end, GetState = function() return enabled end}
end

-- Slider
function addSlider(data, parent, window)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, -20, 0, 50)
	frame.Position = UDim2.new(0, 10, 0, data.PositionY or 100)
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextColor3 = Theme.Text
	label.TextSize = 14
	label.Text = data.Text or "Slider"
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Size = UDim2.new(0, 120, 0, 20)
	label.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.TextColor3 = Theme.SubText
	valueLabel.TextSize = 12
	valueLabel.Text = tostring(data.Default or 50)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Size = UDim2.new(0, 40, 0, 20)
	valueLabel.Position = UDim2.new(1, -40, 0, 0)
	valueLabel.Parent = frame

	local sliderFrame = Instance.new("Frame")
	sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,55)
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Size = UDim2.new(1, 0, 0, 6)
	sliderFrame.Position = UDim2.new(0, 0, 0, 30)
	sliderFrame.Parent = frame
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(0, 3)
	sliderCorner.Parent = sliderFrame

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Theme.Accent
	fill.BorderSizePixel = 0
	fill.Size = UDim2.new(0.5, 0, 1, 0)
	fill.Parent = sliderFrame
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = fill

	local knob = Instance.new("ImageButton")
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel = 0
	knob.Image = ""
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0.5, -7, 0.5, -7)
	knob.Parent = sliderFrame
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local minValue = data.Min or 0
	local maxValue = data.Max or 100
	local current = data.Default or 50

	local function updateSlider(percent)
		fill.Size = UDim2.new(percent, 0, 1, 0)
		knob.Position = UDim2.new(percent, -7, 0.5, -7)
		valueLabel.Text = tostring(math.floor(minValue + (maxValue - minValue) * percent))
	end
	updateSlider((current - minValue) / (maxValue - minValue))

	local dragging = false
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	local sliderConn = UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relPos = input.Position.X - sliderFrame.AbsolutePosition.X
			local percent = math.clamp(relPos / sliderFrame.AbsoluteSize.X, 0, 1)
			updateSlider(percent)
			current = minValue + (maxValue - minValue) * percent
			if data.Callback then
				data.Callback(current)
			end
		end
	end)
	table.insert(window.Connections, sliderConn)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	return {SetValue = function(self, val) updateSlider((val-minValue)/(maxValue-minValue)) end, GetValue = function() return current end}
end

-- Dropdown
function addDropdown(data, parent, window)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, -20, 0, 40)
	frame.Position = UDim2.new(0, 10, 0, data.PositionY or 150)
	frame.Parent = parent

	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = Theme.Foreground
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Theme.Text
	btn.TextSize = 14
	btn.Text = data.Text or "Select..."
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.Parent = frame
	btn.AutoButtonColor = false
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	if data.Image then
		local icon = Instance.new("ImageLabel")
		icon.BackgroundTransparency = 1
		icon.Image = data.Image
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Position = UDim2.new(0, 10, 0.5, -10)
		icon.Parent = btn
		btn.Text = "    " .. (data.Text or "Select...")
	end

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.BackgroundColor3 = Theme.Foreground
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
	dropdownFrame.Position = UDim2.new(0, 0, 1, 5)
	dropdownFrame.Visible = false
	dropdownFrame.Parent = frame
	dropdownFrame.ClipsDescendants = true
	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 6)
	dropCorner.Parent = dropdownFrame

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.Size = UDim2.new(1, 0, 1, -10)
	scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
	scrollFrame.ScrollBarThickness = 4
	scrollFrame.Parent = dropdownFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = scrollFrame
	listLayout.Padding = UDim.new(0, 2)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local opened = false
	local items = {}
	local selected = data.Default or data.Items and data.Items[1]

	local function rebuildOptions()
		for _, item in ipairs(items) do
			item:Destroy()
		end
		items = {}
		scrollFrame.CanvasSize = UDim2.new(0,0,0,0)

		for i, option in ipairs(data.Items or {}) do
			local optionBtn = Instance.new("TextButton")
			optionBtn.BackgroundColor3 = Theme.Foreground
			optionBtn.BorderSizePixel = 0
			optionBtn.Font = Enum.Font.Gotham
			optionBtn.TextColor3 = Theme.Text
			optionBtn.TextSize = 13
			optionBtn.Text = option
			optionBtn.Size = UDim2.new(1, -10, 0, 28)
			optionBtn.Parent = scrollFrame
			optionBtn.AutoButtonColor = false
			local optCorner = Instance.new("UICorner")
			optCorner.CornerRadius = UDim.new(0, 4)
			optCorner.Parent = optionBtn

			optionBtn.MouseButton1Click:Connect(function()
				selected = option
				btn.Text = (data.Image and "    " or "") .. option
				opened = false
				createTween(dropdownFrame, {Size = UDim2.new(1,0,0,0)}, 0.2):Play()
				task.wait(0.2)
				dropdownFrame.Visible = false
				if data.Callback then
					data.Callback(option)
				end
			end)
			table.insert(items, optionBtn)
			scrollFrame.CanvasSize = UDim2.new(0,0,0,#items * 30)
		end
	end
	rebuildOptions()

	local btnConn = btn.MouseButton1Click:Connect(function()
		if not opened then
			dropdownFrame.Visible = true
			local totalHeight = math.min(#items * 30, 120)
			createTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.2):Play()
			opened = true
		else
			opened = false
			createTween(dropdownFrame, {Size = UDim2.new(1,0,0,0)}, 0.2):Play()
			task.wait(0.2)
			dropdownFrame.Visible = false
		end
	end)
	table.insert(window.Connections, btnConn)

	local dropdownObj = {}
	function dropdownObj:GetValue() return selected end
	function dropdownObj:SetValue(val)
		selected = val
		btn.Text = (data.Image and "    " or "") .. val
	end
	function dropdownObj:UpdateItems(newItems)
		data.Items = newItems
		rebuildOptions()
	end
	return dropdownObj
end

-- Label
function addLabel(data, parent, window)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextColor3 = Theme.Text
	label.TextSize = 14
	label.Text = data.Text or ""
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 10, 0, data.PositionY or 200)
	label.Parent = parent
	return label
end

-- Library API
function Library.CreateWindow(title, options)
	return Window:CreateWindow(title, options)
end

-- Global Notifications instance
local GlobalNotifications = Notifications.new()
function Library:Notify(data)
	GlobalNotifications:Notify(data)
end

-- Cleanup on library destroy
function Library:Destroy()
	for _, window in ipairs(self.ActiveWindows) do
		window:Destroy()
	end
	if GlobalNotifications.Container then
		GlobalNotifications.Container:Destroy()
	end
end

Library.ActiveWindows = {}

return Library
