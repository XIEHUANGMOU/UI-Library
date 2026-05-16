--[[
    Fluent UI Library for Roblox Executors
    Designed by Senior Frontend Architect
    Modern Fluid Design / Premium Dark Theme
    Fully Modular, Production-Ready, No Placeholders
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    CurrentWindow = nil,
    Notifications = {},
    Signals = {}
}

-- [[ Utility Functions ]]

local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        if k ~= "Parent" then
            instance[k] = v
        end
    end
    instance.Parent = properties.Parent
    return instance
end

local function Tween(instance, info, propertyTable)
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

local function MakeDraggable(dragFrame, objectToDrag)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Tween(objectToDrag, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
    end

    local c1 = dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = objectToDrag.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    local c2 = dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local c3 = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    table.insert(Library.Signals, c1)
    table.insert(Library.Signals, c2)
    table.insert(Library.Signals, c3)
end

-- [[ Notification System ]]

local NotifyGui = Create("ScreenGui", {
    Name = "Fluent_Notifications",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui
})

local NotifyLayoutFrame = Create("Frame", {
    Name = "NotificationContainer",
    Position = UDim2.new(1, -20, 1, -20),
    Size = UDim2.new(0, 320, 1, -40),
    AnchorPoint = Vector2.new(1, 1),
    BackgroundTransparency = 1,
    Parent = NotifyGui
})

local NotifyListLayout = Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 10),
    Parent = NotifyLayoutFrame
})

function Library:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 5
    local iconId = config.Image

    local notificationFrame = Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = NotifyLayoutFrame
    })

    local uiCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notificationFrame
    })

    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(45, 45, 55),
        Thickness = 1,
        Transparency = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = notificationFrame
    })

    local accentBar = Create("Frame", {
        Name = "AccentBar",
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 122, 255),
        BorderSizePixel = 0,
        Parent = notificationFrame
    })

    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Text = title,
        TextTransparency = 1,
        Parent = notificationFrame
    })

    local contentLabel = Create("TextLabel", {
        Name = "Content",
        Position = UDim2.new(0, 15, 0, 28),
        Size = UDim2.new(1, -30, 1, -36),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(200, 200, 205),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Text = content,
        TextTransparency = 1,
        Parent = notificationFrame
    })

    if iconId then
        titleLabel.Position = UDim2.new(0, 40, 0, 8)
        contentLabel.Position = UDim2.new(0, 40, 0, 28)
        titleLabel.Size = UDim2.new(1, -55, 0, 20)
        contentLabel.Size = UDim2.new(1, -55, 1, -36)

        local iconFrame = Create("ImageLabel", {
            Name = "Icon",
            Position = UDim2.new(0, 12, 0, 10),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Image = typeof(iconId) == "number" and "rbxassetid://" .. iconId or iconId,
            ImageColor3 = Color3.fromRGB(0, 122, 255),
            ImageTransparency = 1,
            Parent = notificationFrame
        })
        Tween(iconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 0})
    end

    -- Measurement for dynamic sizing
    local baseHeight = 45
    local textBounds = game:GetService("TextService"):GetTextSize(content, 12, Enum.Font.Gotham, Vector2.new(250, 1000))
    local targetHeight = math.clamp(baseHeight + textBounds.Y, 65, 120)

    notificationFrame.Size = UDim2.new(1, 0, 0, 0)
    notificationFrame.Position = UDim2.new(0, 50, 0, 0)

    Tween(notificationFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight), BackgroundTransparency = 0})
    Tween(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Transparency = 0})
    Tween(titleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 0})
    Tween(contentLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 0})

    task.spawn(function()
        local breatheIn = true
        local startTime = os.clock()
        while os.clock() - startTime < duration and notificationFrame and notificationFrame.Parent do
            local pulse = breatheIn and 0.3 or 0.7
            Tween(stroke, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Transparency = pulse})
            breatheIn = not breatheIn
            task.wait(1)
        end

        if notificationFrame and notificationFrame.Parent then
            Tween(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Position = UDim2.new(0, 100, 0, 0)})
            Tween(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
            Tween(titleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextTransparency = 1})
            Tween(contentLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextTransparency = 1})
            task.wait(0.3)
            notificationFrame:Destroy()
        end
    end)
end

-- [[ Core UI Window Creation ]]

