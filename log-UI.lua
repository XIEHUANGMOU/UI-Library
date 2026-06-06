local HackerLogUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HackerLogUI"
ScreenGui.Enabled = false
ScreenGui.Parent = nil

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 800, 0, 500)
MainFrame.Position = UDim2.new(0.5, -400, 1, 0)
MainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.07)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.new(0.4, 0.45, 0.5)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local DragHandle = Instance.new("Frame")
DragHandle.Size = UDim2.new(1, 0, 0, 35)
DragHandle.BackgroundTransparency = 1
DragHandle.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = ">> 更新日志 <<"
Title.TextColor3 = Color3.new(0.85, 0.9, 0.95)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Title.Parent = DragHandle

local BeijingTimeBox = Instance.new("Frame")
BeijingTimeBox.Size = UDim2.new(0, 180, 0, 35)
BeijingTimeBox.Position = UDim2.new(1, -190, 0, 0)
BeijingTimeBox.BackgroundColor3 = Color3.new(0.08, 0.08, 0.1)
BeijingTimeBox.BorderColor3 = Color3.new(0.4, 0.45, 0.5)
BeijingTimeBox.BorderSizePixel = 1
BeijingTimeBox.Parent = DragHandle

local BeijingTimeLabel = Instance.new("TextLabel")
BeijingTimeLabel.Size = UDim2.new(1, 0, 1, 0)
BeijingTimeLabel.BackgroundTransparency = 1
BeijingTimeLabel.TextColor3 = Color3.new(0.85, 0.9, 0.95)
BeijingTimeLabel.TextSize = 14
BeijingTimeLabel.Font = Enum.Font.Code
BeijingTimeLabel.Parent = BeijingTimeBox

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 120, 1, -45)
TabBar.Position = UDim2.new(0, 5, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -130, 1, -45)
RightPanel.Position = UDim2.new(0, 130, 0, 45)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.9, 0, 0, 30)
SearchBox.Position = UDim2.new(0.05, 0, 0, 0)
SearchBox.BackgroundColor3 = Color3.new(0.08, 0.08, 0.1)
SearchBox.BorderColor3 = Color3.new(0.4, 0.45, 0.5)
SearchBox.TextColor3 = Color3.new(0.85, 0.9, 0.95)
SearchBox.PlaceholderText = "查找日志..."
SearchBox.PlaceholderColor3 = Color3.new(0.5, 0.55, 0.6)
SearchBox.Text = ""
SearchBox.Font = Enum.Font.SourceSans
SearchBox.Parent = RightPanel

local LogList = Instance.new("ScrollingFrame")
LogList.Size = UDim2.new(0.9, 0, 1, -55)
LogList.Position = UDim2.new(0.05, 0, 0, 40)
LogList.BackgroundColor3 = Color3.new(0.03, 0.03, 0.05)
LogList.BackgroundTransparency = 0.2
LogList.BorderColor3 = Color3.new(0.4, 0.45, 0.5)
LogList.CanvasSize = UDim2.new(0, 0, 0, 0)
LogList.ScrollBarThickness = 8
LogList.Parent = RightPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = LogList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -130, 0, 20)
StatusBar.Position = UDim2.new(0, 130, 1, -20)
StatusBar.BackgroundTransparency = 0.8
StatusBar.BackgroundColor3 = Color3.new(0.05, 0.05, 0.07)
StatusBar.Text = "> 就绪"
StatusBar.TextColor3 = Color3.new(0.7, 0.75, 0.8)
StatusBar.TextSize = 12
StatusBar.Font = Enum.Font.Code
StatusBar.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 100, 0, 25)
CloseButton.Position = UDim2.new(1, -110, 1, -30)
CloseButton.BackgroundColor3 = Color3.new(0.1, 0.1, 0.12)
CloseButton.BorderColor3 = Color3.new(0.4, 0.45, 0.5)
CloseButton.Text = "我已知晓"
CloseButton.TextColor3 = Color3.new(0.85, 0.9, 0.95)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

local tabs = {}
local activeTab = 1
local tabButtons = {}

local currentTween = nil

