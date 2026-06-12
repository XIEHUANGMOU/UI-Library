local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local function downloadImage(url, filename)
    if not isfile(filename) then
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success then
            writefile(filename, result)
        end
    end
    return getcustomasset and getcustomasset(filename) or ""
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.ImageTransparency = 0.85
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 100)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "MATRIX INJECTOR V4"
TitleText.TextColor3 = Color3.fromRGB(0, 255, 100)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.Code
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, 0, 0, 1)
TitleLine.Position = UDim2.new(0, 0, 1, -1)
TitleLine.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
TitleLine.BorderSizePixel = 0
TitleLine.Parent = TitleBar

local WindowButtons = Instance.new("Frame")
WindowButtons.Size = UDim2.new(0, 80, 1, 0)
WindowButtons.Position = UDim2.new(1, -80, 0, 0)
WindowButtons.BackgroundTransparency = 1
WindowButtons.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0, 5, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.Code
MinimizeBtn.Parent = WindowButtons

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = Color3.fromRGB(40, 40, 40)
MinimizeStroke.Thickness = 1
MinimizeStroke.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0, 40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.Code
CloseBtn.Parent = WindowButtons

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(40, 40, 40)
CloseStroke.Thickness = 1
CloseStroke.Parent = CloseBtn

local OpenFrame = Instance.new("Frame")
OpenFrame.Size = UDim2.new(0, 130, 0, 40)
OpenFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
OpenFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenFrame.BorderSizePixel = 0
OpenFrame.Visible = false
OpenFrame.Parent = ScreenGui

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(0, 255, 100)
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenFrame

local DragHandle = Instance.new("Frame")
DragHandle.Size = UDim2.new(0, 25, 1, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
DragHandle.BorderSizePixel = 0
DragHandle.Parent = OpenFrame

local DragLine = Instance.new("Frame")
DragLine.Size = UDim2.new(0, 1, 1, 0)
DragLine.Position = UDim2.new(1, -1, 0, 0)
DragLine.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
DragLine.BorderSizePixel = 0
DragLine.Parent = DragHandle

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(1, -25, 1, 0)
OpenBtn.Position = UDim2.new(0, 25, 0, 0)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Text = "OPEN UI"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
OpenBtn.TextSize = 13
OpenBtn.Font = Enum.Font.Code
OpenBtn.Parent = OpenFrame

local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 130, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideBarLine = Instance.new("Frame")
SideBarLine.Size = UDim2.new(0, 1, 1, 0)
SideBarLine.Position = UDim2.new(1, -1, 0, 0)
SideBarLine.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
SideBarLine.BorderSizePixel = 0
SideBarLine.Parent = SideBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = SideBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = SideBar

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -130, 1, -40)
Container.Position = UDim2.new(0, 130, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainFrame, TitleBar)
makeDraggable(OpenFrame, DragHandle)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenFrame.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    OpenFrame.Visible = false
    MainFrame.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Library = {}
local tabs = {}
local currentTab = nil

function Library:SetBackground(url, filename)
    task.spawn(function()
        local asset = downloadImage(url, filename)
        if asset ~= "" then
            BackgroundImage.Image = asset
        end
    end)
end

function Library:CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.Code
    TabButton.Parent = SideBar

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(30, 30, 30)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
    Page.Parent = Container

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = Page

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.Parent = Page

    PageLayout.Changed:Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
    end)

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Page.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Stroke.Color = Color3.fromRGB(30, 30, 30)
        end
        Page.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(0, 255, 100)
        ButtonStroke.Color = Color3.fromRGB(0, 255, 100)
    end)

    if currentTab == nil then
        Page.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(0, 255, 100)
        ButtonStroke.Color = Color3.fromRGB(0, 255, 100)
        currentTab = name
    end

    tabs[name] = {Page = Page, Button = TabButton, Stroke = ButtonStroke}

    local ElementHandler = {}

    function ElementHandler:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(0, 255, 100)
        Button.TextSize = 13
        Button.Font = Enum.Font.Code
        Button.Parent = Page

        local ElementStroke = Instance.new("UIStroke")
        ElementStroke.Color = Color3.fromRGB(40, 40, 40)
        ElementStroke.Thickness = 1
        ElementStroke.Parent = Button

        Button.MouseEnter:Connect(function()
            TweenService:Create(ElementStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 100)}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(ElementStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
        end)
        Button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    function ElementHandler:CreateToggle(text, default, callback)
        local state = default or false

        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(1, 0, 0, 35)
        Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Toggle.BorderSizePixel = 0
        Toggle.Text = ""
        Toggle.Parent = Page

        local ElementStroke = Instance.new("UIStroke")
        ElementStroke.Color = Color3.fromRGB(40, 40, 40)
        ElementStroke.Thickness = 1
        ElementStroke.Parent = Toggle

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.Font = Enum.Font.Code
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Toggle

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 35, 0, 17)
        Indicator.Position = UDim2.new(1, -45, 0.5, -8)
        Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(40, 40, 40)
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Toggle

        local InnerDot = Instance.new("Frame")
        InnerDot.Size = UDim2.new(0, 13, 0, 13)
        InnerDot.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        InnerDot.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        InnerDot.BorderSizePixel = 0
        InnerDot.Parent = Indicator

        local function updateToggle()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(InnerDot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
            pcall(callback, state)
        end

        Toggle.MouseButton1Click:Connect(function()
            state = not state
            updateToggle()
        end)
    end

    function ElementHandler:CreateSlider(text, min, max, default, callback)
        local value = default or min

        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(1, 0, 0, 45)
        Slider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Slider.BorderSizePixel = 0
        Slider.Parent = Page

        local ElementStroke = Instance.new("UIStroke")
        ElementStroke.Color = Color3.fromRGB(40, 40, 40)
        ElementStroke.Thickness = 1
        ElementStroke.Parent = Slider

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 0, 25)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.Font = Enum.Font.Code
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Slider

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.5, -10, 0, 25)
        ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(value)
        ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        ValueLabel.TextSize = 13
        ValueLabel.Font = Enum.Font.Code
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Slider

        local Track = Instance.new("TextButton")
        Track.Size = UDim2.new(1, -20, 0, 4)
        Track.Position = UDim2.new(0, 10, 0, 30)
        Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Track.BorderSizePixel = 0
        Track.Text = ""
        Track.Parent = Slider

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        Fill.BorderSizePixel = 0
        Fill.Parent = Track

        local sliderDragging = false

        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * pos)
            ValueLabel.Text = tostring(value)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            pcall(callback, value)
        end

        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderDragging = true
                updateSlider(input)
            end
        end)

        Track.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
    end

    return ElementHandler
end

ScreenGui.Parent = game:GetService("CoreGui")
return Library
