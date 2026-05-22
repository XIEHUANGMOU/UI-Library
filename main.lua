local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {}

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function LerpUDim2(current, target, t)
    return UDim2.new(
        Lerp(current.X.Scale, target.X.Scale, t),
        Lerp(current.X.Offset, target.X.Offset, t),
        Lerp(current.Y.Scale, target.Y.Scale, t),
        Lerp(current.Y.Offset, target.Y.Offset, t)
    )
end

function Library:Notification(NotifConfig)
    NotifConfig.Title = NotifConfig.Title or "通知"
    NotifConfig.Content = NotifConfig.Content or "这长一条通知内容描述。"
    NotifConfig.Duration = NotifConfig.Duration or 3
    NotifConfig.Icon = NotifConfig.Icon or "rbxassetid://10841334522"

    local NotifGui = CoreGui:FindFirstChild("LiquidGlass_Notifications")
    if not NotifGui then
        NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "LiquidGlass_Notifications"
        NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NotifGui.Parent = RunService:IsStudio() and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") or CoreGui
    end

    local IslandFrame = Instance.new("CanvasGroup")
    IslandFrame.Name = "DynamicIsland"
    IslandFrame.Size = UDim2.new(0, 80, 0, 35)
    IslandFrame.Position = UDim2.new(0.5, -40, 0, 15)
    IslandFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    IslandFrame.BackgroundTransparency = 0.2
    IslandFrame.GroupTransparency = 1
    IslandFrame.ClipsDescendants = true
    IslandFrame.Parent = NotifGui

    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, 18)
    IslandCorner.Parent = IslandFrame

    local IslandStroke = Instance.new("UIStroke")
    IslandStroke.Thickness = 1.5
    IslandStroke.Color = Color3.fromRGB(255, 255, 255)
    IslandStroke.Transparency = 0.85
    IslandStroke.Parent = IslandFrame

    local IslandIcon = Instance.new("ImageLabel")
    IslandIcon.Name = "Icon"
    IslandIcon.Size = UDim2.new(0, 22, 0, 22)
    IslandIcon.Position = UDim2.new(0, 14, 0, 11)
    IslandIcon.BackgroundTransparency = 1
    IslandIcon.Image = NotifConfig.Icon
    IslandIcon.ImageColor3 = Color3.fromRGB(100, 180, 255)
    IslandIcon.Parent = IslandFrame

    local IslandTitle = Instance.new("TextLabel")
    IslandTitle.Name = "Title"
    IslandTitle.Size = UDim2.new(1, -60, 0, 20)
    IslandTitle.Position = UDim2.new(0, 44, 0, 12)
    IslandTitle.BackgroundTransparency = 1
    IslandTitle.Font = Enum.Font.GothamBold
    IslandTitle.TextSize = 13
    IslandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    IslandTitle.TextXAlignment = Enum.TextXAlignment.Left
    IslandTitle.Text = NotifConfig.Title
    IslandTitle.TextTransparency = 1
    IslandTitle.Parent = IslandFrame

    local IslandContent = Instance.new("TextLabel")
    IslandContent.Name = "Content"
    IslandContent.Size = UDim2.new(1, -28, 0, 18)
    IslandContent.Position = UDim2.new(0, 14, 0, 36)
    IslandContent.BackgroundTransparency = 1
    IslandContent.Font = Enum.Font.GothamMedium
    IslandContent.TextSize = 12
    IslandContent.TextColor3 = Color3.fromRGB(180, 190, 210)
    IslandContent.TextXAlignment = Enum.TextXAlignment.Left
    IslandContent.Text = NotifConfig.Content
    IslandContent.TextTransparency = 1
    IslandContent.Parent = IslandFrame

    TweenService:Create(IslandFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
    task.wait(0.15)
    TweenService:Create(IslandFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 65), Position = UDim2.new(0.5, -140, 0, 15)}):Play()
    TweenService:Create(IslandTitle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(IslandContent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

    task.delay(NotifConfig.Duration, function()
        TweenService:Create(IslandTitle, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
        TweenService:Create(IslandContent, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
        task.wait(0.1)
        TweenService:Create(IslandFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 80, 0, 35), Position = UDim2.new(0.5, -40, 0, 15), GroupTransparency = 1}):Play()
        task.wait(0.35)
        IslandFrame:Destroy()
    end)
end

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
    MainCorner.CornerRadius = UDim.new(0, 16)
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
        BgCorner.CornerRadius = UDim.new(0, 16)
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
    BottomCorner.CornerRadius = UDim.new(0, 16)
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
        end
    end)

    RunService.Heartbeat:Connect(function()
        WindowFrame.Position = LerpUDim2(WindowFrame.Position, TargetPosition, 0.16)
        FloatBallFrame.Position = LerpUDim2(FloatBallFrame.Position, BallTargetPos, 0.16)
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
            ButtonIcon.Image = "rbxassetid://10747373176"
            ButtonIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            ButtonIcon.Parent = InteractButton

            InteractButton.MouseButton1Click:Connect(function()
                if not ElementConfig.Locked then
                    TweenService:Create(InteractButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -48, 0, 12)}):Play()
                    task.wait(0.1)
                    TweenService:Create(InteractButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(1, -50, 0, 10)}):Play()
                    ElementConfig.Callback()
                end
            end)

            return ButtonFrame
        end

        function Tab:Toggle(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "开关组件"
            ElementConfig.Desc = ElementConfig.Desc or "切换特定功能的开启或关闭"
            ElementConfig.Default = ElementConfig.Default or false
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local ToggleState = ElementConfig.Default

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
            TitleLabel.Size = UDim2.new(1, -120, 0, 22)
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
            DescLabel.Size = UDim2.new(1, -120, 0, 18)
            DescLabel.Position = UDim2.new(0, 16, 0, 27)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = ToggleFrame

            local ToggleBg = Instance.new("TextButton")
            ToggleBg.Name = "ToggleBg"
            ToggleBg.Size = UDim2.new(0, 46, 0, 24)
            ToggleBg.Position = UDim2.new(1, -62, 0.5, -12)
            ToggleBg.BackgroundColor3 = ToggleState and Color3.fromRGB(0, 180, 210) or Color3.fromRGB(45, 50, 65)
            ToggleBg.Text = ""
            ToggleBg.AutoButtonColor = false
            ToggleBg.Parent = ToggleFrame

            local BgCorner = Instance.new("UICorner")
            BgCorner.CornerRadius = UDim.new(0, 12)
            BgCorner.Parent = ToggleBg

            local ToggleBall = Instance.new("Frame")
            ToggleBall.Name = "ToggleBall"
            ToggleBall.Size = UDim2.new(0, 18, 0, 18)
            ToggleBall.Position = ToggleState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            ToggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBall.Parent = ToggleBg

            local BallCorner = Instance.new("UICorner")
            BallCorner.CornerRadius = UDim.new(0, 9)
            BallCorner.Parent = ToggleBall

            local function UpdateToggle()
                local TargetPos = ToggleState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
                local TargetColor = ToggleState and Color3.fromRGB(0, 180, 210) or Color3.fromRGB(45, 50, 65)
                TweenService:Create(ToggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = TargetPos}):Play()
                TweenService:Create(ToggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = TargetColor}):Play()
            end

            ToggleBg.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                UpdateToggle()
                ElementConfig.Callback(ToggleState)
            end)

            return ToggleFrame
        end

        function Tab:Slider(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "滑块组件"
            ElementConfig.Desc = ElementConfig.Desc or "滑动调节具体数值范围"
            ElementConfig.Min = ElementConfig.Min or 0
            ElementConfig.Max = ElementConfig.Max or 100
            ElementConfig.Default = ElementConfig.Default or 50
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local SliderValue = ElementConfig.Default

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = ElementConfig.Title .. "_Element"
            SliderFrame.Size = UDim2.new(1, 0, 0, 65)
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
            TitleLabel.Position = UDim2.new(0, 16, 0, 6)
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
            DescLabel.Position = UDim2.new(0, 16, 0, 24)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.GothamMedium
            DescLabel.TextSize = 12
            DescLabel.TextColor3 = Color3.fromRGB(140, 150, 165)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Text = ElementConfig.Desc
            DescLabel.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "ValueLabel"
            ValueLabel.Size = UDim2.new(0, 60, 0, 22)
            ValueLabel.Position = UDim2.new(1, -76, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 14
            ValueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Text = tostring(SliderValue)
            ValueLabel.Parent = SliderFrame

            local SliderTrack = Instance.new("TextButton")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.Size = UDim2.new(1, -32, 0, 6)
            SliderTrack.Position = UDim2.new(0, 16, 0, 48)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
            SliderTrack.Text = ""
            SliderTrack.AutoButtonColor = false
            SliderTrack.Parent = SliderFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 3)
            TrackCorner.Parent = SliderTrack

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new((SliderValue - ElementConfig.Min) / (ElementConfig.Max - ElementConfig.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 210)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 3)
            FillCorner.Parent = SliderFill

            local SliderBall = Instance.new("Frame")
            SliderBall.Name = "SliderBall"
            SliderBall.Size = UDim2.new(0, 14, 0, 14)
            SliderBall.Position = UDim2.new((SliderValue - ElementConfig.Min) / (ElementConfig.Max - ElementConfig.Min), -7, 0.5, -7)
            SliderBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderBall.Parent = SliderTrack

            local BallCorner = Instance.new("UICorner")
            BallCorner.CornerRadius = UDim.new(0, 7)
            BallCorner.Parent = SliderBall

            local Sliding = false

            local function UpdateSliderOutput(InputObj)
                local RenderSizeX = SliderTrack.AbsoluteSize.X
                local OffsetX = math.clamp(InputObj.Position.X - SliderTrack.AbsolutePosition.X, 0, RenderSizeX)
                local Percentage = OffsetX / RenderSizeX
                local RoundedValue = math.floor(ElementConfig.Min + (ElementConfig.Max - ElementConfig.Min) * Percentage)
                SliderValue = RoundedValue
                ValueLabel.Text = tostring(SliderValue)
                TweenService:Create(SliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(Percentage, 0, 1, 0)}):Play()
                TweenService:Create(SliderBall, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(Percentage, -7, 0.5, -7)}):Play()
                ElementConfig.Callback(SliderValue)
            end

            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Sliding = true
                    UpdateSliderOutput(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSliderOutput(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Sliding = false
                end
            end)

            return SliderFrame
        end

        function Tab:Dropdown(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "下拉框组件"
            ElementConfig.Desc = ElementConfig.Desc or "点击展开选择列表选项"
            ElementConfig.Options = ElementConfig.Options or {}
            ElementConfig.Default = ElementConfig.Default or ""
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local SelectedOption = ElementConfig.Default
            local DropExpanded = false

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

            local DropBox = Instance.new("TextButton")
            DropBox.Name = "DropBox"
            DropBox.Size = UDim2.new(0, 140, 0, 34)
            DropBox.Position = UDim2.new(1, -156, 0, 10)
            DropBox.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
            DropBox.BackgroundTransparency = 0.4
            DropBox.Text = ""
            DropBox.AutoButtonColor = false
            DropBox.Parent = DropdownFrame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 10)
            BoxCorner.Parent = DropBox

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Thickness = 1
            BoxStroke.Color = Color3.fromRGB(255, 255, 255)
            BoxStroke.Transparency = 0.85
            BoxStroke.Parent = DropBox

            local BoxText = Instance.new("TextLabel")
            BoxText.Name = "BoxText"
            BoxText.Size = UDim2.new(1, -32, 1, 0)
            BoxText.Position = UDim2.new(0, 12, 0, 0)
            BoxText.BackgroundTransparency = 1
            BoxText.Font = Enum.Font.GothamMedium
            BoxText.TextSize = 12
            BoxText.TextColor3 = Color3.fromRGB(230, 235, 245)
            BoxText.TextXAlignment = Enum.TextXAlignment.Left
            BoxText.Text = SelectedOption ~= "" and SelectedOption or "请选择..."
            BoxText.Parent = DropBox

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Name = "ArrowIcon"
            ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
            ArrowIcon.Position = UDim2.new(1, -22, 0.5, -7)
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Image = "rbxassetid://10747383861"
            ArrowIcon.ImageColor3 = Color3.fromRGB(180, 190, 210)
            ArrowIcon.Parent = DropBox

            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Name = "OptionsContainer"
            OptionsContainer.Size = UDim2.new(1, -32, 0, 0)
            OptionsContainer.Position = UDim2.new(0, 16, 0, 54)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Parent = DropdownFrame

            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.Padding = UDim.new(0, 4)
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerLayout.Parent = OptionsContainer

            local function BuildOptionList()
                for _, child in ipairs(OptionsContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for idx, name in ipairs(ElementConfig.Options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Name = name .. "_Opt"
                    OptBtn.Size = UDim2.new(1, 0, 0, 32)
                    OptBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    OptBtn.BackgroundTransparency = (name == SelectedOption) and 0.88 or 0.96
                    OptBtn.Text = ""
                    OptBtn.AutoButtonColor = false
                    OptBtn.Parent = OptionsContainer

                    local OptCorner = Instance.new("UICorner")
                    OptCorner.CornerRadius = UDim.new(0, 8)
                    OptCorner.Parent = OptBtn

                    local OptText = Instance.new("TextLabel")
                    OptText.Name = "Text"
                    OptText.Size = UDim2.new(1, -24, 1, 0)
                    OptText.Position = UDim2.new(0, 12, 0, 0)
                    OptText.BackgroundTransparency = 1
                    OptText.Font = Enum.Font.GothamMedium
                    OptText.TextSize = 12
                    OptText.TextColor3 = (name == SelectedOption) and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(200, 205, 215)
                    OptText.TextXAlignment = Enum.TextXAlignment.Left
                    OptText.Text = name
                    OptText.Parent = OptBtn

                    OptBtn.MouseButton1Click:Connect(function()
                        SelectedOption = name
                        BoxText.Text = name
                        DropExpanded = false
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 54)}):Play()
                        TweenService:Create(ArrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                        BuildOptionList()
                        ElementConfig.Callback(SelectedOption)
                    end)
                end
            end

            BuildOptionList()

            DropBox.MouseButton1Click:Connect(function()
                DropExpanded = not DropExpanded
                if DropExpanded then
                    local FinalHeight = 54 + ContainerLayout.AbsoluteContentSize.Y + 10
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, FinalHeight)}):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
                else
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 54)}):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                end
            end)

            return DropdownFrame
        end

        function Tab:Input(ElementConfig)
            ElementConfig.Title = ElementConfig.Title or "输入框组件"
            ElementConfig.Desc = ElementConfig.Desc or "在此键入文本内容提交"
            ElementConfig.Placeholder = ElementConfig.Placeholder or "请输入..."
            ElementConfig.Callback = ElementConfig.Callback or function() end

            local InputFrame = Instance.new("Frame")
            InputFrame.Name = ElementConfig.Title .. "_Element"
            InputFrame.Size = UDim2.new(1, 0, 0, 54)
            InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            InputFrame.BackgroundTransparency = 0.96
            InputFrame.Parent = ContentFrame

            table.insert(Window.AllElements, {Frame = InputFrame, Title = ElementConfig.Title, Desc = ElementConfig.Desc})

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 14)
            FrameCorner.Parent = InputFrame

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Thickness = 1
            FrameStroke.Color = Color3.fromRGB(255, 255, 255)
            FrameStroke.Transparency = 0.94
            FrameStroke.Parent = InputFrame

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
            TitleLabel.Parent = InputFrame

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
            DescLabel.Parent = InputFrame

            local InputBox = Instance.new("TextBox")
            InputBox.Name = "InputBox"
            InputBox.Size = UDim2.new(0, 140, 0, 34)
            InputBox.Position = UDim2.new(1, -156, 0, 10)
            InputBox.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
            InputBox.BackgroundTransparency = 0.4
            InputBox.Text = ""
            InputBox.PlaceholderText = ElementConfig.Placeholder
            InputBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 130)
            InputBox.Font = Enum.Font.GothamMedium
            InputBox.TextSize = 12
            InputBox.TextColor3 = Color3.fromRGB(240, 245, 255)
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = InputFrame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 10)
            BoxCorner.Parent = InputBox

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Thickness = 1
            BoxStroke.Color = Color3.fromRGB(255, 255, 255)
            BoxStroke.Transparency = 0.85
            BoxStroke.Parent = InputBox

            InputBox.FocusLost:Connect(function(EnterPressed)
                ElementConfig.Callback(InputBox.Text, EnterPressed)
            end)

            return InputFrame
        end

        return Tab
    end

    return Window
end

return Library
