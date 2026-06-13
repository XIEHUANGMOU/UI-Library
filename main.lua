local CF_UI = {}
CF_UI.__index = CF_UI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local THEME = {
	BG_DEEP     = Color3.fromRGB(8, 8, 10),
	BG_PANEL    = Color3.fromRGB(14, 14, 18),
	BG_TAB      = Color3.fromRGB(18, 18, 24),
	BG_TABSEL   = Color3.fromRGB(26, 26, 34),
	ACCENT      = Color3.fromRGB(0, 220, 120),
	ACCENT_DIM  = Color3.fromRGB(0, 140, 76),
	TEXT_MAIN   = Color3.fromRGB(220, 220, 220),
	TEXT_DIM    = Color3.fromRGB(120, 120, 130),
	TEXT_ACCENT = Color3.fromRGB(0, 255, 140),
	BORDER      = Color3.fromRGB(36, 36, 48),
	TOGGLE_ON   = Color3.fromRGB(0, 210, 110),
	TOGGLE_OFF  = Color3.fromRGB(50, 50, 60),
	SLIDER_BG   = Color3.fromRGB(30, 30, 40),
	SLIDER_FILL = Color3.fromRGB(0, 200, 100),
	BTN_BG      = Color3.fromRGB(22, 22, 30),
	BTN_HOVER   = Color3.fromRGB(0, 180, 90),
	BTN_TEXT    = Color3.fromRGB(200, 200, 200),
	SHADOW      = Color3.fromRGB(0, 0, 0),
}

local function makeTween(obj, props, dur, style, dir)
	style = style or Enum.EasingStyle.Linear
	dir   = dir   or Enum.EasingDirection.Out
	local info = TweenInfo.new(dur, style, dir)
	return TweenService:Create(obj, info, props)
end

local function newFrame(parent, size, pos, bg, zindex)
	local f = Instance.new("Frame")
	f.Size            = size
	f.Position        = pos
	f.BackgroundColor3 = bg
	f.BorderSizePixel = 0
	f.ZIndex          = zindex or 1
	f.Parent          = parent
	return f
end

local function newLabel(parent, text, size, pos, color, fontsize, zindex)
	local l = Instance.new("TextLabel")
	l.Size              = size
	l.Position          = pos
	l.BackgroundTransparency = 1
	l.Text              = text
	l.TextColor3        = color or THEME.TEXT_MAIN
	l.Font              = Enum.Font.Code
	l.TextSize          = fontsize or 14
	l.TextXAlignment    = Enum.TextXAlignment.Left
	l.TextYAlignment    = Enum.TextYAlignment.Center
	l.BorderSizePixel   = 0
	l.ZIndex            = zindex or 2
	l.Parent            = parent
	return l
end

local function newButton(parent, text, size, pos, zindex)
	local b = Instance.new("TextButton")
	b.Size              = size
	b.Position          = pos
	b.BackgroundColor3  = THEME.BTN_BG
	b.BorderSizePixel   = 1
	b.BorderColor3      = THEME.BORDER
	b.Text              = text
	b.TextColor3        = THEME.BTN_TEXT
	b.Font              = Enum.Font.Code
	b.TextSize          = 13
	b.AutoButtonColor   = false
	b.ZIndex            = zindex or 2
	b.Parent            = parent
	return b
end

local function addBorder(frame, color, thickness)
	local ui = Instance.new("UIStroke")
	ui.Color     = color or THEME.BORDER
	ui.Thickness = thickness or 1
	ui.Parent    = frame
end

