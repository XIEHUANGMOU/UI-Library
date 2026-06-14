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

local function AttachComponents(targetObj, targetContainer, elementTrans, windowObj, tabObj, parentSection)
    function targetObj:AddButton(config, callback)
        local btnText = type(config) == "table" and config.Title or config
        local btnDesc = type(config) == "table" and config.Desc or nil
        local keybind = type(config) == "table" and config.Keybind or false
        local hasDesc = btnDesc and btnDesc ~= ""
        local btnHeight = hasDesc and 45 or 30
        local displayTitle = keybind and (btnText .. " [" .. keybind.Name .. "]") or btnText

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, btnHeight)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = elementTrans
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
        btn.Text = ""
        btn.ZIndex = targetContainer.ZIndex + 1
        btn.Parent = targetContainer

        CreateText(btn, displayTitle, hasDesc and UDim2.new(1, -20, 0, 15) or UDim2.new(1, -20, 1, 0), hasDesc and UDim2.new(0, 10, 0, 8) or UDim2.new(0, 10, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)
        if hasDesc then CreateText(btn, btnDesc, UDim2.new(1, -20, 0, 15), UDim2.new(0, 10, 0, 23), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left) end

        table.insert(windowObj.SearchElements, {Frame = btn, Text = string.lower(tostring(btnText) .. tostring(btnDesc or "")), Tab = tabObj, Section = parentSection})

        local function triggerBtn()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            task.wait(0.1)
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            if callback then callback() end
        end

        btn.MouseButton1Click:Connect(triggerBtn)
        if keybind then
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == keybind then triggerBtn() end
            end)
        end
    end

    function targetObj:AddToggle(config, callback)
        local toggleText = type(config) == "table" and config.Title or config
        local toggleDesc = type(config) == "table" and config.Desc or nil
        local state = type(config) == "table" and config.Default or false
        local keybind = type(config) == "table" and config.Keybind or false
        local hasDesc = toggleDesc and toggleDesc ~= ""
        local toggleHeight = hasDesc and 45 or 30
        local displayTitle = keybind and (toggleText .. " [" .. keybind.Name .. "]") or toggleText
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, toggleHeight)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggleFrame.BackgroundTransparency = elementTrans
        toggleFrame.BorderSizePixel = 1
        toggleFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        toggleFrame.ZIndex = targetContainer.ZIndex + 1
        toggleFrame.Parent = targetContainer

        CreateText(toggleFrame, displayTitle, hasDesc and UDim2.new(1, -60, 0, 15) or UDim2.new(1, -60, 1, 0), hasDesc and UDim2.new(0, 10, 0, 8) or UDim2.new(0, 10, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)
        if hasDesc then CreateText(toggleFrame, toggleDesc, UDim2.new(1, -60, 0, 15), UDim2.new(0, 10, 0, 23), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left) end

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

        table.insert(windowObj.SearchElements, {Frame = toggleFrame, Text = string.lower(tostring(toggleText) .. tostring(toggleDesc or "")), Tab = tabObj, Section = parentSection})

        local function triggerToggle()
            state = not state
            TweenService:Create(toggleTrack, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(toggleThumb, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -14, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
            if callback then callback(state) end
        end

        toggleTrack.MouseButton1Click:Connect(triggerToggle)
        if keybind then
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == keybind then triggerToggle() end
            end)
        end
    end

    function targetObj:AddKeybind(config, callback)
        local kbTitle = type(config) == "table" and config.Title or "按键绑定"
        local kbDesc = type(config) == "table" and config.Desc or nil
        local currentKey = type(config) == "table" and config.Default or Enum.KeyCode.Unknown
        local hasDesc = kbDesc and kbDesc ~= ""
        local kbHeight = hasDesc and 45 or 30

        local kbFrame = Instance.new("Frame")
        kbFrame.Size = UDim2.new(1, 0, 0, kbHeight)
        kbFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        kbFrame.BackgroundTransparency = elementTrans
        kbFrame.BorderSizePixel = 1
        kbFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        kbFrame.ZIndex = targetContainer.ZIndex + 1
        kbFrame.Parent = targetContainer

        CreateText(kbFrame, kbTitle, UDim2.new(1, -80, 0, 15), hasDesc and UDim2.new(0, 10, 0, 5) or UDim2.new(0, 10, 0, 8), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)
        if hasDesc then CreateText(kbFrame, kbDesc, UDim2.new(1, -80, 0, 15), UDim2.new(0, 10, 0, 20), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left) end

        local kbBtn = Instance.new("TextButton")
        kbBtn.Size = UDim2.new(0, 60, 0, 20)
        kbBtn.Position = UDim2.new(1, -70, 0.5, -10)
        kbBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        kbBtn.BackgroundTransparency = elementTrans
        kbBtn.BorderSizePixel = 1
        kbBtn.BorderColor3 = Color3.fromRGB(10, 10, 10)
        kbBtn.Text = ""
        kbBtn.ZIndex = kbFrame.ZIndex + 1
        kbBtn.Parent = kbFrame

        local keyName = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
        local btnMain, btnShadow = CreateText(kbBtn, keyName, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(200, 200, 200), 12, Enum.TextXAlignment.Center)

        local isBinding = false

        kbBtn.MouseButton1Click:Connect(function()
            isBinding = true
            btnMain.Text = "..."
            btnShadow.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if isBinding then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    local kName = currentKey.Name
                    btnMain.Text = kName
                    btnShadow.Text = kName
                    isBinding = false
                    if callback then callback(currentKey) end
                end
            elseif not gpe and input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
                if callback then callback(currentKey) end
            end
        end)

        table.insert(windowObj.SearchElements, {Frame = kbFrame, Text = string.lower(tostring(kbTitle) .. tostring(kbDesc or "")), Tab = tabObj, Section = parentSection})
    end

    function targetObj:AddSlider(config, callback)
        local sliderText = type(config) == "table" and config.Title or config
        local sliderDesc = type(config) == "table" and config.Desc or nil
        local minVal = type(config) == "table" and config.Min or 0
        local maxVal = type(config) == "table" and config.Max or 100
        local val = type(config) == "table" and config.Default or minVal
        local keybind = type(config) == "table" and config.Keybind or false
        local hasDesc = sliderDesc and sliderDesc ~= ""
        local sliderHeight = hasDesc and 60 or 45
        local displayTitle = keybind and (sliderText .. " [" .. keybind.Name .. "] : " .. tostring(val)) or (sliderText .. " : " .. tostring(val))
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, sliderHeight)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BackgroundTransparency = elementTrans
        sliderFrame.BorderSizePixel = 1
        sliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        sliderFrame.ZIndex = targetContainer.ZIndex + 1
        sliderFrame.Parent = targetContainer

        local sMain, sShadow = CreateText(sliderFrame, displayTitle, UDim2.new(1, -20, 0, 15), hasDesc and UDim2.new(0, 10, 0, 5) or UDim2.new(0, 10, 0, 8), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)
        if hasDesc then CreateText(sliderFrame, sliderDesc, UDim2.new(1, -20, 0, 15), UDim2.new(0, 10, 0, 20), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left) end

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

        table.insert(windowObj.SearchElements, {Frame = sliderFrame, Text = string.lower(tostring(sliderText) .. tostring(sliderDesc or "")), Tab = tabObj, Section = parentSection})

        local draggingSlider = false

        local function updateSliderVal(input)
            local pos = math.clamp((input.Position.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X, 0, 1)
            val = math.floor(minVal + ((maxVal - minVal) * pos))
            local newText = keybind and (sliderText .. " [" .. keybind.Name .. "] : " .. tostring(val)) or (sliderText .. " : " .. tostring(val))
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSliderVal(input) end
        end)

        if keybind then
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == keybind then if callback then callback(val) end end
            end)
        end
    end

    function targetObj:AddDivider(config)
        local divTitle = type(config) == "table" and config.Title or ""
        local divDesc = type(config) == "table" and config.Desc or nil
        local hasTitle = divTitle ~= ""
        local hasDesc = divDesc and divDesc ~= ""
        
        local divHeight = 10
        if hasTitle and hasDesc then divHeight = 40 elseif hasTitle then divHeight = 25 end

        local divFrame = Instance.new("Frame")
        divFrame.Size = UDim2.new(1, 0, 0, divHeight)
        divFrame.BackgroundTransparency = 1
        divFrame.ZIndex = targetContainer.ZIndex + 1
        divFrame.Parent = targetContainer

        if hasTitle then CreateText(divFrame, divTitle, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 0, 0), Color3.fromRGB(200, 200, 200), 12, Enum.TextXAlignment.Center) end
        if hasDesc then CreateText(divFrame, divDesc, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 0, 15), Color3.fromRGB(120, 120, 120), 10, Enum.TextXAlignment.Center) end

        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -40, 0, 1)
        line.Position = UDim2.new(0, 20, 1, -5)
        line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        line.BorderSizePixel = 0
        line.ZIndex = divFrame.ZIndex + 1
        line.Parent = divFrame
    end

    function targetObj:AddInput(config)
        local inputTitle = type(config) == "table" and config.Title or "输入框"
        local inputDesc = type(config) == "table" and config.Desc or nil
        local inputType = type(config) == "table" and config.Type or "Default"
        local placeholder = type(config) == "table" and config.Placeholder or ""
        local keybind = type(config) == "table" and config.Keybind or false
        local callback = type(config) == "table" and config.Callback or function() end
        local hasDesc = inputDesc and inputDesc ~= ""
        local inputHeight = hasDesc and 65 or 50
        if inputType == "Textarea" then inputHeight = inputHeight + 40 end
        local displayTitle = keybind and (inputTitle .. " [" .. keybind.Name .. "]") or inputTitle

        local inputFrame = Instance.new("Frame")
        inputFrame.Size = UDim2.new(1, 0, 0, inputHeight)
        inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        inputFrame.BackgroundTransparency = elementTrans
        inputFrame.BorderSizePixel = 1
        inputFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        inputFrame.ZIndex = targetContainer.ZIndex + 1
        inputFrame.Parent = targetContainer

        CreateText(inputFrame, displayTitle, UDim2.new(1, -20, 0, 15), hasDesc and UDim2.new(0, 10, 0, 5) or UDim2.new(0, 10, 0, 8), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)
        if hasDesc then CreateText(inputFrame, inputDesc, UDim2.new(1, -20, 0, 15), UDim2.new(0, 10, 0, 20), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left) end

        local boxBg = Instance.new("Frame")
        boxBg.Size = inputType == "Textarea" and UDim2.new(1, -20, 0, 60) or UDim2.new(1, -20, 0, 25)
        boxBg.Position = hasDesc and UDim2.new(0, 10, 0, 38) or UDim2.new(0, 10, 0, 22)
        boxBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        boxBg.BackgroundTransparency = elementTrans
        boxBg.BorderSizePixel = 1
        boxBg.BorderColor3 = Color3.fromRGB(10, 10, 10)
        boxBg.ZIndex = inputFrame.ZIndex + 1
        boxBg.Parent = inputFrame

        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -10, 1, -4)
        textBox.Position = UDim2.new(0, 5, 0, 2)
        textBox.BackgroundTransparency = 1
        textBox.Text = ""
        textBox.PlaceholderText = placeholder
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        textBox.Font = Enum.Font.Code
        textBox.TextSize = 12
        textBox.TextXAlignment = Enum.TextXAlignment.Left
        textBox.TextYAlignment = inputType == "Textarea" and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
        textBox.ClearTextOnFocus = false
        textBox.MultiLine = inputType == "Textarea"
        textBox.TextWrapped = true
        textBox.ZIndex = boxBg.ZIndex + 1
        textBox.Parent = boxBg

        table.insert(windowObj.SearchElements, {Frame = inputFrame, Text = string.lower(tostring(inputTitle) .. tostring(inputDesc or "")), Tab = tabObj, Section = parentSection})

        textBox.FocusLost:Connect(function() callback(textBox.Text) end)
        if keybind then
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == keybind then callback(textBox.Text) end
            end)
        end
    end

    function targetObj:AddDropdown(config)
        local dropTitle = type(config) == "table" and config.Title or "下拉列表"
        local dropValues = type(config) == "table" and config.Values or {}
        local dropValue = type(config) == "table" and config.Value or nil
        local isMulti = type(config) == "table" and config.Multi or false
        local searchEnabled = type(config) == "table" and config.SearchBarEnabled or false
        local keybind = type(config) == "table" and config.Keybind or false
        local callback = type(config) == "table" and config.Callback or function() end
        local displayTitle = keybind and (dropTitle .. " [" .. keybind.Name .. "]") or dropTitle
        
        local selectedValues = isMulti and (type(dropValue) == "table" and dropValue or {}) or (dropValue and {dropValue} or {})
        if not isMulti and #selectedValues == 0 and #dropValues > 0 then selectedValues = {dropValues[1]} end

        local function getSelectedText()
            if #selectedValues == 0 then return "未选择" end
            return table.concat(selectedValues, ", ")
        end

        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(1, 0, 0, 45)
        dropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        dropFrame.BackgroundTransparency = elementTrans
        dropFrame.BorderSizePixel = 1
        dropFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        dropFrame.ClipsDescendants = true
        dropFrame.ZIndex = targetContainer.ZIndex + 1
        dropFrame.Parent = targetContainer

        CreateText(dropFrame, displayTitle, UDim2.new(1, -20, 0, 15), UDim2.new(0, 10, 0, 5), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Left)

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(1, -20, 0, 20)
        dropBtn.Position = UDim2.new(0, 10, 0, 20)
        dropBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        dropBtn.BackgroundTransparency = elementTrans
        dropBtn.BorderSizePixel = 1
        dropBtn.BorderColor3 = Color3.fromRGB(10, 10, 10)
        dropBtn.Text = ""
        dropBtn.ZIndex = dropFrame.ZIndex + 1
        dropBtn.Parent = dropFrame

        local valMain, valShadow = CreateText(dropBtn, getSelectedText(), UDim2.new(1, -25, 1, 0), UDim2.new(0, 5, 0, 0), Color3.fromRGB(200, 200, 200), 12, Enum.TextXAlignment.Left)
        valMain.TextTruncate = Enum.TextTruncate.AtEnd
        valShadow.TextTruncate = Enum.TextTruncate.AtEnd

        local arrowMain, arrowShadow = CreateText(dropBtn, "v", UDim2.new(0, 20, 1, 0), UDim2.new(1, -20, 0, 0), Color3.fromRGB(200, 200, 200), 12, Enum.TextXAlignment.Center)

        local listWrapper = Instance.new("Frame")
        listWrapper.Size = UDim2.new(1, -20, 0, 0)
        listWrapper.Position = UDim2.new(0, 10, 0, 45)
        listWrapper.BackgroundTransparency = 1
        listWrapper.ClipsDescendants = true
        listWrapper.ZIndex = dropFrame.ZIndex + 4
        listWrapper.Visible = false
        listWrapper.Parent = dropFrame

        local listFrame = Instance.new("ScrollingFrame")
        listFrame.Size = UDim2.new(1, 0, 1, 0)
        listFrame.Position = UDim2.new(0, 0, 0, 0)
        listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        listFrame.BackgroundTransparency = elementTrans
        listFrame.BorderSizePixel = 1
        listFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        listFrame.ScrollBarThickness = 2
        listFrame.ZIndex = listWrapper.ZIndex + 1
        listFrame.Parent = listWrapper

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = listFrame

        local searchBox = nil
        if searchEnabled then
            searchBox = Instance.new("TextBox")
            searchBox.Size = UDim2.new(1, 0, 0, 25)
            searchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            searchBox.BackgroundTransparency = elementTrans
            searchBox.BorderSizePixel = 1
            searchBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
            searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            searchBox.PlaceholderText = " 搜索..."
            searchBox.Text = ""
            searchBox.Font = Enum.Font.Code
            searchBox.TextSize = 12
            searchBox.TextXAlignment = Enum.TextXAlignment.Left
            searchBox.LayoutOrder = -1
            searchBox.ZIndex = listFrame.ZIndex + 1
            searchBox.Parent = listFrame
        end

        table.insert(windowObj.SearchElements, {Frame = dropFrame, Text = string.lower(tostring(dropTitle)), Tab = tabObj, Section = parentSection})

        local isExpanded = false

        local function refreshList(filterText)
            filterText = filterText and string.lower(filterText) or ""
            for _, child in pairs(listFrame:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            
            local ySize = searchEnabled and 25 or 0

            for _, val in pairs(dropValues) do
                if filterText == "" or string.find(string.lower(val), filterText) then
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, 0, 0, 25)
                    itemBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    itemBtn.BackgroundTransparency = elementTrans
                    itemBtn.BorderSizePixel = 0
                    itemBtn.Text = ""
                    itemBtn.ZIndex = listFrame.ZIndex + 1
                    itemBtn.Parent = listFrame

                    local isSelected = table.find(selectedValues, val) ~= nil
                    local cColor = isSelected and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 200, 200)

                    local tM, tS = CreateText(itemBtn, " " .. val, UDim2.new(1, -10, 1, 0), UDim2.new(0, 0, 0, 0), cColor, 12, Enum.TextXAlignment.Left)
                    
                    itemBtn.MouseButton1Click:Connect(function()
                        if isMulti then
                            local idx = table.find(selectedValues, val)
                            if idx then
                                table.remove(selectedValues, idx)
                                tM.TextColor3 = Color3.fromRGB(200, 200, 200)
                            else
                                table.insert(selectedValues, val)
                                tM.TextColor3 = Color3.fromRGB(0, 180, 0)
                            end
                            valMain.Text = getSelectedText()
                            valShadow.Text = getSelectedText()
                            callback(selectedValues)
                        else
                            selectedValues = {val}
                            valMain.Text = getSelectedText()
                            valShadow.Text = getSelectedText()
                            isExpanded = false
                            arrowMain.Text = "v"
                            arrowShadow.Text = "v"
                            
                            local shrinkList = TweenService:Create(listWrapper, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 0)})
                            shrinkList:Play()
                            TweenService:Create(dropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                            
                            shrinkList.Completed:Connect(function()
                                if not isExpanded then listWrapper.Visible = false end
                            end)
                            
                            refreshList("")
                            if searchBox then searchBox.Text = "" end
                            callback(selectedValues[1])
                        end
                    end)
                    ySize = ySize + 25
                end
            end
            listFrame.CanvasSize = UDim2.new(0, 0, 0, ySize)
            return math.clamp(ySize, 0, 120)
        end

        if searchBox then
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local h = refreshList(searchBox.Text)
                if isExpanded then
                    TweenService:Create(listWrapper, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, h)}):Play()
                    TweenService:Create(dropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 45 + h + 5)}):Play()
                end
            end)
        end

        dropBtn.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            arrowMain.Text = isExpanded and "^" or "v"
            arrowShadow.Text = isExpanded and "^" or "v"
            
            if isExpanded then
                listWrapper.Visible = true
                local h = refreshList(searchBox and searchBox.Text or "")
                
                TweenService:Create(listWrapper, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, h)}):Play()
                TweenService:Create(dropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 45 + h + 5)}):Play()
            else
                local shrinkList = TweenService:Create(listWrapper, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 0)})
                shrinkList:Play()
                TweenService:Create(dropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                
                shrinkList.Completed:Connect(function()
                    if not isExpanded then listWrapper.Visible = false end
                end)
            end
        end)
        
        if not isMulti and #selectedValues > 0 then task.spawn(function() callback(selectedValues[1]) end)
        elseif isMulti and #selectedValues > 0 then task.spawn(function() callback(selectedValues) end) end

        if keybind then
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == keybind then
                    if isMulti then callback(selectedValues) else callback(selectedValues[1]) end
                end
            end)
        end
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
        if hasDesc then CreateText(secHeader, secDesc, UDim2.new(1, -40, 0, 15), UDim2.new(0, 10, 0, 23), Color3.fromRGB(150, 150, 150), 10, Enum.TextXAlignment.Left) end

        local tMain, tShadow = CreateText(secHeader, "+", UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0.5, -10), Color3.fromRGB(255, 255, 255), 16, Enum.TextXAlignment.Center)

        local secContent = Instance.new("Frame")
        secContent.Size = UDim2.new(1, -16, 0, 0)
        secContent.Position = UDim2.new(0, 8, 0, headerHeight + 5)
        secContent.BackgroundTransparency = 1
        secContent.ClipsDescendants = true
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
                TweenService:Create(secFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, headerHeight + secLayout.AbsoluteContentSize.Y + 15)}):Play()
            else
                TweenService:Create(secFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, headerHeight)}):Play()
            end
        end

        secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if isExpanded then updateSize() end
        end)

        local secObj = {
            Frame = secFrame,
            SetExpanded = function(state)
                isExpanded = state
                tMain.Text = isExpanded and "-" or "+"
                tShadow.Text = isExpanded and "-" or "+"
                if isExpanded then
                    secContent.Visible = true
                    updateSize()
                else
                    updateSize()
                    task.delay(0.4, function() if not isExpanded then secContent.Visible = false end end)
                end
            end
        }

        table.insert(windowObj.SearchElements, {Frame = secFrame, Text = string.lower(tostring(secTitle) .. tostring(secDesc or "")), Tab = tabObj, IsSection = true, SectionObj = secObj})

        secHeader.MouseButton1Click:Connect(function() secObj.SetExpanded(not isExpanded) end)

        AttachComponents(secObj, secContent, elementTrans, windowObj, tabObj, secObj)
        return secObj
    end
