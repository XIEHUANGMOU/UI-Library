```markdown
# 🎨 CF_UI Library — 轻量级 Roblox Lua UI 框架
```

> **设计要点**：标题应清晰简洁，一语道破项目是什么。可以使用 Emoji 增加视觉吸引力。

---

### 徽标区（Badges）

```markdown
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Lua](https://img.shields.io/badge/Lua-5.1-blueviolet)
![Roblox](https://img.shields.io/badge/Roblox-支持-black)
![License](https://img.shields.io/badge/license-MIT-green)
![PRs](https://img.shields.io/badge/PRs-welcome-brightgreen)
```

> **设计要点**：徽标（Badge）能直观展示项目状态、版本、许可证等关键信息。Shields.io 提供了丰富的徽标模板可供使用。两个徽标之间可通过 `&nbsp;`（空格实体）添加间隔。

---

### 简介（Description / Background）

```markdown
## 📖 简介

**CF_UI** 是一个专为 Roblox 平台设计的轻量级 Lua UI 框架，旨在帮助开发者以最简洁的代码快速构建美观、功能完整的图形用户界面。

### ✨ 特性

- 🚀 **开箱即用** — 单行加载，即刻拥有完整的 UI 系统
- 🎯 **链式调用** — 直观的 API 设计，代码即文档
- ⌨️ **全局快捷键** — 支持键盘绑定，提升操作效率
- 🌈 **彩虹边框** — 内置动态视觉效果，无需额外编码
- 📦 **模块化设计** — 选项卡、按钮、开关、滑动条等组件一应俱全
- 🔔 **全局通知系统** — 统一的消息推送机制

### 🎯 适用场景

- Roblox 游戏管理面板
- 开发者调试工具
- 游戏内设置界面
- 管理类脚本 UI
```

> **设计要点**：简介部分应回答“这个项目是做什么的”以及“它存在的原因”。使用 engaging 的语言描述项目的目的和要解决的问题。

---

### 目录（Table of Contents）

```markdown
## 📑 目录

- [快速开始](#-快速开始)
- [安装](#-安装)
- [核心 API](#-核心-api)
  - [初始化窗口](#1-初始化窗口-makewindow)
  - [创建选项卡](#2-创建选项卡-maketab)
  - [全局通知](#3-全局通知-notify)
  - [按钮](#4-按钮-addbutton)
  - [开关](#5-开关-addtoggle)
  - [滑动条](#6-滑动条-addslider)
  - [输入框](#7-输入框-addinput)
  - [下拉列表](#8-下拉列表-adddropdown)
  - [按键绑定](#9-按键绑定-addkeybind)
  - [板块与分隔线](#10-板块与分隔线-addsection--adddivider)
- [完整示例](#-完整示例)
- [贡献指南](#-贡献指南)
- [许可证](#-许可证)
- [致谢](#-致谢)
```

> **设计要点**：如果 README 较长，目录能帮助读者快速导航到特定部分。

---

### 快速开始（Quick Start）

```markdown
## 🚀 快速开始

只需一行代码即可完成框架加载：

```lua
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()
```

加载完成后，您就可以开始创建窗口和 UI 组件了。以下是一个最小示例：

```lua
-- 创建主窗口
local Window = CF_UI:MakeWindow({
    Title = "我的管理面板",
    Subtitle = "v1.0.0",
    Icon = "rbxassetid://12345678",
    Background = "rbxassetid://87654321",
    RainbowBorder = true,
    Size = UDim2.new(0, 600, 0, 400),
    Keybind = Enum.KeyCode.RightControl
})

-- 创建选项卡
local MainTab = Window:MakeTab({
    Title = "主页"
})

-- 添加一个按钮
MainTab:AddButton({
    Title = "点击我",
    Desc = "这是一个示例按钮"
}, function()
    print("按钮被点击了！")
end)
```

> 💡 **提示**：将 `rbxassetid://0000000` 替换为您自己的资源 ID。
```

> **设计要点**：快速开始部分应让用户能在最短时间内体验到项目的基本功能。

---

### 安装（Installation）

```markdown
## 📦 安装

