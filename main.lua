local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HMOU_UI_Core"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function protectGui()
	if syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = CoreGui
	elseif gethui then
		ScreenGui.Parent = gethui()
	else
		ScreenGui.Parent = CoreGui
	end
end
protectGui()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0.5, -275, 0.6, -175)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local BgMediaContainer = Instance.new("Frame")
BgMediaContainer.Name = "BgMediaContainer"
BgMediaContainer.Size = UDim2.new(1, 0, 1, 0)
BgMediaContainer.BackgroundTransparency = 1
BgMediaContainer.ZIndex = 0
BgMediaContainer.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local MainBorder = Instance.new("UIStroke")
MainBorder.Thickness = 1
MainBorder.Color = Color3.fromRGB(0, 255, 100)
MainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainBorder.Transparency = 1
MainBorder.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 2
TopBar.Parent = MainFrame

local TopBorder = Instance.new("Frame")
TopBorder.Size = UDim2.new(1, 0, 0, 1)
TopBorder.Position = UDim2.new(0, 0, 1, -1)
TopBorder.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
TopBorder.BorderSizePixel = 0
TopBorder.BackgroundTransparency = 1
TopBorder.Parent = TopBar

local IconImg = Instance.new("ImageLabel")
IconImg.Size = UDim2.new(0, 24, 0, 24)
IconImg.Position = UDim2.new(0, 12, 0, 10)
IconImg.BackgroundTransparency = 1
IconImg.Visible = false
IconImg.ZIndex = 2
IconImg.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 0, 20)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextSize = 14
Title.TextTransparency = 1
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 2
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -120, 0, 15)
Subtitle.Position = UDim2.new(0, 15, 0, 23)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(100, 100, 100)
Subtitle.TextSize = 11
Subtitle.TextTransparency = 1
Subtitle.Font = Enum.Font.Code
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 2
Subtitle.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 45)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "[X]"
CloseBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
CloseBtn.TextSize = 14
CloseBtn.TextTransparency = 1
CloseBtn.Font = Enum.Font.Code
CloseBtn.ZIndex = 2
CloseBtn.Parent = TopBar

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 35, 0, 45)
HideBtn.Position = UDim2.new(1, -70, 0, 0)
HideBtn.BackgroundTransparency = 1
HideBtn.Text = "[-]"
HideBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
HideBtn.TextSize = 14
HideBtn.TextTransparency = 1
HideBtn.Font = Enum.Font.Code
HideBtn.ZIndex = 2
HideBtn.Parent = TopBar

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.Size = UDim2.new(0, 130, 1, -45)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BorderSizePixel = 0
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame

local SidebarBorder = Instance.new("Frame")
SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
SidebarBorder.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
SidebarBorder.BorderSizePixel = 0
SidebarBorder.BackgroundTransparency = 1
SidebarBorder.Parent = Sidebar

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.ZIndex = 2
TabContainer.Parent = Sidebar

local TabLayout = Instance.new("UIListLayout")
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 2)
TabLayout.Parent = TabContainer

local PageContainer = Instance.new("Frame")
PageContainer.Position = UDim2.new(0, 130, 0, 45)
PageContainer.Size = UDim2.new(1, -130, 1, -45)
PageContainer.BackgroundTransparency = 1
PageContainer.ZIndex = 2
PageContainer.Parent = MainFrame

local ToggleWidget = Instance.new("TextButton")
ToggleWidget.Name = "ToggleWidget"
ToggleWidget.Size = UDim2.new(0, 40, 0, 40)
ToggleWidget.Position = UDim2.new(0, 20, 0, 20)
ToggleWidget.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ToggleWidget.Text = "点我"
ToggleWidget.TextColor3 = Color3.fromRGB(0, 255, 100)
ToggleWidget.TextSize = 14
ToggleWidget.Font = Enum.Font.Code
ToggleWidget.Visible = false
ToggleWidget.Parent = ScreenGui