end

function CF_UI:MakeWindow(config)
    local titleText = config.Title or "CF_UI"
    local subTitleText = config.Subtitle or ""
    local bgValue = config.Background or ""
    local iconUrl = config.Icon or ""
    local useRainbow = config.RainbowBorder or false
    local dpi = config.DPI or 1 
    local defaultSize = config.Size or UDim2.new(0, 600, 0, 400) 
    local toggleKey = config.Keybind or false
    
    local hasBg = bgValue ~= ""
    local elementTrans = hasBg and 0.65 or 0
    local activeTrans = hasBg and 0.35 or 0

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 2147483647   
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = TargetGui

    local mainFrame = Instance.new("CanvasGroup")
    mainFrame.Size = defaultSize 
    mainFrame.Position = UDim2.new(0.5, -300, 1, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.BackgroundTransparency = hasBg and 1 or 0
    mainFrame.BorderSizePixel = useRainbow and 0 or 1
    mainFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.GroupTransparency = 1
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local uiScale = Instance.new("UIScale")    
    uiScale.Scale = dpi    
    uiScale.Parent = mainFrame          
    local currentExpandedSize = defaultSize

    if useRainbow then
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = 1.25
        uiStroke.Color = Color3.fromRGB(255, 255, 255)
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Parent = mainFrame

        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),    
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 127, 0)),  
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),  
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),    
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),    
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(139, 0, 255)), 
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
        })
        uiGradient.Parent = uiStroke

        local RunService = game:GetService("RunService")
        local rot = 0
        local connection
        connection = RunService.RenderStepped:Connect(function(dt)
            if not uiGradient.Parent then 
                connection:Disconnect()
                return 
            end
            rot = (rot + dt * 50) % 360 
            uiGradient.Rotation = rot
        end)
    end


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
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    topBar.BackgroundTransparency = elementTrans
    topBar.BorderSizePixel = 1
    topBar.BorderColor3 = Color3.fromRGB(45, 45, 45)
    topBar.Active = true
    topBar.ZIndex = 2
        topBar.Parent = mainFrame

    local textOffsetX = 12
    if iconUrl ~= "" then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Size = UDim2.new(0, 35, 0, 35) 
        iconImg.Position = UDim2.new(0, 0, 0, 0) 
        iconImg.BackgroundTransparency = 1
        iconImg.ScaleType = Enum.ScaleType.Crop 
        iconImg.ZIndex = topBar.ZIndex + 1
        iconImg.Parent = topBar
        textOffsetX = 45 
        if string.find(iconUrl, "rbxassetid://") or string.find(iconUrl, "rbxasset://") then
            iconImg.Image = iconUrl
        elseif string.find(iconUrl, "http") then
            if isfile and writefile and readfile and getcustomasset then
                local iconCacheName = "cf_ui_icon_cache.png"
                local success, data = pcall(function() return game:HttpGet(iconUrl) end)
                if success and data then
                    writefile(iconCacheName, data)
                    iconImg.Image = getcustomasset(iconCacheName)
                end
            end
        end
    end

    local titleMain, titleShadow
    if subTitleText ~= "" then
        titleMain, titleShadow = CreateText(topBar, titleText, UDim2.new(1, -80, 0, 18), UDim2.new(0, textOffsetX, 0, 2), Color3.fromRGB(255, 255, 255), 13, Enum.TextXAlignment.Left)
        CreateText(topBar, subTitleText, UDim2.new(1, -80, 0, 15), UDim2.new(0, textOffsetX, 0, 18), Color3.fromRGB(160, 160, 160), 10, Enum.TextXAlignment.Left)
    else
        titleMain, titleShadow = CreateText(topBar, titleText, UDim2.new(1, -80, 1, 0), UDim2.new(0, textOffsetX, 0, 0), Color3.fromRGB(255, 255, 255), 13, Enum.TextXAlignment.Left)
    end

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimizeBtn.BackgroundTransparency = elementTrans
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.ZIndex = 2
    minimizeBtn.Parent = topBar

    local minIcon = Instance.new("ImageLabel")
    minIcon.Size = UDim2.new(0, 16, 0, 16)
    minIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    minIcon.BackgroundTransparency = 1
    minIcon.Image = "rbxassetid://10734896206"
    minIcon.ScaleType = Enum.ScaleType.Fit
    minIcon.ZIndex = 3
    minIcon.Parent = minimizeBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    closeBtn.BackgroundTransparency = elementTrans
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.ZIndex = 2
    closeBtn.Parent = topBar

    local closeIcon = Instance.new("ImageLabel")
    closeIcon.Size = UDim2.new(0, 16, 0, 16)
    closeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    closeIcon.BackgroundTransparency = 1
    closeIcon.Image = "rbxassetid://10747384394"
    closeIcon.ScaleType = Enum.ScaleType.Fit
    closeIcon.ZIndex = 3
    closeIcon.Parent = closeBtn

    local searchContainer = Instance.new("Frame")
    searchContainer.Size = UDim2.new(0, 120, 0, 30)
    searchContainer.Position = UDim2.new(0, 0, 0, 35)
    searchContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    searchContainer.BackgroundTransparency = elementTrans
    searchContainer.BorderSizePixel = 1
    searchContainer.BorderColor3 = Color3.fromRGB(45, 45, 45)
    searchContainer.ZIndex = 2
    searchContainer.Parent = mainFrame

    local searchInput = Instance.new("TextBox")
    searchInput.Size = UDim2.new(1, -30, 1, 0)
    searchInput.Position = UDim2.new(0, 5, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.Text = ""
    searchInput.PlaceholderText = "搜索..."
    searchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchInput.Font = Enum.Font.Code
    searchInput.TextSize = 12
    searchInput.TextXAlignment = Enum.TextXAlignment.Left
    searchInput.ClearTextOnFocus = false
    searchInput.ZIndex = 3
    searchInput.Parent = searchContainer

    local searchBtn = Instance.new("TextButton")
    searchBtn.Size = UDim2.new(0, 30, 0, 30)
    searchBtn.Position = UDim2.new(1, -30, 0, 0)
    searchBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    searchBtn.BackgroundTransparency = elementTrans
    searchBtn.BorderSizePixel = 1
    searchBtn.BorderColor3 = Color3.fromRGB(45, 45, 45)
    searchBtn.Text = ""
    searchBtn.ZIndex = 3
    searchBtn.Parent = searchContainer

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.new(0, 16, 0, 16)
    searchIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    searchIcon.BackgroundTransparency = 1
    searchIcon.ScaleType = Enum.ScaleType.Fit
    searchIcon.ZIndex = 4
    searchIcon.Parent = searchBtn

    task.spawn(function()
        local iconUrl = "https://raw.githubusercontent.com/XIEHUANGMOU/UI_Icon/main/Search_Icon.png"
        if isfile and writefile and getcustomasset then
            local iconHash = "cf_search_icon.png"
            if not isfile(iconHash) then
                pcall(function() writefile(iconHash, game:HttpGet(iconUrl)) end)
            end
            if isfile(iconHash) then
                searchIcon.Image = getcustomasset(iconHash)
            end
        end
    end)

    local leftBar = Instance.new("ScrollingFrame")
    leftBar.Size = UDim2.new(0, 120, 1, -65)
    leftBar.Position = UDim2.new(0, 0, 0, 65)
    leftBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    leftBar.BackgroundTransparency = elementTrans
    leftBar.BorderSizePixel = 1
    leftBar.BorderColor3 = Color3.fromRGB(45, 45, 45)
    leftBar.ScrollBarThickness = 0
    leftBar.ZIndex = 2
    leftBar.ClipsDescendants = true
    leftBar.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = leftBar

    local rightContainer = Instance.new("Frame")
    rightContainer.Size = UDim2.new(1, -120, 1, -35)
    rightContainer.Position = UDim2.new(0, 120, 0, 35)
    rightContainer.BackgroundTransparency = 1
    rightContainer.ZIndex = 2
    rightContainer.ClipsDescendants = true
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

    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, 0, 1, 0)
    resizeHandle.AnchorPoint = Vector2.new(1, 1)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Text = "◢"
    resizeHandle.TextColor3 = Color3.fromRGB(150, 150, 150)
    resizeHandle.TextSize = 14
    resizeHandle.ZIndex = 10
    resizeHandle.Parent = mainFrame

    local resizing = false
    local resizeStartPos
    local resizeStartSize

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStartPos = input.Position
            resizeStartSize = mainFrame.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStartPos
            local newWidth = math.clamp(resizeStartSize.X.Offset + (delta.X / dpi), 400, 1200)
            local newHeight = math.clamp(resizeStartSize.Y.Offset + (delta.Y / dpi), 250, 800)
            
            mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            currentExpandedSize = mainFrame.Size
        end
    end)

    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200)
    })
    openTween:Play()

    local isMinimized = false
      local function ToggleWindowVisibility()
        isMinimized = not isMinimized
        if isMinimized then
            minIcon.Image = "rbxassetid://10734924532" 
            mainFrame.BorderSizePixel = 0
            topBar.BorderSizePixel = 0
            resizeHandle.Visible = false 
            
            local shrinkTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 180, 0, 35)
            })
            shrinkTween:Play()
            
            TweenService:Create(topBar, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            TweenService:Create(minimizeBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -35, 0, 0), BackgroundTransparency = 0}):Play()
            
            TweenService:Create(closeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            for _, v in pairs(closeBtn:GetChildren()) do
                if v:IsA("ImageLabel") then TweenService:Create(v, TweenInfo.new(0.3), {ImageTransparency = 1}):Play() end
            end
            
            TweenService:Create(searchContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            TweenService:Create(searchBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            TweenService:Create(searchInput, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            if searchIcon then TweenService:Create(searchIcon, TweenInfo.new(0.3), {ImageTransparency = 1}):Play() end

            if bgImage then TweenService:Create(bgImage, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play() end
            if bgTint then TweenService:Create(bgTint, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play() end
            TweenService:Create(leftBar, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            
            shrinkTween.Completed:Connect(function()
                if isMinimized then
                    leftBar.Visible = false
                    rightContainer.Visible = false
                    closeBtn.Visible = false
                    searchContainer.Visible = false
                    if bgImage then bgImage.Visible = false end
                    if bgTint then bgTint.Visible = false end
                end
            end)
        else
            minIcon.Image = "rbxassetid://10734896206" 
            mainFrame.BorderSizePixel = 1
            topBar.BorderSizePixel = 1
            resizeHandle.Visible = true 
            
            leftBar.Visible = true
            rightContainer.Visible = true
            closeBtn.Visible = true
            searchContainer.Visible = true
            if bgImage then bgImage.Visible = true end
            if bgTint then bgTint.Visible = true end
            
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = currentExpandedSize 
            }):Play()
            
            TweenService:Create(topBar, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = elementTrans}):Play()
            TweenService:Create(minimizeBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -70, 0, 0), BackgroundTransparency = elementTrans}):Play()
            
            TweenService:Create(closeBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = elementTrans}):Play()
            for _, v in pairs(closeBtn:GetChildren()) do
                if v:IsA("ImageLabel") then TweenService:Create(v, TweenInfo.new(0.6), {ImageTransparency = 0}):Play() end
            end
            
            TweenService:Create(searchContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = elementTrans}):Play()
            TweenService:Create(searchBtn, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = elementTrans}):Play()
            TweenService:Create(searchInput, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
            if searchIcon then TweenService:Create(searchIcon, TweenInfo.new(0.6), {ImageTransparency = 0}):Play() end

            if bgImage then TweenService:Create(bgImage, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play() end
            if bgTint then TweenService:Create(bgTint, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.4}):Play() end
            TweenService:Create(leftBar, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = elementTrans}):Play()
        end
    end

    minimizeBtn.MouseButton1Click:Connect(ToggleWindowVisibility)

    if toggleKey then
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == toggleKey then
                ToggleWindowVisibility()
            end
        end)
    end

      local confirmOverlay = Instance.new("TextButton")
    confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
    confirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    confirmOverlay.BackgroundTransparency = 1
    confirmOverlay.Text = ""
    confirmOverlay.AutoButtonColor = false
    confirmOverlay.Visible = false
    confirmOverlay.ZIndex = 100
    confirmOverlay.Parent = mainFrame
    local confirmBox = Instance.new("Frame")
    confirmBox.Size = UDim2.new(0, 300, 0, 130)
    confirmBox.Position = UDim2.new(0.5, -150, 0.5, -65)
    confirmBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    confirmBox.BorderSizePixel = 1
    confirmBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
    confirmBox.ZIndex = 101
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
    cancelBtn.ZIndex = 102
    cancelBtn.Parent = confirmBox
    CreateText(cancelBtn, "取消", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Center)

    local confirmYesBtn = Instance.new("TextButton")
    confirmYesBtn.Size = UDim2.new(0, 100, 0, 30)
    confirmYesBtn.Position = UDim2.new(1, -130, 1, -40)
    confirmYesBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    confirmYesBtn.BorderSizePixel = 1
    confirmYesBtn.BorderColor3 = Color3.fromRGB(120, 20, 20)
    confirmYesBtn.Text = ""
    confirmYesBtn.ZIndex = 102
    confirmYesBtn.Parent = confirmBox
    CreateText(confirmYesBtn, "确认关闭", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(255, 255, 255), 12, Enum.TextXAlignment.Center)     cancelBtn.MouseEnter:Connect(function() TweenService:Create(cancelBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0, 190, 0)}):Play() end)
    cancelBtn.MouseLeave:Connect(function() TweenService:Create(cancelBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0, 150, 0)}):Play() end)

    confirmYesBtn.MouseEnter:Connect(function() TweenService:Create(confirmYesBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play() end)
    confirmYesBtn.MouseLeave:Connect(function() TweenService:Create(confirmYesBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play() end)

    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(200, 40, 40)}):Play() end)
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play() end)

    minimizeBtn.MouseEnter:Connect(function() TweenService:Create(minimizeBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play() end)
    minimizeBtn.MouseLeave:Connect(function() 
        local targetTrans = isMinimized and 0 or elementTrans
        TweenService:Create(minimizeBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = targetTrans, BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play() 
    end)
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
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -300, 0.5, -200)
        }):Play()
        confirmOverlay.Visible = true
        TweenService:Create(confirmOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
    end)

        local windowObject = {
        CurrentTab = nil,
        Tabs = {},
        SearchElements = {}
    }

    local function executeSearch()
        local query = string.lower(searchInput.Text)
        
        if query == "" then
            for _, tab in pairs(windowObject.Tabs) do
                tab.Button.Visible = true
            end
            for _, elem in pairs(windowObject.SearchElements) do
                elem.Frame.Visible = true
            end
            if windowObject.CurrentTab then
                for _, t in pairs(windowObject.Tabs) do
                    t.Container.Visible = (t.Container == windowObject.CurrentTab)
                end
            end
            return
        end

        for _, tab in pairs(windowObject.Tabs) do
            tab.Button.Visible = false
            tab.Container.Visible = false
        end
        for _, elem in pairs(windowObject.SearchElements) do
            elem.Frame.Visible = false
        end

        local firstMatchTab = nil

        for _, elem in pairs(windowObject.SearchElements) do
            if string.find(elem.Text, query) then
                elem.Frame.Visible = true
                elem.Tab.Button.Visible = true
                
                if elem.Section then
                    elem.Section.Frame.Visible = true
                    elem.Section.SectionObj.SetExpanded(true)
                end
                
                if not firstMatchTab then
                    firstMatchTab = elem.Tab
                end
            end
        end

        if firstMatchTab then
            for _, t in pairs(windowObject.Tabs) do
                if t == firstMatchTab then
                    t.Container.Visible = true
                    t.MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    t.Button.BackgroundTransparency = activeTrans
                    windowObject.CurrentTab = t.Container
                else
                    t.Container.Visible = false
                    t.MainText.TextColor3 = Color3.fromRGB(150, 150, 150)
                    t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                    t.Button.BackgroundTransparency = elementTrans
                end
            end
        end
    end

    searchBtn.MouseButton1Click:Connect(executeSearch)
    searchInput.FocusLost:Connect(executeSearch)

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
        tabContainer.ClipsDescendants = true
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
        tabBtn.MouseEnter:Connect(function()
            if self.CurrentTab ~= tabContainer then
                TweenService:Create(tabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self.CurrentTab ~= tabContainer then
                TweenService:Create(tabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
            end
        end)
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

       AttachComponents(tabObject, tabContainer, elementTrans, windowObject, tabObject, nil)
        return tabObject
    end

    return windowObject
end
local notifyContainer = nil

function CF_UI:Notify(config)
    local title = type(config) == "table" and config.Title or "通知"
    local content = type(config) == "table" and config.Content or ""
    local iconUrl = type(config) == "table" and config.Icon or ""
    local duration = type(config) == "table" and config.Duration or 3
    local soundUrl = type(config) == "table" and config.Sound or ""

    if not notifyContainer then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = HttpService:GenerateGUID(false)
        screenGui.DisplayOrder = 2147483647
        screenGui.ResetOnSpawn = false
        screenGui.Parent = TargetGui

        notifyContainer = Instance.new("Frame")
        notifyContainer.Size = UDim2.new(0, 300, 1, -40)
        notifyContainer.Position = UDim2.new(1, -320, 0, 20)
        notifyContainer.BackgroundTransparency = 1
        notifyContainer.Parent = screenGui

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        listLayout.Padding = UDim.new(0, 10)
        listLayout.Parent = notifyContainer
    end

    if soundUrl ~= "" then
        task.spawn(function()
            local sound = Instance.new("Sound")
            sound.Parent = game:GetService("SoundService")
            sound.Volume = 1
            if string.find(soundUrl, "rbxasset") then
                sound.SoundId = soundUrl
                sound:Play()
            elseif string.find(soundUrl, "http") then
                if isfile and writefile and getcustomasset then
                    local soundHash = "cf_sound_" .. string.gsub(soundUrl, "[^%w]", ""):sub(-15) .. ".mp3"
                    if not isfile(soundHash) then
                        pcall(function() writefile(soundHash, game:HttpGet(soundUrl)) end)
                    end
                    if isfile(soundHash) then
                        sound.SoundId = getcustomasset(soundHash)
                        sound:Play()
                    end
                end
            end
            game:GetService("Debris"):AddItem(sound, 10)
        end)
    end

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 0)
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = notifyContainer

    local notifFrame = Instance.new("CanvasGroup")
    notifFrame.Size = UDim2.new(1, 0, 1, 0)
    notifFrame.Position = UDim2.new(0, 50, 0, 50)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notifFrame.BorderSizePixel = 1
    notifFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    notifFrame.GroupTransparency = 1
    notifFrame.Parent = wrapper

    local textOffsetX = 15
    if iconUrl ~= "" then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Size = UDim2.new(0, 24, 0, 24)
        iconImg.Position = UDim2.new(0, 15, 0, 15)
        iconImg.BackgroundTransparency = 1
        iconImg.ScaleType = Enum.ScaleType.Fit
        iconImg.ZIndex = 2
        iconImg.Parent = notifFrame
        textOffsetX = 50

        task.spawn(function()
            if string.find(iconUrl, "rbxasset") then
                iconImg.Image = iconUrl
            elseif string.find(iconUrl, "http") then
                if isfile and writefile and getcustomasset then
                    local iconHash = "cf_icon_" .. string.gsub(iconUrl, "[^%w]", ""):sub(-15) .. ".png"
                    if not isfile(iconHash) then
                        pcall(function() writefile(iconHash, game:HttpGet(iconUrl)) end)
                    end
                    if isfile(iconHash) then
                        iconImg.Image = getcustomasset(iconHash)
                    end
                end
            end
        end)
    end

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -textOffsetX - 10, 0, 20)
    tLabel.Position = UDim2.new(0, textOffsetX, 0, 10)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title
    tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Font = Enum.Font.Code
    tLabel.TextSize = 14
    tLabel.ZIndex = 2
    tLabel.Parent = notifFrame

    local cLabel = Instance.new("TextLabel")
    cLabel.Size = UDim2.new(1, -textOffsetX - 10, 0, 0)
    cLabel.Position = UDim2.new(0, textOffsetX, 0, 30)
    cLabel.BackgroundTransparency = 1
    cLabel.Text = content
    cLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
    cLabel.TextXAlignment = Enum.TextXAlignment.Left
    cLabel.TextYAlignment = Enum.TextYAlignment.Top
    cLabel.Font = Enum.Font.Code
    cLabel.TextSize = 12
    cLabel.TextWrapped = true
    cLabel.ZIndex = 2
    cLabel.Parent = notifFrame

    cLabel.Size = UDim2.new(1, -textOffsetX - 10, 0, cLabel.TextBounds.Y + 5)
    local totalHeight = 30 + cLabel.TextBounds.Y + 15
    if totalHeight < 55 then totalHeight = 55 end
    wrapper.Size = UDim2.new(1, 0, 0, totalHeight)

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 3
    progressBar.Parent = notifFrame

    TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
        GroupTransparency = 0
    }):Play()

    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()

    task.delay(duration, function()
        local outTween = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 50, 0, 50),
            GroupTransparency = 1
        })
        outTween:Play()
        outTween.Completed:Connect(function()
            wrapper:Destroy()
        end)
    end)
end

return CF_UI