local function isDragging(gui)
	local dragging, dragStart, startPos = false, nil, nil
	local titleBar = gui:FindFirstChild("TitleBar")
	if not titleBar then return end

	local function onInputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = input.Position
			startPos  = gui.Position
		end
	end

	local function onInputChanged(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end

	local function onInputEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end

	titleBar.InputBegan:Connect(onInputBegan)
	UserInputService.InputChanged:Connect(onInputChanged)
	UserInputService.InputEnded:Connect(onInputEnded)
end

local function loadBackground(frame, url, cacheFile)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size              = UDim2.new(1, 0, 1, 0)
	imageLabel.Position          = UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.ScaleType         = Enum.ScaleType.Crop
	imageLabel.ZIndex            = 0
	imageLabel.Parent            = frame

	local function tryLoad()
		local data = nil
		local ok = pcall(function()
			if readfile and writefile then
				local cached = pcall(function()
					data = readfile(cacheFile)
				end)
				if not cached or not data or #data == 0 then
					local raw
					if request then
						local res = request({ Url = url, Method = "GET" })
						raw = res.Body
					elseif syn and syn.request then
						local res = syn.request({ Url = url, Method = "GET" })
						raw = res.Body
					else
						raw = game:HttpGet(url)
					end
					writefile(cacheFile, raw)
					data = raw
				end
			end
		end)

		if ok and data then
			if saveinstance then
				local id = "rbxasset://textures/ui/TopBar/chatOff.png"
				imageLabel.Image = id
			end
		end

		if url:match("^rbxassetid://") or url:match("^https?://") then
			imageLabel.Image = url
		end
	end

	pcall(tryLoad)
	return imageLabel
end

function CF_UI.new(config)
	local self = setmetatable({}, CF_UI)

	config = config or {}
	self.Title      = config.Title      or "CF_UI"
	self.BgImage    = config.BgImage    or nil
	self.BgCache    = config.BgCache    or "cf_ui_bg_cache.png"
	self.Width      = config.Width      or 560
	self.Height     = config.Height     or 380
	self.TabWidth   = config.TabWidth   or 130

	self._tabs      = {}
	self._activeTab = nil
	self._minimized = false
	self._open      = true

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name              = "CF_UI_Screen"
	screenGui.ResetOnSpawn      = false
	screenGui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
	screenGui.IgnoreGuiInset    = true
	screenGui.DisplayOrder      = 999
	screenGui.Parent            = (gethui and gethui()) or PlayerGui

	self._screenGui = screenGui

	local mainFrame = newFrame(
		screenGui,
		UDim2.new(0, self.Width, 0, self.Height),
		UDim2.new(0.5, -self.Width / 2, 0.5, -self.Height / 2),
		THEME.BG_DEEP,
		1
	)
	mainFrame.Name = "MainFrame"
	addBorder(mainFrame, THEME.ACCENT, 1)
	self._mainFrame = mainFrame

	mainFrame.BackgroundTransparency = 1
	mainFrame.Size = UDim2.new(0, self.Width * 0.6, 0, self.Height * 0.6)
	local openTween = makeTween(mainFrame, {
		BackgroundTransparency = 0,
		Size = UDim2.new(0, self.Width, 0, self.Height),
		Position = UDim2.new(0.5, -self.Width / 2, 0.5, -self.Height / 2)
	}, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	openTween:Play()

	if self.BgImage then
		loadBackground(mainFrame, self.BgImage, self.BgCache)
	end

	local bgOverlay = newFrame(mainFrame, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), THEME.BG_DEEP, 1)
	bgOverlay.BackgroundTransparency = self.BgImage and 0.55 or 0
	bgOverlay.Name = "BgOverlay"
	self._bgOverlay = bgOverlay

	local titleBar = newFrame(mainFrame, UDim2.new(1, 0, 0, 32), UDim2.new(0, 0, 0, 0), THEME.BG_PANEL, 3)
	titleBar.Name = "TitleBar"
	addBorder(titleBar, THEME.BORDER, 1)

	local accentLine = newFrame(titleBar, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 1, -2), THEME.ACCENT, 4)
	accentLine.Name = "AccentLine"

	local titleLabel = newLabel(
		titleBar,
		"[ " .. self.Title .. " ]",
		UDim2.new(1, -90, 1, 0),
		UDim2.new(0, 12, 0, 0),
		THEME.TEXT_ACCENT,
		14,
		4
	)
	titleLabel.Font = Enum.Font.Code

	local minBtn = newButton(titleBar, "最小化", UDim2.new(0, 52, 0, 20), UDim2.new(1, -82, 0.5, -10), 4)
	minBtn.BackgroundColor3 = THEME.BG_TAB
	addBorder(minBtn, THEME.BORDER, 1)

	local closeBtn = newButton(titleBar, "关闭", UDim2.new(0, 40, 0, 20), UDim2.new(1, -26, 0.5, -10), 4)
	closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
	addBorder(closeBtn, Color3.fromRGB(140, 40, 40), 1)

	self._titleBar = titleBar
	isDragging(mainFrame)

	local tabBar = newFrame(mainFrame, UDim2.new(0, self.TabWidth, 0, self.Height - 32), UDim2.new(0, 0, 0, 32), THEME.BG_TAB, 2)
	tabBar.Name = "TabBar"
	addBorder(tabBar, THEME.BORDER, 1)
	self._tabBar = tabBar

	local tabList = Instance.new("UIListLayout")
	tabList.FillDirection  = Enum.FillDirection.Vertical
	tabList.SortOrder      = Enum.SortOrder.LayoutOrder
	tabList.Padding        = UDim.new(0, 0)
	tabList.Parent         = tabBar

	local container = newFrame(
		mainFrame,
		UDim2.new(0, self.Width - self.TabWidth, 0, self.Height - 32),
		UDim2.new(0, self.TabWidth, 0, 32),
		THEME.BG_PANEL,
		2
	)
	container.Name = "Container"
	addBorder(container, THEME.BORDER, 1)
	self._container = container

	local minimizedFrame = newFrame(
		screenGui,
		UDim2.new(0, 160, 0, 32),
		UDim2.new(0.5, -80, 0, 8),
		THEME.BG_PANEL,
		10
	)
	minimizedFrame.Name    = "MinimizedBar"
	minimizedFrame.Visible = false
	addBorder(minimizedFrame, THEME.ACCENT, 1)

	local minLabel = newLabel(minimizedFrame, "[ " .. self.Title .. " ]", UDim2.new(1, -50, 1, 0), UDim2.new(0, 8, 0, 0), THEME.TEXT_ACCENT, 13, 11)
	local restoreBtn = newButton(minimizedFrame, "展开", UDim2.new(0, 42, 0, 20), UDim2.new(1, -48, 0.5, -10), 11)
	restoreBtn.BackgroundColor3 = THEME.BG_TABSEL
	addBorder(restoreBtn, THEME.ACCENT, 1)

	self._minimizedFrame = minimizedFrame

	minBtn.MouseButton1Click:Connect(function()
		if not self._minimized then
			self._minimized = true
			local t = makeTween(mainFrame, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, self.Width, 0, 0)
			}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			t:Play()
			t.Completed:Connect(function()
				mainFrame.Visible = false
				minimizedFrame.Visible = true
			end)
		end
	end)

	restoreBtn.MouseButton1Click:Connect(function()
		if self._minimized then
			self._minimized = false
			minimizedFrame.Visible = false
			mainFrame.Visible = true
			mainFrame.Size = UDim2.new(0, self.Width, 0, 0)
			mainFrame.BackgroundTransparency = 1
			local t = makeTween(mainFrame, {
				BackgroundTransparency = 0,
				Size = UDim2.new(0, self.Width, 0, self.Height)
			}, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			t:Play()
		end
	end)

	closeBtn.MouseButton1Click:Connect(function()
		local t = makeTween(mainFrame, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, self.Width * 0.5, 0, self.Height * 0.5),
			Position = UDim2.new(0.5, -self.Width * 0.25, 0.5, -self.Height * 0.25)
		}, 0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		t:Play()
		t.Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)

	minBtn.MouseEnter:Connect(function()
		makeTween(minBtn, { BackgroundColor3 = THEME.ACCENT_DIM }, 0.12):Play()
	end)
	minBtn.MouseLeave:Connect(function()
		makeTween(minBtn, { BackgroundColor3 = THEME.BG_TAB }, 0.12):Play()
	end)
	closeBtn.MouseEnter:Connect(function()
		makeTween(closeBtn, { BackgroundColor3 = Color3.fromRGB(160, 30, 30) }, 0.12):Play()
	end)
	closeBtn.MouseLeave:Connect(function()
		makeTween(closeBtn, { BackgroundColor3 = Color3.fromRGB(80, 20, 20) }, 0.12):Play()
	end)

	return self
