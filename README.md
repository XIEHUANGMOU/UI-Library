```markdown

# 🌌 CF_UI Library

### 一个现代化、高可定制性的 Roblox UI 框架

![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge)
![Lua](https://img.shields.io/badge/Language-Lua-2C2D72?style=for-the-badge&logo=lua)
![Platform](https://img.shields.io/badge/Platform-Roblox-FF0000?style=for-the-badge&logo=roblox)

**轻量 · 美观 · 响应式 · 功能完备**

</div>

---

## 📖 目录

- [✨ 特性](#-特性)
- [🚀 快速开始](#-快速开始)
- [📦 API 文档](#-api-文档)
  - [初始化窗口 (MakeWindow)](#初始化窗口-makewindow)
  - [选项卡 (MakeTab)](#选项卡-maketab)
  - [全局通知 (Notify)](#全局通知-notify)
  - [🧩 交互组件](#-交互组件)
  - [📐 布局组件](#-布局组件)
- [💡 完整示例](#-完整示例)
- [🤝 贡献与反馈](#-贡献与反馈)

---

## ✨ 特性

- 🎨 **高度可定制**：支持自定义图标、背景图、彩虹边框等视觉效果。
- 🧩 **丰富的组件**：内置按钮、开关、滑动条、下拉框、输入框、快捷键绑定等常用 UI 组件。
- ⌨️ **全局快捷键**：支持为 UI 隐藏/展开以及单个组件绑定快捷键。
- 📱 **DPI 适配**：支持自定义 DPI 缩放，适配不同分辨率的屏幕。
- 🔔 **原生通知系统**：内置美观的全局通知功能，支持自定义图标和音效。

---

## 🚀 快速开始

只需以下几行代码即可加载 CF_UI 库并初始化你的第一个窗口：

```lua
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()
local Window = CF_UI:MakeWindow({
    Title = "我的脚本",
    Subtitle = "由 CF_UI 驱动",
    Size = UDim2.new(0, 600, 0, 400),
    Keybind = Enum.KeyCode.RightControl
})
```

---

## 📦 API 文档

### 初始化窗口 (MakeWindow)

创建 UI 的主视窗。

**参数说明：**

<details>
<summary>🔨 查看代码示例</summary>

```lua
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()
local Window = CF_UI:MakeWindow({
    Title = "标题",
    Subtitle = "副标题",
    Icon = "rbxassetid://0000000",
    Background = "rbxassetid://0000000",
    RainbowBorder = true,
    DPI = 1,
    Size = UDim2.new(0, 600, 0, 400),
    Keybind = Enum.KeyCode.RightControl 
})
```

</details>

---

### 选项卡 (MakeTab)

在主窗口中创建一个选项卡页面，用于存放各类组件。

<details>
<summary>🔨 查看代码示例</summary>

```lua
local Tab = Window:MakeTab({
    Title = "选项卡标题"
})
```

</details>

---

### 全局通知 (Notify)

在屏幕角落弹出自定义通知。

**参数说明：**

<details>
<summary>🔨 查看代码示例</summary>

```lua
CF_UI:Notify({
    Title = "通知标题",
    Content = "通知内容",
    Icon = "rbxassetid://0000000",
    Duration = 3,
    Sound = "rbxassetid://0000000"
})
```

</details>

---

### 🧩 交互组件

#### 按钮

执行单击事件的按钮。支持绑定快捷键。

```lua
Tab:AddButton({
    Title = "按钮标题",
    Desc = "按钮描述",
    Keybind = Enum.KeyCode.F -- 快捷键 (可选, false为关闭)
}, function()
    print("按钮被点击！")
    -- 执行代码
end)
```

---

#### 开关

用于布尔值的状态切换。

```lua
Tab:AddToggle({
    Title = "开关标题",
    Desc = "开关描述",
    Default = false,
    Keybind = Enum.KeyCode.V 
}, function(state)
    print("当前状态:", state)
    -- 执行代码
end)
```

---

#### 滑动条

用于在一定范围内选择数值。

```lua
Tab:AddSlider({
    Title = "滑动条标题",
    Desc = "滑动条描述",
    Min = 0,
    Max = 100,
    Default = 50,
    Keybind = false 
}, function(value)
    print("当前数值:", value)
    -- 执行代码
end)
```

---

#### 输入框

获取用户输入的文本。

> 💡 **提示：** `Type` 参数可设置输入框样式（如 `"Default"` 或 `"Password"` 密码隐藏）。

```lua
Tab:AddInput({
    Title = "输入框标题",
    Desc = "输入框描述",
    Type = "Default",
    Placeholder = "占位符...",
    Keybind = false 
}, function(text)
    print("用户输入:", text)
    -- 执行代码
end)
```

---

#### 下拉列表

提供单选或多选的下拉菜单。内置搜索栏支持。

```lua
Tab:AddDropdown({
    Title = "下拉列表标题",
    Values = {"选项1", "选项2", "选项3"},
    Value = "选项1", -- 默认选中
    Multi = false, -- 设为 true 可开启多选
    SearchBarEnabled = true, -- 开启搜索
    Keybind = false 
}, function(selected)
    print("选中项:", selected)
    -- 执行代码
end)
```

---

#### 按键绑定

允许用户动态设置或更改某个功能的快捷键。

```lua
Tab:AddKeybind({
    Title = "按键绑定标题",
    Desc = "按键绑定描述",
    Default = Enum.KeyCode.Unknown
}, function(key)
    print("绑定的按键:", key)
    -- 执行代码
end)
```

---

### 📐 布局组件

#### 板块 / 折叠区

将相关组件分组，支持折叠隐藏，让 UI 更具层次感。

```lua
local Section = Tab:AddSection({
    Title = "板块标题",
    Desc = "板块描述"
})
-- 在板块中添加组件 (示例)
Section:AddButton({ Title = "板块内的按钮" }, function() end)
```

---

#### 分隔线

在视觉上分割不同区域的组件。

```lua
Tab:AddDivider({
    Title = "分隔线标题",
    Desc = "分隔线描述"
})
```

---

## 💡 完整示例

这里提供一个组合使用各种 API 的综合演示：

<details>
<summary>📂 展开查看完整演示代码</summary>

```lua
-- 加载库
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()

