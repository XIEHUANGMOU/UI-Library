local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HMOU_WindUI_Core"
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
MainFrame.Size = UDim2.new(0, 560, 0, 380)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 0.15
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainBorder = Instance.new("UIStroke")
MainBorder.Thickness = 1
MainBorder.Color = Color3.fromRGB(0, 255, 100)
MainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainBorder.Transparency = 0.2
MainBorder.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.BackgroundTransparency = 0.3
TopBar.ZIndex = 2
TopBar.Parent = MainFrame

local TopBorder = Instance.new("Frame")
TopBorder.Size = UDim2.new(1, 0, 0, 1)
TopBorder.Position = UDim2.new(0, 0, 1, -1)
TopBorder.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
TopBorder.BorderSizePixel = 0
TopBorder.BackgroundTransparency = 0.5
TopBorder.Parent = TopBar

local HeaderContainer = Instance.new("Frame")
HeaderContainer.Name = "HeaderContainer"
HeaderContainer.Position = UDim2.new(0, 15, 0, 12)
HeaderContainer.Size = UDim2.new(1, -120, 0, 22)
HeaderContainer.BackgroundTransparency = 1
HeaderContainer.ZIndex = 2
HeaderContainer.Parent = TopBar

local HeaderLayout = Instance.new("UIListLayout")
HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
HeaderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
HeaderLayout.Padding = UDim.new(0, 8)
HeaderLayout.Parent = HeaderContainer

local function createShadowText(parent, size, position, font, textSize, alignment, name)
	local shadow = Instance.new("TextLabel")
	shadow.Name = name .. "_Shadow"
	shadow.Size = size
	shadow.Position = position + UDim2.new(0, 1, 0, 1)
	shadow.BackgroundTransparency = 1
	shadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	shadow.TextSize = textSize
	shadow.TextTransparency = 0.5
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
	main.TextTransparency = 0
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

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 45)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = ""
CloseBtn.ZIndex = 2
CloseBtn.Parent = TopBar
local CloseLabel, CloseShadow = createShadowText(CloseBtn, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Code, 14, Enum.TextXAlignment.Center, "Close")
CloseLabel.Text = "[X]"

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BorderSizePixel = 0
Sidebar.BackgroundTransparency = 0.25
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame

local SidebarBorder = Instance.new("Frame")
SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
SidebarBorder.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
SidebarBorder.BorderSizePixel = 0
SidebarBorder.BackgroundTransparency = 0.5
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
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabContainer

local PageContainer = Instance.new("Frame")
PageContainer.Position = UDim2.new(0, 140, 0, 45)
PageContainer.Size = UDim2.new(1, -140, 1, -45)
PageContainer.BackgroundTransparency = 1
PageContainer.ZIndex = 2
PageContainer.Parent = MainFrame

do
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

local currentAccentColor = Color3.fromRGB(0, 255, 100)

local HMOU_UI = {}
HMOU_UI.__index = HMOU_UI

local WindowClass = {}
WindowClass.__index = WindowClass

local TabClass = {}
TabClass.__index = TabClass

local SectionClass = {}
SectionClass.__index = SectionClass

function HMOU_UI:CreateWindow(config)
	config = config or {}
	Title.Text = config.Title or "WindUI"
	if config.AccentColor then
		currentAccentColor = config.AccentColor
		MainBorder.Color = currentAccentColor
		TopBorder.BackgroundColor3 = currentAccentColor
		SidebarBorder.BackgroundColor3 = currentAccentColor
		Title.TextColor3 = currentAccentColor
		CloseLabel.TextColor3 = currentAccentColor
	end
	local windowInstance = setmetatable({}, WindowClass)
	windowInstance.tabs = {}
	windowInstance.pages = {}
	return windowInstance
end

