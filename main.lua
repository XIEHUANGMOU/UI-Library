local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

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
MainFrame.Position = UDim2.new(0.5, -275, 1, 0)
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

local function createShadowText(parent, size, position, font, textSize, alignment, name)
	local shadow = Instance.new("TextLabel")
	shadow.Name = name .. "_Shadow"
	shadow.Size = size
	shadow.Position = position + UDim2.new(0, 1, 0, 1)
	shadow.BackgroundTransparency = 1
	shadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	shadow.TextSize = textSize
	shadow.TextTransparency = 1
	shadow.Font = font
	shadow.TextXAlignment = alignment
	shadow.ZIndex = parent.ZIndex
	shadow.Parent = parent

	local main = Instance.new("TextLabel")
	main.Name = name .. "_Main"
	main.Size = size
	main.Position = position
	main.BackgroundTransparency = 1
	main.TextColor3 = Color3.fromRGB(0, 255, 100)
	main.TextSize = textSize
	main.TextTransparency = 1
	main.Font = font
	main.TextXAlignment = alignment
	main.ZIndex = parent.ZIndex + 1
	main.Parent = parent

	main:GetPropertyChangedSignal("Text"):Connect(function()
		shadow.Text = main.Text
	end)
	
	return main, shadow
end

local Title, TitleShadow = createShadowText(TopBar, UDim2.new(1, -120, 0, 20), UDim2.new(0, 15, 0, 5), Enum.Font.Code, 14, Enum.TextXAlignment.Left, "Title")
local Subtitle, SubtitleShadow = createShadowText(TopBar, UDim2.new(1, -120, 0, 15), UDim2.new(0, 15, 0, 23), Enum.Font.Code, 11, Enum.TextXAlignment.Left, "Subtitle")
Subtitle.TextColor3 = Color3.fromRGB(130, 130, 130)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 45)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = ""
CloseBtn.ZIndex = 2
CloseBtn.Parent = TopBar
local CloseLabel, CloseShadow = createShadowText(CloseBtn, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Code, 14, Enum.TextXAlignment.Center, "Close")
CloseLabel.Text = "[X]"

local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 35, 0, 45)
HideBtn.Position = UDim2.new(1, -70, 0, 0)
HideBtn.BackgroundTransparency = 1
HideBtn.Text = ""
HideBtn.ZIndex = 2
HideBtn.Parent = TopBar
local HideLabel, HideShadow = createShadowText(HideBtn, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Code, 14, Enum.TextXAlignment.Center, "Hide")
HideLabel.Text = "[-]"

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
ToggleWidget.Text = ""
ToggleWidget.Visible = false
ToggleWidget.Parent = ScreenGui

local WidgetCorner = Instance.new("UICorner")
WidgetCorner.CornerRadius = UDim.new(0, 6)
WidgetCorner.Parent = ToggleWidget

local WidgetBorder = Instance.new("UIStroke")
WidgetBorder.Thickness = 1
WidgetBorder.Color = Color3.fromRGB(0, 255, 100)
WidgetBorder.Parent = ToggleWidget

local WidgetLabel, WidgetShadow = createShadowText(ToggleWidget, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Center, "Widget")
WidgetLabel.Text = "点我"
WidgetLabel.TextTransparency = 0
WidgetShadow.TextTransparency = 0.3

local currentAccentColor = Color3.fromRGB(0, 255, 100)
local rainbowConnection = nil

local themes = {
	["Default"] = Color3.fromRGB(0, 255, 100),
	["Red"] = Color3.fromRGB(255, 50, 50),
	["Blue"] = Color3.fromRGB(50, 150, 255),
	["Purple"] = Color3.fromRGB(180, 50, 255),
	["Orange"] = Color3.fromRGB(255, 120, 0),
	["Pink"] = Color3.fromRGB(255, 105, 180),
	["Cyan"] = Color3.fromRGB(0, 240, 255),
	["Yellow"] = Color3.fromRGB(255, 215, 0),
	["White"] = Color3.fromRGB(240, 240, 240)
}

