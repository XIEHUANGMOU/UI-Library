local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local TargetGui = (gethui and gethui()) or CoreGui

local CF_UI = {}

local function CreateText(parent, text, size, pos, color, fontSize, align)
    local shadow = Instance.new("TextLabel")
    shadow.Size = size
    shadow.Position = UDim2.new(pos.X.Scale, pos.X.Offset + 1, pos.Y.Scale, pos.Y.Offset + 1)
    shadow.BackgroundTransparency = 1
    shadow.Text = text
    shadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    shadow.TextXAlignment = align
    shadow.Font = Enum.Font.Code
    shadow.TextSize = fontSize
    shadow.ZIndex = parent.ZIndex + 1
    shadow.Parent = parent

    local main = Instance.new("TextLabel")
    main.Size = size
    main.Position = pos
    main.BackgroundTransparency = 1
    main.Text = text
    main.TextColor3 = color
    main.TextXAlignment = align
    main.Font = Enum.Font.Code
    main.TextSize = fontSize
    main.ZIndex = parent.ZIndex + 2
    main.Parent = parent

    return main, shadow
end

function CF_UI:MakeWindow(config)
    local titleText = config.Title or "CF_UI"
    local bgValue = config.Background or ""
    local hasBg = bgValue ~= ""
    
    local elementTrans = hasBg and 0.65 or 0
    local activeTrans = hasBg and 0.35 or 0

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = TargetGui

    local mainFrame = Instance.new("CanvasGroup")
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.8, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.BackgroundTransparency = hasBg and 1 or 0
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.GroupTransparency = 1
    mainFrame.Parent = screenGui

    local bgImage = nil
    local bgTint = nil
    if hasBg then
        bgImage = Instance.new("ImageLabel")
        bgImage.Size = UDim2.new(1, 0, 1, 0)
        bgImage.BackgroundTransparency = 1
        bgImage.ImageTransparency = 0
        bgImage.ScaleType = Enum.ScaleType.Crop
        bgImage.ZIndex = 0
        bgImage.Parent = mainFrame

        bgTint = Instance.new("Frame")
        bgTint.Size = UDim2.new(1, 0, 1, 0)
        bgTint.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bgTint.BackgroundTransparency = 0.4
        bgTint.BorderSizePixel = 0
        bgTint.ZIndex = 1
        bgTint.Parent = mainFrame

        if string.find(bgValue, "rbxassetid://") or string.find(bgValue, "rbxasset://") then
            bgImage.Image = bgValue
        elseif string.find(bgValue, "http") then
            if isfile and writefile and getcustomasset then
                local fileName = "cf_ui_bg_cache.png"
                local success, data = pcall(function()
                    return game:HttpGet(bgValue)
                end)
                if success and data then
                    writefile(fileName, data)
                    bgImage.Image = getcustomasset(fileName)
                end
            end
        end
    end

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 25)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    topBar.BackgroundTransparency = elementTrans
    topBar.BorderSizePixel = 1
    topBar.BorderColor3 = Color3.fromRGB(45, 45, 45)
    topBar.Active = true
    topBar.ZIndex = 2
    topBar.Parent = mainFrame

    local titleMain, titleShadow = CreateText(topBar, titleText, UDim2.new(1, -60, 1, 0), UDim2.new(0, 10, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    minimizeBtn.Position = UDim2.new(1, -50, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimizeBtn.BackgroundTransparency = elementTrans
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.ZIndex = 2
    minimizeBtn.Parent = topBar
    local minMain, minShadow = CreateText(minimizeBtn, "-", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), 16, Enum.TextXAlignment.Center)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -25, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    closeBtn.BackgroundTransparency = elementTrans
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.ZIndex = 2
    closeBtn.Parent = topBar
    CreateText(closeBtn, "X", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Center)

    local leftBar = Instance.new("ScrollingFrame")
    leftBar.Size = UDim2.new(0, 120, 1, -25)
    leftBar.Position = UDim2.new(0, 0, 0, 25)
    leftBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    leftBar.BackgroundTransparency = elementTrans
    leftBar.BorderSizePixel = 1
    leftBar.BorderColor3 = Color3.fromRGB(45, 45, 45)
    leftBar.ScrollBarThickness = 0
    leftBar.ZIndex = 2
    leftBar.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = leftBar

    local rightContainer = Instance.new("Frame")
    rightContainer.Size = UDim2.new(1, -120, 1, -25)
    rightContainer.Position = UDim2.new(0, 120, 0, 25)
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
            if bgTint then bgTint.Visible = false end
            
            minMain.Text = "+"
            minShadow.Text = "+"
            mainFrame.BorderSizePixel = 0
            topBar.BorderSizePixel = 0
            
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 150, 0, 25)
            }):Play()
            TweenService:Create(minimizeBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -25, 0, 0)
            }):Play()
            TweenService:Create(titleMain, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -30, 1, 0)
            }):Play()
            TweenService:Create(titleShadow, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -30, 1, 0)
            }):Play()
        else
            minMain.Text = "-"
            minShadow.Text = "-"
            mainFrame.BorderSizePixel = 1
            topBar.BorderSizePixel = 1
            
            local expandTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 400)
            })
            TweenService:Create(minimizeBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -50, 0, 0)
            }):Play()
            TweenService:Create(titleMain, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -60, 1, 0)
            }):Play()
            TweenService:Create(titleShadow, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -60, 1, 0)
            }):Play()
            expandTween:Play()
            
            expandTween.Completed:Connect(function()
                if not isMinimized then
                    leftBar.Visible = true
                    rightContainer.Visible = true
                    closeBtn.Visible = true
                    if bgImage then bgImage.Visible = true end
                    if bgTint then bgTint.Visible = true end
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
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        tabBtn.BackgroundTransparency = elementTrans
        tabBtn.BorderSizePixel = 1
        tabBtn.BorderColor3 = Color3.fromRGB(45, 45, 45)
        tabBtn.Text = ""
        tabBtn.ZIndex = 2
        tabBtn.Parent = leftBar

        local tMain, tShadow = CreateText(tabBtn, tabName, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(150, 150, 150), 12, Enum.TextXAlignment.Center)

        local tabContainer = Instance.new("ScrollingFrame")
        tabContainer.Size = UDim2.new(1, -16, 1, -16)
        tabContainer.Position = UDim2.new(0, 8, 0, 8)
        tabContainer.BackgroundTransparency = 1
        tabContainer.ScrollBarThickness = 2
        tabContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        tabContainer.Visible = false
        tabContainer.ZIndex = 2
        tabContainer.Parent = rightContainer

        local containerLayout = Instance.new("UIListLayout")
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        containerLayout.Padding = UDim.new(0, 8)
        containerLayout.Parent = tabContainer

        if not self.CurrentTab then
            self.CurrentTab = tabContainer
            tabContainer.Visible = true
            tMain.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabBtn.BackgroundTransparency = activeTrans
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Container.Visible = false
                t.MainText.TextColor3 = Color3.fromRGB(150, 150, 150)
                t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                t.Button.BackgroundTransparency = elementTrans
            end
            tabContainer.Visible = true
            tMain.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabBtn.BackgroundTransparency = activeTrans
            self.CurrentTab = tabContainer
        end)

        local tabObject = {
            Container = tabContainer,
            Button = tabBtn,
            MainText = tMain
        }
        table.insert(self.Tabs, tabObject)

        function tabObject:AddButton(btnConfig, callback)
            local btnText = type(btnConfig) == "table" and btnConfig.Title or btnConfig
            local btnDesc = type(btnConfig) == "table" and btnConfig.Desc or nil
            local hasDesc = btnDesc and btnDesc ~= ""
            local btnHeight = hasDesc and 45 or 30

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, btnHeight)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.BackgroundTransparency = elementTrans
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
            btn.Text = ""
            btn.ZIndex = 2
            btn.Parent = tabContainer

            CreateText(btn, btnText, hasDesc and UDim2.new(1, -20, 0, 15) or UDim2.new(1, -20, 1, 0), hasDesc and UDim2.new(0, 10, 0, 8) or UDim2.new(0, 10, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)

            if hasDesc then
                CreateText(btn, btnDesc, UDim2.new(1, -20, 0, 15), UDim2.new(0, 10, 0, 23), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left)
            end

            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                if callback then callback() end
            end)
        end

        function tabObject:AddToggle(toggleConfig, callback)
            local toggleText = type(toggleConfig) == "table" and toggleConfig.Title or toggleConfig
            local toggleDesc = type(toggleConfig) == "table" and toggleConfig.Desc or nil
            local state = type(toggleConfig) == "table" and toggleConfig.Default or false
            local hasDesc = toggleDesc and toggleDesc ~= ""
            local toggleHeight = hasDesc and 45 or 30
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, toggleHeight)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            toggleFrame.BackgroundTransparency = elementTrans
            toggleFrame.BorderSizePixel = 1
            toggleFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            toggleFrame.ZIndex = 2
            toggleFrame.Parent = tabContainer

            CreateText(toggleFrame, toggleText, hasDesc and UDim2.new(1, -40, 0, 15) or UDim2.new(1, -40, 1, 0), hasDesc and UDim2.new(0, 10, 0, 8) or UDim2.new(0, 10, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)

            if hasDesc then
                CreateText(toggleFrame, toggleDesc, UDim2.new(1, -40, 0, 15), UDim2.new(0, 10, 0, 23), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left)
            end

            local tBtn = Instance.new("TextButton")
            tBtn.Size = UDim2.new(0, 18, 0, 18)
            tBtn.Position = UDim2.new(1, -28, 0.5, -9)
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
            local sliderDesc = type(sliderConfig) == "table" and sliderConfig.Desc or nil
            local minVal = type(sliderConfig) == "table" and sliderConfig.Min or 0
            local maxVal = type(sliderConfig) == "table" and sliderConfig.Max or 100
            local val = type(sliderConfig) == "table" and sliderConfig.Default or minVal
            local hasDesc = sliderDesc and sliderDesc ~= ""
            local sliderHeight = hasDesc and 60 or 45
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, sliderHeight)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            sliderFrame.BackgroundTransparency = elementTrans
            sliderFrame.BorderSizePixel = 1
            sliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
            sliderFrame.ZIndex = 2
            sliderFrame.Parent = tabContainer

            local sMain, sShadow = CreateText(sliderFrame, sliderText .. " : " .. tostring(val), UDim2.new(1, -20, 0, 15), hasDesc and UDim2.new(0, 10, 0, 5) or UDim2.new(0, 10, 0, 8), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)

            if hasDesc then
                CreateText(sliderFrame, sliderDesc, UDim2.new(1, -20, 0, 15), UDim2.new(0, 10, 0, 20), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left)
            end

            local sBg = Instance.new("Frame")
            sBg.Size = UDim2.new(1, -20, 0, 8)
            sBg.Position = hasDesc and UDim2.new(0, 10, 0, 42) or UDim2.new(0, 10, 0, 28)
            sBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            sBg.BackgroundTransparency = elementTrans
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
                local newText = sliderText .. " : " .. tostring(val)
                sMain.Text = newText
                sShadow.Text = newText
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
