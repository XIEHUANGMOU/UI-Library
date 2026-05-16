local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local TargetGui = (gethui and gethui()) or CoreGui

local Library = {
    Connections = {},
    ActiveWindow = nil,
    Theme = {
        MainBackground = Color3.fromRGB(15, 15, 15),
        SidebarBackground = Color3.fromRGB(20, 20, 20),
        TopbarBackground = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(85, 170, 255),
        TextPrimary = Color3.fromRGB(240, 240, 240),
        TextSecondary = Color3.fromRGB(150, 150, 150),
        ElementBackground = Color3.fromRGB(30, 30, 30),
        ElementHover = Color3.fromRGB(40, 40, 40),
        Shadow = Color3.fromRGB(0, 0, 0)
    }
}

local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    duration = duration or 0.3
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbar, mainFrame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local inputBeganConn = topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    local inputChangedConn = topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local renderSteppedConn = RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Tween(mainFrame, {Position = targetPos}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end
    end)

    table.insert(Library.Connections, inputBeganConn)
    table.insert(Library.Connections, inputChangedConn)
    table.insert(Library.Connections, renderSteppedConn)
end

function Library:Notify(options)
    local title = options.Title or "Notification"
    local content = options.Content or "Description"
    local duration = options.Duration or 5
    local image = options.Image

    if not self.NotificationScreen then
        self.NotificationScreen = Create("ScreenGui", {
            Name = "FluidUI_Notifications",
            Parent = TargetGui,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        })
        self.NotificationContainer = Create("Frame", {
            Name = "Container",
            Parent = self.NotificationScreen,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 250, 1, -40),
            Position = UDim2.new(1, -270, 0, 20)
        })
        local uiListLayout = Create("UIListLayout", {
            Parent = self.NotificationContainer,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 10)
        })
    end

    local notifFrame = Create("Frame", {
        Name = "Notification",
        Parent = self.NotificationContainer,
        BackgroundColor3 = self.Theme.MainBackground,
        Size = UDim2.new(0, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    local uiCorner = Create("UICorner", {
        Parent = notifFrame,
        CornerRadius = UDim.new(0, 6)
    })

    local notifShadow = Create("ImageLabel", {
        Name = "NotifShadow",
        Parent = notifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        Image = "rbxassetid://1316045217",
        ImageColor3 = self.Theme.Shadow,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(15, 15, 15, 15),
        ZIndex = 0
    })

    local colorBar = Create("Frame", {
        Name = "ColorBar",
        Parent = notifFrame,
        BackgroundColor3 = self.Theme.Accent,
        Size = UDim2.new(0, 3, 1, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })

    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = notifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0, 225, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })

    local contentLabel = Create("TextLabel", {
        Name = "Content",
        Parent = notifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(0, 225, 1, -40),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextTransparency = 1
    })

    if image then
        local icon = Create("ImageLabel", {
            Parent = notifFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 15),
            Size = UDim2.new(0, 30, 0, 30),
            Image = image,
            ImageTransparency = 1
        })
        titleLabel.Position = UDim2.new(0, 55, 0, 10)
        titleLabel.Size = UDim2.new(0, 185, 0, 20)
        contentLabel.Position = UDim2.new(0, 55, 0, 30)
        contentLabel.Size = UDim2.new(0, 185, 1, -40)
        Tween(icon, {ImageTransparency = 0}, 0.5)
    end

    Tween(notifFrame, {Size = UDim2.new(0, 250, 0, 60), BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Tween(notifShadow, {ImageTransparency = 0.4}, 0.5)
    Tween(colorBar, {BackgroundTransparency = 0}, 0.5)
    Tween(titleLabel, {TextTransparency = 0}, 0.5)
    Tween(contentLabel, {TextTransparency = 0}, 0.5)

    task.delay(duration, function()
        Tween(notifFrame, {Size = UDim2.new(0, 0, 0, 60), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(notifShadow, {ImageTransparency = 1}, 0.5)
        Tween(colorBar, {BackgroundTransparency = 1}, 0.5)
        Tween(titleLabel, {TextTransparency = 1}, 0.5)
        Tween(contentLabel, {TextTransparency = 1}, 0.5)
        if image then
            Tween(notifFrame:FindFirstChildOfClass("ImageLabel"), {ImageTransparency = 1}, 0.5)
        end
        task.wait(0.5)
        notifFrame:Destroy()
    end)
end

function Library:CreateWindow(options)
    local title = options.Title or "Fluid UI"
    local ballIcon = options.BallIcon or "rbxassetid://6034287525"

    if self.ActiveWindow then
        self.ActiveWindow:Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "FluidUI_Main",
        Parent = TargetGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    self.ActiveWindow = ScreenGui

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 600, 0, 400),
        BackgroundColor3 = self.Theme.MainBackground,
        ClipsDescendants = false,
        BackgroundTransparency = 1
    })

    local AspectRatio = Create("UIAspectRatioConstraint", {
        Parent = MainFrame,
        AspectRatio = 1.5,
        AspectType = Enum.AspectType.FitWithinMaxSize,
        DominantAxis = Enum.DominantAxis.Width
    })

    local MainCorner = Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })

    local DropShadow = Create("ImageLabel", {
        Name = "DropShadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        Image = "rbxassetid://1316045217",
        ImageColor3 = self.Theme.Shadow,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(15, 15, 15, 15),
        ZIndex = 0
    })

    local Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = MainFrame,
        BackgroundColor3 = self.Theme.TopbarBackground,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    Create("UICorner", { Parent = Topbar, CornerRadius = UDim.new(0, 8) })
    
    local TopbarBottomFix = Create("Frame", {
        Name = "BottomFix",
        Parent = Topbar,
        BackgroundColor3 = self.Theme.TopbarBackground,
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })

    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -100, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })

    local ControlContainer = Create("Frame", {
        Name = "Controls",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0, 0),
        Size = UDim2.new(0, 70, 1, 0)
    })

    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Parent = ControlContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -35, 0, 0),
        Size = UDim2.new(0, 35, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "✕",
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 14,
        TextTransparency = 1
    })

    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = ControlContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0, 0),
        Size = UDim2.new(0, 35, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "—",
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 14,
        TextTransparency = 1
    })

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = self.Theme.SidebarBackground,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 150, 1, -40),
        BackgroundTransparency = 1
    })
    Create("UICorner", { Parent = Sidebar, CornerRadius = UDim.new(0, 8) })

    local SidebarRightFix = Create("Frame", {
        Name = "RightFix",
        Parent = Sidebar,
        BackgroundColor3 = self.Theme.SidebarBackground,
        Size = UDim2.new(0, 8, 1, 0),
        Position = UDim2.new(1, -8, 0, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })

    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.new(0, 0, 0, 10),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    local TabListLayout = Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -150, 1, -40),
        ClipsDescendants = true
    })

    local FloatingBall = Create("ImageButton", {
        Name = "FloatingBall",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.9, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Theme.MainBackground,
        Image = ballIcon,
        ImageTransparency = 1,
        BackgroundTransparency = 1,
        Visible = false,
        ClipsDescendants = false
    })
    Create("UICorner", { Parent = FloatingBall, CornerRadius = UDim.new(1, 0) })
    
    local BallShadow = Create("ImageLabel", {
        Name = "BallShadow",
        Parent = FloatingBall,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -10, 0, -10),
        Size = UDim2.new(1, 20, 1, 20),
        Image = "rbxassetid://1316045217",
        ImageColor3 = self.Theme.Shadow,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(15, 15, 15, 15),
        ZIndex = 0
    })

    MakeDraggable(Topbar, MainFrame)

    local function ApplyHover(button, defaultColor, hoverColor)
        local hoverEnter = button.MouseEnter:Connect(function()
            Tween(button, {TextColor3 = hoverColor}, 0.2)
        end)
        local hoverLeave = button.MouseLeave:Connect(function()
            Tween(button, {TextColor3 = defaultColor}, 0.2)
        end)
        table.insert(Library.Connections, hoverEnter)
        table.insert(Library.Connections, hoverLeave)
    end
    ApplyHover(CloseBtn, self.Theme.TextSecondary, Color3.fromRGB(255, 80, 80))
    ApplyHover(MinimizeBtn, self.Theme.TextSecondary, self.Theme.TextPrimary)

    local closeClick = CloseBtn.MouseButton1Click:Connect(function()
        for _, conn in pairs(Library.Connections) do
            if conn then conn:Disconnect() end
        end
        Library.Connections = {}
        Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 350), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        for _, v in pairs(MainFrame:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("ScrollingFrame") then
                pcall(function() Tween(v, {BackgroundTransparency = 1}, 0.2) end)
            elseif v:IsA("TextLabel") or v:IsA("TextButton") then
                pcall(function() Tween(v, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2) end)
            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                pcall(function() Tween(v, {BackgroundTransparency = 1, ImageTransparency = 1}, 0.2) end)
            end
        end
        task.wait(0.3)
        ScreenGui:Destroy()
        if self.NotificationScreen then self.NotificationScreen:Destroy() end
    end)
    table.insert(Library.Connections, closeClick)

    local isMinimized = false
    local minimizeClick = MinimizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then return end
        isMinimized = true
        
        Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 300), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        for _, v in pairs(MainFrame:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("ScrollingFrame") then
                pcall(function() Tween(v, {BackgroundTransparency = 1}, 0.2) end)
            elseif v:IsA("TextLabel") or v:IsA("TextButton") then
                pcall(function() Tween(v, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2) end)
            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                pcall(function() Tween(v, {BackgroundTransparency = 1, ImageTransparency = 1}, 0.2) end)
            end
        end
        
        task.wait(0.3)
        MainFrame.Visible = false
        FloatingBall.Visible = true
        FloatingBall.Position = UDim2.new(0.5, 0, 0.5, 0) 
        
        local targetBallPos = UDim2.new(0.95, -25, 0.5, 0)
        Tween(FloatingBall, {Size = UDim2.new(0, 50, 0, 50), Position = targetBallPos, BackgroundTransparency = 0, ImageTransparency = 0}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Tween(BallShadow, {ImageTransparency = 0.3}, 0.5)
    end)
    table.insert(Library.Connections, minimizeClick)

    local ballDragging = false
    local ballDragStart, ballStartPos, ballInput
    
    local ballBegan = FloatingBall.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            ballDragging = true
            ballDragStart = input.Position
            ballStartPos = FloatingBall.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    ballDragging = false
                    local clickDelta = (input.Position - ballDragStart).Magnitude
                    if clickDelta < 5 then
                        isMinimized = false
                        Tween(FloatingBall, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, ImageTransparency = 1}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                        Tween(BallShadow, {ImageTransparency = 1}, 0.3)
                        task.wait(0.3)
                        FloatingBall.Visible = false
                        MainFrame.Visible = true
                        
                        Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Tween(Topbar, {BackgroundTransparency = 0}, 0.4)
                        Tween(TopbarBottomFix, {BackgroundTransparency = 0}, 0.4)
                        Tween(Sidebar, {BackgroundTransparency = 0}, 0.4)
                        Tween(SidebarRightFix, {BackgroundTransparency = 0}, 0.4)
                        Tween(DropShadow, {ImageTransparency = 0.3}, 0.4)
                        Tween(TitleLabel, {TextTransparency = 0}, 0.4)
                        Tween(CloseBtn, {TextTransparency = 0}, 0.4)
                        Tween(MinimizeBtn, {TextTransparency = 0}, 0.4)
                        
                        for _, v in pairs(ContentContainer:GetDescendants()) do
                            if v:GetAttribute("IsActiveTab") then
                                pcall(function() Tween(v, {BackgroundTransparency = 0, TextTransparency = 0, ImageTransparency = 0}, 0.4) end)
                            end
                        end
                        for _, v in pairs(TabContainer:GetDescendants()) do
                            if v:IsA("TextButton") then
                                pcall(function() Tween(v, {BackgroundTransparency = v:GetAttribute("DefaultBgTrans"), TextTransparency = 0}, 0.4) end)
                                local icon = v:FindFirstChildOfClass("ImageLabel")
                                if icon then Tween(icon, {ImageTransparency = 0}, 0.4) end
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    local ballChanged = FloatingBall.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            ballInput = input
        end
    end)
    
    local ballStepped = RunService.RenderStepped:Connect(function()
        if ballDragging and ballInput then
            local delta = ballInput.Position - ballDragStart
            local targetPos = UDim2.new(ballStartPos.X.Scale, ballStartPos.X.Offset + delta.X, ballStartPos.Y.Scale, ballStartPos.Y.Offset + delta.Y)
            Tween(FloatingBall, {Position = targetPos}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end
    end)

    table.insert(Library.Connections, ballBegan)
    table.insert(Library.Connections, ballChanged)
    table.insert(Library.Connections, ballStepped)

    Tween(MainFrame, {BackgroundTransparency = 0}, 0.5)
    Tween(DropShadow, {ImageTransparency = 0.3}, 0.5)
    Tween(Topbar, {BackgroundTransparency = 0}, 0.5)
    Tween(TopbarBottomFix, {BackgroundTransparency = 0}, 0.5)
    Tween(Sidebar, {BackgroundTransparency = 0}, 0.5)
    Tween(SidebarRightFix, {BackgroundTransparency = 0}, 0.5)
    Tween(TitleLabel, {TextTransparency = 0}, 0.5)
    Tween(CloseBtn, {TextTransparency = 0}, 0.5)
    Tween(MinimizeBtn, {TextTransparency = 0}, 0.5)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(tabOptions)
        local tabTitle = tabOptions.Title or "Tab"
        local tabIcon = tabOptions.Icon

        local TabBtn = Create("TextButton", {
            Name = tabTitle,
            Parent = TabContainer,
            BackgroundColor3 = Library.Theme.ElementHover,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 35),
            Font = Enum.Font.GothamSemibold,
            Text = tabTitle,
            TextColor3 = Library.Theme.TextSecondary,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
            AutoButtonColor = false
        })
        Create("UICorner", { Parent = TabBtn, CornerRadius = UDim.new(0, 6) })
        TabBtn:SetAttribute("DefaultBgTrans", 1)

        local TextOffset = 15
        if tabIcon then
            local IconLabel = Create("ImageLabel", {
                Name = "Icon",
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = (type(tabIcon) == "number" and "rbxassetid://"..tabIcon) or tabIcon,
                ImageColor3 = Library.Theme.TextSecondary,
                ImageTransparency = 1
            })
            TextOffset = 40
        end

        local UIPadding = Create("UIPadding", {
            Parent = TabBtn,
            PaddingLeft = UDim.new(0, TextOffset)
        })

        local TabPage = Create("ScrollingFrame", {
            Name = tabTitle.."Page",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(1, 50, 0, 10),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        })
        TabPage:SetAttribute("IsActiveTab", false)

        local PageLayout = Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })

        local updateCanvas = PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)
        table.insert(Library.Connections, updateCanvas)

        local function ActivateTab()
            if Window.CurrentTab == TabPage then return end

            if Window.CurrentTab then
                local oldPage = Window.CurrentTab
                local oldBtn = Window.CurrentTabBtn
                oldPage:SetAttribute("IsActiveTab", false)
                oldBtn:SetAttribute("DefaultBgTrans", 1)
                
                Tween(oldBtn, {BackgroundTransparency = 1, TextColor3 = Library.Theme.TextSecondary}, 0.3)
                if oldBtn:FindFirstChild("Icon") then
                    Tween(oldBtn.Icon, {ImageColor3 = Library.Theme.TextSecondary}, 0.3)
                end

                Tween(oldPage, {Position = UDim2.new(-1, -50, 0, 10)}, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                for _, v in pairs(oldPage:GetDescendants()) do
                    if v:IsA("Frame") or v:IsA("ScrollingFrame") then
                        pcall(function() Tween(v, {BackgroundTransparency = 1}, 0.2) end)
                    elseif v:IsA("TextLabel") or v:IsA("TextButton") then
                        pcall(function() Tween(v, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2) end)
                    elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                        pcall(function() Tween(v, {BackgroundTransparency = 1, ImageTransparency = 1}, 0.2) end)
                    end
                end
                task.delay(0.4, function() oldPage.Visible = false end)
            end

            Window.CurrentTab = TabPage
            Window.CurrentTabBtn = TabBtn
            TabPage:SetAttribute("IsActiveTab", true)
            TabBtn:SetAttribute("DefaultBgTrans", 0)

            TabPage.Visible = true
            TabPage.Position = UDim2.new(1, 50, 0, 10)
            Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = Library.Theme.Accent}, 0.3)
            if TabBtn:FindFirstChild("Icon") then
                Tween(TabBtn.Icon, {ImageColor3 = Library.Theme.Accent}, 0.3)
            end

            Tween(TabPage, {Position = UDim2.new(0, 10, 0, 10)}, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            for _, v in pairs(TabPage:GetDescendants()) do
                if v:IsA("Frame") then
                    pcall(function() Tween(v, {BackgroundTransparency = 0}, 0.4) end)
                elseif v:IsA("TextLabel") or v:IsA("TextButton") then
                    pcall(function() Tween(v, {TextTransparency = 0, BackgroundTransparency = (v.Name == "Ripple" and 1 or 0)}, 0.4) end)
                elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                    pcall(function() Tween(v, {ImageTransparency = 0}, 0.4) end)
                end
            end
        end

        local tabClick = TabBtn.MouseButton1Click:Connect(ActivateTab)
        table.insert(Library.Connections, tabClick)

        local tabEnter = TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= TabPage then
                Tween(TabBtn, {BackgroundTransparency = 0.5, TextColor3 = Library.Theme.TextPrimary}, 0.2)
                if TabBtn:FindFirstChild("Icon") then Tween(TabBtn.Icon, {ImageColor3 = Library.Theme.TextPrimary}, 0.2) end
            end
        end)
        local tabLeave = TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= TabPage then
                Tween(TabBtn, {BackgroundTransparency = 1, TextColor3 = Library.Theme.TextSecondary}, 0.2)
                if TabBtn:FindFirstChild("Icon") then Tween(TabBtn.Icon, {ImageColor3 = Library.Theme.TextSecondary}, 0.2) end
            end
        end)
        table.insert(Library.Connections, tabEnter)
        table.insert(Library.Connections, tabLeave)

        local TabElements = {}

        function TabElements:CreateButton(btnOptions)
            local btnText = btnOptions.Text or "Button"
            local btnCallback = btnOptions.Callback or function() end

            local ButtonFrame = Create("TextButton", {
                Name = "Button",
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.ElementBackground,
                Size = UDim2.new(1, -10, 0, 40),
                Font = Enum.Font.Gotham,
                Text = btnText,
                TextColor3 = Library.Theme.TextPrimary,
                TextSize = 14,
                AutoButtonColor = false,
                ClipsDescendants = true
            })
            Create("UICorner", { Parent = ButtonFrame, CornerRadius = UDim.new(0, 6) })

            local btnEnter = ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.ElementHover}, 0.2)
            end)
            local btnLeave = ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.ElementBackground}, 0.2)
            end)
            
            local btnDown = ButtonFrame.MouseButton1Down:Connect(function()
                Tween(ButtonFrame, {Size = UDim2.new(1, -14, 0, 36)}, 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            end)

            local btnUp = ButtonFrame.MouseButton1Up:Connect(function()
                Tween(ButtonFrame, {Size = UDim2.new(1, -10, 0, 40)}, 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                btnCallback()
            end)

            table.insert(Library.Connections, btnEnter)
            table.insert(Library.Connections, btnLeave)
            table.insert(Library.Connections, btnDown)
            table.insert(Library.Connections, btnUp)
        end

        if not Window.CurrentTab then
            ActivateTab()
        else
            TabBtn.BackgroundTransparency = 1
            TabBtn.TextTransparency = 1
            if TabBtn:FindFirstChild("Icon") then TabBtn.Icon.ImageTransparency = 1 end
        end

        return TabElements
    end

    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    local tabLayoutConn = TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)
    table.insert(Library.Connections, tabLayoutConn)

    return Window
end

return Library