local WidgetCorner = Instance.new("UICorner")
WidgetCorner.CornerRadius = UDim.new(0, 6)
WidgetCorner.Parent = ToggleWidget

local WidgetBorder = Instance.new("UIStroke")
WidgetBorder.Thickness = 1
WidgetBorder.Color = Color3.fromRGB(0, 255, 100)
WidgetBorder.Parent = ToggleWidget

local function changeGroupTransparency(transparency)
	MainBorder.Transparency = transparency
	TopBorder.BackgroundTransparency = transparency
	Title.TextTransparency = transparency
	Subtitle.TextTransparency = transparency
	IconImg.ImageTransparency = transparency
	CloseBtn.TextTransparency = transparency
	HideBtn.TextTransparency = transparency
	SidebarBorder.BackgroundTransparency = transparency
	
	local targetBgTrans = transparency == 1 and 1 or 0.15
	local targetSideTrans = transparency == 1 and 1 or 0.25
	local targetBarTrans = transparency == 1 and 1 or 0.3
	
	MainFrame.BackgroundTransparency = transparency == 1 and 1 or targetBgTrans
	Sidebar.BackgroundTransparency = transparency == 1 and 1 or targetSideTrans
	TopBar.BackgroundTransparency = transparency == 1 and 1 or targetBarTrans
	
	local mediaChild = BgMediaContainer:GetChildren()[1]
	if mediaChild then
		if mediaChild:IsA("ImageLabel") then
			mediaChild.ImageTransparency = transparency
		elseif mediaChild:IsA("VideoFrame") then
			mediaChild.Volume = transparency == 1 and 0 or 1
		end
	end

	for _, child in ipairs(TabContainer:GetChildren()) do
		if child:IsA("TextButton") then
			child.TextTransparency = transparency
		end
	end
	
	for _, page in ipairs(PageContainer:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, element in ipairs(page:GetChildren()) do
				if element:IsA("TextButton") then
					element.BackgroundTransparency = transparency == 1 and 1 or 0.4
					element.TextTransparency = transparency
					local stroke = element:FindFirstChildOfClass("UIStroke")
					if stroke then stroke.Transparency = transparency == 1 and 1 or 0.6 end
					local label = element:FindFirstChildOfClass("TextLabel")
					if label then label.TextTransparency = transparency end
					local indicator = element:FindFirstChild("IndicatorLabel")
					if indicator then indicator.TextTransparency = transparency end
				end
			end
		end
	end
end

local isAnimating = false

local function openUI()
	if isAnimating then return end
	isAnimating = true
	
	MainFrame.Position = UDim2.new(0.5, -275, 0.6, -175)
	changeGroupTransparency(1)
	MainFrame.Visible = true
	
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
	local moveTween = TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.5, -275, 0.5, -175)})
	
	local transparencyValue = Instance.new("NumberValue")
	transparencyValue.Value = 1
	transparencyValue:GetPropertyChangedSignal("Value"):Connect(function()
		changeGroupTransparency(transparencyValue.Value)
	end)
	
	local fadeTween = TweenService:Create(transparencyValue, tweenInfo, {Value = 0})
	
	moveTween:Play()
	fadeTween:Play()
	
	moveTween.Completed:Connect(function()
		transparencyValue:Destroy()
		isAnimating = false
	end)
end

local function closeUI(destroys)
	if isAnimating then return end
	isAnimating = true
	
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	local moveTween = TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.5, -275, 0.6, -175)})
	
	local transparencyValue = Instance.new("NumberValue")
	transparencyValue.Value = 0
	transparencyValue:GetPropertyChangedSignal("Value"):Connect(function()
		changeGroupTransparency(transparencyValue.Value)
	end)
	
	local fadeTween = TweenService:Create(transparencyValue, tweenInfo, {Value = 1})
	
	moveTween:Play()
	fadeTween:Play()
	
	moveTween.Completed:Connect(function()
		MainFrame.Visible = false
		transparencyValue:Destroy()
		isAnimating = false
		if destroys then
			ScreenGui:Destroy()
		else
			ToggleWidget.Visible = true
		end
	end)
