<div align="center">
# 🌌 CF_UI Library
### 下一代 Roblox 脚本界面框架
![Version](https://img.shields.io/badge/Version-1.0.0-9cf?style=flat-square)
![Lua](https://img.shields.io/badge/Language-Lua-0000FF?style=flat-square)
![Roblox](https://img.shields.io/badge/Platform-Roblox-FF0000?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-brightgreen?style=flat-square)
**轻量 · 美观 · 高度可定制 · 组件化开发**
提供从基础控件到复杂布局的全套解决方案，支持彩虹边框、DPI缩放与全局事件系统，助您在几分钟内构建出惊艳的 Roblox UI 体验。
</div>
---
## 📋 目录
- [✨ 核心特性](#-核心特性)
- [📦 快速部署](#-快速部署)
- [🏗️ API 参考手册](#️-api-参考手册)
  - [1. 核心系统](#1-核心系统)
  - [2. 交互组件](#2-交互组件)
  - [3. 布局与排版](#3-布局与排版)
  - [4. 全局事件](#4-全局事件)
- [🚀 高级实战示例](#-高级实战示例)
- [🤝 贡献与反馈](#-贡献与反馈)
---
## ✨ 核心特性
- 🎨 **视觉美化**：内置彩虹边框、自定义背景图与图标支持。
- 🖥️ **高 DPI 适配**：自动缩放 UI 尺寸，完美兼容各种分辨率设备。
- 🧩 **组件化架构**：支持在 `Tab` 或 `Section` 中无限嵌套组件。
- ⌨️ **全局快捷键**：几乎所有组件均支持绑定独立的快捷键。
- 🔔 **全局通知系统**：自带支持图标与音效的 Toast 通知推流。
---
## 📦 快速部署
只需一行代码即可通过 HTTP 加载最新的 CF_UI 核心库：
```lua
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()
🏗️ API 参考手册
1. 核心系统
🪟 CF_UI:MakeWindow(config)
初始化并渲染 UI 的主窗口。
local Window = CF_UI:MakeWindow({
    Title = "我的脚本中心",
    Subtitle = "Powered by CF_UI",
    Icon = "rbxassetid://0000000",
    Background = "rbxassetid://0000000",
    RainbowBorder = true,       -- 启用流光彩虹边框
    DPI = 1,                    -- DPI 缩放倍率
    Size = UDim2.new(0, 600, 0, 400),
    Keybind = Enum.KeyCode.RightControl  -- 显隐快捷键 (设为 false 禁用)
})
📑 Window:MakeTab(config)
在主窗口侧边栏创建一个独立的选项卡页面。
local PlayerTab = Window:MakeTab({
    Title = "玩家功能"
})
2. 交互组件
💡 提示：以下所有组件均支持可选的 Keybind 参数（默认为 false 关闭），用于绑定全局快捷键。
🔘 按钮 Tab:AddButton(config, callback)
触发一次性操作的交互组件。
Tab:AddButton({
    Title = "执行刷级",
    Desc = "自动寻找最近怪物并攻击",
    Keybind = Enum.KeyCode.F
}, function()
    print("按钮逻辑已触发")
end)
🎚️ 开关 Tab:AddToggle(config, callback)
管理布尔状态的双值切换器。
Tab:AddToggle({
    Title = "无限体力",
    Desc = "锁定玩家 Stamina 为满值",
    Default = false,            -- 初始状态
    Keybind = Enum.KeyCode.V
}, function(state)
    print("当前无限体力状态:", state)
end)
🎨 滑动条 Tab:AddSlider(config, callback)
限制范围内的数值选择器。
Tab:AddSlider({
    Title = "移动速度",
    Desc = "调整 WalkSpeed 数值",
    Min = 16,
    Max = 120,
    Default = 16
}, function(value)
    print("速度变更为:", value)
end)
⌨️ 输入框 Tab:AddInput(config, callback)
接收用户文本输入的字段。
Tab:AddInput({
    Title = "目标玩家名",
    Desc = "输入要传送的玩家名称",
    Type = "Default",
    Placeholder = "在此输入玩家ID或名字..."
}, function(text)
    print("用户输入了:", text)
end)
📜 下拉列表 Tab:AddDropdown(config, callback)
支持单选/多选及搜索过滤的高级列表。
Tab:AddDropdown({
    Title = "选择武器",
    Values = {"剑", "弓", "法杖"},
    Value = "剑",               -- 默认选中值
    Multi = false,              -- false为单选, true为多选
    SearchBarEnabled = true     -- 启用搜索栏
}, function(selected)
    print("当前选中的武器:", selected)
end)
🎯 按键绑定 Tab:AddKeybind(config, callback)
允许用户运行时动态修改绑定的按键。
Tab:AddKeybind({
    Title = "自动闪避按键",
    Desc = "按下此键触发闪避",
    Default = Enum.KeyCode.Unknown
}, function(key)
    print("闪避键已绑定为:", tostring(key))
end)
3. 布局与排版
📦 板块/折叠区 Tab:AddSection(config)
在选项卡内创建可折叠的分组容器，返回的 Section 对象支持添加上述所有交互组件。
local CombatSection = Tab:AddSection({
    Title = "战斗设置",
    Desc = "所有与战斗相关的自动化功能"
})
-- 在 Section 中添加组件
CombatSection:AddToggle({ Title = "自动攻击" }, function(state) end)
➖ 分隔线 Tab:AddDivider(config)
用于在视觉上分割不同模块，支持附带文字说明。
Tab:AddDivider({
    Title = "危险功能区",
    Desc = "以下操作不可逆，请谨慎使用"
})
4. 全局事件
🔔 通知 CF_UI:Notify(config)
在屏幕角落弹出系统级 Toast 通知。
CF_UI:Notify({
    Title = "系统提示",
    Content = "脚本已成功注入并运行！",
    Icon = "rbxassetid://0000000",
    Duration = 3,               -- 持续时间 (秒)
    Sound = "rbxassetid://0000000" -- 通知音效
})
🚀 高级实战示例
以下演示如何构建一个完整的“自动化农场”配置面板，结合多种组件与事件联动：
-- 1. 加载与初始化
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()
local Window = CF_UI:MakeWindow({
    Title = "Auto Farm Hub",
    RainbowBorder = true,
    Keybind = Enum.KeyCode.RightShift
})
-- 2. 创建选项卡
local FarmTab = Window:MakeTab({ Title = "自动化" })
-- 3. 添加分隔说明
FarmTab:AddDivider({ Title = "基础设置" })
-- 4. 添加核心组件
local AutoFarmToggle = FarmTab:AddToggle({
    Title = "启用自动刷怪",
    Default = false
}, function(state)
    if state then
        CF_UI:Notify({ Title = "状态", Content = "自动刷怪已启动", Duration = 2 })
    end
end)
-- 5. 使用 Section 进行布局嵌套
local AdvancedSection = FarmTab:AddSection({ Title = "高级参数" })
AdvancedSection:AddSlider({
    Title = "攻击范围 ( studs )",
    Min = 10, Max = 100, Default = 50
}, function(range)
    print("搜索半径更新:", range)
end)
AdvancedSection:AddDropdown({
    Title = "优先击杀目标",
    Values = {"Boss", "小怪", "精英怪"},
    Multi = false,
    SearchBarEnabled = true
}, function(target)
    print("目标锁定:", target)
end)
-- 6. 绑定紧急停止按钮
FarmTab:AddButton({
    Title = "紧急停止所有任务",
    Desc = "强制清除所有循环线程",
    Keybind = Enum.KeyCode.Escape
}, function()
    AutoFarmToggle:SetState(false) -- 假设库内部提供了状态控制接口
    CF_UI:Notify({ Title = "警告", Content = "所有任务已强制终止!" })
end)
🤝 贡献与反馈
如果您在使用过程中遇到任何 Bug，或者有功能建议，欢迎在 GitHub 仓库提交 Issue 或 Pull Request。
<div align="center">
<sub>Copyright © 2024 CF_UI. All rights reserved.</sub>
</div>
