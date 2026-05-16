--[=[
    高级前端架构师级 - 流体 UI 框架 (Fluid UI Framework)
    专门适配 Roblox 注入器环境，提供高性能、多端自适应、高颜值的极简现代暗黑风界面。
]=]

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {
    Theme = {
        Background = Color3.fromRGB(15, 15, 20),
        Topbar = Color3.fromRGB(22, 22, 28),
        Sidebar = Color3.fromRGB(18, 18, 24),
        Accent = Color3.fromRGB(0, 122, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(140, 140, 150),
        ElementBg = Color3.fromRGB(26, 26, 34),
        ElementHover = Color3.fromRGB(34, 34, 44),
        Border = Color3.fromRGB(35, 35, 45)
    },
    Connections = {}
}

-- [全局通知系统初始化]
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "FluidUI_Notifications"
NotifyGui.Parent = CoreGui
NotifyGui.DisplayOrder = 100

local NotifyLayoutFrame = Instance.new("Frame")
NotifyLayoutFrame.Size = UDim2.new(0, 300, 1, 0)
NotifyLayoutFrame.Position = UDim2.new(1, -320, 0, 20)
NotifyLayoutFrame.BackgroundTransparency = 1
NotifyLayoutFrame.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifyLayout.Parent = NotifyLayoutFrame

-- [原生纯净平滑拖拽实现（带阻尼物理感）]
function Library:MakeDraggable(obj, dragSpeed)
    dragSpeed = dragSpeed or 0.15
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local targetPos = obj.Position

    local inputBegan = obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position

            local changed
            changed = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    changed:Disconnect()
                end
            end)
        end
    end)
    table.insert(Library.Connections, inputBegan)

    local inputChanged = obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    table.insert(Library.Connections, inputChanged)

    local renderStep = RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        obj.Position = obj.Position:Lerp(targetPos, dragSpeed)
    end)
    table.insert(Library.Connections, renderStep)
end

-- [独立通知方法]
function Library:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 5
    local imageId = config.Image

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 70)
    container.BackgroundTransparency = 1
    container.Parent = NotifyLayoutFrame

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 1, 0)
    card.Position = UDim2.new(1, 10, 0, 0)
    card.BackgroundColor3 = Library.Theme.ElementBg
    card.BorderSizePixel = 0
    card.Parent = container

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = Library.Theme.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = accentBar

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(15, 15, 15, 15)
    shadow.Parent = card

    local textOffset = 16
    if imageId then
        textOffset = 46
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 22, 0, 22)
        img.Position = UDim2.new(0, 14, 0.5, -11)
        img.BackgroundTransparency = 1
        img.Image = imageId
        img.Parent = card
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -textOffset - 10, 0, 20)
    titleLabel.Position = UDim2.new(0, textOffset, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextColor3 = Library.Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.Parent = card

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -textOffset - 10, 0, 30)
    contentLabel.Position = UDim2.new(0, textOffset, 0, 28)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextSize = 11
    contentLabel.TextColor3 = Library.Theme.TextMuted
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Text = content
    contentLabel.Parent = card

    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingStyle.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(duration, function()
        local tweenOut = TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingStyle.In), {Position = UDim2.new(1, 10, 0, 0)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            local collapse = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {Size = UDim2.new(1, 0, 0, 0)})
            collapse:Play()
            collapse.Completed:Connect(function()
                container:Destroy()
            end)
        end)
    end)
end