end

do
	local dragging, dragInput, dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	end
	
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

do
	local dragging, dragInput, dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(ToggleWidget, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
	end
	
	ToggleWidget.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = ToggleWidget.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	ToggleWidget.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

HideBtn.MouseButton1Click:Connect(function()
	closeUI(false)
end)

CloseBtn.MouseButton1Click:Connect(function()
	closeUI(true)
end)

ToggleWidget.MouseButton1Click:Connect(function()
	ToggleWidget.Visible = false
	openUI()
end)

local function handleMediaBackground(url)
	if not url or url == "" then return end
	BgMediaContainer:ClearAllChildren()

	local isVideo = string.match(string.lower(url), "%.mp4") or string.match(string.lower(url), "%.mov") or string.match(string.lower(url), "%.webm")
	local ext = isVideo and ".mp4" or ".png"
	local fileName = "hmou_bg_" .. string.sub(HttpService:GenerateGUID(false), 1, 8) .. ext

	local originalTitle = Title.Text
	if isVideo then
		Title.Text = "系统提示 // 正在下载背景视频，请稍候..."
	end

	task.spawn(function()
		local success, response = pcall(function()
			return game:HttpGet(url)
		end)

		if success and response then
			pcall(function()
				writefile(fileName, response)
			end)
			
			task.spawn(function()
				if isVideo then
					local video = Instance.new("VideoFrame")
					video.Size = UDim2.new(1, 0, 1, 0)
					video.BackgroundTransparency = 1
					video.Video = getcustomasset(fileName)
					video.Looped = true
					video.ZIndex = 0
					video.Parent = BgMediaContainer
					video:Play()
				else
					local image = Instance.new("ImageLabel")
					image.Size = UDim2.new(1, 0, 1, 0)
					image.BackgroundTransparency = 1
					image.Image = getcustomasset(fileName)
					image.ScaleType = Enum.ScaleType.Crop
					image.ZIndex = 0
					image.Parent = BgMediaContainer
				end
			end)
		end
		Title.Text = originalTitle
	end)
end

local HMOU_UI = {}
HMOU_UI.__index = HMOU_UI

local WindowClass = {}
WindowClass.__index = WindowClass

local TabClass = {}
TabClass.__index = TabClass

function HMOU_UI:CreateWindow(config)
	config = config or {}
	local titleText = config.Title or "HMOU UI"
	local iconAsset = config.Icon or ""
	local authorText = config.Author or ""
	local bgUrl = config.Background or ""

	Title.Text = titleText
	
	if iconAsset ~= "" then
		IconImg.Image = iconAsset
		IconImg.Visible = true
		Title.Position = UDim2.new(0, 42, 0, 5)
		Subtitle.Position = UDim2.new(0, 42, 0, 23)
	else
		IconImg.Visible = false
		Title.Position = UDim2.new(0, 15, 0, 5)
		Subtitle.Position = UDim2.new(0, 15, 0, 23)
	end

	if authorText ~= "" then
		Subtitle.Text = authorText
		Subtitle.Visible = true
	else
		Subtitle.Visible = false
		Title.Position = UDim2.new(Title.Position.X.Scale, Title.Position.X.Offset, 0, 12)
	end

	if bgUrl ~= "" and writefile and getcustomasset then
		handleMediaBackground(bgUrl)
	end

	openUI()
	
	local windowInstance = setmetatable({}, WindowClass)
	windowInstance.tabs = {}
	windowInstance.pages = {}
	return windowInstance
end

function WindowClass:CreateTab(config)
	config = config or {}
	local name = config.Name or "新栏目"
	local core = self
	
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -10, 0, 32)
	tabBtn.Position = UDim2.new(0, 5, 0, 0)
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = " [ ] " .. name
	tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	tabBtn.TextSize = 13
	tabBtn.Font = Enum.Font.Code
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.ZIndex = 2
	tabBtn.Parent = TabContainer

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Visible = false
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
	page.ZIndex = 2
	page.Parent = PageContainer

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 6)
	pageLayout.Parent = page
	
	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingTop = UDim.new(0, 10)
	pagePadding.PaddingLeft = UDim.new(0, 15)
	pagePadding.PaddingRight = UDim.new(0, 15)
	pagePadding.Parent = page

	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
	end)

	tabBtn.MouseButton1Click:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		for _, t in ipairs(core.tabs) do
			TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
			t.Text = " [ ] " .. string.sub(t.Text, 6)
		end
		for _, p in ipairs(core.pages) do
			p.Visible = false
		end
		TweenService:Create(tabBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(0, 255, 100)}):Play()
		tabBtn.Text = " [*] " .. name
		page.Visible = true
	end)

	table.insert(core.tabs, tabBtn)
	table.insert(core.pages, page)

	if #core.tabs == 1 then
		tabBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
		tabBtn.Text = " [*] " .. name
		page.Visible = true
	end

	local tabInstance = setmetatable({}, TabClass)
	tabInstance.page = page
	return tabInstance
