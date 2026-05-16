local Library = {
    Version = "1.0.0",
    Connections = {},
    Instances = {},
    Theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Container = Color3.fromRGB(25, 25, 30),
        TopBar = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(85, 170, 255),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(40, 40, 45),
        Shadow = Color3.fromRGB(0, 0, 0),
        Notification = Color3.fromRGB(35, 35, 40)
    }
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local ProtectGui = (gethui and gethui) or function()
    local Success, Result = pcall(function() return CoreGui end)
    return Success and Result or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local TargetParent = ProtectGui()

local function Create(ClassName, Properties)
    local Inst = Instance.new(ClassName)
    for Key, Value in pairs(Properties) do
        Inst[Key] = Value
    end
    table.insert(Library.Instances, Inst)
    return Inst
end

local function Tween(Instance, Properties, Duration, Style, Direction)
    Duration = Duration or 0.3
    Style = Style or Enum.EasingStyle.Sine
    Direction = Direction or Enum.EasingDirection.Out
    local Info = TweenInfo.new(Duration, Style, Direction)
    local Anim = TweenService:Create(Instance, Info, Properties)
    Anim:Play()
    return Anim
end

local function MakeDraggableSmooth(DragPoint, MainFrame)
    local Dragging, DragInput, DragStart, StartPos
    
    local InputBeganConn = DragPoint.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = MainFrame.Position
            
            local InputEndedConn
            InputEndedConn = Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    if InputEndedConn then
                        InputEndedConn:Disconnect()
                    end
                end
            end)
            table.insert(Library.Connections, InputEndedConn)
        end
    end)
    
    local InputChangedConn = DragPoint.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)
    
    local UISChangedConn = UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Tween(MainFrame, {
                Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            }, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end)
    
    table.insert(Library.Connections, InputBeganConn)
    table.insert(Library.Connections, InputChangedConn)
    table.insert(Library.Connections, UISChangedConn)
end

local NotifyGui = Create("ScreenGui", {
    Name = "FluidNotifyGui",
    Parent = TargetParent,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

local NotifyContainer = Create("Frame", {
    Name = "Container",
    Parent = NotifyGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -280, 0, 20),
    Size = UDim2.new(0, 260, 1, -40)
})

local NotifyLayout = Create("UIListLayout", {
    Parent = NotifyContainer,
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 10)
})

