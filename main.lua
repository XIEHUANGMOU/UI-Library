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
			ZIndex = 1,
			Parent = ScreenGui,
		})
		local TopBar = New("Frame", {
			Name = "TopBar",
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(26, 26, 31),
			BorderSizePixel = 0,
			ZIndex = 2,
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
			Position = UDim2.new(1, -64, 0, 4),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			Parent = TopBar,
		})
		local MinimizeIcon = New("TextLabel", {
			Name = "Icon",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = "-",
			TextSize = 18,
			TextColor3 = Color3.fromRGB(160, 160, 170),
			Parent = MinimizeButton,
		})
		local CloseButton = New("TextButton", {
			Name = "Close",
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(1, -34, 0, 4),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			Parent = TopBar,
		})
		local CloseIcon = New("TextLabel", {
			Name = "Icon",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = "X",
			TextSize = 16,
			TextColor3 = Color3.fromRGB(160, 160, 170),
			Parent = CloseButton,
		})
		local TabsContainer = New("Frame", {
			Name = "Tabs",
			Size = UDim2.new(0, 148, 1, -38),
			Position = UDim2.new(0, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(24, 24, 30),
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = Main,
		})
		local Body = New("Frame", {
			Name = "Body",
			Size = UDim2.new(1, -148, 1, -38),
			Position = UDim2.new(0, 148, 0, 38),
			BackgroundColor3 = Color3.fromRGB(18, 18, 22),
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = Main,
		})
		local TopDivider = New("Frame", {
			Name = "TopDivider",
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(44, 44, 54),
			BorderSizePixel = 0,
			ZIndex = 2,
			Parent = Main,
		})
		local SideDivider = New("Frame", {
			Name = "SideDivider",
			Size = UDim2.new(0, 1, 1, -38),
			Position = UDim2.new(0, 148, 0, 38),
			BackgroundColor3 = Color3.fromRGB(44, 44, 54),
			BorderSizePixel = 0,
			ZIndex = 2,
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
						ZIndex = 5,
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
					ZIndex = 5,
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
				MinimizeIcon.Text = "+"
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 38) }):Play()
				TabsContainer.Visible = false
				Body.Visible = false
			else
				MinimizeIcon.Text = "-"
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = size }):Play()
				task.wait(0.15)
				TabsContainer.Visible = true
				Body.Visible = true
			end
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
		CloseButton.MouseButton1Click:Connect(CloseWindow)
		MinimizeButton.MouseEnter:Connect(function()
			TweenService:Create(MinimizeIcon, TweenInfo.new(0.1), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
		end)
		MinimizeButton.MouseLeave:Connect(function()
			TweenService:Create(MinimizeIcon, TweenInfo.new(0.1), { TextColor3 = Color3.fromRGB(160, 160, 170) }):Play()
		end)
		CloseButton.MouseEnter:Connect(function()
			TweenService:Create(CloseIcon, TweenInfo.new(0.1), { TextColor3 = Color3.fromRGB(255, 120, 120) }):Play()
		end)
		CloseButton.MouseLeave:Connect(function()
			TweenService:Create(CloseIcon, TweenInfo.new(0.1), { TextColor3 = Color3.fromRGB(160, 160, 170) }):Play()
		end)
		local Window = {}
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
			TitleLabel.Text = t
		end
		function Window:GetScreenGui()
			return ScreenGui
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
			Size = UDim2.new(0, 72, 0, 72),
			Position = UDim2.new(1, -84, 1, -80),
			BackgroundTransparency = 1,
			Parent = ControlGui,
		})
		local function MakeControlButton(text, pos)
			local Btn = New("TextButton", {
				Name = text,
				Size = UDim2.new(0, 72, 0, 32),
				Position = pos,
				BackgroundColor3 = Color3.fromRGB(36, 36, 44),
				AutoButtonColor = false,
				Text = "",
				Parent = ControlGui,
			})
			New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })
			local Lbl = New("TextLabel", {
				Name = "Icon",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = text,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(230, 230, 236),
				Parent = Btn,
			})
			return Btn, Lbl
		end
		local VisButton, VisIcon = MakeControlButton("隐藏", UDim2.new(0, 0, 0, 0))
		local FixButton, FixIcon = MakeControlButton("固定", UDim2.new(0, 0, 0, 40))
		function Window:SetDraggable(v)
			WindowDraggable = v and true or false
			if FixIcon then
				FixIcon.Text = WindowDraggable and "固定" or "解锁"
				FixButton.BackgroundColor3 = WindowDraggable and Color3.fromRGB(36, 36, 44) or Color3.fromRGB(90, 160, 255)
			end
		end
		local function UpdateVisButton()
			VisIcon.Text = ScreenGui.Enabled and "隐藏" or "显示"
			VisButton.BackgroundColor3 = ScreenGui.Enabled and Color3.fromRGB(36, 36, 44) or Color3.fromRGB(70, 70, 80)
		end
		VisButton.MouseButton1Click:Connect(function()
			ScreenGui.Enabled = not ScreenGui.Enabled
			UpdateVisButton()
		end)
		FixButton.MouseButton1Click:Connect(function()
			WindowDraggable = not WindowDraggable
			FixIcon.Text = WindowDraggable and "固定" or "解锁"
			FixButton.BackgroundColor3 = WindowDraggable and Color3.fromRGB(36, 36, 44) or Color3.fromRGB(90, 160, 255)
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
	function Library:Notification(text, duration)
		local NotifyGui = New("ScreenGui", {
			DisplayOrder = 1000000001,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = LocalPlayer:WaitForChild("PlayerGui"),
		})
		local Holder = New("Frame", {
			Size = UDim2.new(0, 320, 0, 46),
			Position = UDim2.new(1, -332, 1, -16),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Color3.fromRGB(26, 26, 31),
			BorderSizePixel = 0,
			Parent = NotifyGui,
		})
		New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Holder })
		New("UIStroke", { Color = Color3.fromRGB(60, 60, 70), Thickness = 1, Parent = Holder })
		local NotifyText = New("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, -24, 1, 0),
			Position = UDim2.new(0, 12, 0, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			Text = text,
			TextSize = 16,
			TextColor3 = Color3.fromRGB(235, 235, 240),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Holder,
		})
		local NotifyBar = New("Frame", {
			Name = "Bar",
			Size = UDim2.new(1, 0, 0, 3),
			Position = UDim2.new(0, 0, 1, -3),
			BackgroundColor3 = Color3.fromRGB(90, 160, 255),
			BorderSizePixel = 0,
			Parent = Holder,
		})
		New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = NotifyBar })
		Holder.Position = UDim2.new(1, -332, 1, 30)
		Holder.BackgroundTransparency = 1
		NotifyText.TextTransparency = 1
		TweenService:Create(Holder, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(1, -332, 1, -16), BackgroundTransparency = 0 }):Play()
		TweenService:Create(NotifyText, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
		task.spawn(function()
			task.wait((duration or 3))
			TweenService:Create(NotifyBar, TweenInfo.new((duration or 3) - 1), { Size = UDim2.new(0, 0, 0, 3) }):Play()
		end)
		task.spawn(function()
			task.wait((duration or 3) + 0.5)
			TweenService:Create(Holder, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(1, -332, 1, 30), BackgroundTransparency = 1 }):Play()
			TweenService:Create(NotifyText, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
			task.wait(0.3)
			NotifyGui:Destroy()
		end)
		return Holder
	end
	function Library:CreateNotify(text, duration)
		return self:Notification(text, duration)
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
