local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local TargetGui = (gethui and gethui()) or CoreGui

local CF_UI = {}

function CF_UI:MakeWindow(config)
    local titleText = config.Title or "CF_UI"
    local bgUrl = config.BackgroundUrl or ""
    local bgName = config.BackgroundName or "cf_ui_background.png"

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = TargetGui

    local mainFrame = Instance.new("CanvasGroup")
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.8, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.GroupTransparency = 1
    mainFrame.Parent = screenGui

    local bgImage = nil
    if bgUrl ~= "" and isfile and writefile and getcustomasset then
        if not isfile(bgName) then
            local success, imgData = pcall(function()
                return game:HttpGet(bgUrl)
            end)
            if success and imgData then
                writefile(bgName, imgData)
            end
        end
        if isfile(bgName) then
            bgImage = Instance.new("ImageLabel")
            bgImage.Size = UDim2.new(1, 0, 1, 0)
            bgImage.BackgroundTransparency = 1
            bgImage.Image = getcustomasset(bgName)
            bgImage.ImageTransparency = 0.8
            bgImage.ScaleType = Enum.ScaleType.Crop
            bgImage.ZIndex = 0
            bgImage.Parent = mainFrame
        end
    end

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    topBar.BorderSizePixel = 1
    topBar.BorderColor3 = Color3.fromRGB(45, 45, 45)
    topBar.Active = true
    topBar.ZIndex = 2
    topBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextSize = 14
    titleLabel.ZIndex = 2
    titleLabel.Parent = topBar

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Font = Enum.Font.Code
    minimizeBtn.TextSize = 18
    minimizeBtn.ZIndex = 2
    minimizeBtn.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 2
    closeBtn.Parent = topBar

    local leftBar = Instance.new("ScrollingFrame")
    leftBar.Size = UDim2.new(0, 140, 1, -30)
    leftBar.Position = UDim2.new(0, 0, 0, 30)
    leftBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    leftBar.BorderSizePixel = 1
    leftBar.BorderColor3 = Color3.fromRGB(45, 45, 45)
    leftBar.ScrollBarThickness = 0
    leftBar.ZIndex = 2
    leftBar.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = leftBar

    local rightContainer = Instance.new("Frame")
    rightContainer.Size = UDim2.new(1, -140, 1, -30)
    rightContainer.Position = UDim2.new(0, 140, 0, 30)
    rightContainer.BackgroundTransparency = 1
    rightContainer.ZIndex = 2
    rightContainer.Parent = mainFrame

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(mainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
    end

    topBar.InputBegan:Connect(function(input)
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

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200)
    })
    openTween:Play()

    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            leftBar.Visible = false
            rightContainer.Visible = false
            closeBtn.Visible = false
            if bgImage then bgImage.Visible = false end
            
            minimizeBtn.Text = "+"
            
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 160, 0, 30)}):Play()
            TweenService:Create(minimizeBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -30, 0, 0)}):Play()
            TweenService:Create(titleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, -40, 1, 0)}):Play()
        else
            minimizeBtn.Text = "-"
            
            local expandTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
            TweenService:Create(minimizeBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -60, 0, 0)}):Play()
            TweenService:Create(titleLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, -70, 1, 0)}):Play()
            expandTween:Play()
            
            expandTween.Completed:Connect(function()
                if not isMinimized then
                    leftBar.Visible = true
                    rightContainer.Visible = true
                    closeBtn.Visible = true
                    if bgImage then bgImage.Visible = true end
                end
            end)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            GroupTransparency = 1,
            Position = UDim2.new(0.5, -300, 0.8, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)

    local windowObject = {
        CurrentTab = nil,
        Tabs = {}
    }

    function windowObject:MakeTab(tabConfig)
        local tabName = type(tabConfig) == "table" and tabConfig.Title or "未命名"
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 40)
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        tabBtn.BorderSizePixel = 1
        tabBtn.BorderColor3 = Color3.fromRGB(45, 45, 45)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabBtn.Font = Enum.Font.Code
        tabBtn.TextSize = 14
        tabBtn.ZIndex = 2
        tabBtn.Parent = leftBar

        local tabContainer = Instance.new("ScrollingFrame")
        tabContainer.Size = UDim2.new(1, -20, 1, -20)
        tabContainer.Position = UDim2.new(0, 10, 0, 10)
        tabContainer.BackgroundTransparency = 1
        tabContainer.ScrollBarThickness = 2
        tabContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        tabContainer.Visible = false
        tabContainer.ZIndex = 2
        tabContainer.Parent = rightContainer

        local containerLayout = Instance.new("UIListLayout")
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        containerLayout.Padding = UDim.new(0, 10)
        containerLayout.Parent = tabContainer

        if not self.CurrentTab then
            self.CurrentTab = tabContainer
            tabContainer.Visible = true
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Container.Visible = false
                t.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
                t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            end
            tabContainer.Visible = true
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            self.CurrentTab = tabContainer
        end)

        local tabObject = {
            Container = tabContainer,
            Button = tabBtn
        }
        table.insert(self.Tabs, tabObject)

        function tabObject:AddButton(btnConfig, callback)
            local btnText = type(btnConfig) == "table" and btnConfig.Title or btnConfig
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
            btn.Text = btnText
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Code
            btn.TextSize = 14
            btn.ZIndex = 2
            btn.Parent = tabContainer

            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                if callback then callback() end
            end)
        end

        function tabObject:AddToggle(toggleConfig, callback)
            local toggleText = type(toggleConfig) == "table" and toggleConfig.Title or toggleConfig
            local state = type(toggleConfig) == "table" and toggleConfig.Default or false
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 40)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            toggleFrame.BorderSizePixel = 1
            toggleFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            toggleFrame.ZIndex = 2
            toggleFrame.Parent = tabContainer

            local tLabel = Instance.new("TextLabel")
            tLabel.Size = UDim2.new(1, -60, 1, 0)
            tLabel.Position = UDim2.new(0, 15, 0, 0)
            tLabel.BackgroundTransparency = 1
            tLabel.Text = toggleText
            tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            tLabel.TextXAlignment = Enum.TextXAlignment.Left
            tLabel.Font = Enum.Font.Code
            tLabel.TextSize = 14
            tLabel.ZIndex = 2
            tLabel.Parent = toggleFrame

            local tBtn = Instance.new("TextButton")
            tBtn.Size = UDim2.new(0, 24, 0, 24)
            tBtn.Position = UDim2.new(1, -40, 0.5, -12)
            tBtn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
            tBtn.BorderSizePixel = 1
            tBtn.BorderColor3 = Color3.fromRGB(15, 15, 15)
            tBtn.Text = ""
            tBtn.ZIndex = 2
            tBtn.Parent = toggleFrame

            tBtn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)}):Play()
                if callback then callback(state) end
            end)
        end

        function tabObject:AddSlider(sliderConfig, callback)
            local sliderText = type(sliderConfig) == "table" and sliderConfig.Title or sliderConfig
            local minVal = type(sliderConfig) == "table" and sliderConfig.Min or 0
            local maxVal = type(sliderConfig) == "table" and sliderConfig.Max or 100
            local val = type(sliderConfig) == "table" and sliderConfig.Default or minVal
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 55)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            sliderFrame.BorderSizePixel = 1
            sliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            sliderFrame.ZIndex = 2
            sliderFrame.Parent = tabContainer

            local sLabel = Instance.new("TextLabel")
            sLabel.Size = UDim2.new(1, -30, 0, 20)
            sLabel.Position = UDim2.new(0, 15, 0, 5)
            sLabel.BackgroundTransparency = 1
            sLabel.Text = sliderText .. " : " .. tostring(val)
            sLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sLabel.TextXAlignment = Enum.TextXAlignment.Left
            sLabel.Font = Enum.Font.Code
            sLabel.TextSize = 14
            sLabel.ZIndex = 2
            sLabel.Parent = sliderFrame

            local sBg = Instance.new("Frame")
            sBg.Size = UDim2.new(1, -30, 0, 12)
            sBg.Position = UDim2.new(0, 15, 0, 32)
            sBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            sBg.BorderSizePixel = 1
            sBg.BorderColor3 = Color3.fromRGB(10, 10, 10)
            sBg.ZIndex = 2
            sBg.Parent = sliderFrame

            local sFill = Instance.new("Frame")
            sFill.Size = UDim2.new(math.clamp((val - minVal) / (maxVal - minVal), 0, 1), 0, 1, 0)
            sFill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            sFill.BorderSizePixel = 0
            sFill.ZIndex = 2
            sFill.Parent = sBg

            local sClickArea = Instance.new("TextButton")
            sClickArea.Size = UDim2.new(1, 0, 1, 0)
            sClickArea.BackgroundTransparency = 1
            sClickArea.Text = ""
            sClickArea.ZIndex = 3
            sClickArea.Parent = sBg

            local draggingSlider = false
            local function updateSliderVal(input)
                local pos = math.clamp((input.Position.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X, 0, 1)
                val = math.floor(minVal + ((maxVal - minVal) * pos))
                sLabel.Text = sliderText .. " : " .. tostring(val)
                TweenService:Create(sFill, TweenInfo.new(0.08), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                if callback then callback(val) end
            end

            sClickArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    updateSliderVal(input)
                end
            end)

            sClickArea.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSliderVal(input)
                end
            end)
        end

        return tabObject
    end

    return windowObject
end

return CF_UI