-- [主窗口构建方法]
function Library.CreateWindow(titleText)
    local Window = {
        CurrentTab = nil,
        Tabs = {}
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluidUI_Framework"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(15, 15, 15, 15)
    shadow.Parent = MainFrame

    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = 580 / 400
    aspect.AspectType = Enum.AspectType.ScaleWithParentSize
    aspect.DominantAxis = Enum.DominantAxis.Width
    aspect.Parent = MainFrame

    Library:MakeDraggable(MainFrame, 0.15)

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    Topbar.BackgroundColor3 = Library.Theme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local topbarCorner = Instance.new("UICorner")
    topbarCorner.CornerRadius = UDim.new(0, 12)
    topbarCorner.Parent = Topbar

    local topbarHide = Instance.new("Frame")
    topbarHide.Size = UDim2.new(1, 0, 0, 10)
    topbarHide.Position = UDim2.new(0, 0, 1, -10)
    topbarHide.BackgroundColor3 = Library.Theme.Topbar
    topbarHide.BorderSizePixel = 0
    topbarHide.Parent = Topbar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Library.Theme.Text
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = titleText or "Fluid UI Framework"
    titleLabel.Parent = Topbar

    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 80, 1, 0)
    controls.Position = UDim2.new(1, -90, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = Topbar

    local controlLayout = Instance.new("UIListLayout")
    controlLayout.FillDirection = Enum.FillDirection.Horizontal
    controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlLayout.Padding = UDim.new(0, 10)
    controlLayout.Parent = controls

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 14, 0, 14)
    minBtn.BackgroundColor3 = Color3.fromRGB(250, 180, 50)
    minBtn.Text = ""
    minBtn.Parent = controls
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 14, 0, 14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(250, 80, 80)
    closeBtn.Text = ""
    closeBtn.Parent = controls
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -45)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 12)
    sideCorner.Parent = Sidebar

    local sideHide = Instance.new("Frame")
    sideHide.Size = UDim2.new(0, 15, 1, 0)
    sideHide.Position = UDim2.new(1, -15, 0, 0)
    sideHide.BackgroundColor3 = Library.Theme.Sidebar
    sideHide.BorderSizePixel = 0
    sideHide.Parent = Sidebar

    local sideHideTop = Instance.new("Frame")
    sideHideTop.Size = UDim2.new(1, 0, 0, 15)
    sideHideTop.Position = UDim2.new(0, 0, 0, 0)
    sideHideTop.BackgroundColor3 = Library.Theme.Sidebar
    sideHideTop.BorderSizePixel = 0
    sideHideTop.Parent = Sidebar

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size = UDim2.new(1, -10, 1, -20)
    tabScroll.Position = UDim2.new(0, 5, 0, 10)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 0
    tabScroll.Parent = Sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.Parent = tabScroll

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -160, 1, -45)
    ContentContainer.Position = UDim2.new(0, 160, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local FloatingBall = Instance.new("Frame")
    FloatingBall.Size = UDim2.new(0, 50, 0, 50)
    FloatingBall.Position = UDim2.new(0.05, 0, 0.5, -25)
    FloatingBall.BackgroundColor3 = Library.Theme.Topbar
    FloatingBall.Visible = false
    FloatingBall.Active = true
    FloatingBall.Parent = ScreenGui

    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = FloatingBall

    local ballShadow = Instance.new("ImageLabel")
    ballShadow.BackgroundTransparency = 1
    ballShadow.Position = UDim2.new(0, -12, 0, -12)
    ballShadow.Size = UDim2.new(1, 24, 1, 24)
    ballShadow.Image = "rbxassetid://1316045217"
    ballShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ballShadow.ImageTransparency = 0.4
    ballShadow.ScaleType = Enum.ScaleType.Slice
    ballShadow.SliceCenter = Rect.new(15, 15, 15, 15)
    ballShadow.Parent = FloatingBall

    local ballIcon = Instance.new("ImageLabel")
    ballIcon.Size = UDim2.new(0, 26, 0, 26)
    ballIcon.Position = UDim2.new(0.5, -13, 0.5, -13)
    ballIcon.BackgroundTransparency = 1
    ballIcon.Image = "rbxassetid://6031094678"
    ballIcon.ImageColor3 = Library.Theme.Accent
    ballIcon.Parent = FloatingBall

    Library:MakeDraggable(FloatingBall, 0.2)

    local isMinimized = false
    local origSize = MainFrame.Size
    local origPos = MainFrame.Position

    local function minimize()
        if isMinimized then return end
        isMinimized = true
        origSize = MainFrame.Size
        origPos = MainFrame.Position

        local tweenMain = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingStyle.InOut), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(origPos.X.Scale, FloatingBall.Position.X.Offset + 25, origPos.Y.Scale, FloatingBall.Position.Y.Offset + 25)
        })
        tweenMain:Play()
        tweenMain.Completed:Connect(function()
            MainFrame.Visible = false
            FloatingBall.Visible = true
            FloatingBall.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(FloatingBall, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingStyle.Out), {
                Size = UDim2.new(0, 50, 0, 50)
            }):Play()
        end)
    end

    local function restore()
        if not isMinimized then return end
        isMinimized = false

        TweenService:Create(FloatingBall, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingStyle.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()

        task.delay(0.2, function()
            FloatingBall.Visible = false
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingStyle.Out), {
                Size = origSize,
                Position = origPos
            }):Play()
        end)
    end

    local minClick = minBtn.MouseButton1Click:Connect(minimize)
    table.insert(Library.Connections, minClick)

    local ballClick = FloatingBall.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local startTime = tick()
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    connection:Disconnect()
                    if tick() - startTime < 0.3 then
                        restore()
                    end
                end
            end)
        end
    end)
    table.insert(Library.Connections, ballClick)

    local closeClick = closeBtn.MouseButton1Click:Connect(function()
        for _, conn in ipairs(Library.Connections) do
            if conn then conn:Disconnect() end
        end
        ScreenGui:Destroy()
        NotifyGui:Destroy()
    end)
    table.insert(Library.Connections, closeClick)

    local function addMicroAnims(btn, normalColor, hoverColor)
        local h = btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = hoverColor}):Play()
        end)
        local l = btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = normalColor}):Play()
        end)
        table.insert(Library.Connections, h)
        table.insert(Library.Connections, l)
    end
    addMicroAnims(closeBtn, Color3.fromRGB(250, 80, 80), Color3.fromRGB(255, 110, 110))
    addMicroAnims(minBtn, Color3.fromRGB(250, 180, 50), Color3.fromRGB(255, 200, 80))

    -- [分栏创建方法]
    function Window:CreateTab(tabName, tabIcon)
        local Tab = {
            Elements = {}
        }

        local TabPage = Instance.new("CanvasGroup")
        TabPage.Size = UDim2.new(1, -20, 1, -20)
        TabPage.Position = UDim2.new(0, 10, 0, 10)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.Parent = ContentContainer

        local pageScroll = Instance.new("ScrollingFrame")
        pageScroll.Size = UDim2.new(1, 0, 1, 0)
        pageScroll.BackgroundTransparency = 1
        pageScroll.BorderSizePixel = 0
        pageScroll.ScrollBarThickness = 2
        pageScroll.ScrollBarImageColor3 = Library.Theme.Accent
        pageScroll.Parent = TabPage

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = pageScroll

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 38)
        tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundTransparency = 1
        tabButton.Text = ""
        tabButton.Parent = tabScroll

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabButton

        local iconOffset = 14
        if tabIcon and tabIcon ~= "" then
            iconOffset = 38
            local iconImg = Instance.new("ImageLabel")
            iconImg.Size = UDim2.new(0, 18, 0, 18)
            iconImg.Position = UDim2.new(0, 12, 0.5, -9)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = tabIcon
            iconImg.ImageColor3 = Library.Theme.TextMuted
            iconImg.Parent = tabButton
            Tab.IconImg = iconImg
        end

        local btnLabel = Instance.new("TextLabel")
        btnLabel.Size = UDim2.new(1, -iconOffset, 1, 0)
        btnLabel.Position = UDim2.new(0, iconOffset, 0, 0)
        btnLabel.BackgroundTransparency = 1
        btnLabel.Font = Enum.Font.GothamMedium
        btnLabel.TextColor3 = Library.Theme.TextMuted
        btnLabel.TextSize = 13
        btnLabel.TextXAlignment = Enum.TextXAlignment.Left
        btnLabel.Text = tabName
        btnLabel.Parent = tabButton

        function Tab:Select()
            if Window.CurrentTab == Tab then return end

            if Window.CurrentTab then
                local prevPage = Window.CurrentTab.TabPage
                local prevBtn = Window.CurrentTab.TabButton
                local prevLabel = Window.CurrentTab.BtnLabel
                local prevIcon = Window.CurrentTab.IconImg

                TweenService:Create(prevBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundTransparency = 1}):Play()
                TweenService:Create(prevLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {TextColor3 = Library.Theme.TextMuted}):Play()
                if prevIcon then
                    TweenService:Create(prevIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {ImageColor3 = Library.Theme.TextMuted}):Play()
                end

                TweenService:Create(prevPage, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingStyle.In), {
                    GroupTransparency = 1,
                    Position = UDim2.new(0, -20, 0, 10)
                }):Play()
                task.delay(0.25, function() prevPage.Visible = false end)
            end

            Window.CurrentTab = Tab
            TabPage.Visible = true
            TabPage.Position = UDim2.new(0, 30, 0, 10)
            TabPage.GroupTransparency = 1

            TweenService:Create(tabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundTransparency = 0.9, BackgroundColor3 = Library.Theme.Accent}):Play()
            TweenService:Create(btnLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {TextColor3 = Library.Theme.Text}):Play()
            if Tab.IconImg then
                TweenService:Create(Tab.IconImg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {ImageColor3 = Library.Theme.Accent}):Play()
            end

            TweenService:Create(TabPage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingStyle.Out), {
                GroupTransparency = 0,
                Position = UDim2.new(0, 10, 0, 10)
            }):Play()
        end

        local btnClick = tabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)
        table.insert(Library.Connections, btnClick)

        local h = tabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                TweenService:Create(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundTransparency = 0.95, BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
        end)
        local l = tabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                TweenService:Create(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundTransparency = 1}):Play()
            end
        end)
        table.insert(Library.Connections, h)
        table.insert(Library.Connections, l)

        Tab.TabPage = TabPage
        Tab.TabButton = tabButton
        Tab.BtnLabel = btnLabel

        -- [交互组件实现 - 按钮]
        function Tab:CreateButton(text, icon, callback)
            local btnFrame = Instance.new("Frame")
            btnFrame.Size = UDim2.new(1, -6, 0, 40)
            btnFrame.BackgroundColor3 = Library.Theme.ElementBg
            btnFrame.BorderSizePixel = 0
            btnFrame.Parent = pageScroll

            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = btnFrame

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = btnFrame

            local labelOffset = 14
            if icon and icon ~= "" then
                labelOffset = 38
                local btnIcon = Instance.new("ImageLabel")
                btnIcon.Size = UDim2.new(0, 18, 0, 18)
                btnIcon.Position = UDim2.new(0, 12, 0.5, -9)
                btnIcon.BackgroundTransparency = 1
                btnIcon.Image = icon
                btnIcon.ImageColor3 = Library.Theme.Text
                btnIcon.Parent = btnFrame
            end

            local btnText = Instance.new("TextLabel")
            btnText.Size = UDim2.new(1, -labelOffset, 1, 0)
            btnText.Position = UDim2.new(0, labelOffset, 0, 0)
            btnText.BackgroundTransparency = 1
            btnText.Font = Enum.Font.GothamMedium
            btnText.TextColor3 = Library.Theme.Text
            btnText.TextSize = 13
            btnText.TextXAlignment = Enum.TextXAlignment.Left
            btnText.Text = text
            btnText.Parent = btnFrame

            local cbConn = clickBtn.MouseButton1Click:Connect(function()
                TweenService:Create(btnFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Library.Theme.Accent}):Play()
                task.delay(0.1, function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Library.Theme.ElementHover}):Play()
                end)
                if callback then callback() end
            end)
            table.insert(Library.Connections, cbConn)

            local enter = clickBtn.MouseEnter:Connect(function()
                TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Library.Theme.ElementHover}):Play()
            end)
            local leave = clickBtn.MouseLeave:Connect(function()
                TweenService:Create(btnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Library.Theme.ElementBg}):Play()
            end)
            table.insert(Library.Connections, enter)
            table.insert(Library.Connections, leave)
        end

        -- [交互组件实现 - 开关]
        function Tab:CreateToggle(text, default, callback)
            local toggleState = default or false

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -6, 0, 40)
            toggleFrame.BackgroundColor3 = Library.Theme.ElementBg
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = pageScroll

            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = toggleFrame

            local toggleText = Instance.new("TextLabel")
            toggleText.Size = UDim2.new(1, -60, 1, 0)
            toggleText.Position = UDim2.new(0, 14, 0, 0)
            toggleText.BackgroundTransparency = 1
            toggleText.Font = Enum.Font.GothamMedium
            toggleText.TextColor3 = Library.Theme.Text
            toggleText.TextSize = 13
            toggleText.TextXAlignment = Enum.TextXAlignment.Left
            toggleText.Text = text
            toggleText.Parent = toggleFrame

            local switchBg = Instance.new("Frame")
            switchBg.Size = UDim2.new(0, 36, 0, 20)
            switchBg.Position = UDim2.new(1, -50, 0.5, -10)
            switchBg.BackgroundColor3 = toggleState and Library.Theme.Accent or Color3.fromRGB(50, 50, 60)
            switchBg.BorderSizePixel = 0
            switchBg.Parent = toggleFrame

            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(1, 0)
            sc.Parent = switchBg

            local switchBall = Instance.new("Frame")
            switchBall.Size = UDim2.new(0, 14, 0, 14)
            switchBall.Position = toggleState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            switchBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            switchBall.BorderSizePixel = 0
            switchBall.Parent = switchBg

            local sbc = Instance.new("UICorner")
            sbc.CornerRadius = UDim.new(1, 0)
            sbc.Parent = switchBall

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = toggleFrame

            local function updateToggle()
                if toggleState then
                    TweenService:Create(switchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Library.Theme.Accent}):Play()
                    TweenService:Create(switchBall, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingStyle.Out), {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
                else
                    TweenService:Create(switchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                    TweenService:Create(switchBall, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingStyle.Out), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
                end
                if callback then callback(toggleState) end
            end

            local toggleConn = clickBtn.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                updateToggle()
            end)
            table.insert(Library.Connections, toggleConn)

            local enter = clickBtn.MouseEnter:Connect(function()
                TweenService:Create(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Library.Theme.ElementHover}):Play()
            end)
            local leave = clickBtn.MouseLeave:Connect(function()
                TweenService:Create(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {BackgroundColor3 = Library.Theme.ElementBg}):Play()
            end)
            table.insert(Library.Connections, enter)
            table.insert(Library.Connections, leave)
        end

        -- [交互组件实现 - 滑块]
        function Tab:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -6, 0, 52)
            sliderFrame.BackgroundColor3 = Library.Theme.ElementBg
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = pageScroll

            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = sliderFrame

            local sliderText = Instance.new("TextLabel")
            sliderText.Size = UDim2.new(1, -100, 0, 25)
            sliderText.Position = UDim2.new(0, 14, 0, 4)
            sliderText.BackgroundTransparency = 1
            sliderText.Font = Enum.Font.GothamMedium
            sliderText.TextColor3 = Library.Theme.Text
            sliderText.TextSize = 13
            sliderText.TextXAlignment = Enum.TextXAlignment.Left
            sliderText.Text = text
            sliderText.Parent = sliderFrame

            local valText = Instance.new("TextLabel")
            valText.Size = UDim2.new(0, 60, 0, 25)
            valText.Position = UDim2.new(1, -74, 0, 4)
            valText.BackgroundTransparency = 1
            valText.Font = Enum.Font.GothamMedium
            valText.TextColor3 = Library.Theme.Accent
            valText.TextSize = 13
            valText.TextXAlignment = Enum.TextXAlignment.Right
            valText.Text = tostring(default or min)
            valText.Parent = sliderFrame

            local sliderTrack = Instance.new("Frame")
            sliderTrack.Size = UDim2.new(1, -28, 0, 6)
            sliderTrack.Position = UDim2.new(0, 14, 1, -14)
            sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = sliderFrame

            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = sliderTrack

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(math.clamp(((default or min) - min) / (max - min), 0, 1), 0, 1, 0)
            sliderFill.BackgroundColor3 = Library.Theme.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack

            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = sliderFill

            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size = UDim2.new(1, 0, 1, 0)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""
            sliderBtn.Parent = sliderFrame

            local isSliding = false

            local function moveSlider(input)
                local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * relativeX)
                valText.Text = tostring(val)
                TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingStyle.Out), {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
                if callback then callback(val) end
            end

            local dragStartConn = sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isSliding = true
                    moveSlider(input)
                end
            end)
            local dragEndConn = UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isSliding = false
                end
            end)
            local dragMoveConn = UIS.InputChanged:Connect(function(input)
                if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    moveSlider(input)
                end
            end)
            table.insert(Library.Connections, dragStartConn)
            table.insert(Library.Connections, dragEndConn)
            table.insert(Library.Connections, dragMoveConn)
        end

        if not Window.CurrentTab then
            Tab:Select()
        end

        return Tab
    end

    return Window
end

return Library
