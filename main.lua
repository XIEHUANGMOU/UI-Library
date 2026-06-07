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

local HeaderContainer = Instance.new("Frame")
HeaderContainer.Name = "HeaderContainer"
HeaderContainer.Position = UDim2.new(0, 15, 0, 5)
HeaderContainer.Size = UDim2.new(1, -120, 0, 20)
HeaderContainer.BackgroundTransparency = 1
HeaderContainer.ZIndex = 2
HeaderContainer.Parent = TopBar

local HeaderLayout = Instance.new("UIListLayout")
HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
HeaderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
HeaderLayout.Padding = UDim.new(0, 6)
HeaderLayout.Parent = HeaderContainer

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

local Title, TitleShadow = createShadowText(HeaderContainer, UDim2.new(0, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Code, 14, Enum.TextXAlignment.Left, "Title")
Title.LayoutOrder = 1
TitleShadow.LayoutOrder = 1

local TagListContainer = Instance.new("Frame")
TagListContainer.Name = "TagListContainer"
TagListContainer.Size = UDim2.new(0, 0, 1, 0)
TagListContainer.BackgroundTransparency = 1
TagListContainer.ZIndex = 2
TagListContainer.LayoutOrder = 2
TagListContainer.Parent = HeaderContainer

local TagListLayout = Instance.new("UIListLayout")
TagListLayout.FillDirection = Enum.FillDirection.Horizontal
TagListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TagListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TagListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TagListLayout.Padding = UDim.new(0, 5)
TagListLayout.Parent = TagListContainer

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
local activeTheme = "Default"

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

local function updateHeaderLayoutSize()
	local titleWidth = Title.TextBounds.X
	Title.Size = UDim2.new(0, titleWidth, 1, 0)
	TitleShadow.Size = UDim2.new(0, titleWidth, 1, 0)
	
	local totalTagsWidth = 0
	local tagCount = 0
	for _, child in ipairs(TagListContainer:GetChildren()) do
		if child:IsA("Frame") then
			totalTagsWidth = totalTagsWidth + child.Size.X.Offset
			tagCount = tagCount + 1
		end
	end
	if tagCount > 1 then
		totalTagsWidth = totalTagsWidth + ((tagCount - 1) * TagListLayout.Padding.Offset)
	end
	TagListContainer.Size = UDim2.new(0, totalTagsWidth, 1, 0)
end

Title:GetPropertyChangedSignal("Text"):Connect(updateHeaderLayoutSize)
Title:GetPropertyChangedSignal("TextBounds"):Connect(updateHeaderLayoutSize)
TagListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeaderLayoutSize)

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
	
	for _, tag in ipairs(TagListContainer:GetChildren()) do
		if tag:IsA("Frame") and tag:GetAttribute("FollowTheme") then
			tag.BackgroundColor3 = color
			local tagStroke = tag:FindFirstChildOfClass("UIStroke")
			if tagStroke then tagStroke.Color = color end
		end
	end
	
	for _, child in ipairs(TabContainer:GetChildren()) do
		if child:IsA("TextButton") and child:GetAttribute("IsSelected") then
			local mainText = child:FindFirstChild("Tab_Main")
			if mainText then mainText.TextColor3 = color end
		end
	end
	
	for _, page in ipairs(PageContainer:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			for _, element in ipairs(page:GetChildren()) do
				if element:IsA("TextButton") or element:IsA("Frame") then
					local mainText = element:FindFirstChild("Btn_Main") or element:FindFirstChild("Toggle_Main") or element:FindFirstChild("SliderTitle_Main") or element:FindFirstChild("InputTitle_Main") or element:FindFirstChild("KeybindTitle_Main")
					local indicator = element:FindFirstChild("Indicator_Main")
					if indicator and element:GetAttribute("ToggleState") == true then
						indicator.TextColor3 = color
					end
					if mainText and not indicator and not element:IsA("Frame") then
						mainText.TextColor3 = color
					end
				end
			end
		end
	end
end

local function applyThemeStyle(themeName)
	activeTheme = themeName
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
	
	for _, tag in ipairs(TagListContainer:GetChildren()) do
		if tag:IsA("Frame") then
			tag.BackgroundTransparency = transparency == 1 and 1 or (tag:GetAttribute("BaseTransparency") or 0)
			local tagStroke = tag:FindFirstChildOfClass("UIStroke")
			if tagStroke then tagStroke.Transparency = transparency == 1 and 1 or 0 end
			local m = tag:FindFirstChild("Tag_Main")
			local s = tag:FindFirstChild("Tag_Shadow")
			if m and s then
				m.TextTransparency = textTrans
				s.TextTransparency = shadowTrans
			end
		end
	end
	
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
				if element:IsA("TextButton") or element:IsA("Frame") then
					element.BackgroundTransparency = transparency == 1 and 1 or (element:IsA("Frame") and 1 or 0.4)
					local stroke = element:FindFirstChildOfClass("UIStroke")
					if stroke then stroke.Transparency = transparency == 1 and 1 or 0.6 end
					
					for _, item in ipairs(element:GetChildren()) do
						if item:IsA("TextLabel") then
							if string.match(item.Name, "_Shadow") then
								item.TextTransparency = shadowTrans
							else
								item.TextTransparency = textTrans
							end
						elseif item:IsA("Frame") and item.Name == "SliderBar" then
							item.BackgroundTransparency = transparency == 1 and 1 or 0.6
							local fill = item:FindFirstChild("SliderFill")
							if fill then fill.BackgroundTransparency = transparency end
						elseif item:IsA("TextBox") then
							item.BackgroundTransparency = transparency == 1 and 1 or 0.5
							item.TextTransparency = textTrans
						end
					end
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
		updateHeaderLayoutSize()
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
		HeaderContainer.Position = UDim2.new(0, 42, 0, 5)
		HeaderContainer.Size = UDim2.new(1, -147, 0, 20)
		Subtitle.Position = UDim2.new(0, 42, 0, 23)
		SubtitleShadow.Position = UDim2.new(0, 43, 0, 24)
	else
		IconImg.Visible = false
		HeaderContainer.Position = UDim2.new(0, 15, 0, 5)
		HeaderContainer.Size = UDim2.new(1, -120, 0, 20)
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
		HeaderContainer.Position = UDim2.new(HeaderContainer.Position.X.Scale, HeaderContainer.Position.X.Offset, 0, 12)
	end

	applyThemeStyle(themeStyle)
	openUI()
	
	local windowInstance = setmetatable({}, WindowClass)
	windowInstance.tabs = {}
	windowInstance.pages = {}
	return windowInstance
end

function WindowClass:CreateTag(config)
	config = config or {}
	local text = config.Text or "Tag"
	local color = config.Color or Color3.fromRGB(0, 255, 100)
	local isFilled = (config.Style == "Filled")
	local followTheme = (config.FollowTheme == true)
	
	local tagFrame = Instance.new("Frame")
	tagFrame.Name = "Tag_" .. text
	tagFrame.ZIndex = 2
	
	local tagCorner = Instance.new("UICorner")
	tagCorner.CornerRadius = UDim.new(0, 4)
	tagCorner.Parent = tagFrame
	
	if followTheme then
		tagFrame:SetAttribute("FollowTheme", true)
		color = currentAccentColor
	end
	
	if isFilled then
		tagFrame.BackgroundColor3 = color
		tagFrame.BackgroundTransparency = 0.2
		tagFrame:SetAttribute("BaseTransparency", 0.2)
	else
		tagFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		tagFrame.BackgroundTransparency = 0.4
		tagFrame:SetAttribute("BaseTransparency", 0.4)
		
		local tagStroke = Instance.new("UIStroke")
		tagStroke.Thickness = 1
		tagStroke.Color = color
		tagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		tagStroke.Parent = tagFrame
	end
	
	local textColor = isFilled and Color3.fromRGB(10, 10, 10) or color
	local mLabel, sLabel = createShadowText(tagFrame, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Code, 10, Enum.TextXAlignment.Center, "Tag")
	mLabel.Text = text
	mLabel.TextColor3 = textColor
	
	if isFilled then
		sLabel:Destroy()
	end
	
	tagFrame.Parent = TagListContainer
	
	local tempText = Instance.new("TextLabel")
	tempText.Font = Enum.Font.Code
	tempText.TextSize = 10
	tempText.Text = text
	local textWidth = tempText.TextBounds.X
	tagFrame.Size = UDim2.new(0, textWidth + 10, 0, 15)
	tempText:Destroy()
	
	updateHeaderLayoutSize()
	
	if MainFrame.Visible then
		tagFrame.BackgroundTransparency = tagFrame:GetAttribute("BaseTransparency")
		local str = tagFrame:FindFirstChildOfClass("UIStroke")
		if str then str.Transparency = 0 end
		mLabel.TextTransparency = 0
		local sh = tagFrame:FindFirstChild("Tag_Shadow")
		if sh then sh.TextTransparency = 0.3 end
	else
		tagFrame.BackgroundTransparency = 1
		local str = tagFrame:FindFirstChildOfClass("UIStroke")
		if str then str.Transparency = 1 end
		mLabel.TextTransparency = 1
		local sh = tagFrame:FindFirstChild("Tag_Shadow")
		if sh then sh.TextTransparency = 1 end
	end
	
	local tagObj = {}
	function tagObj:SetText(newText)
		mLabel.Text = newText
		local temp = Instance.new("TextLabel")
		temp.Font = Enum.Font.Code
		temp.TextSize = 10
		temp.Text = newText
		tagFrame.Size = UDim2.new(0, temp.TextBounds.X + 10, 0, 15)
		temp:Destroy()
		updateHeaderLayoutSize()
	end
	function tagObj:Destroy()
		tagFrame:Destroy()
		updateHeaderLayoutSize()
	end
	return tagObj
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

function TabClass:CreateSlider(config)
	config = config or {}
	local text = config.Name or "滑块"
	local min = config.Min or 0
	local max = config.Max or 100
	local default = config.Default or 50
	local callback = config.Callback
	local page = self.page
	
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, 0, 0, 45)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	sliderFrame.BackgroundTransparency = 0.4
	sliderFrame.ZIndex = 2
	sliderFrame.Parent = page
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = sliderFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(30, 30, 30)
	stroke.Transparency = 0.6
	stroke.Parent = sliderFrame
	
	local mTitle, sTitle = createShadowText(sliderFrame, UDim2.new(0.6, 0, 0, 20), UDim2.new(0, 10, 0, 4), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "SliderTitle")
	mTitle.Text = text
	mTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	
	local mVal, sVal = createShadowText(sliderFrame, UDim2.new(0.35, 0, 0, 20), UDim2.new(1, -110, 0, 4), Enum.Font.Code, 13, Enum.TextXAlignment.Right, "SliderValue")
	mVal.Text = tostring(default)
	mVal.TextColor3 = currentAccentColor
	
	local sliderBar = Instance.new("TextButton")
	sliderBar.Name = "SliderBar"
	sliderBar.Size = UDim2.new(1, -20, 0, 6)
	sliderBar.Position = UDim2.new(0, 10, 0, 28)
	sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	sliderBar.BackgroundTransparency = 0.6
	sliderBar.Text = ""
	sliderBar.ZIndex = 2
	sliderBar.Parent = sliderFrame
	
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 3)
	barCorner.Parent = sliderBar
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "SliderFill"
	sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = currentAccentColor
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 2
	sliderFill.Parent = sliderBar
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = sliderFill
	
	local value = default
	local isDragging = false
	
	local function updateSliderPosition(inputPosition)
		local barAbsPos = sliderBar.AbsolutePosition.X
		local barAbsSize = sliderBar.AbsoluteSize.X
		local percentage = math.clamp((inputPosition - barAbsPos) / barAbsSize, 0, 1)
		sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		
		value = math.floor(min + (max - min) * percentage)
		mVal.Text = tostring(value)
		if callback then callback(value) end
	end
	
	sliderBar.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and MainFrame.BackgroundTransparency <= 0.5 then
			isDragging = true
			updateSliderPosition(input.Position.X)
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSliderPosition(input.Position.X)
		end
	end)
	
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)
	
	sliderFrame.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
	end)
	sliderFrame.MouseLeave:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
	end)