### 方式一：直接加载（推荐）

```lua
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()
```

### 方式二：本地导入

1. 将 `main.lua` 下载到您的项目中
2. 使用 `require()` 导入：

```lua
local CF_UI = require(path.to.main)
```

### 系统要求

- Roblox Studio（任意版本）
- Lua 5.1 及以上
```

> **设计要点**：安装部分应清晰说明依赖项和配置步骤。

---

### 核心 API（完整文档）

```markdown
## 🔧 核心 API

### 1. 初始化窗口 `MakeWindow`

创建应用程序的主窗口，所有 UI 组件都基于此窗口展开。

#### 语法

```lua
local Window = CF_UI:MakeWindow({ ... })
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 窗口标题 |
| `Subtitle` | `string` | ❌ | `""` | 副标题文字 |
| `Icon` | `string` | ❌ | `""` | 图标资源 ID（格式：`rbxassetid://xxx`） |
| `Background` | `string` | ❌ | `""` | 背景图片资源 ID |
| `RainbowBorder` | `boolean` | ❌ | `false` | 是否启用彩虹边框动态效果 |
| `DPI` | `number` | ❌ | `1` | 界面缩放比例 |
| `Size` | `UDim2` | ❌ | `UDim2.new(0, 600, 0, 400)` | 窗口尺寸 |
| `Keybind` | `Enum.KeyCode` | ❌ | `false` | 显示/隐藏窗口的快捷键 |

#### 示例

```lua
local Window = CF_UI:MakeWindow({
    Title = "管理面板",
    Subtitle = "v2.0.0",
    Icon = "rbxassetid://12345678",
    Background = "rbxassetid://87654321",
    RainbowBorder = true,
    DPI = 1,
    Size = UDim2.new(0, 600, 0, 400),
    Keybind = Enum.KeyCode.RightControl
})
```

#### 返回值

| 类型 | 描述 |
|------|------|
| `table` | Window 对象，用于后续创建选项卡 |

---

### 2. 创建选项卡 `MakeTab`

在窗口中创建一个新的选项卡，用于组织不同类型的 UI 控件。

#### 语法

```lua
local Tab = Window:MakeTab({ ... })
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 选项卡标题 |

#### 示例

```lua
local SettingsTab = Window:MakeTab({
    Title = "设置"
})
```

#### 返回值

| 类型 | 描述 |
|------|------|
| `table` | Tab 对象，用于添加各类 UI 组件 |

---

### 3. 全局通知 `Notify`

在屏幕任意位置显示一条全局通知消息，独立于窗口存在。

#### 语法

```lua
CF_UI:Notify({ ... })
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 通知标题 |
| `Content` | `string` | ✅ | — | 通知内容 |
| `Icon` | `string` | ❌ | `""` | 通知图标资源 ID |
| `Duration` | `number` | ❌ | `3` | 显示时长（秒） |
| `Sound` | `string` | ❌ | `""` | 提示音资源 ID |

#### 示例

```lua
CF_UI:Notify({
    Title = "✅ 操作成功",
    Content = "配置已保存",
    Icon = "rbxassetid://12345678",
    Duration = 3,
    Sound = "rbxassetid://87654321"
})
```

---

### 4. 按钮 `AddButton`

在选项卡中添加一个可点击的按钮。

#### 语法