end

function CF_UI:AddTab(name)
	local tabIndex = #self._tabs + 1

	local tabBtn = newButton(
		self._tabBar,
		name,
		UDim2.new(1, 0, 0, 38),
		UDim2.new(0, 0, 0, 0),
		3
	)
	tabBtn.LayoutOrder      = tabIndex
	tabBtn.BackgroundColor3 = THEME.BG_TAB
	tabBtn.TextColor3       = THEME.TEXT_DIM
	tabBtn.Font             = Enum.Font.Code
	tabBtn.TextSize         = 13
	tabBtn.TextXAlignment   = Enum.TextXAlignment.Left
	tabBtn.BorderSizePixel  = 0

	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingLeft = UDim.new(0, 12)
	tabPad.Parent      = tabBtn

	local indicator = newFrame(tabBtn, UDim2.new(0, 2, 1, 0), UDim2.new(0, 0, 0, 0), THEME.ACCENT, 4)
	indicator.Visible = false

	local page = newFrame(
		self._container,
		UDim2.new(1, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		Color3.fromRGB(0, 0, 0),
		2
	)
	page.BackgroundTransparency = 1
	page.Visible                = false
	page.Name                   = "Page_" .. name

	local pageScroll = Instance.new("ScrollingFrame")
	pageScroll.Size                  = UDim2.new(1, 0, 1, 0)
	pageScroll.Position              = UDim2.new(0, 0, 0, 0)
	pageScroll.BackgroundTransparency = 1
	pageScroll.BorderSizePixel       = 0
	pageScroll.ScrollBarThickness    = 3
	pageScroll.ScrollBarImageColor3  = THEME.ACCENT
	pageScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
	pageScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
	pageScroll.ZIndex                = 2
	pageScroll.Parent                = page

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.SortOrder     = Enum.SortOrder.LayoutOrder
	listLayout.Padding       = UDim.new(0, 6)
	listLayout.Parent        = pageScroll

	local pagePad = Instance.new("UIPadding")
	pagePad.PaddingTop    = UDim.new(0, 10)
	pagePad.PaddingLeft   = UDim.new(0, 12)
	pagePad.PaddingRight  = UDim.new(0, 12)
	pagePad.PaddingBottom = UDim.new(0, 10)
	pagePad.Parent        = pageScroll

	local tabData = {
		Name      = name,
		Button    = tabBtn,
		Page      = page,
		Scroll    = pageScroll,
		Indicator = indicator,
		Layout    = listLayout,
		Index     = tabIndex,
	}

	table.insert(self._tabs, tabData)

	local function selectTab()
		for _, t in ipairs(self._tabs) do
			makeTween(t.Button, { BackgroundColor3 = THEME.BG_TAB, TextColor3 = THEME.TEXT_DIM }, 0.15):Play()
			t.Indicator.Visible = false
			t.Page.Visible      = false
		end
		makeTween(tabBtn, { BackgroundColor3 = THEME.BG_TABSEL, TextColor3 = THEME.TEXT_ACCENT }, 0.15):Play()
		indicator.Visible    = true
		page.Visible         = true
		self._activeTab      = tabData
	end

	tabBtn.MouseButton1Click:Connect(selectTab)

	tabBtn.MouseEnter:Connect(function()
		if self._activeTab ~= tabData then
			makeTween(tabBtn, { BackgroundColor3 = Color3.fromRGB(22, 22, 30) }, 0.1):Play()
		end
	end)
	tabBtn.MouseLeave:Connect(function()
		if self._activeTab ~= tabData then
			makeTween(tabBtn, { BackgroundColor3 = THEME.BG_TAB }, 0.1):Play()
		end
	end)

	if tabIndex == 1 then
		selectTab()
	end

	local api = {}

	function api:AddToggle(label, default, callback)
		local state = default or false

		local row = newFrame(pageScroll, UDim2.new(1, -24, 0, 40), UDim2.new(0, 0, 0, 0), THEME.BG_TAB, 3)
		row.LayoutOrder = #pageScroll:GetChildren()
		addBorder(row, THEME.BORDER, 1)

		local lbl = newLabel(row, label, UDim2.new(1, -60, 1, 0), UDim2.new(0, 10, 0, 0), THEME.TEXT_MAIN, 13, 4)

		local trackW, trackH = 44, 22
		local track = newFrame(row, UDim2.new(0, trackW, 0, trackH), UDim2.new(1, -(trackW + 10), 0.5, -trackH / 2), state and THEME.TOGGLE_ON or THEME.TOGGLE_OFF, 4)
		addBorder(track, THEME.BORDER, 1)

		local thumbW = trackH - 4
		local thumb  = newFrame(track, UDim2.new(0, thumbW, 0, thumbW), UDim2.new(0, state and (trackW - thumbW - 2) or 2, 0, 2), THEME.TEXT_MAIN, 5)

		local function updateVisual(s)
			makeTween(track, { BackgroundColor3 = s and THEME.TOGGLE_ON or THEME.TOGGLE_OFF }, 0.18):Play()
			makeTween(thumb, { Position = UDim2.new(0, s and (trackW - thumbW - 2) or 2, 0, 2) }, 0.18):Play()
		end

		local function onToggle()
			state = not state
			updateVisual(state)
			if callback then pcall(callback, state) end
		end

		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				onToggle()
			end
		end)
		row.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				onToggle()
			end
		end)

		local ctrl = {}
		function ctrl:Set(v)
			state = v
			updateVisual(state)
			if callback then pcall(callback, state) end
		end
		function ctrl:Get() return state end
		return ctrl
	end

	function api:AddButton(label, callback)
		local btn = newButton(
			pageScroll,
			label,
			UDim2.new(1, -24, 0, 38),
			UDim2.new(0, 0, 0, 0),
			3
		)
		btn.LayoutOrder     = #pageScroll:GetChildren()
		btn.BackgroundColor3 = THEME.BTN_BG
		btn.TextColor3      = THEME.BTN_TEXT
		btn.Font            = Enum.Font.Code
		btn.TextSize        = 13
		btn.TextXAlignment  = Enum.TextXAlignment.Center
		addBorder(btn, THEME.BORDER, 1)

		btn.MouseEnter:Connect(function()
			makeTween(btn, { BackgroundColor3 = THEME.BTN_HOVER, TextColor3 = THEME.BG_DEEP }, 0.15):Play()
		end)
		btn.MouseLeave:Connect(function()
			makeTween(btn, { BackgroundColor3 = THEME.BTN_BG, TextColor3 = THEME.BTN_TEXT }, 0.15):Play()
		end)
		btn.MouseButton1Down:Connect(function()
			makeTween(btn, { BackgroundColor3 = THEME.ACCENT_DIM }, 0.08):Play()
		end)
		btn.MouseButton1Up:Connect(function()
			makeTween(btn, { BackgroundColor3 = THEME.BTN_HOVER }, 0.08):Play()
		end)

		btn.MouseButton1Click:Connect(function()
			if callback then pcall(callback) end
		end)

		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				makeTween(btn, { BackgroundColor3 = THEME.ACCENT_DIM }, 0.08):Play()
			end
		end)
		btn.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				makeTween(btn, { BackgroundColor3 = THEME.BTN_BG, TextColor3 = THEME.BTN_TEXT }, 0.12):Play()
				if callback then pcall(callback) end
			end
		end)
	end

	function api:AddSlider(label, min, max, default, callback)
		min     = min     or 0
		max     = max     or 100
		default = math.clamp(default or min, min, max)

		local row = newFrame(pageScroll, UDim2.new(1, -24, 0, 56), UDim2.new(0, 0, 0, 0), THEME.BG_TAB, 3)
		row.LayoutOrder = #pageScroll:GetChildren()
		addBorder(row, THEME.BORDER, 1)

		local lbl = newLabel(row, label, UDim2.new(0.7, 0, 0, 22), UDim2.new(0, 10, 0, 4), THEME.TEXT_MAIN, 13, 4)

		local valLabel = newLabel(row, tostring(default), UDim2.new(0.28, 0, 0, 22), UDim2.new(0.72, 0, 0, 4), THEME.TEXT_ACCENT, 13, 4)
		valLabel.TextXAlignment = Enum.TextXAlignment.Right

		local trackH   = 6
		local trackY   = 34
		local sliderTrack = newFrame(row, UDim2.new(1, -20, 0, trackH), UDim2.new(0, 10, 0, trackY), THEME.SLIDER_BG, 4)
		addBorder(sliderTrack, THEME.BORDER, 1)

		local pct  = (default - min) / (max - min)
		local fill = newFrame(sliderTrack, UDim2.new(pct, 0, 1, 0), UDim2.new(0, 0, 0, 0), THEME.SLIDER_FILL, 5)

		local thumbSz = 14
		local thumb   = newFrame(sliderTrack, UDim2.new(0, thumbSz, 0, thumbSz), UDim2.new(pct, -thumbSz / 2, 0.5, -thumbSz / 2), THEME.ACCENT, 6)
		addBorder(thumb, THEME.ACCENT_DIM, 1)

		local dragging = false
		local value    = default

		local function updateSlider(absX)
			local trackAbsPos  = sliderTrack.AbsolutePosition.X
			local trackAbsSize = sliderTrack.AbsoluteSize.X
			local rel          = math.clamp((absX - trackAbsPos) / trackAbsSize, 0, 1)
			value              = math.floor(min + rel * (max - min) + 0.5)
			local newPct       = (value - min) / (max - min)
			fill.Size          = UDim2.new(newPct, 0, 1, 0)
			thumb.Position     = UDim2.new(newPct, -thumbSz / 2, 0.5, -thumbSz / 2)
			valLabel.Text      = tostring(value)
			if callback then pcall(callback, value) end
		end

		sliderTrack.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				updateSlider(input.Position.X)
			end
		end)
		thumb.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				updateSlider(input.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		local ctrl = {}
		function ctrl:Set(v)
			value = math.clamp(v, min, max)
			local np = (value - min) / (max - min)
			fill.Size      = UDim2.new(np, 0, 1, 0)
			thumb.Position = UDim2.new(np, -thumbSz / 2, 0.5, -thumbSz / 2)
			valLabel.Text  = tostring(value)
			if callback then pcall(callback, value) end
		end
		function ctrl:Get() return value end
		return ctrl
	end

	function api:AddLabel(text)
		local lbl = newLabel(
			pageScroll,
			text,
			UDim2.new(1, -24, 0, 28),
			UDim2.new(0, 0, 0, 0),
			THEME.TEXT_DIM,
			12,
			3
		)
		lbl.LayoutOrder    = #pageScroll:GetChildren()
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 10)
		pad.Parent      = lbl
	end

	function api:AddSection(title)
		local sec = newFrame(pageScroll, UDim2.new(1, -24, 0, 26), UDim2.new(0, 0, 0, 0), Color3.fromRGB(0, 0, 0), 3)
		sec.BackgroundTransparency = 1
		sec.LayoutOrder            = #pageScroll:GetChildren()

		local line = newFrame(sec, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0.5, 0), THEME.BORDER, 3)

		local secLbl = newLabel(sec, " " .. title .. " ", UDim2.new(0, 0, 1, 0), UDim2.new(0, 8, 0, 0), THEME.ACCENT, 11, 4)
		secLbl.AutomaticSize    = Enum.AutomaticSize.X
		secLbl.BackgroundColor3 = THEME.BG_PANEL
		secLbl.BackgroundTransparency = 0
		secLbl.BorderSizePixel  = 0
		secLbl.TextXAlignment   = Enum.TextXAlignment.Center
	end

	return api
end

return CF_UI