end

function TabClass:CreateInput(config)
	config = config or {}
	local text = config.Name or "输入框"
	local placeholder = config.Placeholder or "请输入内容..."
	local callback = config.Callback
	local page = self.page
	
	local inputFrame = Instance.new("Frame")
	inputFrame.Size = UDim2.new(1, 0, 0, 36)
	inputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	inputFrame.BackgroundTransparency = 0.4
	inputFrame.ZIndex = 2
	inputFrame.Parent = page
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = inputFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(30, 30, 30)
	stroke.Transparency = 0.6
	stroke.Parent = inputFrame
	
	local mTitle, sTitle = createShadowText(inputFrame, UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 10, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "InputTitle")
	mTitle.Text = text
	mTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.55, 0, 0, 24)
	box.Position = UDim2.new(1, -10, 0, 6)
	box.AnchorPoint = Vector2.new(1, 0)
	box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	box.BackgroundTransparency = 0.5
	box.Text = ""
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
	box.TextColor3 = currentAccentColor
	box.Font = Enum.Font.Code
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.ZIndex = 2
	box.Parent = inputFrame
	
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 4)
	boxCorner.Parent = box
	
	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = 1
	boxStroke.Color = Color3.fromRGB(40, 40, 40)
	boxStroke.Transparency = 0.5
	boxStroke.Parent = box
	
	box.FocusLost:Connect(function(enterPressed)
		if MainFrame.BackgroundTransparency > 0.5 then return end
		if callback then callback(box.Text, enterPressed) end
	end)
	
	inputFrame.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
		TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = currentAccentColor}):Play()
	end)
	inputFrame.MouseLeave:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
		TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
	end)