```lua
Tab:AddButton({ ... }, callback)
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 按钮标题 |
| `Desc` | `string` | ❌ | `""` | 按钮描述文字 |
| `Keybind` | `Enum.KeyCode` | ❌ | `false` | 触发按钮的快捷键 |

#### 回调

| 参数 | 类型 | 描述 |
|------|------|------|
| 无 | — | 点击按钮时触发 |

#### 示例

```lua
Tab:AddButton({
    Title = "执行脚本",
    Desc = "点击运行当前选中的脚本",
    Keybind = Enum.KeyCode.F
}, function()
    print("脚本已执行！")
    -- 您的业务逻辑
end)
```

---

### 5. 开关 `AddToggle`

在选项卡中添加一个开关（Toggle）控件，用于切换布尔状态。

#### 语法

```lua
Tab:AddToggle({ ... }, callback)
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 开关标题 |
| `Desc` | `string` | ❌ | `""` | 开关描述文字 |
| `Default` | `boolean` | ❌ | `false` | 初始状态 |
| `Keybind` | `Enum.KeyCode` | ❌ | `false` | 触发切换的快捷键 |

#### 回调

| 参数 | 类型 | 描述 |
|------|------|------|
| `state` | `boolean` | 当前开关状态（`true` = 开启） |

#### 示例

```lua
Tab:AddToggle({
    Title = "自动保存",
    Desc = "启用后每 30 秒自动保存一次",
    Default = true,
    Keybind = Enum.KeyCode.V
}, function(state)
    if state then
        print("自动保存已开启")
    else
        print("自动保存已关闭")
    end
end)
```

---

### 6. 滑动条 `AddSlider`

在选项卡中添加一个滑动条，用于选择数值范围内的值。

#### 语法

```lua
Tab:AddSlider({ ... }, callback)
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 滑动条标题 |
| `Desc` | `string` | ❌ | `""` | 滑动条描述文字 |
| `Min` | `number` | ✅ | — | 最小值 |
| `Max` | `number` | ✅ | — | 最大值 |
| `Default` | `number` | ❌ | `50` | 初始值 |
| `Keybind` | `Enum.KeyCode` | ❌ | `false` | 快捷键 |

#### 回调

| 参数 | 类型 | 描述 |
|------|------|------|
| `value` | `number` | 当前滑块数值 |

#### 示例

```lua
Tab:AddSlider({
    Title = "音量",
    Desc = "调整系统音量 (0-100)",
    Min = 0,
    Max = 100,
    Default = 75
}, function(value)
    print("当前音量: " .. value .. "%")
end)
```

---

### 7. 输入框 `AddInput`

在选项卡中添加一个文本输入框。

#### 语法

```lua
Tab:AddInput({ ... }, callback)
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 输入框标题 |
| `Desc` | `string` | ❌ | `""` | 输入框描述文字 |
| `Type` | `string` | ❌ | `"Default"` | 输入类型（`"Default"` / `"Number"` / `"Password"`） |
| `Placeholder` | `string` | ❌ | `""` | 占位提示文字 |
| `Keybind` | `Enum.KeyCode` | ❌ | `false` | 快捷键 |

#### 回调

| 参数 | 类型 | 描述 |
|------|------|------|
| `text` | `string` | 用户输入的文本 |

#### 示例

```lua
Tab:AddInput({
    Title = "玩家名称",
    Desc = "输入要查找的玩家名称",
    Type = "Default",
    Placeholder = "请输入玩家名称..."
}, function(text)
    print("搜索玩家: " .. text)
end)
```

---

### 8. 下拉列表 `AddDropdown`

在选项卡中添加一个下拉选择列表。

#### 语法