function WindowClass:CreateTag(config)
	config = config or {}
	local text = config.Text or "Tag"
	local color = config.Color or currentAccentColor
	local isFilled = (config.Style == "Filled")
	
	local tagFrame = Instance.new("Frame")
	tagFrame.Name = "Tag_" .. text
	tagFrame.ZIndex = 2
	
	local tagCorner = Instance.new("UICorner")
	tagCorner.CornerRadius = UDim.new(0, 4)
	tagCorner.Parent = tagFrame
	
	if isFilled then
		tagFrame.BackgroundColor3 = color
		tagFrame.BackgroundTransparency = 0.2
	else
		tagFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		tagFrame.BackgroundTransparency = 0.5
		local tagStroke = Instance.new("UIStroke")
		tagStroke.Thickness = 1
		tagStroke.Color = color
		tagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		tagStroke.Parent = tagFrame
	end
	
	local textColor = isFilled and Color3.fromRGB(10, 10, 10) or color
	local mLabel = Instance.new("TextLabel")
	mLabel.Size = UDim2.new(1, 0, 1, 0)
	mLabel.BackgroundTransparency = 1
	mLabel.TextColor3 = textColor
	mLabel.TextSize = 10
	mLabel.Font = Enum.Font.Code
	mLabel.TextXAlignment = Enum.TextXAlignment.Center
	mLabel.Text = text
	mLabel.ZIndex = 3
	mLabel.Parent = tagFrame
	
	tagFrame.Parent = TagListContainer
	
	local tempText = Instance.new("TextLabel")
	tempText.Font = Enum.Font.Code
	tempText.TextSize = 10
	tempText.Text = text
	local textWidth = tempText.TextBounds.X
	tagFrame.Size = UDim2.new(0, textWidth + 10, 0, 16)
	tempText:Destroy()
	
	updateHeaderLayoutSize()
	
	local tagObj = {}
	function tagObj:SetText(newText)
		mLabel.Text = newText
		local temp = Instance.new("TextLabel")
		temp.Font = Enum.Font.Code
		temp.TextSize = 10
		temp.Text = newText
		tagFrame.Size = UDim2.new(0, temp.TextBounds.X + 10, 0, 16)
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
	local name = config.Name or "Tab"
	local core = self
	
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -10, 0, 32)
	tabBtn.Position = UDim2.new(0, 5, 0, 0)
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = ""
	tabBtn.ZIndex = 2
	tabBtn.Parent = TabContainer

	local mLabel = Instance.new("TextLabel")
	mLabel.Size = UDim2.new(1, 0, 1, 0)
	mLabel.Position = UDim2.new(0, 8, 0, 0)
	mLabel.BackgroundTransparency = 1
	mLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
	mLabel.TextSize = 12
	mLabel.Font = Enum.Font.SourceSansPro
	mLabel.TextXAlignment = Enum.TextXAlignment.Left
	mLabel.Text = name
	mLabel.ZIndex = 3
	mLabel.Parent = tabBtn

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Visible = false
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = currentAccentColor
	page.ZIndex = 2
	page.Parent = PageContainer

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 8)
	pageLayout.Parent = page
	
	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingTop = UDim.new(0, 12)
	pagePadding.PaddingLeft = UDim.new(0, 12)
	pagePadding.PaddingRight = UDim.new(0, 12)
	pagePadding.Parent = page

	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 25)
	end)

	tabBtn.MouseButton1Click:Connect(function()
		for _, t in ipairs(core.tabs) do
			local label = t:FindFirstChildOfClass("TextLabel")
			if label then label.TextColor3 = Color3.fromRGB(160, 160, 160) end
		end
		for _, p in ipairs(core.pages) do p.Visible = false end
		mLabel.TextColor3 = currentAccentColor
		page.Visible = true
	end)

	table.insert(core.tabs, tabBtn)
	table.insert(core.pages, page)

	if #core.tabs == 1 then
		mLabel.TextColor3 = currentAccentColor
		page.Visible = true
	end

	local tabInstance = setmetatable({}, TabClass)
	tabInstance.page = page
	return tabInstance
end

local function createStandardContainer(parent, height, title, desc)
	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, height)
	box.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	box.BackgroundTransparency = 0.3
	box.BorderSizePixel = 0
	box.Parent = parent

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = box

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = 1
	boxStroke.Color = Color3.fromRGB(40, 40, 40)
	boxStroke.Transparency = 0.5
	boxStroke.Parent = box

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -100, 0, 18)
	titleLabel.Position = desc and UDim2.new(0, 12, 0, 6) or UDim2.new(0, 12, 0.5, -9)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	titleLabel.TextSize = 13
	titleLabel.Font = Enum.Font.SourceSansPro
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = title
	titleLabel.Parent = box

	if desc then
		local descLabel = Instance.new("TextLabel")
		descLabel.Size = UDim2.new(1, -100, 0, 14)
		descLabel.Position = UDim2.new(0, 12, 0, 24)
		descLabel.BackgroundTransparency = 1
		descLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
		descLabel.TextSize = 11
		descLabel.Font = Enum.Font.SourceSansPro
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.Text = desc
		descLabel.Parent = box
	end

	return box, boxStroke
