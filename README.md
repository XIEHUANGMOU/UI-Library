### 选项卡 (MakeTab)
在左侧导航栏创建一个分类选项卡。
 * Title: 选项卡名称
```lua
local Tab = Window:MakeTab({
    Title = "选项卡标题"
})

```
### 全局通知 (Notify)
在屏幕右下角弹出带有进度条、滑入动画和声音的提示框。
 * Title: 通知标题
 * Content: 通知内容
 * Icon: 图标（支持 rbxassetid 或 Http URL）
 * Duration: 停留时长（秒）
 * Sound: 提示音（支持 rbxassetid 或 Http URL）
```lua
CF_UI:Notify({
    Title = "通知标题",
    Content = "通知正文内容",
    Icon = "rbxassetid://0000000", 
    Duration = 3,
    Sound = "rbxassetid://0000000"
})

```
## 2. 交互组件
所有交互组件均支持挂载在 Tab（选项卡）或 Section（板块）下。
### 按钮 (AddButton)
基础点击按钮组件。
 * Title: 按钮标题
 * Desc: 按钮功能描述（可选）
```lua
Tab:AddButton({
    Title = "按钮标题",
    Desc = "按钮描述内容"
}, function()
    -- 点击后执行的代码
end)

```
### 开关 (AddToggle)
包含平滑滑动动画的状态开关。
 * Title: 开关标题
 * Desc: 开关描述（可选）
 * Default: 默认状态 (boolean)
```lua
Tab:AddToggle({
    Title = "开关标题",
    Desc = "开关描述内容",
    Default = false
}, function(state)
    -- 状态改变时执行的代码，state 返回布尔值
end)

```
### 滑动条 (AddSlider)
支持全局触摸拖拽的数值调节器。
 * Title: 滑动条标题
 * Desc: 滑动条描述（可选）
 * Min: 最小值
 * Max: 最大值
 * Default: 默认初始值
```lua
Tab:AddSlider({
    Title = "滑动条标题",
    Desc = "滑动条描述内容",
    Min = 0,
    Max = 100,
    Default = 50
}, function(value)
    -- 数值改变时执行的代码，value 返回当前数值
end)

```
### 输入框 (AddInput)
支持单行文本或多行脚本输入。
 * Title: 输入框标题
 * Desc: 输入框描述（可选）
 * Type: "Default" (单行) 或 "Textarea" (多行)
 * Placeholder: 空白占位符提示
```lua
Tab:AddInput({
    Title = "输入框标题",
    Desc = "输入框描述内容",
    Type = "Default",
    Placeholder = "占位符内容...",
}, function(text)
    -- 失去焦点或输入完成时执行的代码，text 返回字符串
end)

```
### 下拉列表 (AddDropdown)
带有平滑展开动画，支持单选、多选及内置搜索过滤。
 * Title: 列表标题
 * Values: 选项数组 (table)
 * Value: 默认选中项
 * Multi: 是否开启多选 (boolean)
 * SearchBarEnabled: 是否开启内置搜索框 (boolean)
```lua
Tab:AddDropdown({
    Title = "下拉列表标题",
    Values = {"选项1", "选项2", "选项3"},
    Value = "选项1",
    Multi = false,
    SearchBarEnabled = true
}, function(selected)
    -- 选中后执行的代码，单选返回字符串，多选返回 table 数组
end)

```
## 3. 排版与布局组件
### 板块 / 折叠区 (AddSection)
用于将相关的多个功能组件包裹在一起，支持点击标题栏平滑展开或收缩。
 * Title: 板块标题
 * Desc: 板块描述（可选）
```lua
local Section = Tab:AddSection({
    Title = "板块标题",
    Desc = "板块描述内容"
})

-- 在板块内添加组件的语法与在 Tab 内一致
Section:AddButton({
    Title = "板块内按钮"
}, function()
    -- 执行代码
end)

```
### 分隔线 (AddDivider)
用于在功能区之间绘制一条分割线，可选择是否带居中文字。
 * Title: 居中标题（可选）
 * Desc: 居中描述（可选）