```lua
Tab:AddDropdown({ ... }, callback)
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 下拉列表标题 |
| `Values` | `table` | ✅ | — | 选项数组（如 `{"选项1", "选项2"}`） |
| `Value` | `string` / `table` | ❌ | `Values[1]` | 默认选中值（多选时为数组） |
| `Multi` | `boolean` | ❌ | `false` | 是否启用多选模式 |
| `SearchBarEnabled` | `boolean` | ❌ | `true` | 是否显示搜索栏 |
| `Keybind` | `Enum.KeyCode` | ❌ | `false` | 快捷键 |

#### 回调

| 参数 | 类型 | 描述 |
|------|------|------|
| `selected` | `string` / `table` | 选中的值（单选为字符串，多选为数组） |

#### 示例（单选）

```lua
Tab:AddDropdown({
    Title = "主题风格",
    Values = {"明亮", "暗黑", "自动"},
    Value = "明亮",
    Multi = false,
    SearchBarEnabled = true
}, function(selected)
    print("已选择主题: " .. selected)
end)
```

#### 示例（多选）

```lua
Tab:AddDropdown({
    Title = "权限选择",
    Values = {"管理员", "编辑", "查看者", "访客"},
    Value = {"管理员", "编辑"},
    Multi = true,
    SearchBarEnabled = true
}, function(selected)
    -- selected 是一个数组
    for _, v in ipairs(selected) do
        print("已选权限: " .. v)
    end
end)
```

---

### 9. 按键绑定 `AddKeybind`

在选项卡中添加一个按键绑定控件，用于捕获用户按键。

#### 语法

```lua
Tab:AddKeybind({ ... }, callback)
```

#### 参数

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 按键绑定标题 |
| `Desc` | `string` | ❌ | `""` | 按键绑定描述 |
| `Default` | `Enum.KeyCode` | ❌ | `Enum.KeyCode.Unknown` | 默认按键 |

#### 回调

| 参数 | 类型 | 描述 |
|------|------|------|
| `key` | `Enum.KeyCode` | 用户按下的按键 |

#### 示例

```lua
Tab:AddKeybind({
    Title = "截图快捷键",
    Desc = "按下设置快捷键进行截图",
    Default = Enum.KeyCode.F12
}, function(key)
    print("截图快捷键已设置为: " .. tostring(key))
end)
```

---

### 10. 板块与分隔线 `AddSection` & `AddDivider`

用于组织和美化 UI 布局的辅助组件。

#### 板块（Section）

```lua
local Section = Tab:AddSection({
    Title = "高级设置",
    Desc = "以下为高级配置选项，请谨慎修改"
})
```

#### 分隔线（Divider）

```lua
Tab:AddDivider({
    Title = "─ 基础配置 ─",
    Desc = "基本参数设置区域"
})
```
```

> **设计要点**：API 文档应包含完整的参数说明、类型标注、示例代码和返回值说明。

---

### 完整示例

```markdown
## 💡 完整示例

以下是一个包含所有组件的完整示例：

```lua
-- 1. 加载框架
local CF_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua"))()

-- 2. 创建窗口
local Window = CF_UI:MakeWindow({
    Title = "全能管理面板",
    Subtitle = "v1.0.0",
    Icon = "rbxassetid://12345678",
    RainbowBorder = true,
    Size = UDim2.new(0, 650, 0, 450),
    Keybind = Enum.KeyCode.RightControl
})

-- 3. 创建选项卡
local MainTab = Window:MakeTab({ Title = "主页" })
local SettingsTab = Window:MakeTab({ Title = "设置" })
local AboutTab = Window:MakeTab({ Title = "关于" })

-- 4. 主页选项卡
MainTab:AddButton({
    Title = "🚀 启动服务",
    Desc = "启动所有后台服务",
    Keybind = Enum.KeyCode.F1
}, function()
    print("服务已启动")
    CF_UI:Notify({
        Title = "✅ 成功",
        Content = "所有服务已启动",
        Duration = 2
    })
end)

MainTab:AddToggle({
    Title = "🔔 启用通知",
    Desc = "接收系统通知推送",
    Default = true
}, function(state)
    print("通知状态: " .. tostring(state))
end)

-- 5. 设置选项卡
SettingsTab:AddSlider({
    Title = "🔊 音量",
    Min = 0,
    Max = 100,
    Default = 80
}, function(value)
    print("音量: " .. value)
end)

SettingsTab:AddDropdown({
    Title = "🎨 界面语言",
    Values = {"中文", "English", "日本語"},
    Value = "中文"
}, function(selected)
    print("语言: " .. selected)
end)