end

function TabClass:CreateButton(config)
	config = config or {}
	local title = config.Name or "Button"
	local callback = config.Callback
	
	local box, stroke = createStandardContainer(self.page, 40, title, nil)
	
	local clickBtn = Instance.new("TextButton")
	clickBtn.Size = UDim2.new(1, 0, 1, 0)
	clickBtn.BackgroundTransparency = 1
	clickBtn.Text = ""
	clickBtn.Parent = box
	
	clickBtn.MouseEnter:Connect(function()
		stroke.Color = currentAccentColor
	end)
	clickBtn.MouseLeave:Connect(function()
		stroke.Color = Color3.fromRGB(40, 40, 40)
	end)
	clickBtn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

function TabClass:CreateToggle(config)
	config = config or {}
	local title = config.Name or "Toggle"
	local state = config.Default or false
	local callback = config.Callback
	
	local box, stroke = createStandardContainer(self.page, 40, title, nil)
	
	local clickBtn = Instance.new("TextButton")
	clickBtn.Size = UDim2.new(1, 0, 1, 0)
	clickBtn.BackgroundTransparency = 1
	clickBtn.Text = ""
	clickBtn.Parent = box

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(0, 60, 1, 0)
	statusLabel.Position = UDim2.new(1, -70, 0, 0)
	statusLabel.BackgroundTransparency = 1
	statusLabel.TextSize = 12
	statusLabel.Font = Enum.Font.Code
	statusLabel.TextXAlignment = Enum.TextXAlignment.Right
	statusLabel.Text = state and "[开启]" or "[关闭]"
	statusLabel.TextColor3 = state and currentAccentColor or Color3.fromRGB(240, 70, 70)
	statusLabel.Parent = box

	clickBtn.MouseEnter:Connect(function() stroke.Color = currentAccentColor end)
	clickBtn.MouseLeave:Connect(function() stroke.Color = Color3.fromRGB(40, 40, 40) end)
	
	clickBtn.MouseButton1Click:Connect(function()
		state = not state
		statusLabel.Text = state and "[开启]" or "[关闭]"
		statusLabel.TextColor3 = state and currentAccentColor or Color3.fromRGB(240, 70, 70)
		if callback then callback(state) end
	end)
end

function TabClass:CreateParagraph(config)
	config = config or {}
	local title = config.Title or "Paragraph"
	local desc = config.Desc or ""
	
	local box = Instance.new("Frame")
	box.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	box.BackgroundTransparency = 0.4
	box.BorderSizePixel = 0
	box.Parent = self.page

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = box

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = 1
	boxStroke.Color = config.Color or Color3.fromRGB(45, 45, 45)
	boxStroke.Transparency = 0.5
	boxStroke.Parent = box

	local tLabel = Instance.new("TextLabel")
	tLabel.Size = UDim2.new(1, -24, 0, 20)
	tLabel.Position = UDim2.new(0, 12, 0, 8)
	tLabel.BackgroundTransparency = 1
	tLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	tLabel.TextSize = 13
	tLabel.Font = Enum.Font.SourceSansProFrame
	tLabel.TextXAlignment = Enum.TextXAlignment.Left
	tLabel.Text = title
	tLabel.Parent = box

	local dLabel = Instance.new("TextLabel")
	dLabel.BackgroundTransparency = 1
	dLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	dLabel.TextSize = 12
	dLabel.Font = Enum.Font.SourceSansPro
	dLabel.TextXAlignment = Enum.TextXAlignment.Left
	dLabel.TextWrapped = true
	dLabel.Text = desc
	dLabel.Parent = box

	local function layout()
		local maxWidth = MainFrame.Size.X.Offset - 140 - 24 - 24
		local fixedSize = TextService:GetTextSize(desc, 12, Enum.Font.SourceSansPro, Vector2.new(maxWidth, 9999))
		dLabel.Position = UDim2.new(0, 12, 0, 30)
		dLabel.Size = UDim2.new(1, -24, 0, fixedSize.Y)
		box.Size = UDim2.new(1, 0, 0, 38 + fixedSize.Y)
	end
	layout()
	box:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)
