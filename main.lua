local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {}

function Library:CreateWindow(Config)
    Config.Title = Config.Title or "未命名UI"
    Config.SubTitle = Config.SubTitle or "副标题"
    Config.Info = Config.Info or "底部栏"
    Config.Icon = Config.Icon or "rbxassetid://1"
    Config.BackgroundImage = Config.BackgroundImage or ""
    Config.BallImage = Config.BallImage ~= nil and Config.BallImage or Config.Icon
    Config.UIFG = Config.UIFG or "Default"

    local OpenBtnConfig = Config.OpenButton or {}
    OpenBtnConfig.Title = OpenBtnConfig.Title or Config.Title
    OpenBtnConfig.Icon = OpenBtnConfig.Icon or ""
    OpenBtnConfig.CornerRadius = OpenBtnConfig.CornerRadius or UDim.new(0, 16)
    OpenBtnConfig.StrokeThickness = OpenBtnConfig.StrokeThickness or 2
    OpenBtnConfig.Color = OpenBtnConfig.Color
    OpenBtnConfig.OnlyMobile = OpenBtnConfig.OnlyMobile or false
    OpenBtnConfig.Enabled = OpenBtnConfig.Enabled ~= nil and OpenBtnConfig.Enabled or true
    OpenBtnConfig.Draggable = OpenBtnConfig.Draggable ~= nil and OpenBtnConfig.Draggable or true

    local IsMac = Config.UIFG == "Mac"

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

    local UI_Shadow = Instance.new("ImageLabel")
