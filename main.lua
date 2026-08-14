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
		local FitViewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 600)
		local FitScale = math.min(1, math.min((FitViewport.X - 24) / size.X.Offset, (FitViewport.Y - 24) / size.Y.Offset))
		if FitScale < 1 then
			WindowScale.Scale = WindowScale.Scale * FitScale
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
		if options.Subtitle then
			New("TextLabel", {
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
		local MinimizeButton = New("TextButton", {
			Name = "Minimize",
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(1, -94, 0, 4),
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
		local MaximizeButton = New("TextButton", {
			Name = "Maximize",
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(1, -64, 0, 4),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			Parent = TopBar,
		})
		local MaximizeIcon = New("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5, -8, 0.5, -8),
			BackgroundTransparency = 1,
			Image = Library:GetIcon("square"),
			ImageColor3 = Color3.fromRGB(160, 160, 170),
			ScaleType = Enum.ScaleType.Fit,
			Parent = MaximizeButton,
		})
		Library:SetIcon(MaximizeIcon, "square", 10)
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
			local startPos = nil
			local startMouse = nil
			local function Update(mousePos)
				local delta = mousePos - startMouse
				Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
			local function IsPress(input)
				return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
			end
			local function StopDrag(input)
				if IsPress(input) then
					dragging = false
				end
			end
			bar.InputBegan:Connect(function(input)
				if WindowDraggable and IsPress(input) then
					dragging = true
					startPos = Main.Position
					startMouse = UserInputService:GetMouseLocation()
				end
			end)
			bar.InputEnded:Connect(StopDrag)
			UserInputService.InputEnded:Connect(StopDrag)
			RunService.RenderStepped:Connect(function()
				if dragging and WindowDraggable then
					Update(UserInputService:GetMouseLocation())
				end
			end)
		end
		DragWindow(TopBar)
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
				local SectionIcon = Library:GetIcon(options.icon)
				local Section = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = TabPage,
				})
				local SectionTitle = New("Frame", {
					Name = "SectionTitle",
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					Parent = Section,
				})
				local SectionText = New("TextLabel", {
					Name = "Text",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = SectionTitle,
				})
				New("UIPadding", { PaddingLeft = UDim.new(0, SectionIcon and 34 or 14), Parent = SectionText })
				if SectionIcon then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 1),
						BackgroundTransparency = 1,
						Image = SectionIcon,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = SectionTitle,
					})
				end
				local Divider = New("Frame", {
					Name = "Divider",
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0, 20),
					BackgroundColor3 = Color3.fromRGB(50, 50, 60),
					BorderSizePixel = 0,
					Parent = Section,
				})
				local SectionLayout = New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6),
					Parent = Section,
				})
				local SectionPad = New("UIPadding", {
					PaddingTop = UDim.new(0, 22),
					Parent = Section,
				})
				local SectionObj = {}
				function SectionObj:AddButton(options)
					local text = options.name
					local callback = options.callback
					local ic = Library:GetIcon(options.icon)
					local Button = New("TextButton", {
						Name = text,
						Size = UDim2.new(1, 0, 0, 32),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						AutoButtonColor = false,
						Text = "",
						Parent = Section,
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
					local OriginalColor = Button.BackgroundColor3
					Button.MouseEnter:Connect(function()
						TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(52, 52, 62) }):Play()
					end)
					Button.MouseLeave:Connect(function()
						TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = OriginalColor }):Play()
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
						Parent = Section,
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
						Size = UDim2.new(1, 0, 0, 28),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						Parent = Section,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Label })
					local LabelText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = text,
						TextSize = 16,
						TextColor3 = color or Color3.fromRGB(230, 230, 236),
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = Label,
					})