end

function TabClass:CreateDivider()
	local divFrame = Instance.new("Frame")
	divFrame.Size = UDim2.new(1, 0, 0, 8)
	divFrame.BackgroundTransparency = 1
	divFrame.Parent = self.page
	
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 0.5, 0)
	line.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	line.BorderSizePixel = 0
	line.Parent = divFrame
end

function TabClass:CreateKeybind(config)
	config = config or {}
	local title = config.Title or "Keybind"
	local defaultKey = config.Value or "None"
	local callback = config.Callback
	local currentKey = defaultKey
	
	local box, stroke = createStandardContainer(self.page, 45, title, config.Desc)
	
	local bindBtn = Instance.new("TextButton")
	bindBtn.Size = UDim2.new(0, 70, 0, 24)
	bindBtn.Position = UDim2.new(1, -82, 0.5, -12)
	bindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	bindBtn.TextColor3 = currentAccentColor
	bindBtn.TextSize = 12
	bindBtn.Font = Enum.Font.Code
	bindBtn.Text = "[" .. currentKey .. "]"
	bindBtn.Parent = box
	
	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 4)
	bCorner.Parent = bindBtn
	
	local isListening = false
	
	bindBtn.MouseButton1Click:Connect(function()
		isListening = true
		bindBtn.Text = "[...]"
	end)
	
	UIS.InputBegan:Connect(function(input, processed)
		if isListening and not processed then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				isListening = false
				currentKey = input.KeyCode.Name
				bindBtn.Text = "[" .. currentKey .. "]"
				if callback then callback(input.KeyCode) end
			end
		end
	end)
end

function TabClass:CreateDropdown(config)
	config = config or {}
	local title = config.Title or "Dropdown"
	local items = config.Values or {}
	local callback = config.Callback
	local isMulti = config.Multi or false
	local selectedList = {}
	
	if not isMulti then
		selectedList[config.Value or items[1] or ""] = true
	end

	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, 45)
	box.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	box.BackgroundTransparency = 0.3
	box.BorderSizePixel = 0
	box.ClipsDescendants = true
	box.Parent = self.page

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = box

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = 1
	boxStroke.Color = Color3.fromRGB(40, 40, 40)
	boxStroke.Transparency = 0.5
	boxStroke.Parent = box

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -100, 0, 20)
	titleLabel.Position = UDim2.new(0, 12, 0, 12)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	titleLabel.TextSize = 13
	titleLabel.Font = Enum.Font.SourceSansPro
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = title
	titleLabel.Parent = box

	local triggerBtn = Instance.new("TextButton")
	triggerBtn.Size = UDim2.new(1, 0, 0, 45)
	triggerBtn.BackgroundTransparency = 1
	triggerBtn.Text = ""
	triggerBtn.Parent = box

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 30, 0, 45)
	arrow.Position = UDim2.new(1, -35, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.TextColor3 = Color3.fromRGB(160, 160, 160)
	arrow.TextSize = 12
	arrow.Font = Enum.Font.Code
	arrow.Text = "V"
	arrow.Parent = box

	local listContainer = Instance.new("Frame")
	listContainer.Position = UDim2.new(0, 10, 0, 45)
	listContainer.Size = UDim2.new(1, -20, 0, 0)
	listContainer.BackgroundTransparency = 1
	listContainer.Parent = box

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 3)
	listLayout.Parent = listContainer

	local isOpen = false

	local function refreshItems()
		for _, child in ipairs(listContainer:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		for _, v in ipairs(items) do
			local itemBtn = Instance.new("TextButton")
			itemBtn.Size = UDim2.new(1, 0, 0, 28)
			itemBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
			itemBtn.BackgroundTransparency = 0.3
			itemBtn.TextColor3 = selectedList[v] and currentAccentColor or Color3.fromRGB(200, 200, 200)
			itemBtn.TextSize = 12
			itemBtn.Font = Enum.Font.SourceSansPro
			itemBtn.TextXAlignment = Enum.TextXAlignment.Left
			itemBtn.Text = "   " .. tostring(v)
			itemBtn.Parent = listContainer
			
			local iCorner = Instance.new("UICorner")
			iCorner.CornerRadius = UDim.new(0, 4)
			iCorner.Parent = itemBtn

			itemBtn.MouseButton1Click:Connect(function()
				if isMulti then
					selectedList[v] = not selectedList[v]
					itemBtn.TextColor3 = selectedList[v] and currentAccentColor or Color3.fromRGB(200, 200, 200)
					if callback then
						local results = {}
						for k, active in pairs(selectedList) do if active then table.insert(results, k) end end
						callback(results)
					end
				else
					selectedList = {}
					selectedList[v] = true
					isOpen = false
					TweenService:Create(box, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 45)}):Play()
					arrow.Text = "V"
					if callback then callback(v) end
				end
			end)
		end
	end

	triggerBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			refreshItems()
			local targetHeight = 45 + listLayout.AbsoluteContentSize.Y + 10
			TweenService:Create(box, TweenInfo.new(0.25, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
			arrow.Text = "^"
		else
			TweenService:Create(box, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, 0, 0, 45)}):Play()
			arrow.Text = "V"
		end
	end)