-- 创建窗口
local Window = CF_UI:MakeWindow({
    Title = "CF_UI 演示",
    Subtitle = "功能展示",
    RainbowBorder = true,
    Size = UDim2.new(0, 600, 0, 400),
    Keybind = Enum.KeyCode.RightControl
})

-- 通知测试
CF_UI:Notify({
    Title = "欢迎使用",
    Content = "CF_UI 已成功加载！",
    Duration = 3
})

-- 创建选项卡
local MainTab = Window:MakeTab({ Title = "主页" })

-- 添加板块
local PlayerSection = MainTab:AddSection({ Title = "玩家功能" })

PlayerSection:AddToggle({
    Title = "无限跳跃",
    Desc = "按下空格键可持续跳跃",
    Default = false
}, function(state)
    if state then
        print("无限跳跃 开启")
    else
        print("无限跳跃 关闭")
    end
end)

PlayerSection:AddSlider({
    Title = "移动速度",
    Min = 16,
    Max = 100,
    Default = 16
}, function(value)
    print("速度设置为:", value)
end)

MainTab:AddDivider({ Title = "其他功能" })

MainTab:AddButton({
    Title = "复制世界ID",
    Keybind = Enum.KeyCode.C
}, function()
    print("已复制！")
end)
```

</details>

---

## 🤝 贡献与反馈

如果您发现了 Bug 或有功能建议，请通过 [Issues](https://github.com/XIEHUANGMOU/UI-Library/issues) 提交反馈。  
欢迎通过 [Pull Request](https://github.com/XIEHUANGMOU/UI-Library/pulls) 贡献代码！

---

<div align="center">
  <sub>Copyright © 2023 XIEHUANGMOU. All rights reserved.</sub>
</div>
```