end

function TabClass:CreateDropdown(config)
	config = config or {}
	local text = config.Name or "下拉菜单"
	local options = config.Options or {}
	local default = config.Default or ""
	local callback = config.Callback
	local page = self.page
	
	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Size = UDim2.new(1, 0, 0, 36)
	dropdownFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	dropdownFrame.BackgroundTransparency = 0.4
	dropdownFrame.ClipsDescendants = true
	dropdownFrame.ZIndex = 2
	dropdownFrame.Parent = page
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = dropdownFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(30, 30, 30)
	stroke.Transparency = 0.6
	stroke.Parent = dropdownFrame
	
	local headerBtn = Instance.new("TextButton")
	headerBtn.Size = UDim2.new(1, 0, 0, 36)
	headerBtn.BackgroundTransparency = 1
	headerBtn.Text = ""
	headerBtn.ZIndex = 2
	headerBtn.Parent = dropdownFrame
	
	local mTitle, sTitle = createShadowText(headerBtn, UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 10, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "DropdownTitle")
	mTitle.Text = text
	mTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	
	local mSelected, sSelected = createShadowText(headerBtn, UDim2.new(0.45, 0, 1, 0), UDim2.new(1, -25, 0, 0), Enum.Font.Code, 12, Enum.TextXAlignment.Right, "DropdownSelected")
	mSelected.Text = default ~= "" and default or "请选择..."
	mSelected.TextColor3 = currentAccentColor
	
	local mArrow, sArrow = createShadowText(headerBtn, UDim2.new(0, 15, 1, 0), UDim2.new(1, -20, 0, 0), Enum.Font.Code, 12, Enum.TextXAlignment.Center, "DropdownArrow")
	mArrow.Text = "v"
	mArrow.TextColor3 = Color3.fromRGB(120, 120, 120)
	
	local listContainer = Instance.new("Frame")
	listContainer.Size = UDim2.new(1, -10, 1, -40)
	listContainer.Position = UDim2.new(0, 5, 0, 38)
	listContainer.BackgroundTransparency = 1
	listContainer.ZIndex = 2
	listContainer.Parent = dropdownFrame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = listContainer
	
	local isOpen = false
	
	local function layoutItems()
		local count = 0
		for _, v in ipairs(listContainer:GetChildren()) do
			if v:IsA("TextButton") then count = count + 1 end
		end
		if isOpen then
			dropdownFrame.Size = UDim2.new(1, 0, 0, 38 + (count * 26) + 4)
		else
			dropdownFrame.Size = UDim2.new(1, 0, 0, 36)
		end
		page.CanvasSize = UDim2.new(0, 0, 0, page:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 20)
	end
	
	for i, opt in ipairs(options) do
		local itemBtn = Instance.new("TextButton")
		itemBtn.Size = UDim2.new(1, 0, 0, 24)
		itemBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		itemBtn.BackgroundTransparency = 0.5
		itemBtn.Text = ""
		itemBtn.ZIndex = 2
		itemBtn.Parent = listContainer
		
		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 3)
		itemCorner.Parent = itemBtn
		
		local mItem, sItem = createShadowText(itemBtn, UDim2.new(1, 0, 1, 0), UDim2.new(0, 10, 0, 0), Enum.Font.Code, 12, Enum.TextXAlignment.Left, "DropdownItem")
		mItem.Text = tostring(opt)
		mItem.TextColor3 = Color3.fromRGB(160, 160, 160)
		
		itemBtn.MouseEnter:Connect(function()
			if MainFrame.BackgroundTransparency > 0.5 then return end
			TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), BackgroundTransparency = 0.3}):Play()
			TweenService:Create(mItem, TweenInfo.new(0.15), {TextColor3 = currentAccentColor}):Play()
		end)
		itemBtn.MouseLeave:Connect(function()
			TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), BackgroundTransparency = 0.5}):Play()
			TweenService:Create(mItem, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
		end)
		itemBtn.MouseButton1Click:Connect(function()
			if MainFrame.BackgroundTransparency > 0.5 then return end
			mSelected.Text = tostring(opt)
			isOpen = false
			mArrow.Text = "v"
			layoutItems()
			if callback then callback(opt) end
		end)
	end
	
	headerBtn.MouseButton1Click:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		isOpen = not isOpen
		mArrow.Text = isOpen and "^" or "v"
		TweenService:Create(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = isOpen and UDim2.new(1, 0, 0, 38 + (#options * 26) + 4) or UDim2.new(1, 0, 0, 36)
		}):Play()
		task.delay(0.05, function()
			page.CanvasSize = UDim2.new(0, 0, 0, page:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 20)
		end)
	end)
	
	dropdownFrame.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
	end)
	dropdownFrame.MouseLeave:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
	end)