function Library:Notify(Config)
    Config = Config or {}
    local Title = Config.Title or "Notification"
    local Content = Config.Content or "This is a notification."
    local Duration = Config.Duration or 5
    local IconId = Config.Image or nil

    local NotifyFrame = Create("Frame", {
        Name = "NotifyFrame",
        Parent = NotifyContainer,
        BackgroundColor3 = Library.Theme.Notification,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 80, 0, 0),
        Size = UDim2.new(1, 0, 0, 65),
        ClipsDescendants = false
    })

    Create("UICorner", {
        Parent = NotifyFrame,
        CornerRadius = UDim.new(0, 8)
    })

    local ColorStrip = Create("Frame", {
        Name = "ColorStrip",
        Parent = NotifyFrame,
        BackgroundColor3 = Library.Theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 1, 0)
    })

    Create("UICorner", {
        Parent = ColorStrip,
        CornerRadius = UDim.new(0, 8)
    })

    local TextContainerOffset = 12
    if IconId then
        TextContainerOffset = 45
        local Icon = Create("ImageLabel", {
            Name = "Icon",
            Parent = NotifyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, -12),
            Size = UDim2.new(0, 24, 0, 24),
            Image = string.find(IconId, "rbxassetid://") and IconId or "rbxassetid://" .. IconId,
            ImageColor3 = Library.Theme.Accent,
            ImageTransparency = 1
        })
    end

    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = NotifyFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, TextContainerOffset, 0, 12),
        Size = UDim2.new(1, -TextContainerOffset - 12, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })

    local ContentLabel = Create("TextLabel", {
        Name = "Content",
        Parent = NotifyFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, TextContainerOffset, 0, 32),
        Size = UDim2.new(1, -TextContainerOffset - 12, 0, 20),
        Font = Enum.Font.Gotham,
        Text = Content,
        TextColor3 = Library.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextTransparency = 1
    })

    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = NotifyFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Library.Theme.Shadow,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local BreathingAnim = TweenService:Create(ColorStrip, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
    BreathingAnim:Play()

    -- 优化后的滑入与渐显动画
    Tween(NotifyFrame, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Tween(TitleLabel, {TextTransparency = 0}, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Tween(ContentLabel, {TextTransparency = 0}, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Tween(ColorStrip, {BackgroundTransparency = 0}, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Tween(Shadow, {ImageTransparency = 0.5}, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    if IconId then
        Tween(NotifyFrame.Icon, {ImageTransparency = 0}, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end

    task.delay(Duration, function()
        BreathingAnim:Cancel()
        -- 优化后的滑出与渐隐动画
        local OutAnim = Tween(NotifyFrame, {Position = UDim2.new(1, 80, 0, 0), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(TitleLabel, {TextTransparency = 1}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(ContentLabel, {TextTransparency = 1}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(ColorStrip, {BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(Shadow, {ImageTransparency = 1}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        if IconId then
            Tween(NotifyFrame.Icon, {ImageTransparency = 1}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        end
        OutAnim.Completed:Connect(function()
            NotifyFrame:Destroy()
        end)
    end)
end

function Library:CreateWindow(Config)
    Config = Config or {}
    local WindowTitle = Config.Title or "Fluid UI Framework"
    local WindowSize = Config.Size or UDim2.new(0, 650, 0, 400)
    local DefaultIcon = Config.Icon or "rbxassetid://10137902794"

    local Window = {
        Tabs = {},
        CurrentTab = nil,
        IsMinimized = false
    }

    local ScreenGui = Create("ScreenGui", {
        Name = "FluidFrameworkGui",
        Parent = TargetParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2),
        Size = WindowSize,
        ClipsDescendants = false
    })

    Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 10)
    })

    local MainShadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -25, 0, -25),
        Size = UDim2.new(1, 50, 1, 50),
        ZIndex = -1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Library.Theme.Shadow,
        ImageTransparency = 0.3,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Library.Theme.TopBar,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })

    Create("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 10)
    })
    
    local TopBarBottomFix = Create("Frame", {
        Name = "BottomFix",
        Parent = TopBar,
        BackgroundColor3 = Library.Theme.TopBar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -5),
        Size = UDim2.new(1, 0, 0, 5)
    })

    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 0),
        Size = UDim2.new(1, -100, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = WindowTitle,
        TextColor3 = Library.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TitleIcon = Create("ImageLabel", {
        Name = "Icon",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0.5, -10),
        Size = UDim2.new(0, 20, 0, 20),
        Image = string.find(DefaultIcon, "rbxassetid://") and DefaultIcon or "rbxassetid://" .. DefaultIcon,
        ImageColor3 = Library.Theme.Accent
    })

    local ControlLayout = Create("Frame", {
        Name = "ControlLayout",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0, 0),
        Size = UDim2.new(0, 80, 1, 0)
    })

    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = ControlLayout,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Library.Theme.TextDark,
        TextSize = 20
    })

    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Parent = ControlLayout,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Library.Theme.TextDark,
        TextSize = 16
    })

    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Library.Theme.Container,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 50),
        Size = UDim2.new(0, 160, 1, -60)
    })

    Create("UICorner", {
        Parent = TabContainer,
        CornerRadius = UDim.new(0, 8)
    })

    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        Parent = TabContainer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 1, -10),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    local TabListLayout = Create("UIListLayout", {
        Parent = TabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundColor3 = Library.Theme.Container,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 180, 0, 50),
        Size = UDim2.new(1, -190, 1, -60),
        ClipsDescendants = true
    })

    Create("UICorner", {
        Parent = ContentContainer,
        CornerRadius = UDim.new(0, 8)
    })

    local FloatingBall = Create("ImageButton", {
        Name = "FloatingBall",
        Parent = ScreenGui,
        BackgroundColor3 = Library.Theme.Container,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 50, 0.5, -25),
        Size = UDim2.new(0, 50, 0, 50),
        Visible = false,
        AutoButtonColor = false,
        ClipsDescendants = false
    })

    Create("UICorner", {
        Parent = FloatingBall,
        CornerRadius = UDim.new(1, 0)
    })

    local BallShadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = FloatingBall,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Library.Theme.Shadow,
        ImageTransparency = 0.3,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local BallIcon = Create("ImageLabel", {
        Name = "Icon",
        Parent = FloatingBall,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -12, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Image = string.find(DefaultIcon, "rbxassetid://") and DefaultIcon or "rbxassetid://" .. DefaultIcon,
        ImageColor3 = Library.Theme.Accent
    })

    MakeDraggableSmooth(TopBar, MainFrame)
    MakeDraggableSmooth(FloatingBall, FloatingBall)

    local function CloseUI()
        for _, Conn in pairs(Library.Connections) do
            if Conn then Conn:Disconnect() end
        end
        local CloseAnim = Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(MainShadow, {ImageTransparency = 1}, 0.3)
        CloseAnim.Completed:Connect(function()
            ScreenGui:Destroy()
            NotifyGui:Destroy()
        end)
    end

    local function ToggleMinimize()
        Window.IsMinimized = not Window.IsMinimized
        if Window.IsMinimized then
            local MinimizeAnim = Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = FloatingBall.Position}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            Tween(MainShadow, {ImageTransparency = 1}, 0.3)
            MinimizeAnim.Completed:Connect(function()
                MainFrame.Visible = false
                FloatingBall.Visible = true
                FloatingBall.Size = UDim2.new(0, 0, 0, 0)
                Tween(FloatingBall, {Size = UDim2.new(0, 50, 0, 50)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end)
        else
            local RestoreAnim = Tween(FloatingBall, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            RestoreAnim.Completed:Connect(function()
                FloatingBall.Visible = false
                MainFrame.Visible = true
                MainFrame.Position = FloatingBall.Position
                Tween(MainFrame, {Size = WindowSize, Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                Tween(MainShadow, {ImageTransparency = 0.3}, 0.5)
            end)
        end
    end

    table.insert(Library.Connections, CloseBtn.MouseButton1Click:Connect(CloseUI))
    table.insert(Library.Connections, MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize))
    table.insert(Library.Connections, FloatingBall.MouseButton1Click:Connect(ToggleMinimize))

    table.insert(Library.Connections, CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 80, 80)}, 0.2) end))
    table.insert(Library.Connections, CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {TextColor3 = Library.Theme.TextDark}, 0.2) end))
    table.insert(Library.Connections, MinimizeBtn.MouseEnter:Connect(function() Tween(MinimizeBtn, {TextColor3 = Library.Theme.Text}, 0.2) end))
    table.insert(Library.Connections, MinimizeBtn.MouseLeave:Connect(function() Tween(MinimizeBtn, {TextColor3 = Library.Theme.TextDark}, 0.2) end))

    local function UpdateTabListSize()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end
    table.insert(Library.Connections, TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateTabListSize))

    function Window:CreateTab(TabConfig)
        TabConfig = TabConfig or {}
        local TabName = TabConfig.Name or "Tab"
        local TabIcon = TabConfig.Icon or nil

        local Tab = {
            Elements = {}
        }

        local TabButton = Create("TextButton", {
            Name = TabName .. "Btn",
            Parent = TabScroll,
            BackgroundColor3 = Library.Theme.Background,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 35),
            AutoButtonColor = false,
            Font = Enum.Font.GothamSemibold,
            Text = "",
            ClipsDescendants = true
        })

        Create("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 6)
        })

        local TextOffset = 15
        if TabIcon then
            TextOffset = 40
            Create("ImageLabel", {
                Name = "Icon",
                Parent = TabButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18),
                Image = string.find(TabIcon, "rbxassetid://") and TabIcon or "rbxassetid://" .. TabIcon,
                ImageColor3 = Library.Theme.TextDark
            })
        end

        local TabLabel = Create("TextLabel", {
            Name = "Title",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, TextOffset, 0, 0),
            Size = UDim2.new(1, -TextOffset, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = TabName,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local TabIndicator = Create("Frame", {
            Name = "Indicator",
            Parent = TabButton,
            BackgroundColor3 = Library.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.new(0, 3, 0, 16),
            BackgroundTransparency = 1
        })

        Create("UICorner", {
            Parent = TabIndicator,
            CornerRadius = UDim.new(0, 4)
        })

        local TabContent = Create("ScrollingFrame", {
            Name = TabName .. "Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Border,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })

        local ContentPadding = Create("UIPadding", {
            Parent = TabContent,
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })

        local ContentLayout = Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })

        local function UpdateContentSize()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end
        table.insert(Library.Connections, ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateContentSize))

        local function ActivateTab()
            if Window.CurrentTab == Tab then return end
            
            if Window.CurrentTab then
                local OldTab = Window.CurrentTab
                Tween(OldTab.Button, {BackgroundColor3 = Library.Theme.Background}, 0.3)
                Tween(OldTab.Label, {TextColor3 = Library.Theme.TextDark}, 0.3)
                Tween(OldTab.Indicator, {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 0)}, 0.3)
                if OldTab.Icon then
                    Tween(OldTab.Icon, {ImageColor3 = Library.Theme.TextDark}, 0.3)
                end
                
                local OldContent = OldTab.Content
                local FadeOut = Tween(OldContent, {Position = UDim2.new(-0.1, 0, 0, 0)}, 0.2)
                FadeOut.Completed:Connect(function()
                    if Window.CurrentTab ~= OldTab then
                        OldContent.Visible = false
                    end
                end)
            end
            
            Window.CurrentTab = Tab
            
            Tween(TabButton, {BackgroundColor3 = Library.Theme.Border}, 0.3)
            Tween(TabLabel, {TextColor3 = Library.Theme.Text}, 0.3)
            Tween(TabIndicator, {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0, 16)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            if TabIcon then
                Tween(TabButton.Icon, {ImageColor3 = Library.Theme.Accent}, 0.3)
            end
            
            TabContent.Visible = true
            TabContent.Position = UDim2.new(0.1, 0, 0, 0)
            Tween(TabContent, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end

        table.insert(Library.Connections, TabButton.MouseButton1Click:Connect(ActivateTab))
        
        table.insert(Library.Connections, TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Library.Theme.TopBar}, 0.2)
            end
        end))
        table.insert(Library.Connections, TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Library.Theme.Background}, 0.2)
            end
        end))

        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Indicator = TabIndicator
        Tab.Content = TabContent
        Tab.Icon = TabIcon and TabButton.Icon or nil
        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            ActivateTab()
        end

        function Tab:CreateButton(BtnConfig)
            BtnConfig = BtnConfig or {}
            local BtnName = BtnConfig.Name or "Button"
            local BtnIcon = BtnConfig.Icon or nil
            local Callback = BtnConfig.Callback or function() end

            local ButtonFrame = Create("TextButton", {
                Name = BtnName,
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.Background,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Font = Enum.Font.Gotham,
                Text = "",
                ClipsDescendants = true
            })

            Create("UICorner", {
                Parent = ButtonFrame,
                CornerRadius = UDim.new(0, 6)
            })

            local BtnTextOffset = 15
            if BtnIcon then
                BtnTextOffset = 45
                Create("ImageLabel", {
                    Name = "Icon",
                    Parent = ButtonFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    Image = string.find(BtnIcon, "rbxassetid://") and BtnIcon or "rbxassetid://" .. BtnIcon,
                    ImageColor3 = Library.Theme.Text
                })
            end

            local BtnLabel = Create("TextLabel", {
                Name = "Title",
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, BtnTextOffset, 0, 0),
                Size = UDim2.new(1, -BtnTextOffset, 1, 0),
                Font = Enum.Font.Gotham,
                Text = BtnName,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local function CreateRipple(X, Y)
                local Ripple = Create("Frame", {
                    Parent = ButtonFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.8,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, X, 0, Y),
                    Size = UDim2.new(0, 0, 0, 0),
                    ZIndex = 2
                })
                Create("UICorner", {Parent = Ripple, CornerRadius = UDim.new(1, 0)})
                
                local RippleTween = Tween(Ripple, {
                    Size = UDim2.new(0, 200, 0, 200),
                    Position = UDim2.new(0, X - 100, 0, Y - 100),
                    BackgroundTransparency = 1
                }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                
                RippleTween.Completed:Connect(function() Ripple:Destroy() end)
            end

            table.insert(Library.Connections, ButtonFrame.MouseButton1Down:Connect(function()
                Tween(ButtonFrame, {Size = UDim2.new(1, -4, 0, 36)}, 0.1)
            end))

            table.insert(Library.Connections, ButtonFrame.MouseButton1Up:Connect(function()
                Tween(ButtonFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
            end))

            table.insert(Library.Connections, ButtonFrame.MouseButton1Click:Connect(function()
                local MouseLoc = UserInputService:GetMouseLocation()
                local Relative = ButtonFrame.AbsolutePosition
                CreateRipple(MouseLoc.X - Relative.X, MouseLoc.Y - Relative.Y - 36) 
                pcall(Callback)
            end))

            table.insert(Library.Connections, ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.TopBar}, 0.2)
            end))
            table.insert(Library.Connections, ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Library.Theme.Background}, 0.2)
                Tween(ButtonFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
            end))
        end

        function Tab:CreateToggle(ToggleConfig)
            ToggleConfig = ToggleConfig or {}
            local ToggleName = ToggleConfig.Name or "Toggle"
            local DefaultState = ToggleConfig.Default or false
            local Callback = ToggleConfig.Callback or function() end

            local State = DefaultState

            local ToggleFrame = Create("TextButton", {
                Name = ToggleName,
                Parent = TabContent,
                BackgroundColor3 = Library.Theme.Background,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Font = Enum.Font.Gotham,
                Text = ""
            })

            Create("UICorner", {
                Parent = ToggleFrame,
                CornerRadius = UDim.new(0, 6)
            })

            local ToggleLabel = Create("TextLabel", {
                Name = "Title",
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Enum.Font.Gotham,
                Text = ToggleName,
                TextColor3 = Library.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SwitchBG = Create("Frame", {
                Name = "SwitchBG",
                Parent = ToggleFrame,
                BackgroundColor3 = State and Library.Theme.Accent or Library.Theme.Border,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -45, 0.5, -10),
                Size = UDim2.new(0, 34, 0, 20)
            })

            Create("UICorner", {
                Parent = SwitchBG,
                CornerRadius = UDim.new(1, 0)
            })

            local SwitchDot = Create("Frame", {
                Name = "Dot",
                Parent = SwitchBG,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = State and UDim2.new(0, 16, 0.5, -7) or UDim2.new(0, 4, 0.5, -7),
                Size = UDim2.new(0, 14, 0, 14)
            })

            Create("UICorner", {
                Parent = SwitchDot,
                CornerRadius = UDim.new(1, 0)
            })

            local function FireToggle()
                State = not State
                if State then
                    Tween(SwitchBG, {BackgroundColor3 = Library.Theme.Accent}, 0.3)
                    Tween(SwitchDot, {Position = UDim2.new(0, 16, 0.5, -7)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                else
                    Tween(SwitchBG, {BackgroundColor3 = Library.Theme.Border}, 0.3)
                    Tween(SwitchDot, {Position = UDim2.new(0, 4, 0.5, -7)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                end
                pcall(Callback, State)
            end

            table.insert(Library.Connections, ToggleFrame.MouseButton1Click:Connect(FireToggle))
            table.insert(Library.Connections, ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Library.Theme.TopBar}, 0.2)
            end))
            table.insert(Library.Connections, ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Library.Theme.Background}, 0.2)
            end))
        end
        
        return Tab
    end

    return Window
end

return Library