end

function TabClass:CreateInput(config)
	config = config or {}
	local title = config.Title or "Input"
	local callback = config.Callback
	
	local box, stroke = createStandardContainer(self.page, 45, title, nil)
	
	local boxContainer = Instance.new("Frame")
	boxContainer.Size = UDim2.new(0, 140, 0, 26)
	boxContainer.Position = UDim2.new(1, -152, 0.5, -13)
	boxContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	boxContainer.Parent = box

	local bcCorner = Instance.new("UICorner")
	bcCorner.CornerRadius = UDim.new(0, 4)
	bcCorner.Parent = boxContainer

	local bcStroke = Instance.new("UIStroke")
	bcStroke.Thickness = 1
	bcStroke.Color = Color3.fromRGB(50, 50, 50)
	bcStroke.Parent = boxContainer

	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(1, -10, 1, 0)
	textBox.Position = UDim2.new(0, 5, 0, 0)
	textBox.BackgroundTransparency = 1
	textBox.TextColor3 = Color3.fromRGB(240, 240, 240)
	textBox.TextSize = 12
	textBox.Font = Enum.Font.SourceSansPro
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.ClearTextOnFocus = false
	textBox.Text = ""
	textBox.PlaceholderText = "输入数据..."
	textBox.Parent = boxContainer

	textBox.Focused:Connect(function() bcStroke.Color = currentAccentColor end)
	textBox.FocusLost:Connect(function()
		bcStroke.Color = Color3.fromRGB(50, 50, 50)
		if callback then callback(textBox.Text) end
	end)
end

function TabClass:CreateSlider(config)
	config = config or {}
	local title = config.Title or "Slider"
	local min = config.Value and config.Value.Min or 0
	local max = config.Value and config.Value.Max or 100
	local default = config.Value and config.Value.Default or min
	local callback = config.Callback
	local currentVal = default
	
	local box, stroke = createStandardContainer(self.page, 50, title, nil)
	
	local valLabel = Instance.new("TextLabel")
	valLabel.Size = UDim2.new(0, 50, 0, 20)
	valLabel.Position = UDim2.new(1, -62, 0, 6)
	valLabel.BackgroundTransparency = 1
	valLabel.TextColor3 = currentAccentColor
	valLabel.TextSize = 12
	valLabel.Font = Enum.Font.Code
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.Text = tostring(currentVal)
	valLabel.Parent = box

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(1, -24, 0, 4)
	track.Position = UDim2.new(0, 12, 0, 36)
	track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	track.BorderSizePixel = 0
	track.Text = ""
	track.Parent = box

	local progress = Instance.new("Frame")
	progress.Size = UDim2.new((currentVal - min)/(max - min), 0, 1, 0)
	progress.BackgroundColor3 = currentAccentColor
	progress.BorderSizePixel = 0
	progress.Parent = track

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 10, 0, 10)
	knob.Position = UDim2.new(1, -5, 0.5, -5)
	knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	knob.BorderSizePixel = 0
	knob.Parent = progress
	
	local kCorner = Instance.new("UICorner")
	kCorner.CornerRadius = UDim.new(1, 0)
	kCorner.Parent = knob

	local isDragging = false
	
	local function updateSlider(input)
		local ratio = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteWidth, 0, 1)
		currentVal = math.floor(min + (max - min) * ratio)
		valLabel.Text = tostring(currentVal)
		progress.Size = UDim2.new(ratio, 0, 1, 0)
		if callback then callback(currentVal) end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			updateSlider(input)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)