UI_Shadow.Name = "UI_Shadow"
UI_Shadow.Size = UDim2.new(1, 20, 1, 20)
UI_Shadow.Position = UDim2.new(0, -10, 0, -10)
UI_Shadow.BackgroundTransparency = 1
UI_Shadow.Image = "rbxassetid://1316045217"
UI_Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
UI_Shadow.ImageTransparency = 0.5
UI_Shadow.ScaleType = Enum.ScaleType.Slice
UI_Shadow.SliceCenter = Rect.new(35, 35, 93, 93)
UI_Shadow.ZIndex = 0
UI_Shadow.Parent = WindowFrame

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.GroupTransparency = 1 
    MainFrame.ZIndex = 1
    MainFrame.Parent = WindowFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 2)
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
        BgImage.ImageTransparency = 0.55
        BgImage.ScaleType = Enum.ScaleType.Crop
        BgImage.Parent = MainFrame
        
        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = UDim.new(0, 2)
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
    IconLabel.Position = IsMac and UDim2.new(0, 100, 0, 15) or UDim2.new(0, 20, 0, 15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = Config.Icon
    IconLabel.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0, 200, 0, 24)
    TitleLabel.Position = IsMac and UDim2.new(0, 148, 0, 12) or UDim2.new(0, 68, 0, 12)
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
    SubLabel.Position = IsMac and UDim2.new(0, 148, 0, 34) or UDim2.new(0, 68, 0, 34)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 13
    SubLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Text = Config.SubTitle
    SubLabel.Parent = TopBar

    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchFrame"
    SearchFrame.Size = UDim2.new(0, 160, 0, 32)
    SearchFrame.Position = UDim2.new(0, 12, 0, 72)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    SearchFrame.BackgroundTransparency = 0.5
    SearchFrame.Parent = MainFrame

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
    SearchIcon.Image = "rbxassetid://140161092708960"
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
    CloseButton.Position = IsMac and UDim2.new(0, 15, 0, 16) or UDim2.new(1, -45, 0, 16)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.Text = IsMac and "" or "×"
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
    MinimizeButton.Position = IsMac and UDim2.new(0, 55, 0, 16) or UDim2.new(1, -85, 0, 16)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    MinimizeButton.BackgroundTransparency = 0.2
    MinimizeButton.Text = IsMac and "" or "−"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 18
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Parent = TopBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 16)
    MinimizeCorner.Parent = MinimizeButton

    if not OpenBtnConfig.Enabled then
        MinimizeButton.Visible = false
    end

    if IsMac then
        local CloseImage = Instance.new("ImageLabel")
        CloseImage.Name = "CloseImage"
        CloseImage.Size = UDim2.new(0, 14, 0, 14)
        CloseImage.Position = UDim2.new(0.5, -7, 0.5, -7)
        CloseImage.BackgroundTransparency = 1
        CloseImage.Image = "rbxassetid://91061623080109"
        CloseImage.ImageTransparency = 1
        CloseImage.Parent = CloseButton

        local MinImage = Instance.new("ImageLabel")
        MinImage.Name = "MinImage"
        MinImage.Size = UDim2.new(0, 14, 0, 14)
        MinImage.Position = UDim2.new(0.5, -7, 0.5, -7)
        MinImage.BackgroundTransparency = 1
        MinImage.Image = "rbxassetid://92767748272191"
        MinImage.ImageTransparency = 1
        MinImage.Parent = MinimizeButton

        local function FadeMacIcons(TargetTransparency)
            TweenService:Create(CloseImage, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = TargetTransparency}):Play()
            TweenService:Create(MinImage, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = TargetTransparency}):Play()
        end

        CloseButton.MouseEnter:Connect(function() FadeMacIcons(0) end)
        CloseButton.MouseLeave:Connect(function() FadeMacIcons(1) end)
        MinimizeButton.MouseEnter:Connect(function() FadeMacIcons(0) end)
        MinimizeButton.MouseLeave:Connect(function() FadeMacIcons(1) end)
    end

    local BottomBar = Instance.new("Frame")
    BottomBar.Name = "BottomBar"
    BottomBar.Size = UDim2.new(1, 0, 0, 30)
    BottomBar.Position = UDim2.new(0, 0, 1, -30)
    BottomBar.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    BottomBar.BackgroundTransparency = 0.4
    BottomBar.Parent = MainFrame

    local BottomCorner = Instance.new("UICorner")
    BottomCorner.CornerRadius = UDim.new(0, 2)
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
    SideBar.Size = UDim2.new(0, 160, 1, -152)
    SideBar.Position = UDim2.new(0, 12, 0, 114)
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

    local FloatBallFrame = Instance.new("CanvasGroup")
    FloatBallFrame.Name = "FloatBallFrame"
    FloatBallFrame.Size = UDim2.new(0, 180, 0, 40)
    FloatBallFrame.Position = UDim2.new(0, 30, 0, 30)
    FloatBallFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
    FloatBallFrame.BackgroundTransparency = 0.35
    FloatBallFrame.GroupTransparency = 0
    FloatBallFrame.ClipsDescendants = true
    FloatBallFrame.Visible = false
    FloatBallFrame.Parent = ScreenGui

    local BallCorner = Instance.new("UICorner")
    BallCorner.CornerRadius = OpenBtnConfig.CornerRadius
    BallCorner.Parent = FloatBallFrame

    local BallStroke = Instance.new("UIStroke")
    BallStroke.Thickness = OpenBtnConfig.StrokeThickness
    BallStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BallStroke.Parent = FloatBallFrame

    if typeof(OpenBtnConfig.Color) == "ColorSequence" then
        local StrokeGradient = Instance.new("UIGradient")
        StrokeGradient.Color = OpenBtnConfig.Color
        StrokeGradient.Rotation = 45
        StrokeGradient.Parent = BallStroke
    elseif typeof(OpenBtnConfig.Color) == "Color3" then
        BallStroke.Color = OpenBtnConfig.Color
    end

    local DragHandle = Instance.new("ImageButton")
    DragHandle.Name = "DragHandle"
    DragHandle.Size = UDim2.new(0, 36, 1, 0)
    DragHandle.Position = UDim2.new(0, 0, 0, 0)
    DragHandle.BackgroundTransparency = 1
    DragHandle.AutoButtonColor = false
    DragHandle.Parent = FloatBallFrame

    local HandleIcon = Instance.new("ImageLabel")
    HandleIcon.Name = "HandleIcon"
    HandleIcon.Size = UDim2.new(0, 18, 0, 18)
    HandleIcon.Position = UDim2.new(0.5, -9, 0.5, -9)
    HandleIcon.BackgroundTransparency = 1
    HandleIcon.Image = "rbxassetid://97423170859199"
    HandleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    HandleIcon.Parent = DragHandle

    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(0, 1, 1, -12)
    Divider.Position = UDim2.new(0, 36, 0, 6)
    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Divider.BackgroundTransparency = 0.6
    Divider.BorderSizePixel = 0
    Divider.Parent = FloatBallFrame

    local OpenClickButton = Instance.new("TextButton")
    OpenClickButton.Name = "OpenClickButton"
    OpenClickButton.Size = UDim2.new(1, -37, 1, 0)
    OpenClickButton.Position = UDim2.new(0, 37, 0, 0)
    OpenClickButton.BackgroundTransparency = 1
    OpenClickButton.Text = ""
    OpenClickButton.Parent = FloatBallFrame

    local BallTitle = Instance.new("TextLabel")
    BallTitle.Name = "BallTitle"
    BallTitle.Size = UDim2.new(1, -16, 1, 0)
    BallTitle.Position = UDim2.new(0, 8, 0, 0)
    BallTitle.BackgroundTransparency = 1
    BallTitle.Font = Enum.Font.GothamBold
    BallTitle.TextSize = 13
    BallTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    BallTitle.TextXAlignment = Enum.TextXAlignment.Left
    BallTitle.Text = OpenBtnConfig.Title
    BallTitle.Parent = OpenClickButton

    if OpenBtnConfig.Icon and OpenBtnConfig.Icon ~= "" then
        local RightIcon = Instance.new("ImageLabel")
        RightIcon.Name = "RightIcon"
        RightIcon.Size = UDim2.new(0, 18, 0, 18)
        RightIcon.Position = UDim2.new(1, -26, 0.5, -9)
        RightIcon.BackgroundTransparency = 1
        RightIcon.Image = OpenBtnConfig.Icon
        RightIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        RightIcon.Parent = OpenClickButton
        
        BallTitle.Size = UDim2.new(1, -34, 1, 0)
    end

    local InitPos = WindowFrame.Position
    WindowFrame.Position = InitPos + UDim2.new(0, 0, 0, 35)
    TweenService:Create(WindowFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = InitPos}):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
    TweenService:Create(UI_Shadow, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()

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
    local BallDragStart, BallStartPos
    local BallTargetPos = FloatBallFrame.Position

    DragHandle.InputBegan:Connect(function(input)
        if OpenBtnConfig.Draggable and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            BallDragging = true
            BallDragStart = input.Position
            BallStartPos = FloatBallFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    BallDragging = false
                end
            end)
        end
    end)

    DragHandle.InputChanged:Connect(function(input)
        if OpenBtnConfig.Draggable and BallDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - BallDragStart
            BallTargetPos = UDim2.new(BallStartPos.X.Scale, BallStartPos.X.Offset + delta.X, BallStartPos.Y.Scale, BallStartPos.Y.Offset + delta.Y)
            TweenService:Create(FloatBallFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = BallTargetPos}):Play()
        end
    end)

    OpenClickButton.MouseButton1Click:Connect(function()
        local BallHidePos = FloatBallFrame.Position + UDim2.new(0, 0, 0, 15)
        TweenService:Create(FloatBallFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = BallHidePos}):Play()
        local BallFade = TweenService:Create(FloatBallFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
        BallFade:Play()
        
        BallFade.Completed:Connect(function()
            FloatBallFrame.Visible = false
            WindowFrame.Visible = true
            WindowFrame.Position = TargetPosition + UDim2.new(0, 0, 0, 30)
            MainFrame.GroupTransparency = 1
            UI_Shadow.ImageTransparency = 1
            
            TweenService:Create(WindowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = TargetPosition}):Play()
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
            TweenService:Create(UI_Shadow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()
        end)
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        if OpenBtnConfig.Enabled then
            local ShowBall = true
            if OpenBtnConfig.OnlyMobile and not UIS.TouchEnabled then
                ShowBall = false
            end

            local MinTargetPos = WindowFrame.Position + UDim2.new(0, 0, 0, 30)
            TweenService:Create(WindowFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = MinTargetPos}):Play()
            TweenService:Create(UI_Shadow, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
            local MainFade = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
            MainFade:Play()

            MainFade.Completed:Connect(function()
                WindowFrame.Visible = false
                if ShowBall then
                    FloatBallFrame.Visible = true
                    FloatBallFrame.Position = BallTargetPos + UDim2.new(0, 0, 0, 15)
                    FloatBallFrame.GroupTransparency = 1
                    
                    TweenService:Create(FloatBallFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = BallTargetPos}):Play()
                    TweenService:Create(FloatBallFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
                else
                    ScreenGui:Destroy()
                end
            end)
        else
            ScreenGui:Destroy()
        end
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
        AllElements = {}
    }

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
            InteractButton.Size = UDim2.new(0, 34, 0, 34)
            InteractButton.Position = UDim2.new(1, -50, 0, 10)
            InteractButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            InteractButton.BackgroundTransparency = 0
            InteractButton.Text = ""
            InteractButton.Font = Enum.Font.GothamBold
            InteractButton.AutoButtonColor = false
            InteractButton.Parent = ButtonFrame

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 17)
            ButtonCorner.Parent = InteractButton

            local ButtonGradient = Instance.new("UIGradient")
            ButtonGradient.Rotation = 45
            if ElementConfig.Locked then
                ButtonGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 80, 90)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 55, 65))
                })
            else
                ButtonGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 180)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 210))
                })
            end
            ButtonGradient.Parent = InteractButton

            local ButtonIcon = Instance.new("ImageLabel")
            ButtonIcon.Name = "ButtonIcon"
            ButtonIcon.Size = UDim2.new(0, 18, 0, 18)
            ButtonIcon.Position = UDim2.new(0.5, -9, 0.5, -9)
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Image = "rbxassetid://97001987725758"
            ButtonIcon.ImageColor3 = ElementConfig.Locked and Color3.fromRGB(150, 155, 165) or Color3.fromRGB(255, 255, 255)
            ButtonIcon.Parent = InteractButton

            if not ElementConfig.Locked then
                InteractButton.MouseButton1Down:Connect(function()
                    TweenService:Create(InteractButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.25
                    }):Play()
                end)

                InteractButton.MouseButton1Up:Connect(function()
                    TweenService:Create(InteractButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0
                    }):Play()
                    ElementConfig.Callback()
                end)

                InteractButton.MouseEnter:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.91}):Play()
                end)

                InteractButton.MouseLeave:Connect(function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.96}):Play()
                    TweenService:Create(InteractButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                end)
            end

            return ButtonFrame
        end

        function Tab:Toggle(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "开关组件"
            ElementConfig.Desc = ElementConfig.Desc or "控制功能开启与关闭"
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
            ElementConfig.Desc = ElementConfig.Desc or "调节数值"
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

            local InitialAlpha = (ElementConfig.Default - ElementConfig.Min) / (ElementConfig.Max - ElementConfig.Min)

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Size = UDim2.new(InitialAlpha, 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(45, 130, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 3)
            FillCorner.Parent = SliderFill

            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "SliderKnob"
            SliderKnob.Size = UDim2.new(0, 14, 0, 14)
            SliderKnob.Position = UDim2.new(InitialAlpha, -7, 0.5, -7)
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.ZIndex = 3
            SliderKnob.Parent = SliderTrack

            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(0, 7)
            KnobCorner.Parent = SliderKnob

            local KnobStroke = Instance.new("UIStroke")
            KnobStroke.Thickness = 3.5
            KnobStroke.Color = Color3.fromRGB(45, 130, 255)
            KnobStroke.Transparency = 0.4
            KnobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            KnobStroke.Parent = SliderKnob

            local ActiveSliding = false

            local function EvaluateInput(InputObj)
                local Alpha = math.clamp((InputObj.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                local PreciseVal = ElementConfig.Min + (Alpha * (ElementConfig.Max - ElementConfig.Min))
                local RoundedVal = math.floor(PreciseVal + 0.5)
                
                TweenService:Create(SliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(Alpha, 0, 1, 0)}):Play()
                TweenService:Create(SliderKnob, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(Alpha, -7, 0.5, -7)}):Play()
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

            local OptionContainer = Instance.new("ScrollingFrame")
            OptionContainer.Name = "Options"
            OptionContainer.Size = UDim2.new(1, -32, 0, 0)
            OptionContainer.Position = UDim2.new(0, 16, 0, 54)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.ClipsDescendants = true
            OptionContainer.ScrollBarThickness = 2
            OptionContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
            OptionContainer.ScrollBarImageTransparency = 0.6
            OptionContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            OptionContainer.Parent = DropdownFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.Padding = UDim.new(0, 4)
            OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionLayout.Parent = OptionContainer

            OptionLayout.Changed:Connect(function()
                OptionContainer.CanvasSize = UDim2.new(0, 0, 0, OptionLayout.AbsoluteContentSize.Y)
            end)

            local function RefreshLayout()
                if Extended then
                    local ContentHeight = OptionLayout.AbsoluteContentSize.Y
                    local DisplayHeight = math.min(ContentHeight, 120)
                    local TargetSize = DisplayHeight + 64
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, TargetSize)}):Play()
                    TweenService:Create(OptionContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -32, 0, DisplayHeight + 4)}):Play()
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
