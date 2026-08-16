local Library = (function()
	local Library = {}
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then
		LocalPlayer = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	end
	local UIScale = 1
	local WindowScale = nil
	local Connections = {}
	local Opened = true
	local Minimized = false
	local function IsEmpty(s)
		for _, ch in utf8.names(s) do
			return false
		end
		return true
	end
	local function New(class, props)
		local inst = Instance.new(class)
		for k, v in pairs(props) do
			if k ~= "Parent" then
				inst[k] = v
			end
		end
		inst.Parent = props.Parent
		return inst
	end
	local function CreateShadow(parent, transparency)
		local shadow = New("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 36, 1, 36),
			Position = UDim2.new(0, -18, 0, -18),
			Image = "rbxassetid://6015897843",
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			ImageTransparency = transparency or 0.35,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(24, 24, 276, 276),
			Parent = parent,
		})
		return shadow
	end
	local IconsModule = nil
	local function LoadIcons()
		if IconsModule then
			return IconsModule
		end
		pcall(function()
			local get = game.HttpGet and game.HttpGet or game.HttpGetAsync
			IconsModule = loadstring(get(game, "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
		end)
		return IconsModule
	end
	function Library:SetIcons(mod)
		IconsModule = mod
	end
	function Library:GetIcon(name)
		local mod = LoadIcons()
		if mod and name then
			if type(mod.GetIcon) == "function" then
				local ok, result = pcall(mod.GetIcon, mod, name)
				if ok and result then
					if type(result) == "string" then
						return result
					elseif type(result) == "table" and type(result[1]) == "string" then
						return result[1]
					end
				end
			elseif type(mod[name]) == "string" then
				return mod[name]
			end
		end
	end
	function Library:SetIcon(img, name, tries)
		if not img then
			return
		end
		local id = Library:GetIcon(name)
		if id then
			img.Image = id
		elseif tries and tries > 0 then
			task.delay(0.2, function()
				if img.Parent then
					Library:SetIcon(img, name, tries - 1)
				end
			end)
		end
	end
	local function MakeParagraphPanel(container, options)
		local title = options.name or ""
		local body = options.text or ""
		local color = options.color
		local ic = options.icon and Library:GetIcon(options.icon)
		local Par = New("Frame", {
			Name = title,
			Size = UDim2.new(1, 0, 0, 46),
			BackgroundColor3 = Color3.fromRGB(36, 36, 44),
			BorderSizePixel = 0,
			Parent = container,
		})
		New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Par })
		New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -28, 0, 20),
			Position = UDim2.new(0, ic and 40 or 14, 0, 11),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamSemibold,
			Text = title,
			TextSize = 16,
			TextColor3 = color or Color3.fromRGB(230, 230, 236),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Par,
		})
		if ic then
			New("ImageLabel", {
				Name = "Icon",
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 14, 0, 13),
				BackgroundTransparency = 1,
				Image = ic,
				ImageColor3 = Color3.fromRGB(150, 160, 180),
				Parent = Par,
			})
		end
		local BodyLabel = New("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, -28, 0, 32),
			Position = UDim2.new(0, 14, 0, 36),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = body,
			TextSize = 20,
			TextColor3 = Color3.fromRGB(200, 200, 210),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Parent = Par,
		})
		local function CountChars(str)
			local n = 0
			for _ in string.gmatch(str or "", "[^\128-\191]") do
				n = n + 1
			end
			return n
		end
		local function IsActuallyVisible()
			local node = Par
			while node and node:IsA("GuiObject") do
				if not node.Visible then
					return false
				end
				node = node.Parent
			end
			return true
		end
		local function EstimateHeight()
			local w = Par.AbsoluteSize.X - 28
			if w <= 0 then
				w = (container and container.AbsoluteSize.X or 400) - 28
			end
			if w <= 0 then
				w = 400
			end
			local perLine = math.max(1, math.floor(w / 20))
			local lines = math.max(1, math.ceil(CountChars(BodyLabel.Text) / perLine))
			return 44 + lines * 28
		end
		local function ApplyHeight(contentH)
			contentH = math.max(1, math.ceil(contentH or 0))
			BodyLabel.Size = UDim2.new(1, -28, 0, contentH)
			Par.Size = UDim2.new(1, 0, 0, math.max(46, 36 + 6 + contentH))
		end
		local function PreciseRefresh()
			if not IsActuallyVisible() then
				return false
			end
			task.wait()
			if not IsActuallyVisible() then
				return false
			end
			ApplyHeight(BodyLabel.TextBounds.Y)
			return true
		end
		local NeedPrecise = true
		local function ApplyCurrent()
			if PreciseRefresh() then
				NeedPrecise = false
				return
			end
			ApplyHeight(EstimateHeight())
			NeedPrecise = true
		end
		task.spawn(function()
			while NeedPrecise do
				if task.wait(0.15) == nil then
					break
				end
				if IsActuallyVisible() then
					if PreciseRefresh() then
						NeedPrecise = false
						break
					end
				end
			end
		end)
		local ParObj = {
			Frame = Par,
			Instance = Par,
		}
		function ParObj:SetText(t)
			BodyLabel.Text = t or ""
			ApplyHeight(EstimateHeight())
			NeedPrecise = true
			task.spawn(function()
				if PreciseRefresh() then
					NeedPrecise = false
					return
				end
				NeedPrecise = true
			end)
		end
		function ParObj:GetFrame()
			return Par
		end
		ApplyCurrent()
		return ParObj
	end
	local function MakeTag(container, options)
		local title = options.title or options.name or "标签"
		local tColor = options.color or Color3.fromRGB(49, 101, 255)
		local radius = options.radius or 999
		local ic = options.icon
		local textSize = options.textSize or 14
		local iconAsset = ic and Library:GetIcon(ic)
		local function ContrastText(c)
			local _, _, v = Color3.toHSV(typeof(c) == "Color3" and c or Color3.new(1, 1, 1))
			if v > 0.55 then
				return Color3.fromRGB(24, 24, 28)
			end
			return Color3.fromRGB(240, 240, 245)
		end
		local TagFrame = New("Frame", {
			Name = title,
			Size = UDim2.new(0, 0, 0, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = tColor,
			BorderSizePixel = 0,
			Parent = container,
		})
		New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = TagFrame })
		local TagContent = New("Frame", {
			Name = "Content",
			Size = UDim2.new(0, 0, 0, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Parent = TagFrame,
		})
		local ContentLayout = New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
			Parent = TagContent,
		})
		New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = TagContent })
		local TagIcon
		if iconAsset then
			TagIcon = New("ImageLabel", {
				Name = "Icon",
				Size = UDim2.new(0, 14, 0, 14),
				BackgroundTransparency = 1,
				Image = iconAsset,
				ImageColor3 = ContrastText(tColor),
				ScaleType = Enum.ScaleType.Fit,
				Parent = TagContent,
			})
			Library:SetIcon(TagIcon, ic, 10)
		end
		local TagTitle = New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(0, 0, 0, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamSemibold,
			Text = title,
			TextSize = textSize,
			TextColor3 = ContrastText(tColor),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TagContent,
		})
		local TagModule = {
			Title = title,
			Color = tColor,
		}
		function TagModule:SetTitle(text)
			TagModule.Title = text
			TagTitle.Text = text
			return TagModule
		end
		function TagModule:SetColor(color)
			TagModule.Color = color
			if typeof(color) == "Color3" then
				TagFrame.BackgroundColor3 = color
				TagTitle.TextColor3 = ContrastText(color)
				if TagIcon then
					TagIcon.ImageColor3 = ContrastText(color)
				end
			end
			return TagModule
		end
		function TagModule:SetIcon(icon)
			if TagIcon then
				TagIcon:Destroy()
				TagIcon = nil
			end
			local asset = icon and Library:GetIcon(icon)
			if asset then
				TagIcon = New("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 14, 0, 14),
					BackgroundTransparency = 1,
					Image = asset,
					ImageColor3 = ContrastText(TagModule.Color),
					ScaleType = Enum.ScaleType.Fit,
					Parent = TagContent,
				})
				Library:SetIcon(TagIcon, icon, 10)
			end
			return TagModule
		end
		function TagModule:GetFrame()
			return TagFrame
		end
		function TagModule:Destroy()
			TagFrame:Destroy()
		end
		return TagModule
	end
	local function MakeColorpickerPanel(container, options)
		local title = options.name or ""
		local callback = options.callback
		local ic = options.icon and Library:GetIcon(options.icon)
		local ph, ps, pv = Color3.toHSV(options.default or Color3.fromRGB(255, 255, 255))
		local hue = ph or 0
		local sat = ps or 1
		local vib = pv or 1
		local Ctrl = New("Frame", {
			Name = title,
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = Color3.fromRGB(36, 36, 44),
			BorderSizePixel = 0,
			Parent = container,
		})
		New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Ctrl })
		local CtrlTitle = New("TextLabel", {
			Name = "TextLabel",
			Size = UDim2.new(1, -90, 0, 20),
			Position = UDim2.new(0, 14, 0, 12),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = title,
			TextSize = 16,
			TextColor3 = Color3.fromRGB(230, 230, 236),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Ctrl,
		})
		if ic then
			CtrlTitle.Position = UDim2.new(0, 40, 0, 12)
			New("ImageLabel", {
				Name = "Icon",
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 14, 0, 14),
				BackgroundTransparency = 1,
				Image = ic,
				ImageColor3 = Color3.fromRGB(150, 160, 180),
				Parent = Ctrl,
			})
		end
		local Swatch = New("TextButton", {
			Name = "Swatch",
			Size = UDim2.new(0, 60, 0, 24),
			Position = UDim2.new(1, -70, 0, 10),
			BackgroundColor3 = Color3.fromHSV(hue, sat, vib),
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			Parent = Ctrl,
		})
		New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Swatch })
		local Popup = nil
		local OutsideConn = nil
		local SatVibMap = nil
		local SatCursor = nil
		local HueBar = nil
		local HueDrag = nil
		local HexBox = nil
		local RedBox = nil
		local GreenBox = nil
		local BlueBox = nil
		local activeSlider = nil
		local function CurrentColor()
			return Color3.fromHSV(hue, sat, vib)
		end
		local function UpdateUI()
			Swatch.BackgroundColor3 = CurrentColor()
			if SatVibMap then
				SatVibMap.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
			end
			if SatCursor then
				SatCursor.Position = UDim2.new(sat, 0, 1 - vib, 0)
				SatCursor.BackgroundColor3 = CurrentColor()
			end
			if HueDrag then
				HueDrag.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				HueDrag.Position = UDim2.new(0.5, 0, hue, 0)
			end
			local col = CurrentColor()
			if HexBox then
				HexBox.Text = "#" .. col:ToHex()
			end
			if RedBox then
				RedBox.Text = tostring(math.floor(col.R * 255))
			end
			if GreenBox then
				GreenBox.Text = tostring(math.floor(col.G * 255))
			end
			if BlueBox then
				BlueBox.Text = tostring(math.floor(col.B * 255))
			end
			if callback then
				pcall(callback, col)
			end
		end
		local function SetsRGB(r, g, b)
			r = math.round(math.clamp(r or 0, 0, 255))
			g = math.round(math.clamp(g or 0, 0, 255))
			b = math.round(math.clamp(b or 0, 0, 255))
			local h, s, v = Color3.toHSV(Color3.fromRGB(r, g, b))
			hue = h or 0
			sat = s or 1
			vib = v or 1
			UpdateUI()
		end
		local function ClosePopup()
			if Popup and Popup.Parent then
				Popup:Destroy()
			end
			Popup = nil
			SatVibMap = nil
			SatCursor = nil
			HueBar = nil
			HueDrag = nil
			HexBox = nil
			RedBox = nil
			GreenBox = nil
			BlueBox = nil
			activeSlider = nil
						if OutsideConn then
				OutsideConn:Disconnect()
				OutsideConn = nil
			end
		end
		local function OpenPopup()
			local screen = container:FindFirstAncestorOfClass("ScreenGui")
			if not screen then
				return
			end
			local sw = Swatch.AbsolutePosition
			Popup = New("Frame", {
				Name = "ColorPopup",
				Size = UDim2.new(0, 240, 0, 236),
				Position = UDim2.fromOffset(sw.X + Swatch.AbsoluteSize.X - 8, sw.Y - 16),
				AnchorPoint = Vector2.new(1, 1),
				BackgroundColor3 = Color3.fromRGB(24, 24, 30),
				BorderSizePixel = 0,
				ZIndex = 1000002,
				Parent = screen,
			})
			New("UIStroke", { Color = Color3.fromRGB(60, 60, 70), Thickness = 1, Parent = Popup })
			New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Popup })
			New("TextLabel", {
				Name = "Title",
				Size = UDim2.new(1, -20, 0, 24),
				Position = UDim2.new(0, 10, 0, 8),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamSemibold,
				Text = title,
				TextSize = 15,
				TextColor3 = Color3.fromRGB(230, 230, 236),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Popup,
			})
			SatVibMap = New("ImageLabel", {
				Name = "SatVib",
				Size = UDim2.new(0, 160, 0, 160),
				Position = UDim2.new(0, 12, 0, 40),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
				Image = "rbxassetid://4155801252",
				ScaleType = Enum.ScaleType.Stretch,
				BorderSizePixel = 0,
				Parent = Popup,
			})
			New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = SatVibMap })
			SatCursor = New("Frame", {
				Name = "Cursor",
				Size = UDim2.new(0, 14, 0, 14),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(sat, 0, 1 - vib, 0),
				BackgroundColor3 = CurrentColor(),
				BorderSizePixel = 0,
				Parent = SatVibMap,
			})
			New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 2, Parent = SatCursor })
			New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SatCursor })
			HueBar = New("Frame", {
				Name = "Hue",
				Size = UDim2.new(0, 6, 0, 160),
				Position = UDim2.new(0, 184, 0, 40),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				Parent = Popup,
			})
			New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = HueBar })
			local segH = 160 / 80
			for i = 0, 79 do
				New("Frame", {
					Size = UDim2.new(1, 0, 0, segH + 0.2),
					Position = UDim2.new(0, 0, 0, segH * i),
					BackgroundColor3 = Color3.fromHSV(i / 80, 1, 1),
					BorderSizePixel = 0,
					Parent = HueBar,
				})
			end
			HueDrag = New("Frame", {
				Name = "Cursor",
				Size = UDim2.new(0, 14, 0, 14),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, hue, 0),
				BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
				BorderSizePixel = 0,
				Parent = HueBar,
			})
			New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 2, Parent = HueDrag })
			New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = HueDrag })
			local function MakeInput(name, x)
				local Frame = New("Frame", {
					Size = UDim2.new(0, 52, 0, 22),
					Position = UDim2.new(0, x, 0, 208),
					BackgroundColor3 = Color3.fromRGB(20, 20, 26),
					BorderSizePixel = 0,
					Parent = Popup,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Frame })
				return New("TextBox", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = "",
					TextSize = 13,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					PlaceholderText = name,
					PlaceholderColor3 = Color3.fromRGB(110, 110, 120),
					TextXAlignment = Enum.TextXAlignment.Center,
					ClearTextOnFocus = false,
					Parent = Frame,
				})
			end
			HexBox = MakeInput("HEX", 12)
			RedBox = MakeInput("R", 70)
			GreenBox = MakeInput("G", 128)
			BlueBox = MakeInput("B", 186)
			UpdateUI()
			local function UpdateSatVib(x, y)
				local minX = SatVibMap.AbsolutePosition.X
				local maxX = minX + SatVibMap.AbsoluteSize.X
				local minY = SatVibMap.AbsolutePosition.Y
				local maxY = minY + SatVibMap.AbsoluteSize.Y
				sat = math.clamp((x - minX) / (maxX - minX), 0, 1)
				vib = math.clamp(1 - (y - minY) / (maxY - minY), 0, 1)
				UpdateUI()
			end
			local function UpdateHue(y)
				local minY = HueBar.AbsolutePosition.Y
				local maxY = minY + HueBar.AbsoluteSize.Y
				hue = math.clamp((y - minY) / (maxY - minY), 0, 1)
				UpdateUI()
			end
			local function IsPress(input)
				return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
			end
			SatVibMap.InputBegan:Connect(function(input)
				if IsPress(input) then
					activeSlider = "SatVib"
					UpdateSatVib(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
				end
			end)
			HueBar.InputBegan:Connect(function(input)
				if IsPress(input) then
					activeSlider = "Hue"
					UpdateHue(UserInputService:GetMouseLocation().Y)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if activeSlider then
					if activeSlider == "SatVib" then
						UpdateSatVib(input.Position.X, input.Position.Y)
					elseif activeSlider == "Hue" then
						UpdateHue(input.Position.Y)
					end
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				activeSlider = nil
			end)
			HexBox.FocusLost:Connect(function(enter)
				if enter then
					local ok, res = pcall(function()
						return Color3.fromHex(HexBox.Text:gsub("#", ""))
					end)
					if ok and typeof(res) == "Color3" then
						local h, s, v = Color3.toHSV(res)
						hue = h or 0
						sat = s or 1
						vib = v or 1
						UpdateUI()
					end
				end
			end)
			RedBox.FocusLost:Connect(function(enter)
				if enter then
					local c = CurrentColor()
					SetsRGB(tonumber(RedBox.Text), math.floor(c.G * 255), math.floor(c.B * 255))
				end
			end)
			GreenBox.FocusLost:Connect(function(enter)
				if enter then
					local c = CurrentColor()
					SetsRGB(math.floor(c.R * 255), tonumber(GreenBox.Text), math.floor(c.B * 255))
				end
			end)
			BlueBox.FocusLost:Connect(function(enter)
				if enter then
					local c = CurrentColor()
					SetsRGB(math.floor(c.R * 255), math.floor(c.G * 255), tonumber(BlueBox.Text))
				end
			end)
			OutsideConn = UserInputService.InputBegan:Connect(function(input)
				if IsPress(input) then
					local p = input.Position
					local ap = Popup.AbsolutePosition
					local asz = Popup.AbsoluteSize
					if p.X < ap.X or p.X > ap.X + asz.X or p.Y < ap.Y or p.Y > ap.Y + asz.Y then
						ClosePopup()
					end
				end
			end)
		end
		Swatch.MouseButton1Click:Connect(function()
			if Popup and Popup.Parent then
				ClosePopup()
			else
				OpenPopup()
			end
		end)
		Swatch.MouseEnter:Connect(function()
			TweenService:Create(Swatch, TweenInfo.new(0.15), { BackgroundColor3 = CurrentColor():Lerp(Color3.fromRGB(255, 255, 255), 0.2) }):Play()
		end)
		Swatch.MouseLeave:Connect(function()
			TweenService:Create(Swatch, TweenInfo.new(0.15), { BackgroundColor3 = CurrentColor() }):Play()
		end)
		local ColorObj = {}
		function ColorObj:Get()
			return CurrentColor()
		end
		function ColorObj:SetValue(c)
			local h, s, v = Color3.toHSV(c)
			hue = h or 0
			sat = s or 1
			vib = v or 1
			UpdateUI()
		end
		UpdateUI()
		return ColorObj
	end
	function Library:CreateWindow(options)
		local title = options.Title or "XHM Ultra"
		local size = options.Size or UDim2.new(0, 680, 0, 460)
		local ScreenGui = New("ScreenGui", {
			DisplayOrder = 999999999,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = LocalPlayer:WaitForChild("PlayerGui"),
		})
		WindowScale = New("UIScale", {
			Name = "WindowScale",
			Scale = 0.85,
			Parent = ScreenGui,
		})
		local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 600)
		local BaseDPI = 1
		if type(options.DPI) == "number" and options.DPI > 0 then
			BaseDPI = options.DPI
		else
			BaseDPI = math.clamp(ViewportSize.X / 1920, 0.5, 1.5)
		end
		local FitScale = math.min(1, math.min((ViewportSize.X - 24) / size.X.Offset, (ViewportSize.Y - 24) / size.Y.Offset))
		WindowScale.Scale = WindowScale.Scale * BaseDPI * (FitScale < 1 and FitScale or 1)
		UIScale = BaseDPI
		local function ApplyDPI()
			if WindowScale then
				WindowScale.Scale = 0.85 * UIScale * (FitScale < 1 and FitScale or 1)
			end
		end
		pcall(function()
			local CoreGui = game:GetService("CoreGui")
			if not CoreGui:FindFirstChild("XHMUltraLib") then
				New("Folder", { Name = "XHMUltraLib", Parent = CoreGui })
			end
		end)
		local Main = New("Frame", {
			Name = "Main",
			Size = size,
			Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
			BackgroundColor3 = Color3.fromRGB(20, 20, 24),
			BackgroundTransparency = 0.04,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Active = true,
			ZIndex = 999999,
			Parent = ScreenGui,
		})
		New("UIStroke", { Color = Color3.fromRGB(235, 235, 240), Thickness = 2, Parent = Main })
		local TopBar = New("Frame", {
			Name = "TopBar",
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(26, 26, 31),
			BorderSizePixel = 0,
			ZIndex = 1000000,
			Parent = Main,
		})
		local Logo = New("ImageLabel", {
			Name = "Logo",
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 12, 0, 9),
			BackgroundTransparency = 1,
			Image = "rbxassetid://12654974860",
			Parent = TopBar,
		})
		if type(options.Icon) == "string" then
			if string.match(options.Icon, "^rbxassetid://") or string.match(options.Icon, "^rbxasset://") or string.match(options.Icon, "^rbxthumb://") or string.match(options.Icon, "roblox%.com") then
				Logo.Image = options.Icon
			elseif string.match(options.Icon, "^https?://") then
				pcall(function()
					local data = game:HttpGet(options.Icon)
					if writefile then
						local ext = string.match(options.Icon, "%.(png|jpg|jpeg|webp|gif)$")
						local filename = "XHMUltraIcon." .. (ext or "png")
						writefile(filename, data)
						if getcustomasset then
							Logo.Image = getcustomasset(filename)
						end
					end
				end)
			end
		end
		local TitleLabel = New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(0.5, -44, 0, 16),
			Position = UDim2.new(0, 38, 0, 5),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamSemibold,
			Text = title,
			TextSize = 14,
			TextColor3 = Color3.fromRGB(235, 235, 240),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = TopBar,
		})
		local SubtitleLabel = nil
		if options.Subtitle then
			SubtitleLabel = New("TextLabel", {
				Name = "Subtitle",
				Size = UDim2.new(0.5, -44, 0, 13),
				Position = UDim2.new(0, 38, 0, 21),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = options.Subtitle,
				TextSize = 11,
				TextColor3 = Color3.fromRGB(135, 135, 145),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = TopBar,
			})
		end
		local TopBarTags = New("ScrollingFrame", {
			Name = "TitleTags",
			Size = UDim2.new(0, 240, 0, 26),
			Position = UDim2.new(0, 46, 0, 6),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			Parent = TopBar,
		})
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
			Parent = TopBarTags,
		})
		New("UIPadding", { PaddingRight = UDim.new(0, 4), Parent = TopBarTags })
		local TagsDragging = false
		local TagsDragStart = 0
		local TagsStartCanvas = 0
		TopBarTags.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				TagsDragging = true
				TagsDragStart = input.Position.X
				TagsStartCanvas = TopBarTags.CanvasPosition.X
			end
		end)
		TopBarTags.InputChanged:Connect(function(input)
			if TagsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local maxX = math.max(0, TopBarTags.AbsoluteCanvasSize.X - TopBarTags.AbsoluteSize.X)
				TopBarTags.CanvasPosition = Vector2.new(math.clamp(TagsStartCanvas + (TagsDragStart - input.Position.X), 0, maxX), 0)
			end
		end)
		TopBarTags.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				TagsDragging = false
			end
		end)
		local function LayoutTopBarTags()
			local tbW = TopBar.AbsoluteSize.X
			local rightEdge = math.max(120, tbW - 322)
			local leftBound = 46
			local guard = 0
			if SubtitleLabel and SubtitleLabel.AbsoluteSize.X > 0 then
				guard = SubtitleLabel.AbsolutePosition.X + SubtitleLabel.AbsoluteSize.X
			elseif TitleLabel and TitleLabel.AbsoluteSize.X > 0 then
				guard = TitleLabel.AbsolutePosition.X + TitleLabel.AbsoluteSize.X
			end
			if guard > 0 then
				leftBound = guard + 8
			end
			local w = math.max(0, rightEdge - leftBound)
			TopBarTags.Position = UDim2.new(0, leftBound, 0, 6)
			TopBarTags.Size = UDim2.new(0, w, 0, 26)
		end
		TopBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(LayoutTopBarTags)
		if SubtitleLabel then
			SubtitleLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(LayoutTopBarTags)
		end
		task.defer(LayoutTopBarTags)
		local MinimizeButton = New("TextButton", {
			Name = "Minimize",
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(1, -64, 0, 4),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			Parent = TopBar,
		})
		local MinimizeIcon = New("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5, -8, 0.5, -8),
			BackgroundTransparency = 1,
			Image = Library:GetIcon("minus"),
			ImageColor3 = Color3.fromRGB(160, 160, 170),
			ScaleType = Enum.ScaleType.Fit,
			Parent = MinimizeButton,
		})
		Library:SetIcon(MinimizeIcon, "minus", 10)
		local CloseButton = New("TextButton", {
			Name = "Close",
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(1, -34, 0, 4),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			Parent = TopBar,
		})
		local CloseIcon = New("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5, -8, 0.5, -8),
			BackgroundTransparency = 1,
			Image = Library:GetIcon("x"),
			ImageColor3 = Color3.fromRGB(160, 160, 170),
			ScaleType = Enum.ScaleType.Fit,
			Parent = CloseButton,
		})
		Library:SetIcon(CloseIcon, "x", 10)
		local TabsContainer = New("Frame", {
			Name = "Tabs",
			Size = UDim2.new(0, 148, 1, -38),
			Position = UDim2.new(0, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(24, 24, 30),
			BorderSizePixel = 0,
			ZIndex = 999999,
			Parent = Main,
		})
		local Body = New("Frame", {
			Name = "Body",
			Size = UDim2.new(1, -148, 1, -38),
			Position = UDim2.new(0, 148, 0, 38),
			BackgroundColor3 = Color3.fromRGB(18, 18, 22),
			BorderSizePixel = 0,
			ZIndex = 999999,
			Parent = Main,
		})
		local BackgroundImg = nil
		local BackgroundVideo = nil
		local function ClearVideoBG()
			if BackgroundVideo and BackgroundVideo.Parent then
				BackgroundVideo:Destroy()
			end
			BackgroundVideo = nil
		end
		local function ClearBG()
			if BackgroundImg and BackgroundImg.Parent then
				BackgroundImg:Destroy()
			end
			BackgroundImg = nil
			ClearVideoBG()
			local sd = Main:FindFirstChild("SideDivider")
			if sd then
				sd.Visible = true
			end
			Body.BackgroundTransparency = 0
			TabsContainer.BackgroundTransparency = 0
		end
		local function SetBGImage(img)
			if type(img) ~= "string" or img == "" then
				ClearBG()
				return
			end
			ClearVideoBG()
			if not BackgroundImg or not BackgroundImg.Parent then
				BackgroundImg = New("ImageLabel", {
					Name = "BackgroundImg",
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Crop,
					ZIndex = 1,
					Parent = Main,
				})
			end
			local resolved = img
			if string.match(img, "^http") then
				pcall(function()
					local data = game:HttpGet(img)
					if writefile then
						local ext = string.match(img, "%.(%w+)$")
						local filename = "XHMUltraBG." .. (ext or "png")
						writefile(filename, data)
						if getcustomasset then
							resolved = getcustomasset(filename)
						end
					end
				end)
			end
			BackgroundImg.Image = resolved
			Body.BackgroundTransparency = 0.45
			TabsContainer.BackgroundTransparency = 0.45
			local sd = Main:FindFirstChild("SideDivider")
			if sd then
				sd.Visible = false
			end
		end
		local function SetBGVideo(url)
			if type(url) ~= "string" or url == "" then
				ClearBG()
				return
			end
			if BackgroundImg and BackgroundImg.Parent then
				BackgroundImg:Destroy()
			end
			BackgroundImg = nil
			ClearVideoBG()
			local asset = url
			if string.match(url, "^http") then
				pcall(function()
					local data = game:HttpGet(url)
					if writefile then
						local ext = string.match(url, "%.(%w+)$")
						local filename = "XHMUltraBG." .. (ext or "webm")
						writefile(filename, data)
						if getcustomasset then
							asset = getcustomasset(filename)
						end
					end
				end)
			end
			BackgroundVideo = New("VideoFrame", {
				Name = "BackgroundVideo",
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				Video = asset,
				Looped = true,
				Volume = 0,
				ZIndex = 1,
				Parent = Main,
			})
			pcall(function()
				BackgroundVideo:Play()
			end)
			Body.BackgroundTransparency = 0.45
			TabsContainer.BackgroundTransparency = 0.45
			local sd = Main:FindFirstChild("SideDivider")
			if sd then
				sd.Visible = false
			end
		end
		if type(options.BackgroundImage) == "string" and options.BackgroundImage ~= "" then
			SetBGImage(options.BackgroundImage)
		elseif type(options.BackgroundVideo) == "string" and options.BackgroundVideo ~= "" then
			SetBGVideo(options.BackgroundVideo)
		end
		local TopDivider = New("Frame", {
			Name = "TopDivider",
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(44, 44, 54),
			BorderSizePixel = 0,
			ZIndex = 1000000,
			Parent = Main,
		})
		local SideDivider = New("Frame", {
			Name = "SideDivider",
			Size = UDim2.new(0, 1, 1, -38),
			Position = UDim2.new(0, 148, 0, 38),
			BackgroundColor3 = Color3.fromRGB(44, 44, 54),
			BorderSizePixel = 0,
			ZIndex = 1000000,
			Parent = Main,
		})
		local TabButtons = {}
		local TabIndicator = New("Frame", {
			Name = "Indicator",
			Size = UDim2.new(0, 3, 0, 20),
			Position = UDim2.new(0, 0, 0, 17),
			BackgroundColor3 = Color3.fromRGB(90, 160, 255),
			BorderSizePixel = 0,
			Visible = false,
			Parent = TabsContainer,
		})
		New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = TabIndicator })
		local function SelectTab(button)
			for _, bt in pairs(TabButtons) do
				local text = bt:FindFirstChild("TextLabel")
				local ic = bt:FindFirstChild("Icon")
				if bt == button then
					text.TextColor3 = Color3.fromRGB(255, 255, 255)
					text.Font = Enum.Font.GothamBold
					if ic then
						ic.ImageColor3 = Color3.fromRGB(90, 160, 255)
					end
				else
					text.TextColor3 = Color3.fromRGB(130, 130, 140)
					text.Font = Enum.Font.GothamMedium
					if ic then
						ic.ImageColor3 = Color3.fromRGB(130, 130, 140)
					end
				end
			end
			TabIndicator.Visible = true
			TweenService:Create(TabIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, 0, 0, button.Position.Y.Offset + 7),
			}):Play()
		end
		local WindowDraggable = true
		local function DragWindow(bar)
			local dragging = false
			local dragStart = nil
			local startPos = nil
			local function Update(input)
				local delta = input.Position - dragStart
				Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
			local function IsPress(input)
				return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
			end
			bar.InputBegan:Connect(function(input)
				if WindowDraggable and IsPress(input) then
					dragging = true
					dragStart = input.Position
					startPos = Main.Position
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and WindowDraggable and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					Update(input)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if IsPress(input) then
					dragging = false
				end
			end)
		end
		DragWindow(TopBar)
		local DropdownGui = ScreenGui
		local function MakeDropdown(container, options)
			local text = options.name or "下拉框"
			local list = options.list or {}
			local default = options.default
			local callback = options.callback
			local ic = Library:GetIcon(options.icon)
			local multi = options.multi or false
			local searchEnabled = options.search or false
			local isLocked = options.locked or false
			local MenuWidth = options.menuWidth or 200
			local ItemHeight = 36
			local MenuPadding = 6
			local function OptionTitle(v)
				return (typeof(v) == "table") and (v.Title or tostring(v)) or tostring(v)
			end
			local function OptionIcon(v)
				return (typeof(v) == "table") and v.Icon or nil
			end
			local function OptionDesc(v)
				return (typeof(v) == "table") and v.Desc or nil
			end
			local function NormalizeDefault()
				if multi then
					if typeof(default) == "table" then
						return { default }
					elseif default then
						return { default }
					end
					return {}
				end
				return default
			end
			local Value = NormalizeDefault()
			local FunctionValueDisplay
			FunctionValueDisplay = function()
				if multi then
					local parts = {}
					local set = {}
					if typeof(Value) == "table" then
						for _, v in ipairs(Value) do
							local t = OptionTitle(v)
							set[t] = true
						end
					end
					for _, v in ipairs(list) do
						local t = OptionTitle(v)
						if set[t] then
							table.insert(parts, t)
						end
					end
					return (#parts > 0) and table.concat(parts, ", ") or "未选择"
				end
				return (Value ~= nil) and OptionTitle(Value) or "未选择"
			end
			local frame = New("Frame", {
				Name = text,
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = Color3.fromRGB(36, 36, 44),
				BorderSizePixel = 0,
				Parent = container,
			})
			New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = frame })
			if ic then
				New("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 14, 0, 10),
					BackgroundTransparency = 1,
					Image = ic,
					ImageColor3 = Color3.fromRGB(150, 160, 180),
					Parent = frame,
				})
			end
			local TitleLabel = New("TextLabel", {
				Name = "TextLabel",
				Size = UDim2.new(0.5, 0, 0, 36),
				Position = UDim2.new(0, ic and 40 or 14, 0, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = text,
				TextSize = 16,
				TextColor3 = Color3.fromRGB(230, 230, 236),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = frame,
			})
			local ValueLabel = New("TextLabel", {
				Name = "Selected",
				Size = UDim2.new(0.46, -28, 0, 36),
				Position = UDim2.new(0.54, 0, 0, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamSemibold,
				Text = FunctionValueDisplay(),
				TextSize = 15,
				TextColor3 = Color3.fromRGB(90, 160, 255),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = frame,
			})
			local Chevron = New("ImageLabel", {
				Name = "Chevron",
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(1, -22, 0.5, -7),
				BackgroundTransparency = 1,
				Image = Library:GetIcon("chevron-down"),
				ImageColor3 = Color3.fromRGB(160, 160, 170),
				ScaleType = Enum.ScaleType.Fit,
				Parent = frame,
			})
			Library:SetIcon(Chevron, "chevron-down", 12)
			local Trigger = New("TextButton", {
				Name = "Button",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Parent = frame,
			})
			local Menu = New("Frame", {
				Name = "Menu",
				Size = UDim2.new(0, MenuWidth, 0, 0),
				BackgroundColor3 = Color3.fromRGB(24, 24, 30),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Visible = false,
				ZIndex = 100000000,
				Parent = DropdownGui,
			})
			New("UIStroke", { Color = Color3.fromRGB(90, 90, 100), Thickness = 1, Parent = Menu })
			New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Menu })
			New("UIPadding", { PaddingLeft = UDim.new(0, MenuPadding), PaddingRight = UDim.new(0, MenuPadding), Parent = Menu })
			local ScrollList = New("ScrollingFrame", {
				Name = "List",
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, searchEnabled and 34 or 4),
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Color3.fromRGB(70, 70, 80),
				ScrollBarImageTransparency = 0.5,
				Parent = Menu,
			})
			New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Parent = ScrollList,
			})
			New("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, MenuPadding), PaddingRight = UDim.new(0, MenuPadding), Parent = ScrollList })
			local ScrollListLayout = ScrollList:FindFirstChildOfClass("UIListLayout")
			local MenuLayout = ScrollListLayout
			local SearchBox
			if searchEnabled then
				SearchBox = New("TextBox", {
					Name = "Search",
					Size = UDim2.new(1, -12, 0, 26),
					Position = UDim2.new(0, 0, 0, 4),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Font = Enum.Font.GothamMedium,
					Text = "",
					PlaceholderText = "搜索...",
					TextSize = 14,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					PlaceholderColor3 = Color3.fromRGB(110, 110, 120),
					ClearTextOnFocus = false,
					LayoutOrder = -1000,
					Parent = Menu,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SearchBox })
				New("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = SearchBox })
			end
			local Items = {}
			local Opened = false
			local OutsideConn = nil
			local function CloseMenu(instant)
				Opened = false
				Chevron.Rotation = 0
				if instant then
					Menu.Visible = false
					Menu.Size = UDim2.new(0, MenuWidth, 0, 0)
					return
				end
				TweenService:Create(Menu, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0, MenuWidth, 0, 0),
				}):Play()
				task.delay(0.15, function()
					if not Opened then
						Menu.Visible = false
					end
				end)
				Menu.BackgroundTransparency = 0.12
			end
			local function Rebuild(keepValue)
				if not keepValue then
					if multi then
						Value = {}
					else
						Value = default
					end
				end
				local query = searchEnabled and SearchBox and SearchBox.Text or ""
				for _, old in ipairs(Items) do
					if old.Parent then
						old:Destroy()
					end
				end
				Items = {}
				for idx, v in ipairs(list) do
					local title = OptionTitle(v)
					local desc = OptionDesc(v)
					local icon = OptionIcon(v)
					local iconAsset = icon and Library:GetIcon(icon)
					local itemLocked = isLocked or ((typeof(v) == "table") and v.Locked or false)
					local selected = false
					if multi and typeof(Value) == "table" then
						for _, sv in ipairs(Value) do
							if OptionTitle(sv) == title then
								selected = true
								break
							end
						end
					else
						selected = (Value ~= nil) and (OptionTitle(Value) == title) or false
					end
					local skipItem = (query ~= "") and (not string.find(string.lower(title), string.lower(query), 1, true))
					if not skipItem then
					local Item = New("TextButton", {
						Name = title,
						Size = UDim2.new(1, 0, 0, ItemHeight + (desc and 12 or 0)),
						BackgroundColor3 = Color3.fromRGB(38, 38, 46),
						BorderSizePixel = 0,
						AutoButtonColor = false,
						Text = "",
						LayoutOrder = idx,
						Parent = ScrollList,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Item })
					if iconAsset then
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 10, 0.5, -8),
							BackgroundTransparency = 1,
							Image = iconAsset,
							ImageColor3 = selected and Color3.fromRGB(90, 160, 255) or Color3.fromRGB(150, 160, 180),
							Parent = Item,
						})
						Library:SetIcon(Item:FindFirstChild("Icon"), icon, 10)
					end
					local ItemTitle = New("TextLabel", {
						Name = "Title",
						Size = UDim2.new(1, -(icon and 36 or 20), 0, desc and 16 or ItemHeight),
						Position = UDim2.new(0, icon and 36 or 14, 0, desc and 3 or 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = title,
						TextSize = 15,
						TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(225, 225, 232),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = Item,
					})
					if desc then
						New("TextLabel", {
							Name = "Desc",
							Size = UDim2.new(1, -(icon and 36 or 20), 0, 14),
							Position = UDim2.new(0, icon and 36 or 14, 0, 20),
							BackgroundTransparency = 1,
							Font = Enum.Font.GothamMedium,
							Text = desc,
							TextSize = 12,
							TextColor3 = Color3.fromRGB(150, 150, 165),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Parent = Item,
						})
					end
					Item.BackgroundColor3 = selected and Color3.fromRGB(48, 60, 92) or Color3.fromRGB(38, 38, 46)
					table.insert(Items, Item)
					Item.MouseButton1Click:Connect(function()
						if itemLocked then
							return
						end
						if multi then
							if not selected then
								if typeof(Value) ~= "table" then
									Value = {}
								end
								table.insert(Value, v)
							else
								if not (options.allowNone == false and #Value <= 1) then
									for i, sv in ipairs(Value) do
										if OptionTitle(sv) == title then
											table.remove(Value, i)
											break
										end
									end
								end
							end
						else
							Value = v
							CloseMenu(false)
						end
						ValueLabel.Text = FunctionValueDisplay()
						if callback then
							pcall(callback, multi and Value or Value, v, idx)
						end
						if not multi then
							Rebuild(false)
						end
					end)
					end
				end
				if #Items == 0 then
					local Empty = New("TextLabel", {
						Name = "Empty",
						Size = UDim2.new(1, 0, 0, 40),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = "无匹配选项",
						TextSize = 14,
						TextColor3 = Color3.fromRGB(150, 150, 165),
						Parent = ScrollList,
					})
					table.insert(Items, Empty)
				end
			end
			local function UpdatePosition()
				local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 600)
				local rightEdge = frame.AbsolutePosition.X + frame.AbsoluteSize.X
				local mw = Menu.AbsoluteSize.X
				if mw <= 0 then
					mw = MenuWidth
				end
				local left = rightEdge + 4
				if left + mw > viewport.X - 8 then
					left = rightEdge - mw - 4
					if left < 0 then
						left = 0
					end
				end
				local below = viewport.Y - (frame.AbsolutePosition.Y + frame.AbsoluteSize.Y)
				local req = ScrollListLayout.AbsoluteContentSize.Y + 12
				local y = frame.AbsolutePosition.Y + frame.AbsoluteSize.Y + 2
				if req > below then
					y = frame.AbsolutePosition.Y - req - 2
					if y < 0 then
						y = 0
					end
				end
				Menu.Position = UDim2.fromOffset(left, y)
			end
			local function OpenMenu()
				if isLocked then
					return
				end
				if Opened then
					CloseMenu(false)
					return
				end
				Opened = true
				Chevron.Rotation = 180
				Rebuild(false)
				Menu.Visible = true
				Menu.BackgroundTransparency = 0.12
				UpdatePosition()
				local maxContent = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 600) - 70
				local searchH = searchEnabled and 32 or 0
				local contentH = ScrollListLayout.AbsoluteContentSize.Y
				local listH = math.min(contentH, math.max(0, maxContent - searchH - MenuPadding * 2 - 8))
				ScrollList.AutomaticSize = Enum.AutomaticSize.None
				ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
				ScrollList.CanvasSize = UDim2.new(0, 0, 0, contentH)
				ScrollList.Size = UDim2.new(1, 0, 0, listH)
				local targetH = searchH + listH + MenuPadding * 2
				Menu.Size = UDim2.new(0, MenuWidth, 0, 0)
				Menu.BackgroundTransparency = 0.12
				TweenService:Create(Menu, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, MenuWidth, 0, targetH),
					BackgroundTransparency = 0.12,
				}):Play()
				if OutsideConn then
					OutsideConn:Disconnect()
				end
				OutsideConn = UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						local p = input.Position
						local mPos, mSize = Menu.AbsolutePosition, Menu.AbsoluteSize
						local fPos, fSize = frame.AbsolutePosition, frame.AbsoluteSize
						local inMenu = p.X >= mPos.X and p.X <= mPos.X + mSize.X and p.Y >= mPos.Y and p.Y <= mPos.Y + mSize.Y
						local inFrame = p.X >= fPos.X and p.X <= fPos.X + fSize.X and p.Y >= fPos.Y and p.Y <= fPos.Y + fSize.Y
						if Opened and not inMenu and not inFrame then
							CloseMenu(false)
							OutsideConn:Disconnect()
							OutsideConn = nil
						end
					end
				end)
			end
			Trigger.MouseButton1Click:Connect(function()
				if isLocked or (multi and #list == 0) then
					return
				end
				OpenMenu()
			end)
			if searchEnabled and SearchBox then
				SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
					Rebuild(false)
				end)
			end
			local dropObj = {}
			function dropObj:Get()
				return Value
			end
			function dropObj:SetValue(v)
				Value = v
				ValueLabel.Text = FunctionValueDisplay()
				Rebuild(false)
			end
			function dropObj:Refresh(newValues)
				if newValues then
					list = newValues
				end
				Rebuild(false)
			end
			function dropObj:Select(v)
				if v == nil then
					if multi then
						Value = {}
					else
						Value = nil
					end
				else
					Value = v
				end
				ValueLabel.Text = FunctionValueDisplay()
				if callback then
					pcall(callback, Value)
				end
				CloseMenu(false)
			end
			function dropObj:Open()
				OpenMenu()
			end
			function dropObj:Close()
				CloseMenu(true)
			end
			ValueLabel.Text = FunctionValueDisplay()
			return dropObj
		end
		local Tabs = {}
		local TabsList = {}
		local function CreateTab(name, icon)
			local TabButton = New("TextButton", {
				Name = name,
				Size = UDim2.new(1, -20, 0, 34),
				Position = UDim2.new(0, 10, 0, 10 + (#TabsList * 42)),
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				Parent = TabsContainer,
			})
			table.insert(TabButtons, TabButton)
			local TabIcon = Library:GetIcon(icon)
			local TabText = New("TextLabel", {
				Name = "TextLabel",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = name,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(130, 130, 140),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = TabButton,
			})
			New("UIPadding", { PaddingLeft = UDim.new(0, TabIcon and 40 or 14), Parent = TabText })
			if TabIcon then
				New("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 16, 0, 9),
					BackgroundTransparency = 1,
					Image = TabIcon,
					ImageColor3 = Color3.fromRGB(130, 130, 140),
					Parent = TabButton,
				})
			end
			local TabPage = New("ScrollingFrame", {
				Name = name,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Color3.fromRGB(70, 70, 80),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				Visible = false,
				Parent = Body,
			})
			local Layout = New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Parent = TabPage,
			})
			local Padding = New("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				Parent = TabPage,
			})
			local function OnTabClick()
				SelectTab(TabButton)
				for _, pg in pairs(Tabs) do
					pg.Visible = false
				end
				TabPage.Visible = true
			end
			TabButton.MouseButton1Click:Connect(OnTabClick)
			Tabs[name] = TabPage
			table.insert(TabsList, TabPage)
			local Tab = {}
			function Tab:AddSection(options)
				local text = options.name
				local desc = options.desc
				local SectionIcon = Library:GetIcon(options.icon)
				local Section = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = TabPage,
				})
				local Header = New("TextButton", {
					Name = "Header",
				Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Text = "",
					Parent = Section,
				})
				local HeaderIcon = nil
				if SectionIcon then
					HeaderIcon = New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0.5, -8),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Image = SectionIcon,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = Header,
					})
				end
				local HeaderCol = New("Frame", {
					Name = "TitleCol",
					Size = UDim2.new(1, -58, 0, 0),
					Position = UDim2.new(0, SectionIcon and 40 or 12, 0, 0),
					BackgroundTransparency = 1,
					Parent = Header,
				})
				local SectionText = New("TextLabel", {
					Name = "Text",
					Size = UDim2.new(1, 0, 0, 16),
					Position = UDim2.new(0, 0, 0, 3),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = HeaderCol,
				})
				local SectionDesc = New("TextLabel", {
					Name = "Desc",
					Size = UDim2.new(1, 0, 0, 12),
					Position = UDim2.new(0, 0, 0, 19),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = desc or "",
					TextSize = 12,
					TextColor3 = Color3.fromRGB(130, 130, 145),
					TextXAlignment = Enum.TextXAlignment.Left,
					Visible = desc ~= nil,
					Parent = HeaderCol,
				})
				local Chevron = New("ImageLabel", {
					Name = "Chevron",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(1, -30, 0, 9),
					BackgroundTransparency = 1,
					Image = Library:GetIcon("chevron-down"),
					ImageColor3 = Color3.fromRGB(140, 140, 155),
					ScaleType = Enum.ScaleType.Fit,
					Parent = Header,
				})
				Library:SetIcon(Chevron, "chevron-down", 12)
				local SectionContent = New("Frame", {
					Name = "Content",
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = Section,
				})
				New("Frame", {
					Name = "Divider",
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Color3.fromRGB(50, 50, 60),
					BorderSizePixel = 0,
					Parent = Section,
				})
				New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0),
					Parent = Section,
				})
				New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6),
					Parent = SectionContent,
				})
				New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 2), Parent = SectionContent })
				local SectionOpened = true
				local function SetSectionOpened(v)
					SectionOpened = v
					if v then
						SectionContent.Visible = true
						TweenService:Create(Chevron, TweenInfo.new(0.2), { Rotation = 0 }):Play()
					else
						SectionContent.Visible = false
						TweenService:Create(Chevron, TweenInfo.new(0.2), { Rotation = 180 }):Play()
					end
				end
				Header.MouseButton1Click:Connect(function()
					SetSectionOpened(not SectionOpened)
				end)
				local SectionObj = {}
				function SectionObj:AddButton(options)
					local text = options.name
					local callback = options.callback
					local ic = Library:GetIcon(options.icon)
					local Button = New("TextButton", {
						Name = text,
					Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						AutoButtonColor = false,
						Text = "",
						Parent = SectionContent,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Button })
					local ButtonText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = text,
						TextSize = 16,
						TextColor3 = Color3.fromRGB(230, 230, 236),
						Parent = Button,
					})
					if ic then
						ButtonText.TextXAlignment = Enum.TextXAlignment.Left
						New("UIPadding", { PaddingLeft = UDim.new(0, 40), Parent = ButtonText })
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 14, 0, 8),
							BackgroundTransparency = 1,
							Image = ic,
							ImageColor3 = Color3.fromRGB(150, 160, 180),
							Parent = Button,
						})
					end
					local MouseIcon = New("ImageLabel", {
						Name = "MouseIcon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(1, -24, 0.5, -8),
						BackgroundTransparency = 1,
						Image = Library:GetIcon("mouse-pointer"),
						ImageColor3 = Color3.fromRGB(120, 120, 130),
						Parent = Button,
					})
					Library:SetIcon(MouseIcon, "mouse-pointer", 10)
					local OriginalColor = Button.BackgroundColor3
					Button.MouseEnter:Connect(function()
						TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(52, 52, 62) }):Play()
						TweenService:Create(MouseIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(230, 230, 236) }):Play()
					end)
					Button.MouseLeave:Connect(function()
						TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = OriginalColor }):Play()
						TweenService:Create(MouseIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(120, 120, 130) }):Play()
					end)
					Button.MouseButton1Down:Connect(function()
						TweenService:Create(Button, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(80, 80, 100) }):Play()
					end)
					Button.MouseButton1Up:Connect(function()
						TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(52, 52, 62) }):Play()
					end)
					Button.MouseButton1Click:Connect(function()
						if callback then
							pcall(callback)
						end
					end)
					return Button
				end
				function SectionObj:AddToggle(options)
					local text = options.name
					local default = options.default
					local callback = options.callback
					local ic = Library:GetIcon(options.icon)
					local Toggle = New("Frame", {
						Name = text,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						Parent = SectionContent,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Toggle })
					local ToggleText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(1, -56, 0, 36),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = text,
						TextSize = 16,
						TextColor3 = Color3.fromRGB(230, 230, 236),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = Toggle,
					})
					New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = ToggleText })
					if ic then
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 14, 0, 10),
							BackgroundTransparency = 1,
							Image = ic,
							ImageColor3 = Color3.fromRGB(150, 160, 180),
							Parent = Toggle,
						})
					end
					local Holder = New("Frame", {
						Name = "Holder",
						Size = UDim2.new(0, 40, 0, 20),
						Position = UDim2.new(1, -48, 0, 8),
						BackgroundColor3 = Color3.fromRGB(55, 55, 66),
						BorderSizePixel = 0,
						Parent = Toggle,
					})
					New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Holder })
					local ToggleButton = New("TextButton", {
						Name = "Button",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 2, 0, 2),
						BackgroundColor3 = Color3.fromRGB(210, 210, 220),
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						Parent = Holder,
					})
					New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleButton })
					local Value = default or false
					local function SetValue(v, animate)
						Value = v
						if v then
							TweenService:Create(Holder, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(90, 160, 255) }):Play()
							TweenService:Create(ToggleButton, TweenInfo.new(0.2), { Position = UDim2.new(0, 22, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
						else
							TweenService:Create(Holder, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(55, 55, 66) }):Play()
							TweenService:Create(ToggleButton, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(210, 210, 220) }):Play()
						end
						if callback then
							pcall(callback, v)
						end
					end
					local RowButton = New("TextButton", {
						Name = "RowButton",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						Parent = Toggle,
					})
					RowButton.MouseButton1Click:Connect(function()
						SetValue(not Value)
					end)
					SetValue(Value, true)
					local ToggleObj = {
						Value = Value,
						Set = SetValue,
					}
					function ToggleObj:Get()
						return Value
					end
					function ToggleObj:SetValue(v)
						SetValue(v)
					end
					return ToggleObj
				end
				function SectionObj:AddLabel(options)
					local text = options.name
					local color = options.color
					local ic = Library:GetIcon(options.icon)
					local Label = New("Frame", {
						Name = text,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						Parent = SectionContent,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Label })
					local LabelText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = text,
						TextSize = 16,
						TextColor3 = color or Color3.fromRGB(230, 230, 236),
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						Parent = Label,
					})
					New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, ic and 40 or 14), PaddingRight = UDim.new(0, 10), Parent = LabelText })
					if ic then
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 14, 0.5, -8),
							AnchorPoint = Vector2.new(0, 0),
							BackgroundTransparency = 1,
							Image = ic,
							ImageColor3 = Color3.fromRGB(150, 160, 180),
							Parent = Label,
						})
					end
					local LabelObj = {
						Text = LabelText,
					}
					function LabelObj:SetText(t)
						LabelText.Text = t
					end
					function LabelObj:SetColor(c)
						LabelText.TextColor3 = c
					end
					return LabelObj
				end
				function SectionObj:AddSlider(options)
					local text = options.name
					local min = options.min
					local max = options.max
					local default = options.default
					local callback = options.callback
					local ic = Library:GetIcon(options.icon)
					local Slider = New("Frame", {
						Name = text,
					Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						Parent = SectionContent,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Slider })
					local SliderText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(0.56, 0, 0, 20),
						Position = UDim2.new(0, ic and 40 or 14, 0, 6),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = text,
						TextSize = 16,
						TextColor3 = Color3.fromRGB(230, 230, 236),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = Slider,
					})
					if ic then
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 14, 0, 8),
							BackgroundTransparency = 1,
							Image = ic,
							ImageColor3 = Color3.fromRGB(150, 160, 180),
							Parent = Slider,
						})
					end
					local ValueBox = New("TextBox", {
						Name = "ValueText",
						Size = UDim2.new(0.3, -16, 0, 22),
						Position = UDim2.new(0.72, 0, 0, 5),
						BackgroundColor3 = Color3.fromRGB(22, 22, 28),
						BorderSizePixel = 0,
						Font = Enum.Font.GothamBold,
						Text = tostring(default or Min or 0),
						TextSize = 15,
						TextColor3 = Color3.fromRGB(90, 160, 255),
						PlaceholderText = "数值",
						PlaceholderColor3 = Color3.fromRGB(110, 110, 120),
						TextXAlignment = Enum.TextXAlignment.Center,
						ClearTextOnFocus = true,
						Parent = Slider,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ValueBox })
					local MinusBtn = New("TextButton", {
						Name = "Minus",
						Size = UDim2.new(0, 18, 0, 16),
						Position = UDim2.new(0.66, -20, 0, 6),
						BackgroundColor3 = Color3.fromRGB(55, 55, 66),
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						Parent = Slider,
					})
					New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = MinusBtn })
					local MinusIcon = New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 12, 0, 12),
						Position = UDim2.new(0.5, -6, 0.5, -6),
						BackgroundTransparency = 1,
						Image = Library:GetIcon("minus"),
						ImageColor3 = Color3.fromRGB(200, 200, 210),
						ScaleType = Enum.ScaleType.Fit,
						Parent = MinusBtn,
					})
					Library:SetIcon(MinusIcon, "minus", 12)
					local PlusBtn = New("TextButton", {
						Name = "Plus",
						Size = UDim2.new(0, 18, 0, 16),
						Position = UDim2.new(0.66, 4, 0, 6),
						BackgroundColor3 = Color3.fromRGB(55, 55, 66),
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						Parent = Slider,
					})
					New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = PlusBtn })
					local PlusIcon = New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 12, 0, 12),
						Position = UDim2.new(0.5, -6, 0.5, -6),
						BackgroundTransparency = 1,
						Image = Library:GetIcon("plus"),
						ImageColor3 = Color3.fromRGB(200, 200, 210),
						ScaleType = Enum.ScaleType.Fit,
						Parent = PlusBtn,
					})
					Library:SetIcon(PlusIcon, "plus", 12)
					local SliderBar = New("Frame", {
						Name = "Bar",
						Size = UDim2.new(1, -24, 0, 4),
						Position = UDim2.new(0, 12, 0, 28),
						BackgroundColor3 = Color3.fromRGB(55, 55, 66),
						BorderSizePixel = 0,
						Parent = Slider,
					})
					New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderBar })
					local SliderFill = New("Frame", {
						Name = "Fill",
						Size = UDim2.new(0, 0, 1, 0),
						BackgroundColor3 = Color3.fromRGB(90, 160, 255),
						BorderSizePixel = 0,
						Parent = SliderBar,
					})
					New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderFill })
					local SliderGrab = New("Frame", {
						Name = "Grab",
						Size = UDim2.new(0, 12, 0, 12),
						Position = UDim2.new(0, -6, 0, -4),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						Parent = SliderBar,
					})
					New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderGrab })
					local Min = min or 0
					local Max = max or 100
					local Current = default or Min
					local Step = options.step or math.max(1, math.round((Max - Min) / 100))
					local function UpdateSlider(x)
						local relX = math.clamp((x - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
						Current = math.round(Min + ((Max - Min) * relX))
						local displayRelX = (Current - Min) / (Max - Min)
						ValueBox.Text = tostring(Current)
						SliderFill.Size = UDim2.new(displayRelX, 0, 1, 0)
						SliderGrab.Position = UDim2.new(displayRelX, -6, 0, -4)
						if callback then
							pcall(callback, Current)
						end
					end
					local function ApplyValue(v)
						v = math.clamp(math.round(v), Min, Max)
						local displayRelX = (v - Min) / (Max - Min)
						Current = v
						ValueBox.Text = tostring(v)
						SliderFill.Size = UDim2.new(displayRelX, 0, 1, 0)
						SliderGrab.Position = UDim2.new(displayRelX, -6, 0, -4)
						if callback then
							pcall(callback, v)
						end
						return v
					end
					local dragging = false
					local function IsPress(input)
						return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
					end
					local function StopDrag(input)
						if IsPress(input) then
							dragging = false
						end
					end
					Slider.InputBegan:Connect(function(input)
						if IsPress(input) then
							dragging = true
							UpdateSlider(UserInputService:GetMouseLocation().X)
							if input.UserInputType == Enum.UserInputType.Touch then
								pcall(function() input.Handled = true end)
							end
						end
					end)
					Slider.InputChanged:Connect(function(input)
						if dragging and input.UserInputType == Enum.UserInputType.Touch then
							pcall(function() input.Handled = true end)
						end
					end)
					Slider.InputEnded:Connect(StopDrag)
					UserInputService.InputEnded:Connect(StopDrag)
					RunService.RenderStepped:Connect(function()
						if dragging then
							UpdateSlider(UserInputService:GetMouseLocation().X)
						end
					end)
					MinusBtn.MouseButton1Click:Connect(function()
						ApplyValue(Current - Step)
					end)
					PlusBtn.MouseButton1Click:Connect(function()
						ApplyValue(Current + Step)
					end)
					ValueBox.FocusLost:Connect(function(enter)
						local n = tonumber(ValueBox.Text)
						if n then
							ApplyValue(n)
						else
							ValueBox.Text = tostring(Current)
						end
						if not enter then
							ValueBox:ReleaseFocus()
						end
					end)
					local SliderObj = {}
					function SliderObj:Get()
						return Current
					end
					function SliderObj:SetValue(v)
						ApplyValue(v)
					end
					SliderObj:SetValue(Current)
					return SliderObj
				end
				function SectionObj:AddTextBox(options)
					local text = options.name
					local default = options.default
					local callback = options.callback
					local ic = Library:GetIcon(options.icon)
					local BoxFrame = New("Frame", {
						Name = text,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						Parent = SectionContent,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = BoxFrame })
					local BoxTitle = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(0.4, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = text,
						TextSize = 16,
						TextColor3 = Color3.fromRGB(230, 230, 236),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = BoxFrame,
					})
					New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = BoxTitle })
					if ic then
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 14, 0, 10),
							BackgroundTransparency = 1,
							Image = ic,
							ImageColor3 = Color3.fromRGB(150, 160, 180),
							Parent = BoxFrame,
						})
					end
					local TextBox = New("TextBox", {
						Name = "TextBox",
						Size = UDim2.new(0.6, -12, 0, 24),
						Position = UDim2.new(0.4, 0, 0, 6),
						BackgroundColor3 = Color3.fromRGB(22, 22, 28),
						BorderSizePixel = 0,
						Font = Enum.Font.GothamMedium,
						Text = default or "",
PlaceholderText = "请输入",
						TextSize = 16,
						TextColor3 = Color3.fromRGB(230, 230, 236),
						PlaceholderColor3 = Color3.fromRGB(110, 110, 120),
						TextXAlignment = Enum.TextXAlignment.Left,
						ClearTextOnFocus = false,
						Parent = BoxFrame,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TextBox })
					New("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = TextBox })
					TextBox.FocusLost:Connect(function()
						if callback then
							pcall(callback, TextBox.Text)
						end
					end)
					local BoxObj = {}
					function BoxObj:SetText(t)
						TextBox.Text = t
					end
					function BoxObj:Get()
						return TextBox.Text
					end
					return BoxObj
				end
				function SectionObj:AddDropdown(options)
					return MakeDropdown(SectionContent, options)
				end
				function SectionObj:AddSeparator()
					local Sep = New("Frame", {
						Name = "Separator",
						Size = UDim2.new(1, 0, 0, 1),
						BackgroundColor3 = Color3.fromRGB(45, 45, 54),
						BorderSizePixel = 0,
						Parent = SectionContent,
					})
					return Sep
				end
				function SectionObj:AddParagraph(options)
					return MakeParagraphPanel(SectionContent, options)
				end
				function SectionObj:AddColorpicker(options)
					return MakeColorpickerPanel(SectionContent, options)
				end
				function SectionObj:AddTag(options)
					return MakeTag(SectionContent, options)
				end
				return SectionObj
			end
			function Tab:AddLabel(options)
				local text = options.name
				local color = options.color
				local ic = Library:GetIcon(options.icon)
				local Label = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Label })
				local LabelText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = color or Color3.fromRGB(230, 230, 236),
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					Parent = Label,
				})
				New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, ic and 40 or 14), PaddingRight = UDim.new(0, 10), Parent = LabelText })
				if ic then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0.5, -8),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 1,
						Image = ic,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = Label,
					})
				end
				local LabelObj = {
					Text = LabelText,
				}
				function LabelObj:SetText(t)
					LabelText.Text = t
				end
				function LabelObj:SetColor(c)
					LabelText.TextColor3 = c
				end
				return LabelObj
			end
			function Tab:AddButton(options)
				local text = options.name
				local callback = options.callback
				local ic = Library:GetIcon(options.icon)
				local Button = New("TextButton", {
					Name = text,
				Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Text = "",
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Button })
				local ButtonText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					Parent = Button,
				})
				if ic then
					ButtonText.TextXAlignment = Enum.TextXAlignment.Left
					New("UIPadding", { PaddingLeft = UDim.new(0, 40), Parent = ButtonText })
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 8),
						BackgroundTransparency = 1,
						Image = ic,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = Button,
					})
				end
				local MouseIcon = New("ImageLabel", {
					Name = "MouseIcon",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(1, -24, 0.5, -8),
					BackgroundTransparency = 1,
					Image = Library:GetIcon("mouse-pointer"),
					ImageColor3 = Color3.fromRGB(120, 120, 130),
					Parent = Button,
				})
				Library:SetIcon(MouseIcon, "mouse-pointer", 10)
				local OriginalColor = Button.BackgroundColor3
				Button.MouseEnter:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(52, 52, 62) }):Play()
					TweenService:Create(MouseIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(230, 230, 236) }):Play()
				end)
				Button.MouseLeave:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = OriginalColor }):Play()
					TweenService:Create(MouseIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(120, 120, 130) }):Play()
				end)
				Button.MouseButton1Down:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(80, 80, 100) }):Play()
				end)
				Button.MouseButton1Up:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(52, 52, 62) }):Play()
				end)
				Button.MouseButton1Click:Connect(function()
					if callback then
						pcall(callback)
					end
				end)
				return Button
			end
			function Tab:AddToggle(options)
				local text = options.name
				local default = options.default
				local callback = options.callback
				local ic = Library:GetIcon(options.icon)
				local Toggle = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Toggle })
				local ToggleText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(1, -56, 0, 36),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = Toggle,
				})
				New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = ToggleText })
				if ic then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 10),
						BackgroundTransparency = 1,
						Image = ic,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = Toggle,
					})
				end
				local Holder = New("Frame", {
					Name = "Holder",
					Size = UDim2.new(0, 40, 0, 20),
					Position = UDim2.new(1, -48, 0, 8),
					BackgroundColor3 = Color3.fromRGB(55, 55, 66),
					BorderSizePixel = 0,
					Parent = Toggle,
				})
				New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Holder })
				local ToggleButton = New("TextButton", {
					Name = "Button",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 2, 0, 2),
					BackgroundColor3 = Color3.fromRGB(210, 210, 220),
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Parent = Holder,
				})
				New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleButton })
				local Value = default or false
				local function SetValue(v)
					Value = v
					if v then
						TweenService:Create(Holder, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(90, 160, 255) }):Play()
						TweenService:Create(ToggleButton, TweenInfo.new(0.2), { Position = UDim2.new(0, 22, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
					else
						TweenService:Create(Holder, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(55, 55, 66) }):Play()
						TweenService:Create(ToggleButton, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(210, 210, 220) }):Play()
					end
					if callback then
						pcall(callback, v)
					end
				end
				local RowButton = New("TextButton", {
					Name = "RowButton",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false,
					Parent = Toggle,
				})
				RowButton.MouseButton1Click:Connect(function()
					SetValue(not Value)
				end)
				SetValue(Value)
				local ToggleObj = {
					Value = Value,
					Set = SetValue,
				}
				function ToggleObj:Get()
					return Value
				end
				function ToggleObj:SetValue(v)
					SetValue(v)
				end
				return ToggleObj
			end
			function Tab:AddSlider(options)
				local text = options.name
				local min = options.min
				local max = options.max
				local default = options.default
				local callback = options.callback
				local ic = Library:GetIcon(options.icon)
				local Slider = New("Frame", {
					Name = text,
				Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Slider })
				local SliderText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(0.56, 0, 0, 20),
					Position = UDim2.new(0, ic and 40 or 14, 0, 6),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = Slider,
				})
				if ic then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 8),
						BackgroundTransparency = 1,
						Image = ic,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = Slider,
					})
				end
				local ValueBox = New("TextBox", {
					Name = "ValueText",
					Size = UDim2.new(0.3, -16, 0, 22),
					Position = UDim2.new(0.72, 0, 0, 5),
					BackgroundColor3 = Color3.fromRGB(22, 22, 28),
					BorderSizePixel = 0,
					Font = Enum.Font.GothamBold,
					Text = tostring(default or Min or 0),
					TextSize = 15,
					TextColor3 = Color3.fromRGB(90, 160, 255),
					PlaceholderText = "数值",
					PlaceholderColor3 = Color3.fromRGB(110, 110, 120),
					TextXAlignment = Enum.TextXAlignment.Center,
					ClearTextOnFocus = true,
					Parent = Slider,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ValueBox })
				local MinusBtn = New("TextButton", {
					Name = "Minus",
					Size = UDim2.new(0, 18, 0, 16),
					Position = UDim2.new(0.66, -20, 0, 6),
					BackgroundColor3 = Color3.fromRGB(55, 55, 66),
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Parent = Slider,
				})
				New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = MinusBtn })
				local MinusIcon = New("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 12, 0, 12),
					Position = UDim2.new(0.5, -6, 0.5, -6),
					BackgroundTransparency = 1,
					Image = Library:GetIcon("minus"),
					ImageColor3 = Color3.fromRGB(200, 200, 210),
					ScaleType = Enum.ScaleType.Fit,
					Parent = MinusBtn,
				})
				Library:SetIcon(MinusIcon, "minus", 12)
				local PlusBtn = New("TextButton", {
					Name = "Plus",
					Size = UDim2.new(0, 18, 0, 16),
					Position = UDim2.new(0.66, 4, 0, 6),
					BackgroundColor3 = Color3.fromRGB(55, 55, 66),
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Parent = Slider,
				})
				New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = PlusBtn })
				local PlusIcon = New("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 12, 0, 12),
					Position = UDim2.new(0.5, -6, 0.5, -6),
					BackgroundTransparency = 1,
					Image = Library:GetIcon("plus"),
					ImageColor3 = Color3.fromRGB(200, 200, 210),
					ScaleType = Enum.ScaleType.Fit,
					Parent = PlusBtn,
				})
				Library:SetIcon(PlusIcon, "plus", 12)
				local SliderBar = New("Frame", {
					Name = "Bar",
					Size = UDim2.new(1, -24, 0, 4),
					Position = UDim2.new(0, 12, 0, 28),
					BackgroundColor3 = Color3.fromRGB(55, 55, 66),
					BorderSizePixel = 0,
					Parent = Slider,
				})
				New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderBar })
				local SliderFill = New("Frame", {
					Name = "Fill",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(90, 160, 255),
					BorderSizePixel = 0,
					Parent = SliderBar,
				})
				New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderFill })
				local SliderGrab = New("Frame", {
					Name = "Grab",
					Size = UDim2.new(0, 12, 0, 12),
					Position = UDim2.new(0, -6, 0, -4),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					Parent = SliderBar,
				})
				New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderGrab })
				local Min = min or 0
				local Max = max or 100
				local Current = default or Min
				local Step = options.step or math.max(1, math.round((Max - Min) / 100))
				local function UpdateSlider(x)
					local relX = math.clamp((x - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					Current = math.round(Min + ((Max - Min) * relX))
					local displayRelX = (Current - Min) / (Max - Min)
					ValueBox.Text = tostring(Current)
					SliderFill.Size = UDim2.new(displayRelX, 0, 1, 0)
					SliderGrab.Position = UDim2.new(displayRelX, -6, 0, -4)
					if callback then
						pcall(callback, Current)
					end
				end
				local function ApplyValue(v)
					v = math.clamp(math.round(v), Min, Max)
					local displayRelX = (v - Min) / (Max - Min)
					Current = v
					ValueBox.Text = tostring(v)
					SliderFill.Size = UDim2.new(displayRelX, 0, 1, 0)
					SliderGrab.Position = UDim2.new(displayRelX, -6, 0, -4)
					if callback then
						pcall(callback, v)
					end
					return v
				end
				local dragging = false
				local function IsPress(input)
					return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
				end
				local function StopDrag(input)
					if IsPress(input) then
						dragging = false
					end
				end
				Slider.InputBegan:Connect(function(input)
					if IsPress(input) then
						dragging = true
						UpdateSlider(UserInputService:GetMouseLocation().X)
						if input.UserInputType == Enum.UserInputType.Touch then
							pcall(function() input.Handled = true end)
						end
					end
				end)
				Slider.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.Touch then
						pcall(function() input.Handled = true end)
					end
				end)
				Slider.InputEnded:Connect(StopDrag)
				UserInputService.InputEnded:Connect(StopDrag)
				RunService.RenderStepped:Connect(function()
					if dragging then
						UpdateSlider(UserInputService:GetMouseLocation().X)
					end
				end)
				MinusBtn.MouseButton1Click:Connect(function()
					ApplyValue(Current - Step)
				end)
				PlusBtn.MouseButton1Click:Connect(function()
					ApplyValue(Current + Step)
				end)
				ValueBox.FocusLost:Connect(function(enter)
					local n = tonumber(ValueBox.Text)
					if n then
						ApplyValue(n)
					else
						ValueBox.Text = tostring(Current)
					end
					if not enter then
						ValueBox:ReleaseFocus()
					end
				end)
				local SliderObj = {}
				function SliderObj:Get()
					return Current
				end
				function SliderObj:SetValue(v)
					ApplyValue(v)
				end
				SliderObj:SetValue(Current)
				return SliderObj
			end
			function Tab:AddTextBox(options)
				local text = options.name
				local default = options.default
				local callback = options.callback
				local ic = Library:GetIcon(options.icon)
				local BoxFrame = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = BoxFrame })
				local BoxTitle = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(0.4, 0, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = BoxFrame,
				})
				New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = BoxTitle })
				if ic then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 10),
						BackgroundTransparency = 1,
						Image = ic,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = BoxFrame,
					})
				end
				local TextBox = New("TextBox", {
					Name = "TextBox",
					Size = UDim2.new(0.6, -12, 0, 24),
					Position = UDim2.new(0.4, 0, 0, 6),
					BackgroundColor3 = Color3.fromRGB(22, 22, 28),
					BorderSizePixel = 0,
					Font = Enum.Font.GothamMedium,
					Text = default or "",
					PlaceholderText = "请输入",
					TextSize = 16,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					PlaceholderColor3 = Color3.fromRGB(110, 110, 120),
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					Parent = BoxFrame,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TextBox })
				New("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = TextBox })
				TextBox.FocusLost:Connect(function()
					if callback then
						pcall(callback, TextBox.Text)
					end
				end)
				local BoxObj = {}
				function BoxObj:SetText(t)
					TextBox.Text = t
				end
				function BoxObj:Get()
					return TextBox.Text
				end
				return BoxObj
			end
			function Tab:AddDropdown(options)
				return MakeDropdown(TabPage, options)
			end
			function Tab:AddKeybind(options)
				local text = options.name
				local default = options.default
				local callback = options.callback
				local ic = Library:GetIcon(options.icon)
				local KeybindFrame = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeybindFrame })
				local KeybindText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(1, -70, 0, 36),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = KeybindFrame,
				})
				New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = KeybindText })
				if ic then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 10),
						BackgroundTransparency = 1,
						Image = ic,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = KeybindFrame,
					})
				end
				local KeyButton = New("TextButton", {
					Name = "KeyButton",
					Size = UDim2.new(0, 60, 0, 24),
					Position = UDim2.new(1, -68, 0, 6),
					BackgroundColor3 = Color3.fromRGB(22, 22, 28),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Text = tostring(default or "未绑定"),
					Font = Enum.Font.GothamSemibold,
					TextSize = 15,
					TextColor3 = Color3.fromRGB(200, 200, 210),
					Parent = KeybindFrame,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyButton })
				local Binding = false
				local CurrentKey = default or nil
				local function KeyToString(key, code)
					if code == Enum.UserInputType.Keyboard then
						return key.Name
					elseif code == Enum.UserInputType.MouseButton1 then
						return "M1"
					elseif code == Enum.UserInputType.MouseButton2 then
						return "M2"
					elseif code == Enum.UserInputType.MouseButton3 then
						return "M3"
					end
					return "未绑定"
				end
				local InputConnection
				KeyButton.MouseButton1Click:Connect(function()
					Binding = true
					KeyButton.Text = "..."
					if InputConnection then
						InputConnection:Disconnect()
					end
					InputConnection = UserInputService.InputBegan:Connect(function(input, gpe)
						if gpe then
							return
						end
						local key = input.KeyCode
						local inputType = input.UserInputType
						if key ~= Enum.KeyCode.Unknown or inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.MouseButton2 or inputType == Enum.UserInputType.MouseButton3 then
							CurrentKey = { Key = key, Type = inputType }
							KeyButton.Text = KeyToString(key, inputType)
							Binding = false
							InputConnection:Disconnect()
							InputConnection = nil
							if callback then
								pcall(callback, KeyButton.Text)
							end
						end
					end)
				end)
				local KeyObj = {}
				function KeyObj:Get()
					return KeyButton.Text
				end
				function KeyObj:SetKey(t)
					KeyButton.Text = t
				end
				return KeyObj
			end
			function Tab:AddParagraph(options)
				return MakeParagraphPanel(TabPage, options)
			end
			function Tab:AddColorpicker(options)
				return MakeColorpickerPanel(TabPage, options)
			end
			function Tab:AddTag(options)
				return MakeTag(TabPage, options)
			end
			if #TabButtons == 1 then
				OnTabClick()
			end
			return Tab
		end
		local function RestoreWindow()
			if not Minimized then
				return
			end
			Minimized = false
			MinimizeIcon.Image = Library:GetIcon("minus")
			TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = size }):Play()
			task.wait(0.15)
			TabsContainer.Visible = true
			Body.Visible = true
		end
		local function MinimizeWindow()
			if Minimized then
				RestoreWindow()
				return
			end
			Minimized = true
			MinimizeIcon.Image = Library:GetIcon("maximize")
			TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 38) }):Play()
			TabsContainer.Visible = false
			Body.Visible = false
		end
		MinimizeButton.MouseButton1Click:Connect(MinimizeWindow)
		local function CloseWindow()
			Opened = false
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
			}):Play()
			task.wait(0.3)
			ScreenGui:Destroy()
		end
		local ConfirmShown = false
		local ConfirmOverlay = nil
		local ConfirmPanel = nil
		local ConfirmSavedDrag = true
		local ConfirmWidth = 380
		local ConfirmHeight = 260
		local function CloseConfirmUI()
			if not ConfirmOverlay or not ConfirmOverlay.Parent then
				return
			end
			ConfirmShown = false
			WindowDraggable = ConfirmSavedDrag
			local overlay = ConfirmOverlay
			local panel = ConfirmPanel
			ConfirmOverlay = nil
			ConfirmPanel = nil
			TweenService:Create(overlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
			if panel then
				TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0),
				}):Play()
			end
			task.delay(0.3, function()
				if overlay.Parent then
					overlay:Destroy()
				end
			end)
		end
		local function ShowConfirmUI()
			if ConfirmShown then
				return
			end
			if Minimized then
				RestoreWindow()
				task.wait(0.3)
			end
			ConfirmShown = true
			ConfirmSavedDrag = WindowDraggable
			WindowDraggable = false
			ConfirmOverlay = New("Frame", {
				Name = "ConfirmOverlay",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2000000,
				Parent = Main,
			})
			ConfirmPanel = New("Frame", {
				Name = "ConfirmPanel",
				Size = UDim2.new(0, ConfirmWidth, 0, ConfirmHeight),
				Position = UDim2.new(0.5, -ConfirmWidth / 2, 0.5, -ConfirmHeight / 2),
				BackgroundColor3 = Color3.fromRGB(26, 26, 31),
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 2000001,
				Parent = ConfirmOverlay,
			})
			New("UIStroke", { Color = Color3.fromRGB(235, 235, 240), Thickness = 1, Parent = ConfirmPanel })
			local WarnIcon = New("ImageLabel", {
				Name = "WarnIcon",
				Size = UDim2.new(0, 44, 0, 44),
				Position = UDim2.new(0.5, -22, 0, 22),
				BackgroundTransparency = 1,
				Image = Library:GetIcon("triangle-alert"),
				ImageColor3 = Color3.fromRGB(255, 180, 60),
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 2000002,
				Parent = ConfirmPanel,
			})
			Library:SetIcon(WarnIcon, "triangle-alert", 10)
			New("Frame", {
				Name = "Divider",
				Size = UDim2.new(1, -48, 0, 1),
				Position = UDim2.new(0, 24, 0, 82),
				BackgroundColor3 = Color3.fromRGB(70, 70, 80),
				BorderSizePixel = 0,
				ZIndex = 2000002,
				Parent = ConfirmPanel,
			})
			local ConfirmText = New("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -48, 0, 116),
				Position = UDim2.new(0, 24, 0, 94),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = "你确定关闭这个脚本吗？关闭后无法打开这个脚本。",
				TextSize = 28,
				TextColor3 = Color3.fromRGB(235, 235, 240),
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 2000002,
				Parent = ConfirmPanel,
			})
			local function MakeConfirmButton(text, pos, iconName, bg)
				local Btn = New("TextButton", {
					Size = UDim2.new(0, 150, 0, 40),
					Position = pos,
					BackgroundColor3 = bg,
					AutoButtonColor = false,
					Text = "",
					ZIndex = 2000002,
					Parent = ConfirmPanel,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
				local Ic = New("ImageLabel", {
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 12, 0.5, -8),
					BackgroundTransparency = 1,
					Image = Library:GetIcon(iconName),
					ImageColor3 = Color3.fromRGB(235, 235, 240),
					ScaleType = Enum.ScaleType.Fit,
					Parent = Btn,
				})
				Library:SetIcon(Ic, iconName, 10)
				New("TextLabel", {
					Size = UDim2.new(1, -36, 1, 0),
					Position = UDim2.new(0, 36, 0, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamSemibold,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(235, 235, 240),
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = Btn,
				})
				return Btn
			end
			local CancelBtn = MakeConfirmButton("取消", UDim2.new(0, 30, 1, -54), "x", Color3.fromRGB(52, 52, 60))
			local OkBtn = MakeConfirmButton("确认", UDim2.new(0, 200, 1, -54), "check", Color3.fromRGB(190, 60, 60))
			CancelBtn.MouseButton1Click:Connect(CloseConfirmUI)
			OkBtn.MouseButton1Click:Connect(function()
				CloseConfirmUI()
				CloseWindow()
			end)
			ConfirmPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
			ConfirmPanel.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(ConfirmOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.6 }):Play()
			TweenService:Create(ConfirmPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, ConfirmWidth, 0, ConfirmHeight),
				Position = UDim2.new(0.5, -ConfirmWidth / 2, 0.5, -ConfirmHeight / 2),
			}):Play()
		end
		CloseButton.MouseButton1Click:Connect(ShowConfirmUI)
		MinimizeButton.MouseEnter:Connect(function()
			TweenService:Create(MinimizeIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
		end)
		MinimizeButton.MouseLeave:Connect(function()
			TweenService:Create(MinimizeIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(160, 160, 170) }):Play()
		end)
		CloseButton.MouseEnter:Connect(function()
			TweenService:Create(CloseIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(255, 120, 120) }):Play()
		end)
		CloseButton.MouseLeave:Connect(function()
			TweenService:Create(CloseIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(160, 160, 170) }):Play()
		end)
		local Window = {
			SearchBox = nil,
			SearchList = nil,
			SearchToggle = nil,
			SearchPanel = nil,
			SearchInited = false,
			SearchOpen = false,
			Title = title,
			Icon = Logo.Image,
		}
		local function SearchContains(str, q)
			if not str or not q or q == "" then
				return false
			end
			return string.find(string.lower(str), string.lower(q), 1, true) ~= nil
		end
		local function SearchIsComponent(node)
			if node.Name == "" then
				return false
			end
			local lbl = node:FindFirstChild("TextLabel") or node:FindFirstChild("Title")
			return lbl and lbl:IsA("TextLabel") and lbl.Text == node.Name
		end
		local function SearchGatherItems()
			local items = {}
			for tabName, page in pairs(Tabs) do
				local stack = { page }
				while #stack > 0 do
					local node = table.remove(stack)
					for _, child in ipairs(node:GetChildren()) do
						if child:IsA("Frame") or child:IsA("TextButton") then
							if SearchIsComponent(child) then
								table.insert(items, { Name = child.Name, Tab = tabName, Elem = child })
							else
								table.insert(stack, child)
							end
						end
					end
				end
			end
			return items
		end
		local function Window_BuildResults(q)
			if Window.SearchList then
				for _, c in ipairs(Window.SearchList:GetChildren()) do
					if c:IsA("TextButton") then
						c:Destroy()
					end
				end
			end
			if not q or q == "" then
				if Window.SearchPanel then
					Window.SearchPanel.Visible = false
				end
				return
			end
			local items = SearchGatherItems()
			local matches = {}
			for _, it in ipairs(items) do
				if SearchContains(it.Name, q) or SearchContains(it.Tab, q) then
					table.insert(matches, it)
				end
			end
			if Window.SearchPanel then
				Window.SearchPanel.Visible = true
			end
			if #matches == 0 then
				New("TextLabel", {
					Name = "None",
					Size = UDim2.new(1, 0, 0, 56),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = "未找到相关结果",
					TextSize = 15,
					TextColor3 = Color3.fromRGB(170, 170, 180),
					Parent = Window.SearchList,
				})
				return
			end
			for _, it in ipairs(matches) do
				local Row = New("TextButton", {
					Name = it.Name,
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundColor3 = Color3.fromRGB(38, 38, 46),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Text = "",
					Parent = Window.SearchList,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Row })
				New("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, -24, 1, 0),
					Position = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = it.Name .. "  ·  " .. it.Tab,
					TextSize = 15,
					TextColor3 = Color3.fromRGB(225, 225, 232),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = Row,
				})
				Row.MouseButton1Click:Connect(function()
					Window:SelectSearchResult(it)
				end)
			end
		end
		function Window:OpenSearch()
			if not Window.SearchInited then
				Window.SearchToggle = New("TextButton", {
					Name = "SearchToggle",
					Size = UDim2.new(0, 30, 0, 30),
					Position = UDim2.new(1, -98, 0, 4),
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Text = "",
					Parent = TopBar,
				})
				local SearchIcon = New("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0.5, -8, 0.5, -8),
					BackgroundTransparency = 1,
					Image = Library:GetIcon("search"),
					ImageColor3 = Color3.fromRGB(160, 160, 170),
					ScaleType = Enum.ScaleType.Fit,
					Parent = Window.SearchToggle,
				})
				Library:SetIcon(SearchIcon, "search", 12)
				Window.SearchToggle.MouseEnter:Connect(function()
					TweenService:Create(SearchIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
				end)
				Window.SearchToggle.MouseLeave:Connect(function()
					TweenService:Create(SearchIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(160, 160, 170) }):Play()
				end)
				Window.SearchToggle.MouseButton1Click:Connect(function()
					if Window.SearchOpen then
						Window:CloseSearch()
					else
						Window:OpenSearch()
					end
				end)
				Window.SearchBox = New("TextBox", {
					Name = "SearchBox",
					Size = UDim2.new(0, 150, 0, 30),
					Position = UDim2.new(1, -242, 0, 4),
					Visible = false,
					BackgroundColor3 = Color3.fromRGB(18, 18, 22),
					BorderSizePixel = 0,
					Font = Enum.Font.GothamMedium,
					Text = "",
					PlaceholderText = "搜索...",
					TextSize = 14,
					TextColor3 = Color3.fromRGB(235, 235, 240),
					PlaceholderColor3 = Color3.fromRGB(120, 120, 132),
					ClearTextOnFocus = false,
					Parent = TopBar,
				})
				New("UIStroke", { Color = Color3.fromRGB(70, 70, 80), Thickness = 1, Parent = Window.SearchBox })
				New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Window.SearchBox })
				Window.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
					Window_BuildResults(Window.SearchBox.Text)
				end)
				Window.SearchBox.FocusLost:Connect(function()
					task.delay(0.15, function()
						Window_BuildResults(Window.SearchBox.Text)
					end)
				end)
				Window.SearchPanel = New("Frame", {
					Name = "SearchPanel",
					Size = UDim2.new(0, 330, 0, 330),
					Position = UDim2.new(1, -10, 0, 44),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = Color3.fromRGB(22, 22, 28),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 1000001,
					Parent = Main,
				})
				New("UIStroke", { Color = Color3.fromRGB(90, 90, 100), Thickness = 1, Parent = Window.SearchPanel })
				New("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Window.SearchPanel })
				Window.SearchList = New("ScrollingFrame", {
					Name = "List",
					Size = UDim2.new(1, -16, 1, -16),
					Position = UDim2.new(0, 8, 0, 8),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 4,
					ScrollBarImageColor3 = Color3.fromRGB(70, 70, 80),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					Parent = Window.SearchPanel,
				})
				New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Window.SearchList })
				Window.SearchInited = true
			end
			Window.SearchOpen = true
			Window.SearchBox.Visible = true
			Window.SearchPanel.Visible = true
			Window_BuildResults(Window.SearchBox.Text)
			if not UserInputService.TouchEnabled then
				task.spawn(function()
					Window.SearchBox:CaptureFocus()
				end)
			end
		end
		function Window:CloseSearch()
			if not Window.SearchInited then
				return
			end
			Window.SearchOpen = false
			Window.SearchBox.Visible = false
			Window.SearchBox.Text = ""
			Window.SearchPanel.Visible = false
		end
		function Window:SelectSearchResult(it)
			if not it then
				return
			end
			local page = Tabs[it.Tab]
			if not page then
				return
			end
			local btn = nil
			for _, b in ipairs(TabButtons) do
				if b.Name == it.Tab then
					btn = b
					break
				end
			end
			if btn then
				SelectTab(btn)
			end
			for _, pg in pairs(Tabs) do
				pg.Visible = false
			end
			page.Visible = true
			Window:CloseSearch()
			task.wait()
			local target = it.Elem
			if target and target.Parent then
				local top = target:FindFirstChild("TextLabel") or target:FindFirstChild("Title")
				local y = target.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y
				if top then
					y = top.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y
				end
				page.CanvasPosition = Vector2.new(0, math.max(0, y - 8))
			end
		end
		function Window:AddTab(options)
			return CreateTab(options.name, options.icon)
		end
		function Window:Minimize()
			MinimizeWindow()
		end
		function Window:Close()
			CloseWindow()
		end
		function Window:SetTitle(t)
			Window.Title = t
			TitleLabel.Text = t
		end
		function Window:AddTag(options)
			return MakeTag(TopBarTags, options)
		end
		function Window:GetScreenGui()
			return ScreenGui
		end
		function Window:GetTitle()
			return Window.Title
		end
		function Window:GetIcon()
			return Window.Icon
		end
		function Window:SetBackgroundImage(img)
			SetBGImage(img)
		end
		function Window:SetVideoBackground(url)
			SetBGVideo(url)
		end
		function Window:RemoveBackgroundImage()
			ClearBG()
		end
		function Window:RemoveVideoBackground()
			ClearBG()
		end
		function Window:Notify(n)
			if type(n) == "string" then
				n = { Text = n }
			end
			n.Title = n.Title or Window.Title
			n.Icon = n.Icon or Window.Icon
			return Library:Notification(n)
		end
		function Window:ToggleVisibility(v)
			ScreenGui.Enabled = v
		end
		local ControlGui = New("ScreenGui", {
			Name = "XHMControlGui",
			DisplayOrder = 1000000000,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = ScreenGui.Parent,
		})
		local ControlBar = New("Frame", {
			Name = "Controls",
			Size = UDim2.new(0, 152, 0, 32),
			Position = UDim2.new(0.5, -76, 0, 16),
			BackgroundTransparency = 1,
			ZIndex = 999999,
			Parent = ControlGui,
		})
		local function MakeControlButton(text, pos, iconName)
			local Btn = New("TextButton", {
				Name = text,
				Size = UDim2.new(0, 72, 0, 32),
				Position = pos,
				BackgroundColor3 = Color3.fromRGB(36, 36, 44),
				AutoButtonColor = false,
				Text = "",
				ZIndex = 999999,
				Parent = ControlBar,
			})
			New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
			local IconImg = New("ImageLabel", {
				Name = "IconImg",
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 10, 0.5, -8),
				BackgroundTransparency = 1,
				Image = iconName and Library:GetIcon(iconName),
				ImageColor3 = Color3.fromRGB(150, 160, 180),
				ScaleType = Enum.ScaleType.Fit,
				Parent = Btn,
			})
			local Lbl = New("TextLabel", {
				Name = "Icon",
				Size = UDim2.new(1, -34, 1, 0),
				Position = UDim2.new(0, 34, 0, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = text,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(230, 230, 236),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = Btn,
			})
			return Btn, Lbl, IconImg
		end
		local VisButton, VisIcon, VisIconImg = MakeControlButton("隐藏", UDim2.new(0, 0, 0, 0), "eye-off")
		local FixButton, FixIcon, FixIconImg = MakeControlButton("固定", UDim2.new(0, 80, 0, 0), "lock-open")
		local function ApplyIcon(iconImg, name, tries)
			if not iconImg then
				return
			end
			local id = Library:GetIcon(name)
			if id then
				iconImg.Image = id
			elseif tries and tries > 0 then
				task.delay(0.2, function()
					if iconImg.Parent then
						ApplyIcon(iconImg, name, tries - 1)
					end
				end)
			end
		end
		local function UpdateVisButton()
			VisIcon.Text = ScreenGui.Enabled and "隐藏" or "显示"
			VisButton.BackgroundColor3 = ScreenGui.Enabled and Color3.fromRGB(36, 36, 44) or Color3.fromRGB(70, 70, 80)
			ApplyIcon(VisIconImg, ScreenGui.Enabled and "eye-off" or "eye", 10)
		end
		local function UpdateFixButton()
			FixIcon.Text = WindowDraggable and "固定" or "解锁"
			FixButton.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
			ApplyIcon(FixIconImg, WindowDraggable and "lock-open" or "lock", 10)
			if FixIconImg then
				FixIconImg.ImageColor3 = WindowDraggable and Color3.fromRGB(150, 160, 180) or Color3.fromRGB(90, 160, 255)
			end
		end
		UpdateVisButton()
		UpdateFixButton()
		function Window:SetDraggable(v)
			WindowDraggable = v and true or false
			UpdateFixButton()
		end
		VisButton.MouseButton1Click:Connect(function()
			ScreenGui.Enabled = not ScreenGui.Enabled
			UpdateVisButton()
		end)
		FixButton.MouseButton1Click:Connect(function()
			Window:SetDraggable(not WindowDraggable)
		end)
		ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(UpdateVisButton)
		ScreenGui.Destroying:Connect(function()
			ControlGui:Destroy()
		end)
		Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		Main.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = size,
			Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
		}):Play()
		local function OnSearchHotkey(input)
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F then
				local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
				if ctrl then
					if Window.SearchOpen then
						Window:CloseSearch()
					else
						Window:OpenSearch()
					end
				end
			end
		end
		local SearchBindConn = UserInputService.InputBegan:Connect(function(input, gpe)
			if not gpe then
				OnSearchHotkey(input)
			end
		end)
		ScreenGui.Destroying:Connect(function()
			if SearchBindConn then
				SearchBindConn:Disconnect()
			end
		end)
		if UserInputService.TouchEnabled then
			Window:OpenSearch()
		end
		local MinSizeX = size.X.Offset
		local MinSizeY = size.Y.Offset
		local function ClampMainSize()
			local w = math.max(MinSizeX, Main.Size.X.Offset)
			local h = math.max(MinSizeY, Main.Size.Y.Offset)
			Main.Size = UDim2.new(0, w, 0, h)
			Main.Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2)
		end
		local BottomBar = New("Frame", {
			Name = "BottomResizeBar",
			Size = UDim2.new(1, 0, 0, 5),
			Position = UDim2.new(0, 0, 1, -5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.75,
			BorderSizePixel = 0,
			ZIndex = 1000000,
			Parent = Main,
		})
		local ResizeHandle = New("ImageLabel", {
			Name = "ResizeHandle",
			Size = UDim2.new(0, 14, 0, 14),
			Position = UDim2.new(1, -8, 1, -8),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Image = Library:GetIcon("grip-horizontal"),
			ImageColor3 = Color3.fromRGB(235, 235, 240),
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 1000001,
			Parent = Main,
		})
		Library:SetIcon(ResizeHandle, "grip-horizontal", 12)
		local ResizeDrag = false
		local ResizeStart = Vector2.new(0, 0)
		local ResizeOrigin = Vector2.new(0, 0)
		local function BeginResize(input)
			ResizeDrag = true
			ResizeStart = input.Position
			ResizeOrigin = Vector2.new(Main.Size.X.Offset, Main.Size.Y.Offset)
		end
		local function UpdateResize(input)
			if not ResizeDrag then
				return
			end
			local dx = input.Position.X - ResizeStart.X
			local dy = input.Position.Y - ResizeStart.Y
			Main.Size = UDim2.new(0, math.max(MinSizeX, ResizeOrigin.X + dx), 0, math.max(MinSizeY, ResizeOrigin.Y + dy))
			ClampMainSize()
		end
		local function EndResize(input)
			ResizeDrag = false
		end
		ResizeHandle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				BeginResize(input)
			end
		end)
		BottomBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				BeginResize(input)
			end
		end)
		BottomBar.InputChanged:Connect(function(input)
			if ResizeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				UpdateResize(input)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if ResizeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				UpdateResize(input)
			end
		end)
		UserInputService.InputEnded:Connect(EndResize)
		function Window:SetSize(w, h)
			Main.Size = UDim2.new(0, math.max(MinSizeX, w or Main.Size.X.Offset), 0, math.max(MinSizeY, h or Main.Size.Y.Offset))
			ClampMainSize()
		end
		function Window:GetSize()
			return Main.Size
		end
		function Window:SetDPI(d)
			UIScale = (type(d) == "number" and d > 0) and d or 1
			ApplyDPI()
		end
		return Window
	end
	local NotifyGui = nil
	local NotifyHolder = nil
	local NotifyIndex = 0
	local NotifyActive = {}
	local NotifyQueue = {}
	local NotifyMax = 5
	local function EnsureNotifyUI()
		if NotifyGui and NotifyGui.Parent then
			return
		end
		NotifyGui = New("ScreenGui", {
			DisplayOrder = 1000000001,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = LocalPlayer:WaitForChild("PlayerGui"),
		})
		NotifyHolder = New("Frame", {
			Name = "NotifyHolder",
			Size = UDim2.new(0, 300, 1, -156),
			Position = UDim2.new(1, -29, 0, 56),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Parent = NotifyGui,
		})
		New("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 8),
			Parent = NotifyHolder,
		})
		New("UIPadding", { PaddingBottom = UDim.new(0, 29), Parent = NotifyHolder })
		NotifyGui.Destroying:Connect(function()
			NotifyGui = nil
			NotifyHolder = nil
		end)
	end
	local function ProcessQueue()
		while #NotifyActive < NotifyMax and #NotifyQueue > 0 do
			ShowNotification(table.remove(NotifyQueue, 1))
		end
	end
	local function CloseNotification(notify)
		if notify.Closed or not notify.Container or not notify.Container.Parent then
			return
		end
		notify.Closed = true
		for i, v in ipairs(NotifyActive) do
			if v == notify then
				table.remove(NotifyActive, i)
				break
			end
		end
		local container = notify.Container
		TweenService:Create(container, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, -8) }):Play()
		local m = container:FindFirstChild("Notify")
		if m then
			TweenService:Create(m, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(2, 0, 0, 0) }):Play()
		end
		task.delay(0.55, function()
			if container.Parent then
				container:Destroy()
			end
			ProcessQueue()
		end)
	end
	function ShowNotification(n)
		local title = n.Title or ""
		local content = n.Text or n.Content or ""
		local hasContent = content ~= ""
		local icon = n.Icon
		local isIconName = type(icon) == "string" and string.match(icon, "^[%w%-]+$") ~= nil
		local iconAsset = type(icon) == "string" and (isIconName and Library:GetIcon(icon) or icon) or nil
		local basePad = 14
		local contentLines = hasContent and math.max(1, math.ceil(string.len(content) / 24)) or 0
		local textH = 22 + (hasContent and (contentLines * 16 + 6) or 0)
		local leftH = iconAsset and 26 or textH
		local height = math.max(46, basePad * 2 + math.max(leftH, textH))
		local textLeft = iconAsset and 48 or 14
		local textRight = (n.CanClose ~= false) and 34 or 14
		local MainContainer = New("Frame", {
			Name = "NotifyContainer",
			Size = UDim2.new(1, 0, 0, height),
			BackgroundTransparency = 1,
			Parent = NotifyHolder,
		})
		MainContainer.LayoutOrder = NotifyIndex
		NotifyIndex = NotifyIndex + 1
		local Main = New("Frame", {
			Name = "Notify",
			Size = UDim2.new(1, 0, 0, height),
			Position = UDim2.new(2, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(26, 26, 31),
			ClipsDescendants = true,
			BorderSizePixel = 0,
			Parent = MainContainer,
		})
		New("UIStroke", { Color = Color3.fromRGB(235, 235, 240), Transparency = 0.7, Thickness = 1, Parent = Main })
		if n.Background then
			New("ImageLabel", {
				Name = "Background",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = n.Background,
				ImageTransparency = n.BackgroundImageTransparency or 0.5,
				ScaleType = Enum.ScaleType.Crop,
				Parent = Main,
			})
		end
		New("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -(textLeft + textRight), 0, 22),
			Position = UDim2.new(0, textLeft, 0, basePad),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamSemibold,
			Text = title,
			TextSize = 18,
			TextColor3 = Color3.fromRGB(235, 235, 240),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = Main,
		})
		if hasContent then
			New("TextLabel", {
				Name = "Content",
				Size = UDim2.new(1, -(textLeft + textRight), 0, contentLines * 16),
				Position = UDim2.new(0, textLeft, 0, basePad + 26),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = content,
				TextSize = 15,
				TextColor3 = Color3.fromRGB(200, 200, 210),
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = Main,
			})
		end
		if iconAsset then
			local IconImg = New("ImageLabel", {
				Name = "Icon",
				Size = UDim2.new(0, 26, 0, 26),
				Position = UDim2.new(0, 14, 0, basePad),
				BackgroundTransparency = 1,
				Image = iconAsset,
				ImageColor3 = isIconName and Color3.fromRGB(150, 160, 180) or Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Fit,
				Parent = Main,
			})
			if isIconName then
				Library:SetIcon(IconImg, icon, 10)
			end
		end
		local notify = {
			Title = title,
			Text = content,
			Icon = n.Icon,
			Duration = n.Duration or 5,
			Container = MainContainer,
			Closed = false,
		}
		function notify:Close()
			CloseNotification(self)
		end
		table.insert(NotifyActive, notify)
		if n.CanClose ~= false then
			local CloseBtn = New("ImageButton", {
				Name = "Close",
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(1, -14, 0, 14),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Image = Library:GetIcon("x"),
				ImageColor3 = Color3.fromRGB(160, 160, 170),
				Parent = Main,
			})
			Library:SetIcon(CloseBtn, "x", 10)
			New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = CloseBtn })
			CloseBtn.MouseButton1Click:Connect(function()
				CloseNotification(notify)
			end)
		end
		local DurationClip = New("Frame", {
			Name = "DurationClip",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Parent = Main,
		})
		New("Frame", {
			Name = "Duration",
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.88,
			BorderSizePixel = 0,
			Parent = DurationClip,
		})
		TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }):Play()
		task.spawn(function()
			task.wait(0.45)
			TweenService:Create(DurationClip, TweenInfo.new((n.Duration or 5), Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Play()
			task.wait(n.Duration or 5)
			CloseNotification(notify)
		end)
		return notify
	end
	function Library:Notification(n)
		if type(n) == "string" then
			n = { Text = n }
		end
		n.Title = n.Title or ""
		n.Text = n.Text or n.Content or ""
		n.Duration = n.Duration or 5
		EnsureNotifyUI()
		if #NotifyActive >= NotifyMax then
			table.insert(NotifyQueue, n)
			return nil
		end
		return ShowNotification(n)
	end
	function Library:CreateNotify(text, duration)
		if type(text) == "table" then
			return self:Notification(text)
		end
		return self:Notification({ Text = text, Duration = duration })
	end
	function Library:SetNotifyMax(n)
		NotifyMax = n and n or 5
		if #NotifyActive < NotifyMax then
			ProcessQueue()
		end
	end
	function Library:SetScale(s)
		UIScale = s
		if WindowScale then
			WindowScale.Scale = s
		end
	end
	return Library
end)()
return Library