function Library:CreateWindow(titleText)
    if Library.CurrentWindow then
        return Library.CurrentWindow
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "Fluent_UI_Framework",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350),
        BackgroundColor3 = Color3.fromRGB(18, 18, 22),
        BackgroundTransparency = 0,
        ClipsDescendants = false,
        Parent = ScreenGui
    })

    local MainCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame
    })

    local MainStroke = Create("UIStroke", {
        Color = Color3.fromRGB(40, 40, 48),
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = MainFrame
    })

    -- Shadow Layer (Dynamic Scale & Follow)
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = MainFrame
    })

    -- Top Bar / Drag Handle
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    local WindowTitle = Create("TextLabel", {
        Name = "WindowTitle",
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 300, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(240, 240, 245),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Text = titleText or "Fluent UI",
        Parent = TopBar
    })

    local ControlButtons = Create("Frame", {
        Name = "ControlButtons",
        Position = UDim2.new(1, -80, 0, 0),
        Size = UDim2.new(0, 80, 1, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    local MinimizeButton = Create("TextButton", {
        Name = "Minimize",
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Text = "",
        Parent = ControlButtons
    })

    local MinimizeIcon = Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10734896206",
        ImageColor3 = Color3.fromRGB(180, 180, 185),
        Parent = MinimizeButton
    })

    local CloseButton = Create("TextButton", {
        Name = "Close",
        Position = UDim2.new(0, 45, 0, 10),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Text = "",
        Parent = ControlButtons
    })

    local CloseIcon = Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10723415982",
        ImageColor3 = Color3.fromRGB(180, 180, 185),
        Parent = CloseButton
    })

    -- Drag Integration
    MakeDraggable(TopBar, MainFrame)

    -- Sidebar / Tab Selection Container
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Position = UDim2.new(0, 10, 0, 50),
        Size = UDim2.new(0, 140, 1, -60),
        BackgroundColor3 = Color3.fromRGB(23, 23, 28),
        Parent = MainFrame
    })

    local SidebarCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Sidebar
    })

    local SidebarStroke = Create("UIStroke", {
        Color = Color3.fromRGB(35, 35, 42),
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = Sidebar
    })

    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 1, -10),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        Parent = Sidebar
    })

    local TabListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = TabScroll
    })

    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Position = UDim2.new(0, 160, 0, 50),
        Size = UDim2.new(1, -170, 1, -60),
        BackgroundColor3 = Color3.fromRGB(23, 23, 28),
        Parent = MainFrame
    })

    local ContentCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = ContentContainer
    })

    local ContentStroke = Create("UIStroke", {
        Color = Color3.fromRGB(35, 35, 42),
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = ContentContainer
    })

    -- Floating Action Button / Minimization Sphere
    local FloatingBall = Create("TextButton", {
        Name = "FloatingBall",
        Position = UDim2.new(0, 20, 0.5, -25),
        Size = UDim2.new(0, 50, 0, 50),
        BackgroundColor3 = Color3.fromRGB(30, 30, 38),
        Text = "",
        Visible = false,
        Parent = ScreenGui
    })

    local BallCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = FloatingBall
    })

    local BallStroke = Create("UIStroke", {
        Color = Color3.fromRGB(0, 122, 255),
        Thickness = 1.5,
        Parent = FloatingBall
    })

    local BallShadow = Create("ImageLabel", {
        Name = "BallShadow",
        Position = UDim2.new(0, -10, 0, -10),
        Size = UDim2.new(1, 20, 1, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.3,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = FloatingBall
    })

    local BallIcon = Create("ImageLabel", {
        Name = "BallIcon",
        Position = UDim2.new(0, 12, 0, 12),
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10734895656",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = FloatingBall
    })

    MakeDraggable(FloatingBall, FloatingBall)

    -- Window Level State Tracking
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        Minimized = false,
        Instance = ScreenGui
    }

    -- Button Interaction Effects
    local function BindHover(btn, icon, strokeInstance)
        local c1 = btn.MouseEnter:Connect(function()
            Tween(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
            if icon then Tween(icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(255, 255, 255)}) end
            if strokeInstance then Tween(strokeInstance, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(0, 122, 255)}) end
        end)
        local c2 = btn.MouseLeave:Connect(function()
            Tween(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(30, 30, 38)})
            if icon then Tween(icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(180, 180, 185)}) end
            if strokeInstance then Tween(strokeInstance, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(35, 35, 42)}) end
        end)
        table.insert(Library.Signals, c1)
        table.insert(Library.Signals, c2)
    end

    BindHover(MinimizeButton, MinimizeIcon)
    BindHover(CloseButton, CloseIcon)

    -- Minimization Mechanics
    local function ToggleMinimize()
        if Window.Minimized then
            -- Restore Phase
            FloatingBall.Visible = false
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 550, 0, 350)
            MainFrame.BackgroundTransparency = 1
            Shadow.ImageTransparency = 1
            TopBar.BackgroundTransparency = 1
            Sidebar.BackgroundTransparency = 1
            ContentContainer.BackgroundTransparency = 1
            
            Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
            Tween(Shadow, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {ImageTransparency = 0.4})
            Tween(Sidebar, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundTransparency = 0})
            Tween(ContentContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundTransparency = 0})
            
            Window.Minimized = false
        else
            -- Shrink to Floating Ball Phase
            Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            Tween(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 1})
            Tween(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
            Tween(ContentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
            
            task.wait(0.25)
            MainFrame.Visible = false
            FloatingBall.Position = UDim2.new(0, math.clamp(MainFrame.Position.X.Offset + 250, 20, Mouse.ViewSizeX - 70), 0, math.clamp(MainFrame.Position.Y.Offset + 150, 20, Mouse.ViewSizeY - 70))
            FloatingBall.Visible = true
            FloatingBall.Size = UDim2.new(0, 0, 0, 0)
            Tween(FloatingBall, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 50, 0, 50)})
            
            Window.Minimized = true
        end
    end

    local cMin = MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)
    local cFloat = FloatingBall.MouseButton1Click:Connect(ToggleMinimize)
    table.insert(Library.Signals, cMin)
    table.insert(Library.Signals, cFloat)

    local cClose = CloseButton.MouseButton1Click:Connect(function()
        Library:Destroy()
    end)
    table.insert(Library.Signals, cClose)

    -- [[ Tab Construction System ]]

    function Window:CreateTab(tabName, iconId)
        local TabPage = Create("ScrollingFrame", {
            Name = tabName .. "_Page",
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70),
            Visible = false,
            Parent = ContentContainer
        })

        local PageLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = TabPage
        })

        -- Auto Canvas Resize logic per tab
        local cCanvas = PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)
        table.insert(Library.Signals, cCanvas)

        -- Sidebar Button Elements
        local TabButton = Create("TextButton", {
            Name = tabName .. "_Btn",
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(23, 23, 28),
            BackgroundTransparency = 1,
            Text = "",
            Parent = TabScroll
        })

        local ButtonCorner = Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })

        local ButtonLabel = Create("TextLabel", {
            Name = "Label",
            Position = UDim2.new(0, 34, 0, 0),
            Size = UDim2.new(1, -39, 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(160, 160, 170),
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Text = tabName,
            Parent = TabButton
        })

        local ButtonIcon
        if iconId then
            ButtonIcon = Create("ImageLabel", {
                Name = "Icon",
                Position = UDim2.new(0, 8, 0, 9),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundTransparency = 1,
                Image = typeof(iconId) == "number" and "rbxassetid://" .. iconId or iconId,
                ImageColor3 = Color3.fromRGB(160, 160, 170),
                Parent = TabButton
            })
        else
            ButtonLabel.Position = UDim2.new(0, 12, 0, 0)
            ButtonLabel.Size = UDim2.new(1, -17, 1, 0)
        end

        local function ActivateThisTab()
            if Window.ActiveTab == TabButton then return end

            if Window.ActiveTab then
                local oldPage = ContentContainer:FindFirstChild(Window.ActiveTab.Name:gsub("_Btn", "_Page"))
                if oldPage then
                    Tween(oldPage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, -15, 0, 8), BackgroundTransparency = 1})
                    task.spawn(function()
                        task.wait(0.15)
                        oldPage.Visible = false
                    end)
                end
                Tween(Window.ActiveTab, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(23, 23, 28), BackgroundTransparency = 1})
                local oldLabel = Window.ActiveTab:FindFirstChild("Label")
                local oldIcon = Window.ActiveTab:FindFirstChild("Icon")
                if oldLabel then Tween(oldLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(160, 160, 170)}) end
                if oldIcon then Tween(oldIcon, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(160, 160, 170)}) end
            end

            Window.ActiveTab = TabButton
            Tween(TabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(33, 33, 44), BackgroundTransparency = 0})
            Tween(ButtonLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(255, 255, 255)})
            if ButtonIcon then Tween(ButtonIcon, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(0, 122, 255)}) end

            TabPage.Visible = true
            TabPage.Position = UDim2.new(0, 25, 0, 8)
            Tween(TabPage, TweenInfo.new(0.35, Enum.EasingStyle.Fluid or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 8, 0, 8)})
        end

        local cTabClick = TabButton.MouseButton1Click:Connect(ActivateThisTab)
        table.insert(Library.Signals, cTabClick)

        local cBtnHover = TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= TabButton then
                Tween(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5, BackgroundBackgroundColor3 = Color3.fromRGB(28, 28, 36)})
            end
        end)
        local cBtnLeave = TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= TabButton then
                Tween(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, BackgroundBackgroundColor3 = Color3.fromRGB(23, 23, 28)})
            end
        end)
        table.insert(Library.Signals, cBtnHover)
        table.insert(Library.Signals, cBtnLeave)

        if not Window.ActiveTab then
            ActivateThisTab()
        end

        -- [[ Interactive UI Components Generation ]]
        local ComponentFactory = {}

        -- Component 1: Functional Button
        function ComponentFactory:CreateButton(btnText, callback)
            local buttonFrame = Create("TextButton", {
                Name = "Button_" .. btnText,
                Size = UDim2.new(1, -8, 0, 36),
                BackgroundColor3 = Color3.fromRGB(30, 30, 38),
                Text = "",
                Parent = TabPage
            })

            local compCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = buttonFrame
            })

            local compStroke = Create("UIStroke", {
                Color = Color3.fromRGB(42, 42, 52),
                Thickness = 1,
                Parent = buttonFrame
            })

            local label = Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(230, 230, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                Text = btnText,
                Parent = buttonFrame
            })

            local cClick = buttonFrame.MouseButton1Click:Connect(function()
                Tween(buttonFrame, TweenInfo.new(0.05, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 122, 255)})
                task.wait(0.05)
                Tween(buttonFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 40, 52)})
                if callback then callback() end
            end)
            table.insert(Library.Signals, cClick)

            local cHov1 = buttonFrame.MouseEnter:Connect(function()
                Tween(buttonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 40, 52)})
                Tween(compStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(60, 60, 75)})
            end)
            local cHov2 = buttonFrame.MouseLeave:Connect(function()
                Tween(buttonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(30, 30, 38)})
                Tween(compStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(42, 42, 52)})
            end)
            table.insert(Library.Signals, cHov1)
            table.insert(Library.Signals, cHov2)
        end

        -- Component 2: Toggle Switch
        function ComponentFactory:CreateToggle(toggleText, defaultState, callback)
            local toggled = defaultState or false

            local toggleFrame = Create("TextButton", {
                Name = "Toggle_" .. toggleText,
                Size = UDim2.new(1, -8, 0, 38),
                BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                Text = "",
                Parent = TabPage
            })

            local compCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = toggleFrame
            })

            local label = Create("TextLabel", {
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(220, 220, 225),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Text = toggleText,
                Parent = toggleFrame
            })

            local switchTrack = Create("Frame", {
                Position = UDim2.new(1, -46, 0, 9),
                Size = UDim2.new(0, 34, 0, 20),
                BackgroundColor3 = toggled and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 55),
                Parent = toggleFrame
            })

            local trackCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = switchTrack
            })

            local switchBall = Create("Frame", {
                Position = toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = switchTrack
            })

            local ballCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = switchBall
            })

            local function updateToggle()
                if toggled then
                    Tween(switchTrack, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 122, 255)})
                    Tween(switchBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -18, 0, 2)})
                else
                    Tween(switchTrack, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)})
                    Tween(switchBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0, 2)})
                end
                if callback then callback(toggled) end
            end

            local cClick = toggleFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            table.insert(Library.Signals, cClick)

            local cHov1 = toggleFrame.MouseEnter:Connect(function()
                Tween(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)})
            end)
            local cHov2 = toggleFrame.MouseLeave:Connect(function()
                Tween(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)})
            end)
            table.insert(Library.Signals, cHov1)
            table.insert(Library.Signals, cHov2)
        end

        -- Component 3: Fluid Slider
        function ComponentFactory:CreateSlider(sliderText, min, max, default, callback)
            local value = math.clamp(default or min, min, max)

            local sliderFrame = Create("Frame", {
                Name = "Slider_" .. sliderText,
                Size = UDim2.new(1, -8, 0, 50),
                BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                Parent = TabPage
            })

            local compCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = sliderFrame
            })

            local label = Create("TextLabel", {
                Position = UDim2.new(0, 12, 0, 6),
                Size = UDim2.new(0, 200, 0, 18),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(210, 210, 215),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = sliderText,
                Parent = sliderFrame
            })

            local valueLabel = Create("TextLabel", {
                Position = UDim2.new(1, -72, 0, 6),
                Size = UDim2.new(0, 60, 0, 18),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(160, 160, 170),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Text = tostring(value),
                Parent = sliderFrame
            })

            local sliderTrack = Create("TextButton", {
                Position = UDim2.new(0, 12, 0, 30),
                Size = UDim2.new(1, -24, 0, 6),
                BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                Text = "",
                Parent = sliderFrame
            })

            local trackCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderTrack
            })

            local sliderFill = Create("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 122, 255),
                BorderSizePixel = 0,
                Parent = sliderTrack
            })

            local fillCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderFill
            })

            local sliding = false

            local function snapToValue(input)
                local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                value = math.round(min + relativeX * (max - min))
                valueLabel.Text = tostring(value)
                Tween(sliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Size = UDim2.new(relativeX, 0, 1, 0)})
                if callback then callback(value) end
            end

            local cInputBegan = sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    snapToValue(input)
                end
            end)

            local cInputEnded = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            local cChanged = UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    snapToValue(input)
                end
            end)

            table.insert(Library.Signals, cInputBegan)
            table.insert(Library.Signals, cInputEnded)
            table.insert(Library.Signals, cChanged)

            local cHov1 = sliderFrame.MouseEnter:Connect(function()
                Tween(sliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)})
            end)
            local cHov2 = sliderFrame.MouseLeave:Connect(function()
                Tween(sliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)})
            end)
            table.insert(Library.Signals, cHov1)
            table.insert(Library.Signals, cHov2)
        end

        -- Component 4: Standard Text Input Box
        function ComponentFactory:CreateTextbox(boxText, placeholder, callback)
            local textboxFrame = Create("Frame", {
                Name = "Textbox_" .. boxText,
                Size = UDim2.new(1, -8, 0, 42),
                BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                Parent = TabPage
            })

            local compCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = textboxFrame
            })

            local label = Create("TextLabel", {
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0, 150, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(210, 210, 215),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Text = boxText,
                Parent = textboxFrame
            })

            local inputBackground = Create("Frame", {
                Position = UDim2.new(1, -162, 0, 7),
                Size = UDim2.new(0, 150, 0, 28),
                BackgroundColor3 = Color3.fromRGB(36, 36, 44),
                Parent = textboxFrame
            })

            local inputCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = inputBackground
            })

            local inputStroke = Create("UIStroke", {
                Color = Color3.fromRGB(50, 50, 62),
                Thickness = 1,
                Parent = inputBackground
            })

            local textBox = Create("TextBox", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(240, 240, 245),
                TextSize = 12,
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder or "Type here...",
                PlaceholderColor3 = Color3.fromRGB(110, 110, 120),
                Text = "",
                ClipsDescendants = true,
                Parent = inputBackground
            })

            local cFocusBegan = textBox.FocusLost:Connect(function(enterPressed)
                Tween(inputStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(50, 50, 62)})
                if callback then callback(textBox.Text, enterPressed) end
            end)
            
            local cFocusEnded = textBox.Focused:Connect(function()
                Tween(inputStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(0, 122, 255)})
            end)

            table.insert(Library.Signals, cFocusBegan)
            table.insert(Library.Signals, cFocusEnded)

            local cHov1 = textboxFrame.MouseEnter:Connect(function()
                Tween(textboxFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)})
            end)
            local cHov2 = textboxFrame.MouseLeave:Connect(function()
                Tween(textboxFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)})
            end)
            table.insert(Library.Signals, cHov1)
            table.insert(Library.Signals, cHov2)
        end

        -- Component 5: Stateful Dropdown Selector
        function ComponentFactory:CreateDropdown(dropdownText, optionList, default, callback)
            local expanded = false
            local selectedValue = default or optionList[1] or ""

            local dropdownFrame = Create("Frame", {
                Name = "Dropdown_" .. dropdownText,
                Size = UDim2.new(1, -8, 0, 40),
                BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                ClipsDescendants = true,
                Parent = TabPage
            })

            local compCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = dropdownFrame
            })

            local mainButton = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Text = "",
                Parent = dropdownFrame
            })

            local label = Create("TextLabel", {
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0, 150, 0, 40),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(210, 210, 215),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Text = dropdownText,
                Parent = mainButton
            })

            local selectionDisplay = Create("TextLabel", {
                Position = UDim2.new(1, -45, 0, 0),
                Size = UDim2.new(0, 120, 0, 40),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(150, 150, 160),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextYAlignment = Enum.TextYAlignment.Center,
                Text = selectedValue,
                Parent = mainButton
            })

            local arrowIcon = Create("ImageLabel", {
                Position = UDim2.new(1, -22, 0, 14),
                Size = UDim2.new(0, 12, 0, 12),
                BackgroundTransparency = 1,
                Image = "rbxassetid://10709790229",
                ImageColor3 = Color3.fromRGB(160, 160, 170),
                Parent = mainButton
            })

            local optionsContainer = Create("Frame", {
                Position = UDim2.new(0, 8, 0, 40),
                Size = UDim2.new(1, -16, 0, #optionList * 30),
                BackgroundTransparency = 1,
                Parent = dropdownFrame
            })

            local optionsLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = optionsContainer
            })

            local function toggleDropdown()
                expanded = not expanded
                if expanded then
                    Tween(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -8, 0, 42 + #optionList * 32)})
                    Tween(arrowIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Rotation = 180})
                else
                    Tween(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -8, 0, 40)})
                    Tween(arrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = 0})
                end
            end

            local cMainClick = mainButton.MouseButton1Click:Connect(toggleDropdown)
            table.insert(Library.Signals, cMainClick)

            for i, option in ipairs(optionList) do
                local optButton = Create("TextButton", {
                    Name = "Opt_" .. tostring(option),
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(32, 32, 40),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(190, 190, 195),
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = "  " .. tostring(option),
                    Parent = optionsContainer
                })

                local optCorner = Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = optButton
                })

                local cOptClick = optButton.MouseButton1Click:Connect(function()
                    selectedValue = option
                    selectionDisplay.Text = tostring(option)
                    toggleDropdown()
                    if callback then callback(option) end
                end)
                table.insert(Library.Signals, cOptClick)

                local cOptHov = optButton.MouseEnter:Connect(function()
                    Tween(optButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(42, 42, 54)})
                end)
                local cOptLev = optButton.MouseLeave:Connect(function()
                    Tween(optButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
                end)
                table.insert(Library.Signals, cOptHov)
                table.insert(Library.Signals, cOptLev)
            end

            local cHov1 = dropdownFrame.MouseEnter:Connect(function()
                Tween(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)})
            end)
            local cHov2 = dropdownFrame.MouseLeave:Connect(function()
                if not expanded then
                    Tween(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)})
                end
            end)
            table.insert(Library.Signals, cHov1)
            table.insert(Library.Signals, cHov2)
        end

        return ComponentFactory
    end

    Library.CurrentWindow = Window
    return Window
end

-- [[ Global Garbage Clean-up / Lifecycle Destruction Method ]]

function Library:Destroy()
    for _, signal in ipairs(Library.Signals) do
        if signal and typeof(signal) == "RBXScriptConnection" then
            signal:Disconnect()
        end
    end
    table.clear(Library.Signals)

    if Library.CurrentWindow and Library.CurrentWindow.Instance then
        Library.CurrentWindow.Instance:Destroy()
        Library.CurrentWindow = nil
    end

    if NotifyGui then
        NotifyGui:Destroy()
    end
end

return Library