```lua
Tab:AddDivider({
    Title = "分隔线标题",
    Desc = "分隔线描述内容"
})

```
"""
with open("CF_UI_Framework_Documentation.md", "w", encoding="utf-8") as f:
f.write(content)
print("Markdown file generated successfully.")
```
您的 Markdown (MD) 文件已准备就绪
[file-tag: code-generated-file-0-1781401165498929933]

我已经为您对该文档进行了层级规范和排版优化，使其更符合标准的 Markdown 语法。如果您需要直接复制文本，请使用以下内容：

```markdown
# CF_UI 框架官方组件文档

本 UI 专为 Roblox 脚本开发设计，支持全平台（PC/移动端）兼容、平滑动画过渡、DPI 等比缩放、全局搜索以及七彩流光特效。以下为所有可用组件的参数说明及基础调用语法。

---

## 1. 核心与基础组件

### 初始化窗口 (MakeWindow)
创建一个支持拖拽、缩放、搜索、背景图及流光特效的主窗口。

* `Title`: 主标题
* `Subtitle`: 副标题（可选）
* `Icon`: 标题栏图标（支持 rbxassetid 或 Http URL）
* `Background`: 背景图片（支持 rbxassetid 或 Http URL）
* `RainbowBorder`: 是否开启七彩流光边框 (boolean)
* `DPI`: 全局缩放比例 (默认 1)
* `Size`: 初始窗口大小 (UDim2)

```lua
local CF_UI = loadstring(game:HttpGet("[https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua](https://raw.githubusercontent.com/XIEHUANGMOU/UI-Library/refs/heads/main/main.lua)"))()

local Window = CF_UI:MakeWindow({
    Title = "标题",
    Subtitle = "副标题",
    Icon = "rbxassetid://0000000",
    Background = "rbxassetid://0000000",
    RainbowBorder = true,
    DPI = 1,
    Size = UDim2.new(0, 600, 0, 400)
})

```
### 选项卡 (MakeTab)
在左侧导航栏创建一个分类选项卡。
 * Title: 选项卡名称
```lua
local Tab = Window:MakeTab({
    Title = "选项卡标题"
})

```
### 全局通知 (Notify)
在屏幕右下角弹出带有进度条、滑入动画和声音的提示框。
 * Title: 通知标题
 * Content: 通知内容
 * Icon: 图标（支持 rbxassetid 或 Http URL）
 * Duration: 停留时长（秒）
 * Sound: 提示音（支持 rbxassetid 或 Http URL）
```lua
CF_UI:Notify({
    Title = "通知标题",
    Content = "通知正文内容",
    Icon = "rbxassetid://0000000", 
    Duration = 3,
    Sound = "rbxassetid://0000000"
})

```
## 2. 交互组件
所有交互组件均支持挂载在 Tab（选项卡）或 Section（板块）下。
### 按钮 (AddButton)
基础点击按钮组件。
 * Title: 按钮标题
 * Desc: 按钮功能描述（可选）
```lua
Tab:AddButton({
    Title = "按钮标题",
    Desc = "按钮描述内容"
}, function()
    -- 点击后执行的代码
end)

```
### 开关 (AddToggle)
包含平滑滑动动画的状态开关。
 * Title: 开关标题
 * Desc: 开关描述（可选）
 * Default: 默认状态 (boolean)
```lua
Tab:AddToggle({
    Title = "开关标题",
    Desc = "开关描述内容",
    Default = false
}, function(state)
    -- 状态改变时执行的代码，state 返回布尔值
end)

```
### 滑动条 (AddSlider)
支持全局触摸拖拽的数值调节器。
 * Title: 滑动条标题
 * Desc: 滑动条描述（可选）
 * Min: 最小值
 * Max: 最大值
 * Default: 默认初始值
```lua
Tab:AddSlider({
    Title = "滑动条标题",
    Desc = "滑动条描述内容",
    Min = 0,
    Max = 100,
    Default = 50
}, function(value)
    -- 数值改变时执行的代码，value 返回当前数值
end)

```
### 输入框 (AddInput)
支持单行文本或多行脚本输入。
 * Title: 输入框标题
 * Desc: 输入框描述（可选）
 * Type: "Default" (单行) 或 "Textarea" (多行)
 * Placeholder: 空白占位符提示
```lua
Tab:AddInput({
    Title = "输入框标题",
    Desc = "输入框描述内容",
    Type = "Default",
    Placeholder = "占位符内容...",
}, function(text)
    -- 失去焦点或输入完成时执行的代码，text 返回字符串
end)

```
### 下拉列表 (AddDropdown)
带有平滑展开动画，支持单选、多选及内置搜索过滤。
 * Title: 列表标题
 * Values: 选项数组 (table)
 * Value: 默认选中项
 * Multi: 是否开启多选 (boolean)
 * SearchBarEnabled: 是否开启内置搜索框 (boolean)
```lua
Tab:AddDropdown({
    Title = "下拉列表标题",
    Values = {"选项1", "选项2", "选项3"},
    Value = "选项1",
    Multi = false,
    SearchBarEnabled = true
}, function(selected)
    -- 选中后执行的代码，单选返回字符串，多选返回 table 数组
end)

```
## 3. 排版与布局组件
### 板块 / 折叠区 (AddSection)
用于将相关的多个功能组件包裹在一起，支持点击标题栏平滑展开或收缩。
 * Title: 板块标题
 * Desc: 板块描述（可选）
```lua
local Section = Tab:AddSection({
    Title = "板块标题",
    Desc = "板块描述内容"
})

-- 在板块内添加组件的语法与在 Tab 内一致
Section:AddButton({
    Title = "板块内按钮"
}, function()
    -- 执行代码
end)

```
### 分隔线 (AddDivider)
用于在功能区之间绘制一条分割线，可选择是否带居中文字。
 * Title: 居中标题（可选）
 * Desc: 居中描述（可选）
```lua
Tab:AddDivider({
    Title = "分隔线标题",
    Desc = "分隔线描述内容"
})

```

```