-- 6. 关于选项卡
AboutTab:AddButton({
    Title = "📄 查看版本信息",
    Desc = "显示当前版本和更新日志"
}, function()
    CF_UI:Notify({
        Title = "ℹ️ 关于",
        Content = "CF_UI Library v1.0.0\n由 XIEHUANGMOU 开发",
        Duration = 4
    })
end)
```
```

---

### 贡献指南

```markdown
## 🤝 贡献指南

我们欢迎并感谢任何形式的贡献！请遵循以下流程：

### 提交 Issue

- 使用 [Issue Template](.github/ISSUE_TEMPLATE) 提交 Bug 报告或功能请求
- 请清晰描述问题复现步骤和预期行为

### 提交 Pull Request

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交您的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 打开一个 Pull Request

### 代码规范

- 遵循 Lua 代码风格指南
- 确保所有新功能有对应的文档说明
- 提交前进行充分测试
```

> **设计要点**：贡献指南应包括如何提交 Bug 报告、功能请求和 Pull Request 的信息。

---

### 许可证

```markdown
## 📄 许可证

本项目采用 **MIT License** 开源许可证。

```
MIT License

Copyright (c) 2026 XIEHUANGMOU

Permission is hereby granted, free of charge, to any person obtaining a copy
...
```
```

> **设计要点**：许可证部分应明确项目的使用、修改和分发条款。

---

### 致谢

```markdown
## 🙏 致谢

- 感谢所有为本项目提交 Issue 和 Pull Request 的贡献者
- 感谢 Roblox 开发者社区的支持与反馈
- 特别感谢 [UI-Library] 项目提供的灵感与参考

---

<div align="center">
  <sub>Built with ❤️ by XIEHUANGMOU</sub>
</div>
```

> **设计要点**：如果项目建立在他人工作之上，应在此表示感谢并提供来源链接。


## 三、Markdown 美化与增强技巧

### 3.1 使用徽标（Badges）

在 README 顶部添加状态徽标，能显著提升项目的专业感：

```markdown
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Lua](https://img.shields.io/badge/Lua-5.1-blueviolet)
![Roblox](https://img.shields.io/badge/Roblox-支持-black)
![License](https://img.shields.io/badge/license-MIT-green)
![PRs](https://img.shields.io/badge/PRs-welcome-brightgreen)
```

### 3.2 使用 Emoji 增强可读性

在标题和描述中适当使用 Emoji，可以让文档更生动：

| 用途 | Emoji |
|------|-------|
| 快速开始 | 🚀 |
| 安装 | 📦 |
| API 文档 | 🔧 |
| 示例 | 💡 |
| 贡献 | 🤝 |
| 许可证 | 📄 |
| 致谢 | 🙏 |
| 通知 | 🔔 |
| 设置 | ⚙️ |

### 3.3 使用表格呈现参数

对于 API 参数文档，使用表格能让信息一目了然：

```markdown
| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| `Title` | `string` | ✅ | — | 窗口标题 |
| `Subtitle` | `string` | ❌ | `""` | 副标题文字 |
```

### 3.4 代码块语法高亮

为代码块指定语言以启用语法高亮：

````markdown
```lua
local Window = CF_UI:MakeWindow({...})
```
````

### 3.5 使用引用块突出提示

```markdown
> 💡 **提示**：将 `rbxassetid://0000000` 替换为您自己的资源 ID。

> ⚠️ **注意**：快捷键功能需要用户权限允许。

> 🚨 **警告**：请勿在生产环境中使用未经测试的功能。
```

### 3.6 使用分隔线组织内容

```markdown
---

## 下一章节
```

### 3.7 添加项目截图/示意图

在“完整示例”或“快速开始”部分添加界面截图，帮助用户直观理解：

```markdown
![主界面预览](./screenshots/main.png)
```

图片建议使用相对路径存放在 `./screenshots/` 目录下。