end

function TabClass:CreateKeybind(config)
	config = config or {}
	local text = config.Name or "快捷键"
	local default = config.Default or Enum.KeyCode.E
	local callback = config.Callback
	local page = self.page
	
	local keybindFrame = Instance.new("Frame")
	keybindFrame.Size = UDim2.new(1, 0, 0, 36)
	keybindFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	keybindFrame.BackgroundTransparency = 0.4
	keybindFrame.ZIndex = 2
	keybindFrame.Parent = page
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = keybindFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(30, 30, 30)
	stroke.Transparency = 0.6
	stroke.Parent = keybindFrame
	
	local mTitle, sTitle = createShadowText(keybindFrame, UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 10, 0, 0), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "KeybindTitle")
	mTitle.Text = text
	mTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	
	local bindBtn = Instance.new("TextButton")
	bindBtn.Size = UDim2.new(0, 70, 0, 24)
	bindBtn.Position = UDim2.new(1, -10, 0, 6)
	bindBtn.AnchorPoint = Vector2.new(1, 0)
	bindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	bindBtn.BackgroundTransparency = 0.3
	bindBtn.Text = ""
	bindBtn.ZIndex = 2
	bindBtn.Parent = keybindFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = bindBtn
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1
	btnStroke.Color = Color3.fromRGB(50, 50, 50)
	btnStroke.Parent = bindBtn
	
	local mKey, sKey = createShadowText(bindBtn, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Code, 11, Enum.TextXAlignment.Center, "KeyLabel")
	mKey.Text = "[" .. default.Name .. "]"
	mKey.TextColor3 = currentAccentColor
	
	local currentKey = default
	local isBinding = false
	
	bindBtn.MouseButton1Click:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		isBinding = true
		mKey.Text = "[...]"
		mKey.TextColor3 = Color3.fromRGB(255, 150, 0)
	end)
	
	UIS.InputBegan:Connect(function(input, gameProcessed)
		if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
			isBinding = false
			currentKey = input.KeyCode
			mKey.Text = "[" .. currentKey.Name .. "]"
			mKey.TextColor3 = currentAccentColor
			if callback then callback(currentKey) end
		elseif not gameProcessed and input.KeyCode == currentKey then
			if callback then callback(currentKey) end
		end
	end)
	
	keybindFrame.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
	end)
	keybindFrame.MouseLeave:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
	end)