end

function TabClass:CreateSection(config)
	config = config or {}
	local title = config.Title or "Section"
	
	local sectionBox = Instance.new("Frame")
	sectionBox.Size = UDim2.new(1, 0, 0, 35)
	sectionBox.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	sectionBox.BackgroundTransparency = 0.5
	sectionBox.BorderSizePixel = 0
	sectionBox.ClipsDescendants = true
	sectionBox.Parent = self.page

	local sCorner = Instance.new("UICorner")
	sCorner.CornerRadius = UDim.new(0, 6)
	sCorner.Parent = sectionBox

	local sStroke = Instance.new("UIStroke")
	sStroke.Thickness = 1
	sStroke.Color = Color3.fromRGB(45, 45, 45)
	sStroke.Transparency = 0.6
	sStroke.Parent = sectionBox

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -100, 0, 35)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	titleLabel.TextSize = 13
	titleLabel.Font = Enum.Font.SourceSansProBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = title
	titleLabel.Parent = sectionBox

	local toggleArrow = Instance.new("TextButton")
	toggleArrow.Size = UDim2.new(0, 40, 0, 35)
	toggleArrow.Position = UDim2.new(1, -40, 0, 0)
	toggleArrow.BackgroundTransparency = 1
	toggleArrow.TextColor3 = Color3.fromRGB(160, 160, 160)
	toggleArrow.TextSize = 12
	toggleArrow.Font = Enum.Font.Code
	toggleArrow.Text = "^"
	toggleArrow.Parent = sectionBox

	local contentContainer = Instance.new("Frame")
	contentContainer.Position = UDim2.new(0, 8, 0, 35)
	contentContainer.Size = UDim2.new(1, -16, 0, 0)
	contentContainer.BackgroundTransparency = 1
	contentContainer.Parent = sectionBox

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 6)
	contentLayout.Parent = contentContainer

	local isOpen = true

	local function updateSectionHeight()
		if isOpen then
			local h = 35 + contentLayout.AbsoluteContentSize.Y + 8
			sectionBox.Size = UDim2.new(1, 0, 0, h)
		else
			sectionBox.Size = UDim2.new(1, 0, 0, 35)
		end
	end

	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionHeight)

	toggleArrow.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		toggleArrow.Text = isOpen and "^" or "V"
		TweenService:Create(sectionBox, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {
			Size = isOpen and UDim2.new(1, 0, 0, 35 + contentLayout.AbsoluteContentSize.Y + 8) or UDim2.new(1, 0, 0, 35)
		}):Play()
	end)

	local sectionInstance = setmetatable({}, SectionClass)
	sectionInstance.page = contentContainer
	return sectionInstance
end

function SectionClass:CreateButton(config) TabClass.CreateButton(self, config) end
function SectionClass:CreateToggle(config) TabClass.CreateToggle(self, config) end

function TabClass:CreateImage(config)
	config = config or {}
	local assetUrl = config.Image or ""
	local radius = config.Radius or 6
	
	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, 150)
	box.BackgroundTransparency = 1
	box.Parent = self.page

	local imgLabel = Instance.new("ImageLabel")
	imgLabel.Size = UDim2.new(1, 0, 1, 0)
	imgLabel.BackgroundTransparency = 1
	imgLabel.Image = assetUrl
	imgLabel.ScaleType = Enum.ScaleType.Crop
	imgLabel.Parent = box

	local iCorner = Instance.new("UICorner")
	iCorner.CornerRadius = UDim.new(0, radius)
	iCorner.Parent = imgLabel
	
	if config.AspectRatio then
		local ratioConstraint = Instance.new("UIAspectRatioConstraint")
		if config.AspectRatio == "16:9" then
			ratioConstraint.AspectRatio = 16/9
		elseif config.AspectRatio == "1:1" then
			ratioConstraint.AspectRatio = 1
		else
			ratioConstraint.AspectRatio = 4/3
		end
		ratioConstraint.Parent = box
		box.Size = UDim2.new(1, 0, 0, 0)
	end
end

return HMOU_UI
