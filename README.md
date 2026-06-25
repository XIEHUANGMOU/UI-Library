

#### **初始化窗口 (MakeWindow)**
```lua
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()

local Window = CF_UI:MakeWindow({
    Title = "标题",
    Subtitle = "副标题",
    Icon = "rbxassetid://0000000",
    Background = "rbxassetid://0000000",
    RainbowBorder = true,
    Snowfall = true,
    DPI = 1,
    Size = UDim2.new(0, 600, 0, 400),
    Keybind = Enum.KeyCode.RightControl -- UI隐藏/展开快捷键 (可选, false为关闭)
})
```

#### **选项卡 (MakeTab)**
```lua
local Tab = Window:MakeTab({
    Title = "选项卡标题"
})
```

#### **全局通知 (Notify)**
```lua
CF_UI:Notify({
    Title = "通知标题",
    Content = "通知内容",
    Icon = "rbxassetid://0000000", 
    Duration = 3,
    Sound = "rbxassetid://0000000"
})
```

#### **按钮 (AddButton)**
```lua
Tab:AddButton({
    Title = "按钮标题",
    Desc = "按钮描述",
    Keybind = Enum.KeyCode.F -- 快捷键 (可选, false为关闭)
}, function()
    -- 执行代码
end)
```

#### **开关 (AddToggle)**
```lua
Tab:AddToggle({
    Title = "开关标题",
    Desc = "开关描述",
    Default = false,
    Keybind = Enum.KeyCode.V -- 快捷键 (可选, false为关闭)
}, function(state)
    -- 执行代码
end)
```

#### **滑动条 (AddSlider)**
```lua
Tab:AddSlider({
    Title = "滑动条标题",
    Desc = "滑动条描述",
    Min = 0,
    Max = 100,
    Default = 50,
    Keybind = false -- 快捷键 (可选, false为关闭)
}, function(value)
    -- 执行代码
end)
```

#### **输入框 (AddInput)**
```lua
Tab:AddInput({
    Title = "输入框标题",
    Desc = "输入框描述",
    Type = "Default",
    Placeholder = "占位符...",
    Keybind = false -- 快捷键 (可选, false为关闭)
}, function(text)
    -- 执行代码
end)
```

#### **下拉列表 (AddDropdown)**
```lua
Tab:AddDropdown({
    Title = "下拉列表标题",
    Values = {"选项1", "选项2"},
    Value = "选项1",
    Multi = false,
    SearchBarEnabled = true,
    Keybind = false -- 快捷键 (可选, false为关闭)
}, function(selected)
    -- 执行代码
end)
```

#### **按键绑定 (AddKeybind)**
```lua
Tab:AddKeybind({
    Title = "按键绑定标题",
    Desc = "按键绑定描述",
    Default = Enum.KeyCode.Unknown
}, function(key)
    -- 执行代码
end)
```

#### **板块 / 折叠区 (AddSection)**
```lua
local Section = Tab:AddSection({
    Title = "板块标题",
    Desc = "板块描述"
})
```

#### **分隔线 (AddDivider)**
```lua
Tab:AddDivider({
    Title = "分隔线标题",
    Desc = "分隔线描述"
})
```