end

function TabClass:CreateParagraph(config)
	config = config or {}
	local titleText = config.Title or "段落标题"
	local descText = config.Desc or "这里是静态文本内容"
	local page = self.page
	
	local paraFrame = Instance.new("Frame")
	paraFrame.Size = UDim2.new(1, 0, 0, 50)
	paraFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	paraFrame.BackgroundTransparency = 0.4
	paraFrame.ZIndex = 2
	paraFrame.Parent = page
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = paraFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(30, 30, 30)
	stroke.Transparency = 0.6
	stroke.Parent = paraFrame
	
	local mTitle, sTitle = createShadowText(paraFrame, UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 5), Enum.Font.Code, 13, Enum.TextXAlignment.Left, "ParaTitle")
	mTitle.Text = titleText
	mTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	
	local mDesc, sDesc = createShadowText(paraFrame, UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 23), Enum.Font.Code, 11, Enum.TextXAlignment.Left, "ParaDesc")
	mDesc.Text = descText
	mDesc.TextColor3 = Color3.fromRGB(130, 130, 130)
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Font = Enum.Font.Code
	textLabel.TextSize = 11
	textLabel.Text = descText
	local height = math.max(50, textLabel.TextBounds.Y + 32)
	paraFrame.Size = UDim2.new(1, 0, 0, height)
	mDesc.Size = UDim2.new(1, -20, 0, textLabel.TextBounds.Y)
	textLabel:Destroy()
	
	paraFrame.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
	end)
	paraFrame.MouseLeave:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
	end)
