local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {}

function Library:CreateWindow(Config)
    Config.Title = Config.Title or "未命名核心"
    Config.SubTitle = Config.SubTitle or "本地玩家加速器"
    Config.Info = Config.Info or "系统状态: 正常运行"
    Config.Icon = Config.Icon or "rbxassetid://6031763426"
    Config.BackgroundImage = Config.BackgroundImage or ""

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LiquidGlass_UiEngine"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if RunService:IsStudio() then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    else
        ScreenGui.Parent = CoreGui
    end

    local WindowFrame = Instance.new("Frame")
    WindowFrame.Name = "WindowFrame"
    WindowFrame.Size = UDim2.new(0, 680, 0, 440)
    WindowFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
    WindowFrame.BackgroundTransparency = 1
    WindowFrame.Parent = ScreenGui

    -- [严格适配] 唯一高强度微阴影，精准包裹 24px 圆角
    local UI_Shadow = Instance.new("ImageLabel")
    UI_Shadow.Name = "UI_Shadow"
    UI_Shadow.Size = UDim2.new(1, 48, 1, 48)
    UI_Shadow.Position = UDim2.new(0, -24, 0, -24)
    UI_Shadow.BackgroundTransparency = 1
    UI_Shadow.Image = "rbxassetid://1316045217"
    UI_Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    UI_Shadow.ImageTransparency = 0.25 -- 加深阴影强度
    UI_Shadow.ScaleType = Enum.ScaleType.Slice
    UI_Shadow.SliceCenter = Rect.new(35, 35, 93, 93)
    UI_Shadow.ZIndex = 0
    UI_Shadow.Parent = WindowFrame

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.GroupTransparency = 1 
    MainFrame.ZIndex = 1
    MainFrame.Parent = WindowFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 24)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.5
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.85
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    local GlassGradient = Instance.new("UIGradient")
    GlassGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 210, 255))
    })
    GlassGradient.Rotation = 45
    GlassGradient.Parent = MainFrame

    if Config.BackgroundImage ~= "" then
        local BgImage = Instance.new("ImageLabel")
        BgImage.Name = "BgImage"
        BgImage.Size = UDim2.new(1, 0, 1, 0)
        BgImage.BackgroundTransparency = 1
        BgImage.Image = Config.BackgroundImage
        BgImage.ImageTransparency = 0.85
        BgImage.ScaleType = Enum.ScaleType.Crop
        BgImage.Parent = MainFrame
        
        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = UDim.new(0, 24)
        BgCorner.Parent = BgImage
    end

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 65)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Name = "IconLabel"
    IconLabel.Size = UDim2.new(0, 36, 0, 36)
    IconLabel.Position = UDim2.new(0, 20, 0, 15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = Config.Icon
    IconLabel.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0, 200, 0, 24)
    TitleLabel.Position = UDim2.new(0, 68, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = Config.Title
    TitleLabel.Parent = TopBar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Name = "SubLabel"
    SubLabel.Size = UDim2.new(0, 200, 0, 18)
    SubLabel.Position = UDim2.new(0, 68, 0, 34)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 13
    SubLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Text = Config.SubTitle
    SubLabel.Parent = TopBar

    -- [新增] 功能搜索组件
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchFrame"
    SearchFrame.Size = UDim2.new(0, 160, 0, 32)
    SearchFrame.Position = UDim2.new(1, -265, 0, 16)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    SearchFrame.BackgroundTransparency = 0.5
    SearchFrame.Parent = TopBar

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 8)
    SearchCorner.Parent = SearchFrame

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Thickness = 1
    SearchStroke.Color = Color3.fromRGB(255, 255, 255)
    SearchStroke.Transparency = 0.85
    SearchStroke.Parent = SearchFrame

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Size = UDim2.new(0, 16, 0, 16)
    SearchIcon.Position = UDim2.new(0, 10, 0, 8)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.ImageColor3 = Color3.fromRGB(150, 160, 180)
    -- ==============================================
    -- ⬇️ 在此填入你的搜索图标ID ⬇️
    SearchIcon.Image = "rbxassetid://0" 
    -- ==============================================
    SearchIcon.Parent = SearchFrame

    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "SearchInput"
    SearchInput.Size = UDim2.new(1, -36, 1, 0)
    SearchInput.Position = UDim2.new(0, 32, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Text = ""
    SearchInput.PlaceholderText = "搜索功能..."
    SearchInput.PlaceholderColor3 = Color3.fromRGB(110, 120, 140)
    SearchInput.Font = Enum.Font.GothamMedium
    SearchInput.TextSize = 12
    SearchInput.TextColor3 = Color3.fromRGB(240, 245, 255)
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchFrame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.Position = UDim2.new(1, -45, 0, 16)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 22
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 16)
    CloseCorner.Parent = CloseButton

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
    MinimizeButton.Position = UDim2.new(1, -85, 0, 16)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    MinimizeButton.BackgroundTransparency = 0.2
    MinimizeButton.Text = "−"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 18
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Parent = TopBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 16)
    MinimizeCorner.Parent = MinimizeButton

    local BottomBar = Instance.new("Frame")
    BottomBar.Name = "BottomBar"
    BottomBar.Size = UDim2.new(1, 0, 0, 30)
    BottomBar.Position = UDim2.new(0, 0, 1, -30)
    BottomBar.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    BottomBar.BackgroundTransparency = 0.4
    BottomBar.Parent = MainFrame

    local BottomCorner = Instance.new("UICorner")
    BottomCorner.CornerRadius = UDim.new(0, 24)
    BottomCorner.Parent = BottomBar

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoLabel"
    InfoLabel.Size = UDim2.new(1, -40, 1, 0)
    InfoLabel.Position = UDim2.new(0, 20, 0, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Font = Enum.Font.GothamMedium
    InfoLabel.TextSize = 12
    InfoLabel.TextColor3 = Color3.fromRGB(140, 150, 170)
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.Text = Config.Info
    InfoLabel.Parent = BottomBar

    local SideBar = Instance.new("ScrollingFrame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 160, 1, -105)
    SideBar.Position = UDim2.new(0, 12, 0, 65)
    SideBar.BackgroundTransparency = 1
    SideBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    SideBar.ScrollBarThickness = 0
    SideBar.Parent = MainFrame

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 8)
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Parent = SideBar

    local ContainerFolder = Instance.new("Folder")
    ContainerFolder.Name = "Containers"
    ContainerFolder.Parent = MainFrame

    local ContainerBounds = Instance.new("Frame")
    ContainerBounds.Name = "ContainerBounds"
    ContainerBounds.Size = UDim2.new(1, -192, 1, -115)
    ContainerBounds.Position = UDim2.new(0, 180, 0, 70)
    ContainerBounds.BackgroundTransparency = 1
    ContainerBounds.Parent = ContainerFolder

    -- 悬浮球容器 (已去除冗余阴影)
    local FloatBallFrame = Instance.new("Frame")
    FloatBallFrame.Name = "FloatBallFrame"
    FloatBallFrame.Size = UDim2.new(0, 55, 0, 55)
    FloatBallFrame.Position = UDim2.new(0, 30, 0, 30)
    FloatBallFrame.BackgroundTransparency = 1
    FloatBallFrame.Visible = false
    FloatBallFrame.Parent = ScreenGui

    local FloatBall = Instance.new("ImageButton")
    FloatBall.Name = "FloatBall"
    FloatBall.Size = UDim2.new(1, 0, 1, 0)
    FloatBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FloatBall.BackgroundTransparency = 0.1
    FloatBall.Image = Config.Icon
    FloatBall.Parent = FloatBallFrame

    local BallCorner = Instance.new("UICorner")
    BallCorner.CornerRadius = UDim.new(0, 28)
    BallCorner.Parent = FloatBall

    local BallStroke = Instance.new("UIStroke")
    BallStroke.Thickness = 1.5
    BallStroke.Color = Color3.fromRGB(255, 255, 255)
    BallStroke.Transparency = 0.6
    BallStroke.Parent = FloatBall

    -- 进场动画：阴影透明度同步适配0.25
    local InitPos = WindowFrame.Position
    WindowFrame.Position = InitPos + UDim2.new(0, 0, 0, 35)
    TweenService:Create(WindowFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = InitPos}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
    TweenService:Create(UI_Shadow, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.25}):Play()

    local Dragging = false
    local DragInput, DragStart, StartPosition
    local TargetPosition = WindowFrame.Position

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = WindowFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            TargetPosition = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
            TweenService:Create(WindowFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = TargetPosition}):Play()
        end
    end)

    local BallDragging = false
    local BallMoved = false
    local BallDragStart, BallStartPos
    local BallTargetPos = FloatBallFrame.Position

    FloatBall.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            BallDragging = true
            BallMoved = false
            BallDragStart = input.Position
            BallStartPos = FloatBallFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    BallDragging = false
                end
            end)
        end
    end)

    FloatBall.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and BallDragging then
            local delta = input.Position - BallDragStart
            if delta.Magnitude > 6 then
                BallMoved = true
            end
            BallTargetPos = UDim2.new(BallStartPos.X.Scale, BallStartPos.X.Offset + delta.X, BallStartPos.Y.Scale, BallStartPos.Y.Offset + delta.Y)
            TweenService:Create(FloatBallFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = BallTargetPos}):Play()
        end
    end)

    FloatBall.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not BallMoved then
                local BallHidePos = FloatBallFrame.Position + UDim2.new(0, 0, 0, 15)
                TweenService:Create(FloatBallFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = BallHidePos}):Play()
                local BallFade = TweenService:Create(FloatBall, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1, BackgroundTransparency = 1})
                BallFade:Play()
                
                BallFade.Completed:Connect(function()
                    FloatBallFrame.Visible = false
                    WindowFrame.Visible = true
                    WindowFrame.Position = TargetPosition + UDim2.new(0, 0, 0, 30)
                    MainFrame.GroupTransparency = 1
                    UI_Shadow.ImageTransparency = 1
                    
                    TweenService:Create(WindowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = TargetPosition}):Play()
                    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
                    TweenService:Create(UI_Shadow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.25}):Play()
                end)
            end
        end
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        local MinTargetPos = WindowFrame.Position + UDim2.new(0, 0, 0, 30)
        TweenService:Create(WindowFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = MinTargetPos}):Play()
        TweenService:Create(UI_Shadow, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
        local MainFade = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
        MainFade:Play()

        MainFade.Completed:Connect(function()
            WindowFrame.Visible = false
            FloatBallFrame.Visible = true
            FloatBallFrame.Position = BallTargetPos + UDim2.new(0, 0, 0, 15)
            FloatBall.ImageTransparency = 1
            FloatBall.BackgroundTransparency = 1
            
            TweenService:Create(FloatBallFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = BallTargetPos}):Play()
            TweenService:Create(FloatBall, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0, BackgroundTransparency = 0.1}):Play()
        end)
    end)

    CloseButton.MouseButton1Click:Connect(function()
        local CloseTargetPos = WindowFrame.Position + UDim2.new(0, 0, 0, 40)
        TweenService:Create(WindowFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = CloseTargetPos}):Play()
        TweenService:Create(UI_Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
        local FinalClose = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
        FinalClose:Play()
        
        FinalClose.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    local Window = {
        Tabs = {},
        CurrentTab = nil,
        AllElements = {} -- 用于全局搜索注册
    }

    -- 绑定搜索框逻辑
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local TextVal = string.lower(SearchInput.Text)
        for _, ItemData in ipairs(Window.AllElements) do
            if TextVal == "" then
                ItemData.Frame.Visible = true
            else
                if string.find(string.lower(ItemData.Title), TextVal) or string.find(string.lower(ItemData.Desc), TextVal) then
                    ItemData.Frame.Visible = true
                else
                    ItemData.Frame.Visible = false
                end
            end
        end
    end)

    function Window:CreateTab(TabConfig)
        TabConfig.Title = TabConfig.Title or "主页"
        TabConfig.Icon = TabConfig.Icon or "rbxassetid://6031094678"

        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabConfig.Title .. "_Button"
        TabButton.Size = UDim2.new(1, -10, 0, 42)
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.95
        TabButton.Text = ""
        TabButton.Parent = SideBar

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 14)
        TabButtonCorner.Parent = TabButton

        local TabButtonStroke = Instance.new("UIStroke")
        TabButtonStroke.Thickness = 1
        TabButtonStroke.Color = Color3.fromRGB(255, 255, 255)
        TabButtonStroke.Transparency = 0.95
        TabButtonStroke.Parent = TabButton

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 22, 0, 22)
        TabIcon.Position = UDim2.new(0, 12, 0, 10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = TabConfig.Icon
        TabIcon.ImageColor3 = Color3.fromRGB(180, 190, 210)
        TabIcon.Parent = TabButton

        local TabText = Instance.new("TextLabel")
        TabText.Name = "Text"
        TabText.Size = UDim2.new(1, -45, 1, 0)
        TabText.Position = UDim2.new(0, 40, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Font = Enum.Font.GothamMedium
        TabText.TextSize = 14
        TabText.TextColor3 = Color3.fromRGB(180, 190, 210)
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Text = TabConfig.Title
        TabText.Parent = TabButton

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = TabConfig.Title .. "_Content"
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Visible = false
        ContentFrame.ScrollBarThickness = 3
        ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        ContentFrame.ScrollBarImageTransparency = 0.7
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ContentFrame.Parent = ContainerBounds

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = ContentFrame

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.Parent = ContentFrame

        ContentLayout.Changed:Connect(function()
            ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        local Tab = {
            Window = Window,
            Active = false
        }

        function Tab:Select()
            if Window.CurrentTab and Window.CurrentTab ~= Tab then
                Window.CurrentTab:DeSelect()
            end
            Window.CurrentTab = Tab
            Tab.Active = true

            TweenService:Create(TabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(TabButtonStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.7}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(100, 180, 255)}):Play()
            TweenService:Create(TabText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            
            ContentFrame.Visible = true
            ContentFrame.Position = UDim2.new(0, 0, 0, 15)
            TweenService:Create(ContentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end

        function Tab:DeSelect()
            Tab.Active = false
            TweenService:Create(TabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
            TweenService:Create(TabButtonStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.95}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(180, 190, 210)}):Play()
            TweenService:Create(TabText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(180, 190, 210)}):Play()
            ContentFrame.Visible = false
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        function Tab:Button(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "按钮组件"
            ElementConfig.Desc = ElementConfig.Desc or "点击执行特定方法函数"
            ElementConfig.Locked = ElementConfig.Locked or false
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = ElementConfig.Title .. "_Element"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 54)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonFrame.BackgroundTransparency = 0.96
            ButtonFrame.Parent = ContentFrame

            -- 注入全局搜索
            table.insert(Window.AllElements, {Frame = ButtonFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            FrameCorner.Parent = ButtonFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.94
            FrameStroke.Parent = ButtonFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -120, 0, 22)
            TitleLabel.Position = UDim2.new(0, 16, 0, 7)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 14
            TitleLabel.TextColor3 = ElementConfig.Locked and Color3.fromRGB(130, 130, 140) or Color3.fromRGB(245, 245, 255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Text = ElementConfig.Title
            TitleLabel.Parent = ButtonFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -120, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 27)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = ButtonFrame

            local InteractButton = Instance.new("TextButton")
            InteractButton.Name = "Interact"
            InteractButton.Size = UDim2.new(0, 90, 0, 32)
            InteractButton.Position = UDim2.new(1, -106, 0, 11)
            InteractButton.BackgroundColor3 = ElementConfig.Locked and Color3.fromRGB(60, 65, 75) or Color3.fromRGB(45, 120, 255)
            InteractButton.BackgroundTransparency = ElementConfig.Locked and 0.5 or 0.1
            InteractButton.Text = ElementConfig.Locked and "锁死" or "执行"
            InteractButton.Font = Enum.Font.GothamBold
            InteractButton.TextSize = 13
            InteractButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            InteractButton.AutoButtonColor = false
            InteractButton.Parent = ButtonFrame

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 10)
            ButtonCorner.Parent = InteractButton

            if not ElementConfig.Locked then
                InteractButton.MouseButton1Down:Connect(function()
                    TweenService:Create(InteractButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(30, 90, 210)
                    }):Play()
                end)

                InteractButton.MouseButton1Up:Connect(function()
                    TweenService:Create(InteractButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(45, 120, 255)
                    }):Play()
                    ElementConfig.Callback()
                end)

                InteractButton.MouseEnter:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.91}):Play()
                end)

                InteractButton.MouseLeave:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.96}):Play()
                    TweenService:Create(InteractButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(45, 120, 255)}):Play()
                end)
            end

            return ButtonFrame
        end

        function Tab:Toggle(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "开关组件"
            ElementConfig.Desc = ElementConfig.Desc or "控制布尔状态的开启与关闭"
            ElementConfig.Default = ElementConfig.Default or false
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local Toggled = ElementConfig.Default

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = ElementConfig.Title .. "_Element"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 54)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleFrame.BackgroundTransparency = 0.96
            ToggleFrame.Parent = ContentFrame

            table.insert(Window.AllElements, {Frame = ToggleFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            FrameCorner.Parent = ToggleFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.94
            FrameStroke.Parent = ToggleFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -100, 0, 22)
            TitleLabel.Position = UDim2.new(0, 16, 0, 7)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 14
            TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Text = ElementConfig.Title
            TitleLabel.Parent = ToggleFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -100, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 27)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = ToggleFrame

            local OuterSwitch = Instance.new("TextButton")
            OuterSwitch.Name = "Outer"
            OuterSwitch.Size = UDim2.new(0, 50, 0, 26)
            OuterSwitch.Position = UDim2.new(1, -66, 0, 14)
            OuterSwitch.BackgroundColor3 = Toggled and Color3.fromRGB(45, 210, 130) or Color3.fromRGB(65, 70, 85)
            OuterSwitch.BackgroundTransparency = 0.2
            OuterSwitch.Text = ""
            OuterSwitch.Parent = ToggleFrame

            local OuterCorner = Instance.new("UICorner")
            OuterCorner.CornerRadius = UDim.new(0, 13)
            OuterCorner.Parent = OuterSwitch

            local InnerBall = Instance.new("Frame")
            InnerBall.Name = "Ball"
            InnerBall.Size = UDim2.new(0, 20, 0, 20)
            InnerBall.Position = Toggled and UDim2.new(1, -23, 0, 3) or UDim2.new(0, 3, 0, 3)
            InnerBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            InnerBall.Parent = OuterSwitch

            local InnerCorner = Instance.new("UICorner")
            InnerCorner.CornerRadius = UDim.new(0, 10)
            InnerCorner.Parent = InnerBall

            OuterSwitch.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                if Toggled then
                    TweenService:Create(OuterSwitch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(45, 210, 130)}):Play()
                    TweenService:Create(InnerBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -23, 0, 3)}):Play()
                else
                    TweenService:Create(OuterSwitch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(65, 70, 85)}):Play()
                    TweenService:Create(InnerBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0, 3)}):Play()
                end
                ElementConfig.Callback(Toggled)
            end)

            return ToggleFrame
        end

        function Tab:Slider(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "滑块组件"
            ElementConfig.Desc = ElementConfig.Desc or "在线性区间内调节连续数值"
            ElementConfig.Min = ElementConfig.Min or 0
            ElementConfig.Max = ElementConfig.Max or 100
            ElementConfig.Default = ElementConfig.Default or 50
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = ElementConfig.Title .. "_Element"
            SliderFrame.Size = UDim2.new(1, 0, 0, 68)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderFrame.BackgroundTransparency = 0.96
            SliderFrame.Parent = ContentFrame

            table.insert(Window.AllElements, {Frame = SliderFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            FrameCorner.Parent = SliderFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.94
            FrameStroke.Parent = SliderFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -120, 0, 22)
            TitleLabel.Position = UDim2.new(0, 16, 0, 8)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 14
            TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Text = ElementConfig.Title
            TitleLabel.Parent = SliderFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -120, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 26)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 11
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "Value"
            ValueLabel.Size = UDim2.new(0, 60, 0, 22)
            ValueLabel.Position = UDim2.new(1, -76, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 14
            ValueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Text = tostring(ElementConfig.Default)
            ValueLabel.Parent = SliderFrame

            local SliderTrack = Instance.new("TextButton")
            SliderTrack.Name = "Track"
            SliderTrack.Size = UDim2.new(1, -32, 0, 6)
            SliderTrack.Position = UDim2.new(0, 16, 0, 48)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(55, 60, 75)
            SliderTrack.Text = ""
            SliderTrack.AutoButtonColor = false
            SliderTrack.Parent = SliderFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 3)
            TrackCorner.Parent = SliderTrack

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Size = UDim2.new((ElementConfig.Default - ElementConfig.Min) / (ElementConfig.Max - ElementConfig.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(45, 130, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 3)
            FillCorner.Parent = SliderFill

            local ActiveSliding = false

            local function EvaluateInput(InputObj)
                local Alpha = math.clamp((InputObj.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                local PreciseVal = ElementConfig.Min + (Alpha * (ElementConfig.Max - ElementConfig.Min))
                local RoundedVal = math.floor(PreciseVal + 0.5)
                
                TweenService:Create(SliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(Alpha, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(RoundedVal)
                ElementConfig.Callback(RoundedVal)
            end

            SliderTrack.InputBegan:Connect(function(InputObj)
                if InputObj.UserInputType == Enum.UserInputType.MouseButton1 or InputObj.UserInputType == Enum.UserInputType.Touch then
                    ActiveSliding = true
                    EvaluateInput(InputObj)
                end
            end)

            UIS.InputChanged:Connect(function(InputObj)
                if ActiveSliding and (InputObj.UserInputType == Enum.UserInputType.MouseMovement or InputObj.UserInputType == Enum.UserInputType.Touch) then
                    EvaluateInput(InputObj)
                end
            end)

            UIS.InputEnded:Connect(function(InputObj)
                if InputObj.UserInputType == Enum.UserInputType.MouseButton1 or InputObj.UserInputType == Enum.UserInputType.Touch then
                    ActiveSliding = false
                end
            end)

            return SliderFrame
        end

        function Tab:Dropdown(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "下拉框组件"
            ElementConfig.Desc = ElementConfig.Desc or "从展开的多项列表中选择结果"
            ElementConfig.Options = ElementConfig.Options or {}
            ElementConfig.Default = ElementConfig.Default or ""
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local Extended = false

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = ElementConfig.Title .. "_Element"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 54)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownFrame.BackgroundTransparency = 0.96
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = ContentFrame

            table.insert(Window.AllElements, {Frame = DropdownFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            FrameCorner.Parent = DropdownFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.94
            FrameStroke.Parent = DropdownFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -180, 0, 22)
            TitleLabel.Position = UDim2.new(0, 16, 0, 7)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 14
            TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Text = ElementConfig.Title
            TitleLabel.Parent = DropdownFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -180, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 27)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = DropdownFrame

            local OpenSelector = Instance.new("TextButton")
            OpenSelector.Name = "Selector"
            OpenSelector.Size = UDim2.new(0, 140, 0, 32)
            OpenSelector.Position = UDim2.new(1, -156, 0, 11)
            OpenSelector.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
            OpenSelector.BackgroundTransparency = 0.3
            OpenSelector.Text = ElementConfig.Default ~= "" and ElementConfig.Default or "请选择..."
            OpenSelector.Font = Enum.Font.GothamMedium
            OpenSelector.TextSize = 13
            OpenSelector.TextColor3 = Color3.fromRGB(230, 235, 245)
            OpenSelector.Parent = DropdownFrame

            local SelectorCorner = Instance.new("UICorner")
            SelectorCorner.CornerRadius = UDim.new(0, 10)
            SelectorCorner.Parent = OpenSelector

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Name = "Options"
            OptionContainer.Size = UDim2.new(1, -32, 0, 0)
            OptionContainer.Position = UDim2.new(0, 16, 0, 54)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.ClipsDescendants = true
            OptionContainer.Parent = DropdownFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.Padding = UDim.new(0, 4)
            OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionLayout.Parent = OptionContainer

            local function RefreshLayout()
                if Extended then
                    local TargetSize = OptionLayout.AbsoluteContentSize.Y + 64
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, TargetSize)}):Play()
                    TweenService:Create(OptionContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -32, 0, OptionLayout.AbsoluteContentSize.Y + 10)}):Play()
                else
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 54)}):Play()
                    TweenService:Create(OptionContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -32, 0, 0)}):Play()
                end
            end

            OpenSelector.MouseButton1Click:Connect(function()
                Extended = not Extended
                RefreshLayout()
            end)

            for Index, OptionName in ipairs(ElementConfig.Options) do
                local OptButton = Instance.new("TextButton")
                OptButton.Name = OptionName .. "_Opt"
                OptButton.Size = UDim2.new(1, 0, 0, 30)
                OptButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                OptButton.BackgroundTransparency = 0.97
                OptButton.Text = OptionName
                OptButton.Font = Enum.Font.GothamMedium
                OptButton.TextSize = 13
                OptButton.TextColor3 = Color3.fromRGB(200, 205, 220)
                OptButton.Parent = OptionContainer

                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 8)
                OptCorner.Parent = OptButton

                OptButton.MouseButton1Click:Connect(function()
                    Extended = false
                    OpenSelector.Text = OptionName
                    RefreshLayout()
                    ElementConfig.Callback(OptionName)
                end)
            end

            return DropdownFrame
        end

        function Tab:TextBox(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "输入框组件"
            ElementConfig.Desc = ElementConfig.Desc or "在这里键入文本进行指令交互"
            ElementConfig.Placeholder = ElementConfig.Placeholder or "输入内容..."
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local BoxFrame = Instance.new("Frame")
            BoxFrame.Name = ElementConfig.Title .. "_Element"
            BoxFrame.Size = UDim2.new(1, 0, 0, 54)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BoxFrame.BackgroundTransparency = 0.96
            BoxFrame.Parent = ContentFrame

            table.insert(Window.AllElements, {Frame = BoxFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            BoxFrame.Parent = ContentFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.94
            FrameStroke.Parent = BoxFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -190, 0, 22)
            TitleLabel.Position = UDim2.new(0, 16, 0, 7)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 14
            TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Text = ElementConfig.Title
            TitleLabel.Parent = BoxFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -190, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 27)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = BoxFrame

            local InputField = Instance.new("TextBox")
            InputField.Name = "Input"
            InputField.Size = UDim2.new(0, 150, 0, 32)
            InputField.Position = UDim2.new(1, -166, 0, 11)
            InputField.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
            InputField.BackgroundTransparency = 0.4
            InputField.Text = ""
            InputField.PlaceholderText = ElementConfig.Placeholder
            InputField.PlaceholderColor3 = Color3.fromRGB(110, 115, 130)
            InputField.Font = Enum.Font.GothamMedium
            InputField.TextSize = 13
            InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputField.ClearTextOnFocus = false
            InputField.Parent = BoxFrame

            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 10)
            InputCorner.Parent = InputField

            local InputStroke = Instance.new("UIStroke")
            InputStroke.Thickness = 1
            InputStroke.Color = Color3.fromRGB(255, 255, 255)
            InputStroke.Transparency = 0.9
            InputStroke.Parent = InputField

            InputField.Focused:Connect(function()
                TweenService:Create(InputStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(100, 180, 255), Transparency = 0.4}):Play()
            end)

            InputField.FocusLost:Connect(function(EnterPressed)
                TweenService:Create(InputStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9}):Play()
                ElementConfig.Callback(InputField.Text, EnterPressed)
            end)

            return BoxFrame
        end

        function Tab:Keybind(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "按键绑定"
            ElementConfig.Desc = ElementConfig.Desc or "设置触发特定功能的快捷按键"
            ElementConfig.Default = ElementConfig.Default or Enum.KeyCode.E
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local CurrentBind = ElementConfig.Default
            local AwaitingInput = false

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = ElementConfig.Title .. "_Element"
            KeybindFrame.Size = UDim2.new(1, 0, 0, 54)
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            KeybindFrame.BackgroundTransparency = 0.96
            KeybindFrame.Parent = ContentFrame

            table.insert(Window.AllElements, {Frame = KeybindFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            KeybindFrame.Parent = ContentFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.94
            FrameStroke.Parent = KeybindFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -160, 0, 22)
            TitleLabel.Position = UDim2.new(0, 16, 0, 7)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 14
            TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Text = ElementConfig.Title
            TitleLabel.Parent = KeybindFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -160, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 27)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = KeybindFrame

            local BindButton = Instance.new("TextButton")
            BindButton.Name = "Bind"
            BindButton.Size = UDim2.new(0, 110, 0, 32)
            BindButton.Position = UDim2.new(1, -126, 0, 11)
            BindButton.BackgroundColor3 = Color3.fromRGB(55, 60, 75)
            BindButton.BackgroundTransparency = 0.4
            BindButton.Text = CurrentBind.Name
            BindButton.Font = Enum.Font.GothamBold
            BindButton.TextSize = 13
            BindButton.TextColor3 = Color3.fromRGB(100, 180, 255)
            BindButton.Parent = KeybindFrame

            local BindCorner = Instance.new("UICorner")
            BindCorner.CornerRadius = UDim.new(0, 10)
            BindCorner.Parent = BindButton

            BindButton.MouseButton1Click:Connect(function()
                AwaitingInput = true
                BindButton.Text = "请按任意键..."
                BindButton.TextColor3 = Color3.fromRGB(255, 180, 50)
            end)

            UIS.InputBegan:Connect(function(InputObj, GameProcessed)
                if AwaitingInput and InputObj.UserInputType == Enum.UserInputType.Keyboard then
                    AwaitingInput = false
                    CurrentBind = InputObj.KeyCode
                    BindButton.Text = CurrentBind.Name
                    BindButton.TextColor3 = Color3.fromRGB(100, 180, 255)
                    ElementConfig.Callback(CurrentBind)
                elseif not GameProcessed and InputObj.KeyCode == CurrentBind then
                    ElementConfig.Callback(CurrentBind)
                end
            end)

            return KeybindFrame
        end

        function Tab:Paragraph(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "段落说明"
            ElementConfig.Desc = ElementConfig.Desc or "展示核心通知或者辅助指导细则文本内容"

            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Name = ElementConfig.Title .. "_Element"
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 54)
            ParagraphFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ParagraphFrame.BackgroundTransparency = 0.98
            ParagraphFrame.Parent = ContentFrame

            table.insert(Window.AllElements, {Frame = ParagraphFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            ParagraphFrame.Parent = ContentFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.96
            FrameStroke.Parent = ParagraphFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.Size = UDim2.new(1, -32, 0, 22)
            TitleLabel.Position = UDim2.new(0, 16, 0, 7)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 14
            TitleLabel.TextColor3 = Color3.fromRGB(200, 210, 230)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Text = ElementConfig.Title
            TitleLabel.Parent = ParagraphFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Desc"
            DescLabel.Size = UDim2.new(1, -32, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 27)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(120, 130, 145)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = ParagraphFrame

            return ParagraphFrame
        end

        Window.Tabs[TabConfig.Title] = Tab
        if Window.CurrentTab == nil then
            Tab:Select()
        end

        return Tab
    end

    return Window
end

return Library