local function applyColorUpdate(color)
	currentAccentColor = color
	MainBorder.Color = color
	TopBorder.BackgroundColor3 = color
	SidebarBorder.BackgroundColor3 = color
	Title.TextColor3 = color
	CloseLabel.TextColor3 = color
	HideLabel.TextColor3 = color
	WidgetBorder.Color = color
	WidgetLabel.TextColor3 = color
	
	for _, child in ipairs(TabContainer:GetChildren()) do
		if child:IsA("TextButton") and child:GetAttribute("IsSelected") then
			local mainText = child:FindFirstChild("Tab_Main")
			if mainText then mainText.TextColor3 = color end
		end
	end
	
	for _, page in ipairs(PageContainer:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, element in ipairs(page:GetChildren()) do
				if element:IsA("TextButton") then
					local mainText = element:FindFirstChild("Btn_Main") or element:FindFirstChild("Toggle_Main")
					local indicator = element:FindFirstChild("Indicator_Main")
					if indicator and element:GetAttribute("ToggleState") == true then
						indicator.TextColor3 = color
					end
					if mainText and not indicator then
						mainText.TextColor3 = color
					end
				elseif element:IsA("Frame") and element.Name == "TagElement" then
					if element:GetAttribute("FollowTheme") == true then
						local stroke = element:FindFirstChildOfClass("UIStroke")
						local tagMain = element:FindFirstChild("Tag_Main")
						if stroke then stroke.Color = color end
						if tagMain then tagMain.TextColor3 = color end
					end
				end
			end
		end
	end
end

local function applyThemeStyle(themeName)
	if rainbowConnection then
		rainbowConnection:Disconnect()
		rainbowConnection = nil
	end
	
	if themeName == "Rainbow" or themeName == "七彩" then
		rainbowConnection = RunService.RenderStepped:Connect(function()
			local hue = (tick() % 4) / 4
			local color = Color3.fromHSV(hue, 0.8, 1)
			applyColorUpdate(color)
		end)
	else
		local targetColor = themes[themeName] or themes["Default"]
		applyColorUpdate(targetColor)
	end
end

local function changeGroupTransparency(transparency)
	MainBorder.Transparency = transparency
	TopBorder.BackgroundTransparency = transparency
	SidebarBorder.BackgroundTransparency = transparency
	
	local textTrans = transparency
	local shadowTrans = transparency == 1 and 1 or (0.3 + (transparency * 0.7))
	
	Title.TextTransparency = textTrans
	TitleShadow.TextTransparency = shadowTrans
	Subtitle.TextTransparency = textTrans
	SubtitleShadow.TextTransparency = shadowTrans
	CloseLabel.TextTransparency = textTrans
	CloseShadow.TextTransparency = shadowTrans
	HideLabel.TextTransparency = textTrans
	HideShadow.TextTransparency = shadowTrans
	
	IconImg.ImageTransparency = transparency
	
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
			local m = child:FindFirstChild("Tab_Main")
			local s = child:FindFirstChild("Tab_Shadow")
			if m and s then
				m.TextTransparency = textTrans
				s.TextTransparency = shadowTrans
			end
		end
	end
	
	for _, page in ipairs(PageContainer:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, element in ipairs(page:GetChildren()) do
				if element:IsA("TextButton") then
					element.BackgroundTransparency = transparency == 1 and 1 or 0.4
					local stroke = element:FindFirstChildOfClass("UIStroke")
					if stroke then stroke.Transparency = transparency == 1 and 1 or 0.6 end
					
					for _, item in ipairs(element:GetChildren()) do
						if item:IsA("TextLabel") then
							if string.match(item.Name, "_Shadow") then
								item.TextTransparency = shadowTrans
							else
								item.TextTransparency = textTrans
							end
						end
					end
				elseif element:IsA("Frame") and element.Name == "TagElement" then
					element.BackgroundTransparency = transparency == 1 and 1 or 0.85
					local stroke = element:FindFirstChildOfClass("UIStroke")
					if stroke then stroke.Transparency = transparency == 1 and 1 or 0.5 end
					local m = element:FindFirstChild("Tag_Main")
					local s = element:FindFirstChild("Tag_Shadow")
					if m and s then
						m.TextTransparency = textTrans
						s.TextTransparency = shadowTrans
					end
					local icon = element:FindFirstChild("TagIcon")
					if icon then icon.ImageTransparency = textTrans end
				end
			end
		end
	end
end

local isAnimating = false

local function openUI()
	if isAnimating then return end
	isAnimating = true
	
	MainFrame.Position = UDim2.new(0.5, -275, 1, 0)
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
	
	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	local moveTween = TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.5, -275, 1, 0)})
	
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
			if rainbowConnection then rainbowConnection:Disconnect() end
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
	local themeStyle = config.Fengge or "Default"

	Title.Text = titleText
	
	if iconAsset ~= "" then
		IconImg.Image = iconAsset
		IconImg.Visible = true
		Title.Position = UDim2.new(0, 42, 0, 5)
		TitleShadow.Position = UDim2.new(0, 43, 0, 6)
		Subtitle.Position = UDim2.new(0, 42, 0, 23)
		SubtitleShadow.Position = UDim2.new(0, 43, 0, 24)
	else
		IconImg.Visible = false
		Title.Position = UDim2.new(0, 15, 0, 5)
		TitleShadow.Position = UDim2.new(0, 16, 0, 6)
		Subtitle.Position = UDim2.new(0, 15, 0, 23)
		SubtitleShadow.Position = UDim2.new(0, 16, 0, 24)
	end

	if authorText ~= "" then
		Subtitle.Text = authorText
		Subtitle.Visible = true
		SubtitleShadow.Visible = true
	else
		Subtitle.Visible = false
		SubtitleShadow.Visible = false
		Title.Position = UDim2.new(Title.Position.X.Scale, Title.Position.X.Offset, 0, 12)
		TitleShadow.Position = UDim2.new(TitleShadow.Position.X.Scale, TitleShadow.Position.X.Offset, 0, 13)
	end

	if bgUrl ~= "" and writefile and getcustomasset then
		handleMediaBackground(bgUrl)
	end

	applyThemeStyle(themeStyle)
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
	tabBtn.Text = ""
	tabBtn.ZIndex = 2
	tabBtn.Parent = TabContainer

	local mLabel, sLabel = createShadowText(tabBtn, UDim2.new(1, 0, 1, 0), UDim2.new(0, 5, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "Tab")
	mLabel.Text = " [ ] " .. name
	mLabel.TextColor3 = Color3.fromRGB(150, 150, 150)

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Visible = false
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = currentAccentColor
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
			t:SetAttribute("IsSelected", false)
			local tm = t:FindFirstChild("Tab_Main")
			if tm then
				TweenService:Create(tm, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
				tm.Text = " [ ] " .. string.sub(tm.Text, 6)
			end
		end
		for _, p in ipairs(core.pages) do
			p.Visible = false
		end
		tabBtn:SetAttribute("IsSelected", true)
		TweenService:Create(mLabel, TweenInfo.new(0.2), {TextColor3 = currentAccentColor}):Play()
		mLabel.Text = " [*] " .. name
		page.Visible = true
	end)

	table.insert(core.tabs, tabBtn)
	table.insert(core.pages, page)

	if #core.tabs == 1 then
		tabBtn:SetAttribute("IsSelected", true)
		mLabel.TextColor3 = currentAccentColor
		mLabel.Text = " [*] " .. name
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
	btn.Text = ""
	btn.BackgroundTransparency = 0.4
	btn.ZIndex = 2
	btn.Parent = page

	local mLabel, sLabel = createShadowText(btn, UDim2.new(1, 0, 1, 0), UDim2.new(0, 10, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "Btn")
	mLabel.Text = " > " .. text
	mLabel.TextColor3 = currentAccentColor

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
		TweenService:Create(btnBorder, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.2}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btnBorder, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15), BackgroundTransparency = 0.4}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		mLabel.Text = " >> " .. text
		task.delay(0.1, function() mLabel.Text = " > " .. text end)
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
	toggleBtn:SetAttribute("ToggleState", state)
	toggleBtn.Parent = page

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 4)
	toggleCorner.Parent = toggleBtn

	local toggleBorder = Instance.new("UIStroke")
	toggleBorder.Thickness = 1
	toggleBorder.Color = Color3.fromRGB(30, 30, 30)
	toggleBorder.Transparency = 0.6
	toggleBorder.Parent = toggleBtn

	local mLabel, sLabel = createShadowText(toggleBtn, UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "Toggle")
	mLabel.Text = text
	mLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

	local mIndicator, sIndicator = createShadowText(toggleBtn, UDim2.new(0, 40, 1, 0), UDim2.new(1, -45, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Right, "Indicator")
	mIndicator.Text = state and "[开启]" or "[关闭]"
	mIndicator.TextColor3 = state and currentAccentColor or Color3.fromRGB(255, 50, 50)

	if MainFrame.BackgroundTransparency <= 0.5 then
		mLabel.TextTransparency = 0
		sLabel.TextTransparency = 0.3
		mIndicator.TextTransparency = 0
		sIndicator.TextTransparency = 0.3
	end

	local function updateToggle()
		toggleBtn:SetAttribute("ToggleState", state)
		mIndicator.Text = state and "[开启]" or "[关闭]"
		local targetColor = state and currentAccentColor or Color3.fromRGB(255, 50, 50)
		TweenService:Create(mIndicator, TweenInfo.new(0.15), {TextColor3 = targetColor}):Play()
		if callback then callback(state) end
	end

	toggleBtn.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(toggleBorder, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
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

function TabClass:CreateTag(config)
	config = config or {}
	local titleText = config.Title or "Featured"
	local iconAsset = config.Icon or ""
	local customColor = config.Color
	local page = self.page

	local tagFrame = Instance.new("Frame")
	tagFrame.Name = "TagElement"
	tagFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	tagFrame.BackgroundTransparency = 0.85
	tagFrame.ZIndex = 2
	tagFrame.Parent = page

	local tagCorner = Instance.new("UICorner")
	tagCorner.CornerRadius = UDim.new(0, 4)
	tagCorner.Parent = tagFrame

	local tagStroke = Instance.new("UIStroke")
	tagStroke.Thickness = 1
	tagStroke.Transparency = 0.5
	tagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	tagStroke.Parent = tagFrame

	local hasIcon = iconAsset ~= ""
	local textOffsetX = hasIcon and 24 or 8

	local mLabel, sLabel = createShadowText(tagFrame, UDim2.new(1, -textOffsetX - 8, 1, 0), UDim2.new(0, textOffsetX, 0, 0), Enum.Font.Code, 11, Enum.TextXAlignment.Left, "Tag")
	mLabel.Text = titleText

	local iconImg = nil
	if hasIcon then
		iconImg = Instance.new("ImageLabel")
		iconImg.Name = "TagIcon"
		iconImg.Size = UDim2.new(0, 12, 0, 12)
		iconImg.Position = UDim2.new(0, 7, 0.5, -6)
		iconImg.BackgroundTransparency = 1
		iconImg.Image = iconAsset
		iconImg.ZIndex = 3
		iconImg.Parent = tagFrame
	end

	if customColor then
		tagFrame:SetAttribute("FollowTheme", false)
		tagStroke.Color = customColor
		mLabel.TextColor3 = customColor
		if iconImg then iconImg.ImageColor3 = customColor end
	else
		tagFrame:SetAttribute("FollowTheme", true)
		tagStroke.Color = currentAccentColor
		mLabel.TextColor3 = currentAccentColor
		if iconImg then iconImg.ImageColor3 = currentAccentColor end
		
		tagFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if iconImg then iconImg.ImageColor3 = currentAccentColor end
		end)
	end

	local textBound = game:GetService("TextService"):GetTextSize(titleText, 11, Enum.Font.Code, Vector2.new(1000, 20))
	local finalWidth = textOffsetX + textBound.X + 10
	tagFrame.Size = UDim2.new(0, math.clamp(finalWidth, 45, 380), 0, 20)

	if MainFrame.BackgroundTransparency <= 0.5 then
		mLabel.TextTransparency = 0
		sLabel.TextTransparency = 0.3
		if iconImg then iconImg.ImageTransparency = 0 end
	end
end

return HMOU_UI