end

function TabClass:CreateImage(config)
	config = config or {}
	local imgAsset = config.Image or ""
	local sizeY = config.SizeY or 120
	local page = self.page
	
	local imgFrame = Instance.new("Frame")
	imgFrame.Size = UDim2.new(1, 0, 0, sizeY)
	imgFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	imgFrame.BackgroundTransparency = 0.4
	imgFrame.ZIndex = 2
	imgFrame.Parent = page
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = imgFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(30, 30, 30)
	stroke.Transparency = 0.6
	stroke.Parent = imgFrame
	
	local imgLabel = Instance.new("ImageLabel")
	imgLabel.Size = UDim2.new(1, -10, 1, -10)
	imgLabel.Position = UDim2.new(0, 5, 0, 5)
	imgLabel.BackgroundTransparency = 1
	imgLabel.Image = imgAsset
	imgLabel.ScaleType = Enum.ScaleType.Fit
	imgLabel.ZIndex = 2
	imgLabel.Parent = imgFrame
	
	if string.match(imgAsset, "^http") then
		local fileName = "hmou_img_" .. string.sub(HttpService:GenerateGUID(false), 1, 8) .. ".png"
		task.spawn(function()
			local success, response = pcall(function() return game:HttpGet(imgAsset) end)
			if success and response then
				pcall(function() writefile(fileName, response) end)
				imgLabel.Image = getcustomasset(fileName)
			end
		end)
	end
	
	imgFrame.MouseEnter:Connect(function()
		if MainFrame.BackgroundTransparency > 0.5 then return end
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = currentAccentColor, Transparency = 0}):Play()
	end)
	imgFrame.MouseLeave:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30), Transparency = 0.6}):Play()
	end)
end

function TabClass:CreateDivider()
	local page = self.page
	
	local divFrame = Instance.new("Frame")
	divFrame.Size = UDim2.new(1, 0, 0, 8)
	divFrame.BackgroundTransparency = 1
	divFrame.ZIndex = 2
	divFrame.Parent = page
	
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 0.5, 0)
	line.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	line.BorderSizePixel = 0
	line.ZIndex = 2
	line.Parent = divFrame
end

function TabClass:CreateSection(config)
	config = config or {}
	local titleText = config.Name or "分块区域"
	local page = self.page
	
	local sectionFrame = Instance.new("Frame")
	sectionFrame.Size = UDim2.new(1, 0, 0, 32)
	sectionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	sectionFrame.BackgroundTransparency = 0.5
	sectionFrame.ZIndex = 2
	sectionFrame.Parent = page
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = sectionFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(45, 45, 45)
	stroke.Transparency = 0.5
	stroke.Parent = sectionFrame
	
	local mText, sText = createShadowText(sectionFrame, UDim2.new(1, -20, 1, 0), UDim2.new(0, 10, 0, 0), Enum.Font.Code, 12, Enum.TextXAlignment.Left, "SectionText")
	mText.Text = "// " .. string.upper(titleText)
	mText.TextColor3 = currentAccentColor
	
	local sectionObj = setmetatable({}, {__index = self})
	sectionObj.page = page
	return sectionObj
end

return HMOU_UI