New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = LabelText })
					if ic then
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 14, 0, 6),
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
						Size = UDim2.new(1, 0, 0, 48),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						Parent = Section,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Slider })
					local SliderText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(0.7, 0, 0, 20),
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
					local ValueText = New("TextLabel", {
						Name = "ValueText",
						Size = UDim2.new(0.3, 0, 0, 20),
						Position = UDim2.new(0.7, 0, 0, 6),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamBold,
						Text = tostring(default),
						TextSize = 15,
						TextColor3 = Color3.fromRGB(90, 160, 255),
						TextXAlignment = Enum.TextXAlignment.Right,
						Parent = Slider,
					})
					local SliderBar = New("Frame", {
						Name = "Bar",
						Size = UDim2.new(1, -24, 0, 4),
						Position = UDim2.new(0, 12, 0, 32),
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
					local function UpdateSlider(x)
						local relX = math.clamp((x - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
						Current = math.round(Min + ((Max - Min) * relX))
						local displayRelX = (Current - Min) / (Max - Min)
						ValueText.Text = tostring(Current)
						SliderFill.Size = UDim2.new(displayRelX, 0, 1, 0)
						SliderGrab.Position = UDim2.new(displayRelX, -6, 0, -4)
						if callback then
							pcall(callback, Current)
						end
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
								input.Handled = true
							end
						end
					end)
					Slider.InputChanged:Connect(function(input)
						if dragging and input.UserInputType == Enum.UserInputType.Touch then
							input.Handled = true
						end
					end)
					Slider.InputEnded:Connect(StopDrag)
					UserInputService.InputEnded:Connect(StopDrag)
					RunService.RenderStepped:Connect(function()
						if dragging then
							UpdateSlider(UserInputService:GetMouseLocation().X)
						end
					end)
					local SliderObj = {}
					function SliderObj:Get()
						return Current
					end
					function SliderObj:SetValue(v)
						v = math.round(v)
						local relX = (v - Min) / (Max - Min)
						Current = v
						ValueText.Text = tostring(v)
						SliderFill.Size = UDim2.new(relX, 0, 1, 0)
						SliderGrab.Position = UDim2.new(relX, -6, 0, -4)
						if callback then
							pcall(callback, v)
						end
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
						Parent = Section,
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
						PlaceholderText = "Input...",
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
					local text = options.name
					local list = options.list
					local default = options.default
					local callback = options.callback
					local ic = Library:GetIcon(options.icon)
					local Dropdown = New("Frame", {
						Name = text,
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundColor3 = Color3.fromRGB(36, 36, 44),
						BorderSizePixel = 0,
						Parent = Section,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Dropdown })
					local DropdownText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(1, -40, 0, 36),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = text,
						TextSize = 16,
						TextColor3 = Color3.fromRGB(230, 230, 236),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = Dropdown,
					})
					New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = DropdownText })
					if ic then
						New("ImageLabel", {
							Name = "Icon",
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(0, 14, 0, 10),
							BackgroundTransparency = 1,
							Image = ic,
							ImageColor3 = Color3.fromRGB(150, 160, 180),
							Parent = Dropdown,
						})
					end
					local DropdownButton = New("TextButton", {
						Name = "Button",
						Size = UDim2.new(1, 0, 0, 36),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						Parent = Dropdown,
					})
					local SelectedLabel = New("TextLabel", {
						Name = "Selected",
						Size = UDim2.new(0.55, 0, 0, 36),
						Position = UDim2.new(0.45, 0, 0, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamSemibold,
						Text = default or "None",
						TextSize = 15,
						TextColor3 = Color3.fromRGB(90, 160, 255),
						TextXAlignment = Enum.TextXAlignment.Right,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = Dropdown,
					})
					New("UIPadding", { PaddingRight = UDim.new(0, 12), Parent = SelectedLabel })
					local DropList = New("Frame", {
						Name = "List",
						Size = UDim2.new(1, 0, 0, 0),
						Position = UDim2.new(0, 0, 0, 38),
						BackgroundColor3 = Color3.fromRGB(28, 28, 34),
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Visible = false,
						ZIndex = 1000001,
						Parent = Dropdown,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropList })
					local DropLayout = New("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4),
						Parent = DropList,
					})
					New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = DropList })
					local Selected = default or "None"
					local Open = false
					local OutsideConnection = nil
					local function Close()
						Open = false
						TweenService:Create(DropList, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 0) }):Play()
						TweenService:Create(Dropdown, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 36) }):Play()
						task.delay(0.15, function()
							if not Open then
								DropList.Visible = false
							end
						end)
						if OutsideConnection then
							OutsideConnection:Disconnect()
							OutsideConnection = nil
						end
					end
					local function OpenList()
						Open = true
						DropList.Visible = true
						local totalHeight = (#list * 30) + 8
						DropList.Size = UDim2.new(1, 0, 0, 0)
						TweenService:Create(DropList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, totalHeight) }):Play()
						TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 36 + totalHeight) }):Play()
						OutsideConnection = UserInputService.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								local clickPos = input.Position
								local absPos = Dropdown.AbsolutePosition
								local absSize = Dropdown.AbsoluteSize
								if clickPos.X < absPos.X or clickPos.X > absPos.X + absSize.X or clickPos.Y < absPos.Y or clickPos.Y > absPos.Y + absSize.Y then
									Close()
								end
							end
						end)
					end
					local function AddOption(option)
						local Item = New("TextButton", {
							Name = option,
							Size = UDim2.new(1, 0, 0, 26),
							BackgroundColor3 = Color3.fromRGB(40, 40, 48),
							BorderSizePixel = 0,
							AutoButtonColor = false,
							Text = "",
							Parent = DropList,
						})
						New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Item })
						local ItemText = New("TextLabel", {
							Name = "TextLabel",
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							Font = Enum.Font.GothamMedium,
							Text = option,
							TextSize = 15,
							TextColor3 = Color3.fromRGB(220, 220, 228),
							TextXAlignment = Enum.TextXAlignment.Left,
							Parent = Item,
						})
						New("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = Item })
						Item.MouseButton1Click:Connect(function()
							Selected = option
							SelectedLabel.Text = option
							Close()
							if callback then
								pcall(callback, option)
							end
						end)
					end
					DropdownButton.MouseButton1Click:Connect(function()
						if Open then
							Close()
						else
							OpenList()
						end
					end)
					for _, option in pairs(list) do
						AddOption(option)
					end
					local DropObj = {}
					function DropObj:Get()
						return Selected
					end
					function DropObj:SetValue(v)
						Selected = v
						SelectedLabel.Text = v
						if callback then
							pcall(callback, v)
						end
					end
					return DropObj
				end
				function SectionObj:AddSeparator()
					local Sep = New("Frame", {
						Name = "Separator",
						Size = UDim2.new(1, 0, 0, 1),
						BackgroundColor3 = Color3.fromRGB(45, 45, 54),
						BorderSizePixel = 0,
						Parent = Section,
					})
					return Sep
				end
				return SectionObj
			end
			function Tab:AddLabel(options)
				local text = options.name
				local color = options.color
				local ic = Library:GetIcon(options.icon)
				local Label = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Label })
				local LabelText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = color or Color3.fromRGB(230, 230, 236),
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = Label,
				})
				New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = LabelText })
				if ic then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 6),
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
					Size = UDim2.new(1, 0, 0, 32),
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
				local OriginalColor = Button.BackgroundColor3
				Button.MouseEnter:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(52, 52, 62) }):Play()
				end)
				Button.MouseLeave:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = OriginalColor }):Play()
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
					Size = UDim2.new(1, 0, 0, 48),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Slider })
				local SliderText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(0.7, 0, 0, 20),
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
				local ValueText = New("TextLabel", {
					Name = "ValueText",
					Size = UDim2.new(0.3, 0, 0, 20),
					Position = UDim2.new(0.7, 0, 0, 6),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					Text = tostring(default),
					TextSize = 15,
					TextColor3 = Color3.fromRGB(90, 160, 255),
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = Slider,
				})
				local SliderBar = New("Frame", {
					Name = "Bar",
					Size = UDim2.new(1, -24, 0, 4),
					Position = UDim2.new(0, 12, 0, 32),
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
				local function UpdateSlider(x)
					local relX = math.clamp((x - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					Current = math.round(Min + ((Max - Min) * relX))
					local displayRelX = (Current - Min) / (Max - Min)
					ValueText.Text = tostring(Current)
					SliderFill.Size = UDim2.new(displayRelX, 0, 1, 0)
					SliderGrab.Position = UDim2.new(displayRelX, -6, 0, -4)
					if callback then
						pcall(callback, Current)
					end
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
							input.Handled = true
						end
					end
				end)
				Slider.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.Touch then
						input.Handled = true
					end
				end)
				Slider.InputEnded:Connect(StopDrag)
				UserInputService.InputEnded:Connect(StopDrag)
				RunService.RenderStepped:Connect(function()
					if dragging then
						UpdateSlider(UserInputService:GetMouseLocation().X)
					end
				end)
				local SliderObj = {}
				function SliderObj:Get()
					return Current
				end
				function SliderObj:SetValue(v)
					v = math.round(v)
					local relX = (v - Min) / (Max - Min)
					Current = v
					ValueText.Text = tostring(v)
					SliderFill.Size = UDim2.new(relX, 0, 1, 0)
					SliderGrab.Position = UDim2.new(relX, -6, 0, -4)
					if callback then
						pcall(callback, v)
					end
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
					PlaceholderText = "Input...",
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
				local text = options.name
				local list = options.list
				local default = options.default
				local callback = options.callback
				local ic = Library:GetIcon(options.icon)
				local Dropdown = New("Frame", {
					Name = text,
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Color3.fromRGB(36, 36, 44),
					BorderSizePixel = 0,
					Parent = TabPage,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Dropdown })
				local DropdownText = New("TextLabel", {
					Name = "TextLabel",
					Size = UDim2.new(1, -40, 0, 36),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = text,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(230, 230, 236),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = Dropdown,
				})
				New("UIPadding", { PaddingLeft = UDim.new(0, ic and 40 or 14), Parent = DropdownText })
				if ic then
					New("ImageLabel", {
						Name = "Icon",
						Size = UDim2.new(0, 16, 0, 16),
						Position = UDim2.new(0, 14, 0, 10),
						BackgroundTransparency = 1,
						Image = ic,
						ImageColor3 = Color3.fromRGB(150, 160, 180),
						Parent = Dropdown,
					})
				end
				local DropdownButton = New("TextButton", {
					Name = "Button",
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false,
					Parent = Dropdown,
				})
				local SelectedLabel = New("TextLabel", {
					Name = "Selected",
					Size = UDim2.new(0.55, 0, 0, 36),
					Position = UDim2.new(0.45, 0, 0, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamSemibold,
					Text = default or "None",
					TextSize = 15,
					TextColor3 = Color3.fromRGB(90, 160, 255),
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = Dropdown,
				})
				New("UIPadding", { PaddingRight = UDim.new(0, 12), Parent = SelectedLabel })
				local DropList = New("Frame", {
					Name = "List",
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.new(0, 0, 0, 38),
					BackgroundColor3 = Color3.fromRGB(28, 28, 34),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 1000001,
					Parent = Dropdown,
				})
				New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropList })
				New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = DropList })
				New("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = DropList })
				local Selected = default or "None"
				local Open = false
				local OutsideConnection = nil
				local function Close()
					Open = false
					TweenService:Create(DropList, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 0) }):Play()
					TweenService:Create(Dropdown, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 36) }):Play()
					task.delay(0.15, function()
						if not Open then
							DropList.Visible = false
						end
					end)
					if OutsideConnection then
						OutsideConnection:Disconnect()
						OutsideConnection = nil
					end
				end
				local function OpenList()
					Open = true
					DropList.Visible = true
					local totalHeight = (#list * 30) + 8
					DropList.Size = UDim2.new(1, 0, 0, 0)
					TweenService:Create(DropList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, totalHeight) }):Play()
					TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 36 + totalHeight) }):Play()
					OutsideConnection = UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							local clickPos = input.Position
							local absPos = Dropdown.AbsolutePosition
							local absSize = Dropdown.AbsoluteSize
							if clickPos.X < absPos.X or clickPos.X > absPos.X + absSize.X or clickPos.Y < absPos.Y or clickPos.Y > absPos.Y + absSize.Y then
								Close()
							end
						end
					end)
				end
				local function AddOption(option)
					local Item = New("TextButton", {
						Name = option,
						Size = UDim2.new(1, 0, 0, 26),
						BackgroundColor3 = Color3.fromRGB(40, 40, 48),
						BorderSizePixel = 0,
						AutoButtonColor = false,
						Text = "",
						Parent = DropList,
					})
					New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Item })
					local ItemText = New("TextLabel", {
						Name = "TextLabel",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Font = Enum.Font.GothamMedium,
						Text = option,
						TextSize = 15,
						TextColor3 = Color3.fromRGB(220, 220, 228),
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = Item,
					})
					New("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = Item })
					Item.MouseButton1Click:Connect(function()
						Selected = option
						SelectedLabel.Text = option
						Close()
						if callback then
							pcall(callback, option)
						end
					end)
				end
				DropdownButton.MouseButton1Click:Connect(function()
					if Open then
						Close()
					else
						OpenList()
					end
				end)
				for _, option in pairs(list) do
					AddOption(option)
				end
				local DropObj = {}
				function DropObj:Get()
					return Selected
				end
				function DropObj:SetValue(v)
					Selected = v
					SelectedLabel.Text = v
					if callback then
						pcall(callback, v)
					end
				end
				return DropObj
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
					Text = tostring(default or "None"),
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
					return "None"
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
			if #TabButtons == 1 then
				OnTabClick()
			end
			return Tab
		end
		local function MinimizeWindow()
			Minimized = not Minimized
			if Minimized then
				MinimizeIcon.Image = Library:GetIcon("maximize")
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 38) }):Play()
				TabsContainer.Visible = false
				Body.Visible = false
			else
				MinimizeIcon.Image = Library:GetIcon("minus")
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = size }):Play()
				task.wait(0.15)
				TabsContainer.Visible = true
				Body.Visible = true
			end
		end
		MinimizeButton.MouseButton1Click:Connect(MinimizeWindow)
		local MaxEnabled = false
		local function MaximizeWindow()
			MaxEnabled = not MaxEnabled
			if MaxEnabled then
				MaximizeIcon.Image = Library:GetIcon("minimize")
				local view = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900, 600)
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, view.X, 0, view.Y), Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
			else
				MaximizeIcon.Image = Library:GetIcon("square")
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = size, Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2) }):Play()
			end
		end
		MaximizeButton.MouseButton1Click:Connect(MaximizeWindow)
		local function CloseWindow()
			Opened = false
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
			}):Play()
			task.wait(0.3)
			ScreenGui:Destroy()
		end
		CloseButton.MouseButton1Click:Connect(CloseWindow)
		MinimizeButton.MouseEnter:Connect(function()
			TweenService:Create(MinimizeIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
		end)
		MinimizeButton.MouseLeave:Connect(function()
			TweenService:Create(MinimizeIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(160, 160, 170) }):Play()
		end)
		MaximizeButton.MouseEnter:Connect(function()
			TweenService:Create(MaximizeIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
		end)
		MaximizeButton.MouseLeave:Connect(function()
			TweenService:Create(MaximizeIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(160, 160, 170) }):Play()
		end)
		CloseButton.MouseEnter:Connect(function()
			TweenService:Create(CloseIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(255, 120, 120) }):Play()
		end)
		CloseButton.MouseLeave:Connect(function()
			TweenService:Create(CloseIcon, TweenInfo.new(0.1), { ImageColor3 = Color3.fromRGB(160, 160, 170) }):Play()
		end)
		local Window = {
			Title = title,
			Icon = Logo.Image,
		}
		function Window:AddTab(options)
			return CreateTab(options.name, options.icon)
		end
		function Window:Minimize()
			MinimizeWindow()
		end
		function Window:Maximize()
			MaximizeWindow()
		end
		function Window:Close()
			CloseWindow()
		end
		function Window:SetTitle(t)
			Window.Title = t
			TitleLabel.Text = t
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
		return Window
	end
	local NotifyGui = nil
	local NotifyStack = nil
	local NotifyActive = {}
	local NotifyQueue = {}
	local NotifyMax = 3
	local NotifyTweens = setmetatable({}, { __mode = "k" })
	local NotifyDismissed = setmetatable({}, { __mode = "k" })
	local ShowNotification
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
		NotifyStack = New("Frame", {
			Name = "NotifyStack",
			Size = UDim2.new(0, 320, 0, 44),
			Position = UDim2.new(1, -16, 1, -16),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 999999,
			Parent = NotifyGui,
		})
		NotifyGui.Destroying:Connect(function()
			NotifyGui = nil
			NotifyStack = nil
		end)
	end
	local function MoveToast(t, pos, dur, ease)
		local old = NotifyTweens[t]
		if old then
			old:Cancel()
		end
		local tw = TweenService:Create(t, TweenInfo.new(dur, Enum.EasingStyle.Quad, ease or Enum.EasingDirection.Out), { Position = pos })
		NotifyTweens[t] = tw
		tw:Play()
	end
