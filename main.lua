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

local function AttachComponents(targetObj, targetContainer, elementTrans)
    function targetObj:AddButton(config, callback)
        local btnText = type(config) == "table" and config.Title or config
        local btnDesc = type(config) == "table" and config.Desc or nil
        local hasDesc = btnDesc and btnDesc ~= ""
        local btnHeight = hasDesc and 45 or 30

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, btnHeight)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = elementTrans
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
        btn.Text = ""
        btn.ZIndex = targetContainer.ZIndex + 1
        btn.Parent = targetContainer

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

    function targetObj:AddToggle(config, callback)
        local toggleText = type(config) == "table" and config.Title or config
        local toggleDesc = type(config) == "table" and config.Desc or nil
        local state = type(config) == "table" and config.Default or false
        local hasDesc = toggleDesc and toggleDesc ~= ""
        local toggleHeight = hasDesc and 45 or 30
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, toggleHeight)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggleFrame.BackgroundTransparency = elementTrans
        toggleFrame.BorderSizePixel = 1
        toggleFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        toggleFrame.ZIndex = targetContainer.ZIndex + 1
        toggleFrame.Parent = targetContainer

        CreateText(toggleFrame, toggleText, hasDesc and UDim2.new(1, -60, 0, 15) or UDim2.new(1, -60, 1, 0), hasDesc and UDim2.new(0, 10, 0, 8) or UDim2.new(0, 10, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)

        if hasDesc then
            CreateText(toggleFrame, toggleDesc, UDim2.new(1, -60, 0, 15), UDim2.new(0, 10, 0, 23), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left)
        end

        local toggleTrack = Instance.new("TextButton")
        toggleTrack.Size = UDim2.new(0, 36, 0, 16)
        toggleTrack.Position = UDim2.new(1, -46, 0.5, -8)
        toggleTrack.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
        toggleTrack.BorderSizePixel = 1
        toggleTrack.BorderColor3 = Color3.fromRGB(15, 15, 15)
        toggleTrack.Text = ""
        toggleTrack.ZIndex = toggleFrame.ZIndex + 1
        toggleTrack.Parent = toggleFrame

        local toggleThumb = Instance.new("Frame")
        toggleThumb.Size = UDim2.new(0, 12, 0, 12)
        toggleThumb.Position = state and UDim2.new(1, -14, 0, 2) or UDim2.new(0, 2, 0, 2)
        toggleThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleThumb.BorderSizePixel = 0
        toggleThumb.ZIndex = toggleTrack.ZIndex + 1
        toggleThumb.Parent = toggleTrack

        toggleTrack.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(toggleTrack, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
            }):Play()
            TweenService:Create(toggleThumb, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = state and UDim2.new(1, -14, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
            if callback then callback(state) end
        end)
    end

    function targetObj:AddSlider(config, callback)
        local sliderText = type(config) == "table" and config.Title or config
        local sliderDesc = type(config) == "table" and config.Desc or nil
        local minVal = type(config) == "table" and config.Min or 0
        local maxVal = type(config) == "table" and config.Max or 100
        local val = type(config) == "table" and config.Default or minVal
        local hasDesc = sliderDesc and sliderDesc ~= ""
        local sliderHeight = hasDesc and 60 or 45
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, sliderHeight)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BackgroundTransparency = elementTrans
        sliderFrame.BorderSizePixel = 1
        sliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        sliderFrame.ZIndex = targetContainer.ZIndex + 1
        sliderFrame.Parent = targetContainer

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
        sBg.ZIndex = sliderFrame.ZIndex + 1
        sBg.Parent = sliderFrame

        local sFill = Instance.new("Frame")
        sFill.Size = UDim2.new(math.clamp((val - minVal) / (maxVal - minVal), 0, 1), 0, 1, 0)
        sFill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        sFill.BorderSizePixel = 0
        sFill.ZIndex = sBg.ZIndex + 1
        sFill.Parent = sBg

        local sClickArea = Instance.new("TextButton")
        sClickArea.Size = UDim2.new(1, 0, 1, 0)
        sClickArea.BackgroundTransparency = 1
        sClickArea.Text = ""
        sClickArea.ZIndex = sBg.ZIndex + 2
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

        UserInputService.InputEnded:Connect(function(input)
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

    function targetObj:AddDivider(config)
        local divTitle = type(config) == "table" and config.Title or ""
        local divDesc = type(config) == "table" and config.Desc or nil
        local hasTitle = divTitle ~= ""
        local hasDesc = divDesc and divDesc ~= ""
        
        local divHeight = 10
        if hasTitle and hasDesc then
            divHeight = 40
        elseif hasTitle then
            divHeight = 25
        end

        local divFrame = Instance.new("Frame")
        divFrame.Size = UDim2.new(1, 0, 0, divHeight)
        divFrame.BackgroundTransparency = 1
        divFrame.ZIndex = targetContainer.ZIndex + 1
        divFrame.Parent = targetContainer

        if hasTitle then
            CreateText(divFrame, divTitle, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 0, 0), Color3.fromRGB(200, 200, 200), 12, Enum.TextXAlignment.Center)
        end
        if hasDesc then
            CreateText(divFrame, divDesc, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 0, 15), Color3.fromRGB(120, 120, 120), 10, Enum.TextXAlignment.Center)
        end

        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -40, 0, 1)
        line.Position = UDim2.new(0, 20, 1, -5)
        line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        line.BorderSizePixel = 0
        line.ZIndex = divFrame.ZIndex + 1
        line.Parent = divFrame
    end

    function targetObj:AddSection(config)
        local secTitle = type(config) == "table" and config.Title or "Section"
        local secDesc = type(config) == "table" and config.Desc or nil
        local hasDesc = secDesc and secDesc ~= ""
        local headerHeight = hasDesc and 45 or 30

        local secFrame = Instance.new("Frame")
        secFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        secFrame.BackgroundTransparency = elementTrans
        secFrame.BorderSizePixel = 1
        secFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
        secFrame.Size = UDim2.new(1, 0, 0, headerHeight)
        secFrame.ClipsDescendants = true
        secFrame.ZIndex = targetContainer.ZIndex + 1
        secFrame.Parent = targetContainer

        local secHeader = Instance.new("TextButton")
        secHeader.Size = UDim2.new(1, 0, 0, headerHeight)
        secHeader.BackgroundTransparency = 1
        secHeader.Text = ""
        secHeader.ZIndex = secFrame.ZIndex + 1
        secHeader.Parent = secFrame

        CreateText(secHeader, secTitle, hasDesc and UDim2.new(1, -40, 0, 15) or UDim2.new(1, -40, 1, 0), hasDesc and UDim2.new(0, 10, 0, 8) or UDim2.new(0, 10, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)

        if hasDesc then
            CreateText(secHeader, secDesc, UDim2.new(1, -40, 0, 15), UDim2.new(0, 10, 0, 23), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left)
        end

        local tMain, tShadow = CreateText(secHeader, "+", UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0.5, -10), Color3.fromRGB(255, 255, 255), 16, Enum.TextXAlignment.Center)

        local secContent = Instance.new("Frame")
        secContent.Size = UDim2.new(1, -16, 0, 0)
        secContent.Position = UDim2.new(0, 8, 0, headerHeight + 5)
        secContent.BackgroundTransparency = 1
        secContent.ZIndex = secFrame.ZIndex + 1
        secContent.Visible = false
        secContent.Parent = secFrame

        local secLayout = Instance.new("UIListLayout")
        secLayout.SortOrder = Enum.SortOrder.LayoutOrder
        secLayout.Padding = UDim.new(0, 8)
        secLayout.Parent = secContent

        local isExpanded = false

        local function updateSize()
            if isExpanded then
                secContent.Size = UDim2.new(1, -16, 0, secLayout.AbsoluteContentSize.Y)
                secFrame.Size = UDim2.new(1, 0, 0, headerHeight + secLayout.AbsoluteContentSize.Y + 15)
            else
                secFrame.Size = UDim2.new(1, 0, 0, headerHeight)
            end
        end

        secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

        secHeader.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            secContent.Visible = isExpanded
            tMain.Text = isExpanded and "-" or "+"
            tShadow.Text = isExpanded and "-" or "+"
            updateSize()
        end)

        local secObj = {}
        AttachComponents(secObj, secContent, elementTrans)
        return secObj
    end
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
            if isfile and writefile and readfile and getcustomasset then
                local bgCacheName = "cf_ui_bg_cache.png"
                local bgUrlName = "cf_ui_bg_url.txt"
                local lastUrl = isfile(bgUrlName) and readfile(bgUrlName) or ""
                
                if lastUrl ~= bgValue or not isfile(bgCacheName) then
                    if isfile(bgCacheName) and delfile then
                        pcall(function() delfile(bgCacheName) end)
                    end
                    local success, data = pcall(function()
                        return game:HttpGet(bgValue)
                    end)
                    if success and data then
                        writefile(bgCacheName, data)
                        writefile(bgUrlName, bgValue)
                        bgImage.Image = getcustomasset(bgCacheName)
                    end
                else
                    bgImage.Image = getcustomasset(bgCacheName)
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
            
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 150, 0, 25)
            }):Play()
            TweenService:Create(minimizeBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -25, 0, 0)
            }):Play()
            TweenService:Create(titleMain, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -30, 1, 0)
            }):Play()
            TweenService:Create(titleShadow, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -30, 1, 0)
            }):Play()
        else
            minMain.Text = "-"
            minShadow.Text = "-"
            mainFrame.BorderSizePixel = 1
            topBar.BorderSizePixel = 1
            
            local expandTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 400)
            })
            TweenService:Create(minimizeBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -50, 0, 0)
            }):Play()
            TweenService:Create(titleMain, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -60, 1, 0)
            }):Play()
            TweenService:Create(titleShadow, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
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

    local confirmOverlay = Instance.new("TextButton")
    confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
    confirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    confirmOverlay.BackgroundTransparency = 1
    confirmOverlay.Text = ""
    confirmOverlay.AutoButtonColor = false
    confirmOverlay.Visible = false
    confirmOverlay.ZIndex = 10
    confirmOverlay.Parent = screenGui

    local confirmBox = Instance.new("Frame")
    confirmBox.Size = UDim2.new(0, 300, 0, 130)
    confirmBox.Position = UDim2.new(0.5, -150, 0.5, -65)
    confirmBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    confirmBox.BorderSizePixel = 1
    confirmBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
    confirmBox.ZIndex = 11
    confirmBox.Parent = confirmOverlay

    CreateText(confirmBox, "关闭提示", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 10), Color3.fromRGB(255, 60, 60), 14, Enum.TextXAlignment.Center)
    CreateText(confirmBox, "你确定要关闭此脚本吗？需重新执行才可使用！", UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 40), Color3.fromRGB(200, 200, 200), 12, Enum.TextXAlignment.Center)

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 100, 0, 30)
    cancelBtn.Position = UDim2.new(0, 30, 1, -40)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    cancelBtn.BorderSizePixel = 1
    cancelBtn.BorderColor3 = Color3.fromRGB(0, 100, 0)
    cancelBtn.Text = ""
    cancelBtn.ZIndex = 12
    cancelBtn.Parent = confirmBox
    CreateText(cancelBtn, "取消", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Center)

    local confirmYesBtn = Instance.new("TextButton")
    confirmYesBtn.Size = UDim2.new(0, 100, 0, 30)
    confirmYesBtn.Position = UDim2.new(1, -130, 1, -40)
    confirmYesBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    confirmYesBtn.BorderSizePixel = 1
    confirmYesBtn.BorderColor3 = Color3.fromRGB(120, 20, 20)
    confirmYesBtn.Text = ""
    confirmYesBtn.ZIndex = 12
    confirmYesBtn.Parent = confirmBox
    CreateText(confirmYesBtn, "确认关闭", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Center)

    cancelBtn.MouseButton1Click:Connect(function()
        TweenService:Create(confirmOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        task.wait(0.2)
        confirmOverlay.Visible = false
    end)

    confirmYesBtn.MouseButton1Click:Connect(function()
        confirmOverlay.Visible = false
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            GroupTransparency = 1,
            Position = UDim2.new(0.5, -300, 0.8, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        confirmOverlay.Visible = true
        TweenService:Create(confirmOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
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

        containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContainer.CanvasSize = UDim2.new(0, 0, 0, containerLayout.AbsoluteContentSize.Y + 20)
        end)

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

        AttachComponents(tabObject, tabContainer, elementTrans)

        return tabObject
    end

    return windowObject
end

return CF_UI