end

function TabClass:CreateButton(config)
	config = config or {}
	local text = config.Name or "按钮"
	local callback = config.Callback
	local page = self.page
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	btn.Text = " > " .. text
	btn.TextColor3 = Color3.fromRGB(0, 255, 100)
	btn.TextSize = 13
	btn.Font = Enum.Font.Code
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BackgroundTransparency = 0.4
	btn.ZIndex = 2
	btn.Parent = page

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = btn

	local btnBorder = Instance.new("UIStroke")
	btnBorder.Thickness = 1
	btnBorder.Color = Color3.fromRGB(30, 30, 30)
	btnBorder.Transparency = 0.6
	btnBorder.Parent = btn

	btn.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(btnBorder, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 100), Transparency = 0}):Play()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.2}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btnBorder, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15), BackgroundTransparency = 0.4}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		btn.Text = " >> " .. text
		task.delay(0.1, function() btn.Text = " > " .. text end)
		if callback then callback() end
	end)
end

function TabClass:CreateToggle(config)
	config = config or {}
	local text = config.Name or "开关"
	local default = config.Default or false
	local callback = config.Callback
	local page = self.page
	local state = default
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(1, 0, 0, 32)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	toggleBtn.Text = ""
	toggleBtn.BackgroundTransparency = 0.4
	toggleBtn.ZIndex = 2
	toggleBtn.Parent = page

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 4)
	toggleCorner.Parent = toggleBtn

	local toggleBorder = Instance.new("UIStroke")
	toggleBorder.Thickness = 1
	toggleBorder.Color = Color3.fromRGB(30, 30, 30)
	toggleBorder.Transparency = 0.6
	toggleBorder.Parent = toggleBtn

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 13
	label.Font = Enum.Font.Code
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 2
	label.Parent = toggleBtn

	local indicator = Instance.new("TextLabel")
	indicator.Name = "IndicatorLabel"
	indicator.Size = UDim2.new(0, 40, 1, 0)
	indicator.Position = UDim2.new(1, -45, 0, 0)
	indicator.BackgroundTransparency = 1
	indicator.Text = state and "[开启]" or "[关闭]"
	indicator.TextColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
	indicator.TextSize = 13
	indicator.Font = Enum.Font.Code
	indicator.TextXAlignment = Enum.TextXAlignment.Right
	indicator.ZIndex = 2
	indicator.Parent = toggleBtn

	local function updateToggle()
		indicator.Text = state and "[开启]" or "[关闭]"
		TweenService:Create(indicator, TweenInfo.new(0.15), {TextColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)}):Play()
		if callback then callback(state) end
	end

	toggleBtn.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(toggleBorder, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 100), Transparency = 0}):Play()
	end)

	toggleBtn.MouseLeave:Connect(function()
		TweenService:Create(toggleBorder, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
	end)

	toggleBtn.MouseButton1Click:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		state = not state
		updateToggle()
	end)
end

return HMOU_UI