local function Relayout()
			local y = 0
			for i, t in ipairs(NotifyActive) do
				MoveToast(t, UDim2.new(0, 0, 1, -y), 0.25)
				y = y + t.Size.Y.Offset + 8
			end
		end
	local function ProcessQueue()
		while #NotifyActive < NotifyMax and #NotifyQueue > 0 do
			ShowNotification(table.remove(NotifyQueue, 1))
		end
	end
	local function DismissToast(t)
		if NotifyDismissed[t] then
			return
		end
		NotifyDismissed[t] = true
		for i, v in ipairs(NotifyActive) do
			if v == t then
				table.remove(NotifyActive, i)
				break
			end
		end
		MoveToast(t, UDim2.new(1, 48, 1, 48), 0.2, Enum.EasingDirection.In)
		TweenService:Create(t, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
		local txt = t:FindFirstChild("Text")
		if txt then
			TweenService:Create(txt, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
		end
		Relayout()
		ProcessQueue()
		task.delay(0.25, function()
			if t.Parent then
				t:Destroy()
			end
		end)
	end
	function ShowNotification(n)
		local hasTitle = type(n.Title) == "string" and n.Title ~= ""
		local height = hasTitle and 56 or 44
		local toast = New("TextButton", {
			Name = "Toast",
			Size = UDim2.new(0, 320, 0, height),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(1, 48, 1, 48),
			BackgroundColor3 = Color3.fromRGB(26, 26, 31),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			ZIndex = 999999,
			Parent = NotifyStack,
		})
		New("UIStroke", { Color = Color3.fromRGB(235, 235, 240), Thickness = 1, Parent = toast })
		local textX = 12
		if n.Icon then
			local isName = string.match(n.Icon, "^[%w%-]+$")
			local ic = isName and Library:GetIcon(n.Icon) or n.Icon
			if ic then
				textX = 36
				New("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, 12, 0.5, -8),
					BackgroundTransparency = 1,
					Image = ic,
					ImageColor3 = n.IconColor or (isName and Color3.fromRGB(150, 160, 180) or Color3.fromRGB(255, 255, 255)),
					ScaleType = Enum.ScaleType.Fit,
					Parent = toast,
				})
			end
		end
		local txt
		if hasTitle then
			local tt = New("TextLabel", {
				Name = "Title",
				Size = UDim2.new(1, -(textX + 12), 0, 16),
				Position = UDim2.new(0, textX, 0, 8),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamSemibold,
				Text = n.Title,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(235, 235, 240),
				TextTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = toast,
			})
			txt = New("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -(textX + 12), 0, 22),
				Position = UDim2.new(0, textX, 0, 26),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = n.Text,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(200, 200, 208),
				TextTransparency = 1,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = toast,
			})
			TweenService:Create(tt, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
		else
			txt = New("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -(textX + 12), 1, 0),
				Position = UDim2.new(0, textX, 0, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = n.Text,
				TextSize = 15,
				TextColor3 = Color3.fromRGB(235, 235, 240),
				TextTransparency = 1,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = toast,
			})
		end
		table.insert(NotifyActive, toast)
		Relayout()
		TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
		TweenService:Create(txt, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
		local pause = false
		toast.MouseEnter:Connect(function()
			pause = true
		end)
		toast.MouseLeave:Connect(function()
			pause = false
		end)
		toast.MouseButton1Click:Connect(function()
			DismissToast(toast)
		end)
		if n.Click then
			toast.MouseButton1Click:Connect(n.Click)
		end
		task.spawn(function()
			local remaining = n.Duration
			local guard = 0
			while remaining > 0 do
				task.wait(0.1)
				if not toast.Parent then
					return
				end
				guard = guard + 1
				if not pause then
					remaining = remaining - 0.1
				elseif guard > (n.Duration * 10 + 50) then
					break
				end
			end
			if toast.Parent then
				DismissToast(toast)
			end
		end)
		return toast
	end
	function Library:Notification(n)
		if type(n) == "string" then
			n = { Text = n }
		end
		n.Text = n.Text or ""
		n.Duration = n.Duration or 3
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
		NotifyMax = n and n or 3
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