local function refreshDisplay(searchTerm)
    for _, child in ipairs(LogList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if #tabs == 0 then return end
    local currentLogs = tabs[activeTab] and tabs[activeTab].data or {}
    local searchLower = searchTerm and searchTerm:lower() or ""
    local yOffset = 0
    for _, entry in ipairs(currentLogs) do
        if searchLower == "" or entry:lower():find(searchLower) then
            local line = Instance.new("TextLabel")
            line.Size = UDim2.new(1, -20, 0, 24)
            line.Position = UDim2.new(0, 10, 0, yOffset)
            line.BackgroundTransparency = 1
            line.Text = entry
            line.TextColor3 = Color3.new(0.85, 0.9, 0.95)
            line.TextXAlignment = Enum.TextXAlignment.Left
            line.TextSize = 14
            line.Font = Enum.Font.Code
            line.Parent = LogList
            yOffset = yOffset + 28
        end
    end
    LogList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    
    local visibleCount = 0
    for _, child in ipairs(LogList:GetChildren()) do
        if child:IsA("TextLabel") then
            visibleCount = visibleCount + 1
        end
    end
    StatusBar.Text = "> 找到 " .. visibleCount .. " / " .. #currentLogs .. " 条"
end

local function rebuildTabBar()
    for _, btn in ipairs(tabButtons) do
        btn:Destroy()
    end
    tabButtons = {}
    for idx, tabData in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.Position = UDim2.new(0, 5, 0, (idx-1)*40)
        btn.BackgroundColor3 = Color3.new(0.08, 0.08, 0.1)
        btn.BorderColor3 = Color3.new(0.4, 0.45, 0.5)
        btn.Text = tabData.name
        btn.TextColor3 = Color3.new(0.85, 0.9, 0.95)
        btn.TextSize = 14
        btn.Font = Enum.Font.SourceSansBold
        btn.Parent = TabBar
        btn.MouseButton1Click:Connect(function()
            activeTab = idx
            refreshDisplay(SearchBox.Text)
            for _, other in ipairs(tabButtons) do
                other.BackgroundColor3 = Color3.new(0.08, 0.08, 0.1)
            end
            btn.BackgroundColor3 = Color3.new(0.2, 0.25, 0.3)
        end)
        if idx == activeTab then
            btn.BackgroundColor3 = Color3.new(0.2, 0.25, 0.3)
        end
        table.insert(tabButtons, btn)
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshDisplay(SearchBox.Text)
end)

local function updateBeijingTime()
    BeijingTimeLabel.Text = os.date("%Y年%m月%d日 %H时%M分%S秒")
end
updateBeijingTime()
spawn(function()
    while true do
        wait(1)
        updateBeijingTime()
    end
end)

local dragging = false
local dragStart = Vector2.new()
local frameStart = UDim2.new()

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local handle = DragHandle.AbsolutePosition
        local size = DragHandle.AbsoluteSize
        local pos = input.Position
        if pos.X >= handle.X and pos.X <= handle.X + size.X and pos.Y >= handle.Y and pos.Y <= handle.Y + size.Y then
            dragging = true
            dragStart = pos
            frameStart = MainFrame.Position
        end
    end
end

local function onInputChanged(input)
    if dragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newX = frameStart.X.Offset + delta.X
            local newY = frameStart.Y.Offset + delta.Y
            MainFrame.Position = UDim2.new(frameStart.X.Scale, newX, frameStart.Y.Scale, newY)
        end
    end
end

local function onInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)
UserInputService.InputEnded:Connect(onInputEnded)

local function animateShow()
    if currentTween then currentTween:Cancel() end
    ScreenGui.Enabled = true
    local targetPos = UDim2.new(0.5, -400, 0.5, -250)
    local targetTrans = 0.15
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local posTween = TweenService:Create(MainFrame, tweenInfo, {Position = targetPos})
    local transTween = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = targetTrans})
    posTween:Play()
    transTween:Play()
    currentTween = posTween
    posTween.Completed:Connect(function() currentTween = nil end)
end

local function animateHide(callback)
    if currentTween then currentTween:Cancel() end
    local targetPos = UDim2.new(0.5, -400, 1, 0)
    local targetTrans = 1
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local posTween = TweenService:Create(MainFrame, tweenInfo, {Position = targetPos})
    local transTween = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = targetTrans})
    posTween:Play()
    transTween:Play()
    currentTween = posTween
    posTween.Completed:Connect(function()
        currentTween = nil
        ScreenGui.Enabled = false
        if callback then callback() end
    end)
end

function HackerLogUI.Show(animate)
    if animate == false then
        if currentTween then currentTween:Cancel() end
        MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
        MainFrame.BackgroundTransparency = 0.15
        ScreenGui.Enabled = true
    else
        animateShow()
    end
end

function HackerLogUI.Hide(animate, callback)
    if animate == false then
        if currentTween then currentTween:Cancel() end
        ScreenGui.Enabled = false
        if callback then callback() end
    else
        animateHide(callback)
    end
end

CloseButton.MouseButton1Click:Connect(function()
    HackerLogUI.Hide(true)
end)

function HackerLogUI.SetTabs(newTabs)
    tabs = newTabs
    activeTab = 1
    rebuildTabBar()
    refreshDisplay(SearchBox.Text)
end

function HackerLogUI.AddLog(tabName, logEntry, timestamp)
    for idx, tab in ipairs(tabs) do
        if tab.name == tabName then
            local timeStr = timestamp or os.date("%Y年%m月%d日 %H时%M分%S秒")
            table.insert(tabs[idx].data, timeStr .. " | " .. logEntry)
            if idx == activeTab then
                refreshDisplay(SearchBox.Text)
            end
            return true
        end
    end
    return false
end

return HackerLogUI
