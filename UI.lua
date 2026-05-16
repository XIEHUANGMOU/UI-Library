local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local CoreGui=game:GetService("CoreGui")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local LocalPlayer=Players.LocalPlayer
local Mouse=LocalPlayer:GetMouse()
local function CreateTween(instance,properties,duration)
local tweenInfo=TweenInfo.new(duration or 0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
local tween=TweenService:Create(instance,tweenInfo,properties)
tween:Play()
return tween
end
local function MakeDraggable(topbarobject,object)
local Dragging=false
local DragInput=nil
local DragStart=nil
local StartPosition=nil
topbarobject.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
Dragging=true
DragStart=input.Position
StartPosition=object.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then
Dragging=false
end
end)
end
end)
topbarobject.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
DragInput=input
end
end)
UserInputService.InputChanged:Connect(function(input)
if input==DragInput and Dragging then
local delta=input.Position-DragStart
object.Position=UDim2.new(StartPosition.X.Scale,StartPosition.X.Offset+delta.X,StartPosition.Y.Scale,StartPosition.Y.Offset+delta.Y)
end
end)
end
local Library={}
Library.Theme={
MainColor=Color3.fromRGB(25,25,30),
BackgroundColor=Color3.fromRGB(15,15,20),
GlassColor=Color3.fromRGB(255,255,255),
GlassTransparency=0.85,
TextColor=Color3.fromRGB(245,245,245),
SubTextColor=Color3.fromRGB(180,180,180),
AccentColor=Color3.fromRGB(10,132,255),
StrokeColor=Color3.fromRGB(255,255,255),
StrokeTransparency=0.85,
CornerRadius=UDim.new(0,14),
Font=Enum.Font.GothamBold,
SubFont=Enum.Font.GothamMedium,
TextSize=15,
TitleSize=18
}
function Library:CreateWindow(options)
local WindowOptions={
Title=options.Title or "注入器",
Subtitle=options.Subtitle or "液态玻璃版",
Icon=options.Icon or "rbxassetid://10137902766",
BottomText=options.BottomText or "欢迎使用本脚本",
BackgroundImage=options.BackgroundImage or ""
}
local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="LiquidGlassUI_"..tostring(math.random(1000,9999))
ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
local success,err=pcall(function() ScreenGui.Parent=CoreGui end)
if not success then ScreenGui.Parent=LocalPlayer:WaitForChild("PlayerGui") end
local MainFrame=Instance.new("Frame")
MainFrame.Name="MainFrame"
MainFrame.Parent=ScreenGui
MainFrame.BackgroundColor3=Library.Theme.BackgroundColor
MainFrame.BackgroundTransparency=0.3
MainFrame.Position=UDim2.new(0.5,-325,0.5,-225)
MainFrame.Size=UDim2.new(0,650,0,450)
MainFrame.BorderSizePixel=0
MainFrame.ClipsDescendants=false
local MainCorner=Instance.new("UICorner")
MainCorner.CornerRadius=Library.Theme.CornerRadius
MainCorner.Parent=MainFrame
local MainStroke=Instance.new("UIStroke")
MainStroke.Color=Library.Theme.StrokeColor
MainStroke.Transparency=Library.Theme.StrokeTransparency
MainStroke.Thickness=1.5
MainStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
MainStroke.Parent=MainFrame
local BackgroundImage=Instance.new("ImageLabel")
BackgroundImage.Name="BackgroundImage"
BackgroundImage.Parent=MainFrame
BackgroundImage.BackgroundColor3=Color3.fromRGB(255,255,255)
BackgroundImage.BackgroundTransparency=1
BackgroundImage.Size=UDim2.new(1,0,1,0)
BackgroundImage.ZIndex=0
BackgroundImage.Image=WindowOptions.BackgroundImage
BackgroundImage.ImageTransparency=0.7
BackgroundImage.ScaleType=Enum.ScaleType.Crop
local BgCorner=Instance.new("UICorner")
BgCorner.CornerRadius=Library.Theme.CornerRadius
BgCorner.Parent=BackgroundImage
local Topbar=Instance.new("Frame")
Topbar.Name="Topbar"
Topbar.Parent=MainFrame
Topbar.BackgroundColor3=Library.Theme.MainColor
Topbar.BackgroundTransparency=0.5
Topbar.Size=UDim2.new(1,0,0,50)
Topbar.BorderSizePixel=0
local TopbarCorner=Instance.new("UICorner")
TopbarCorner.CornerRadius=Library.Theme.CornerRadius
TopbarCorner.Parent=Topbar
local TopbarBottomFix=Instance.new("Frame")
TopbarBottomFix.Name="TopbarBottomFix"
TopbarBottomFix.Parent=Topbar
TopbarBottomFix.BackgroundColor3=Library.Theme.MainColor
TopbarBottomFix.BackgroundTransparency=0.5
TopbarBottomFix.Position=UDim2.new(0,0,1,-10)
TopbarBottomFix.Size=UDim2.new(1,0,0,10)
TopbarBottomFix.BorderSizePixel=0
local TopbarStroke=Instance.new("UIStroke")
TopbarStroke.Color=Library.Theme.StrokeColor
TopbarStroke.Transparency=Library.Theme.StrokeTransparency
TopbarStroke.Thickness=1
TopbarStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
TopbarStroke.Parent=Topbar
MakeDraggable(Topbar,MainFrame)
local WindowIcon=Instance.new("ImageLabel")
WindowIcon.Name="WindowIcon"
WindowIcon.Parent=Topbar
WindowIcon.BackgroundColor3=Color3.fromRGB(255,255,255)
WindowIcon.BackgroundTransparency=1
WindowIcon.Position=UDim2.new(0,15,0.5,-12)
WindowIcon.Size=UDim2.new(0,24,0,24)
WindowIcon.Image=WindowOptions.Icon
local TitleLabel=Instance.new("TextLabel")
TitleLabel.Name="TitleLabel"
TitleLabel.Parent=Topbar
TitleLabel.BackgroundColor3=Color3.fromRGB(255,255,255)
TitleLabel.BackgroundTransparency=1
TitleLabel.Position=UDim2.new(0,50,0,5)
TitleLabel.Size=UDim2.new(0,200,0,20)
TitleLabel.Font=Library.Theme.Font
TitleLabel.Text=WindowOptions.Title
TitleLabel.TextColor3=Library.Theme.TextColor
TitleLabel.TextSize=Library.Theme.TitleSize
TitleLabel.TextXAlignment=Enum.TextXAlignment.Left
local SubtitleLabel=Instance.new("TextLabel")
SubtitleLabel.Name="SubtitleLabel"
SubtitleLabel.Parent=Topbar
SubtitleLabel.BackgroundColor3=Color3.fromRGB(255,255,255)
SubtitleLabel.BackgroundTransparency=1
SubtitleLabel.Position=UDim2.new(0,50,0,25)
SubtitleLabel.Size=UDim2.new(0,200,0,15)
SubtitleLabel.Font=Library.Theme.SubFont
SubtitleLabel.Text=WindowOptions.Subtitle
SubtitleLabel.TextColor3=Library.Theme.AccentColor
SubtitleLabel.TextSize=12
SubtitleLabel.TextXAlignment=Enum.TextXAlignment.Left
local CloseButton=Instance.new("TextButton")
CloseButton.Name="CloseButton"
CloseButton.Parent=Topbar
CloseButton.BackgroundColor3=Color3.fromRGB(255,59,48)
CloseButton.BackgroundTransparency=0.2
CloseButton.Position=UDim2.new(1,-35,0.5,-7)
CloseButton.Size=UDim2.new(0,14,0,14)
CloseButton.Font=Enum.Font.SourceSans
CloseButton.Text=""
CloseButton.AutoButtonColor=false
local CloseCorner=Instance.new("UICorner")
CloseCorner.CornerRadius=UDim.new(1,0)
CloseCorner.Parent=CloseButton
local MinimizeButton=Instance.new("TextButton")
MinimizeButton.Name="MinimizeButton"
MinimizeButton.Parent=Topbar
MinimizeButton.BackgroundColor3=Color3.fromRGB(255,204,0)
MinimizeButton.BackgroundTransparency=0.2
MinimizeButton.Position=UDim2.new(1,-60,0.5,-7)
MinimizeButton.Size=UDim2.new(0,14,0,14)
MinimizeButton.Font=Enum.Font.SourceSans
MinimizeButton.Text=""
MinimizeButton.AutoButtonColor=false
local MinimizeCorner=Instance.new("UICorner")
MinimizeCorner.CornerRadius=UDim.new(1,0)
MinimizeCorner.Parent=MinimizeButton
local BottomBar=Instance.new("Frame")
BottomBar.Name="BottomBar"
BottomBar.Parent=MainFrame
BottomBar.BackgroundColor3=Library.Theme.MainColor
BottomBar.BackgroundTransparency=0.5
BottomBar.Position=UDim2.new(0,0,1,-30)
BottomBar.Size=UDim2.new(1,0,0,30)
BottomBar.BorderSizePixel=0
local BottomCorner=Instance.new("UICorner")
BottomCorner.CornerRadius=Library.Theme.CornerRadius
BottomCorner.Parent=BottomBar
local BottomTopFix=Instance.new("Frame")
BottomTopFix.Name="BottomTopFix"
BottomTopFix.Parent=BottomBar
BottomTopFix.BackgroundColor3=Library.Theme.MainColor
BottomTopFix.BackgroundTransparency=0.5
BottomTopFix.Size=UDim2.new(1,0,0,10)
BottomTopFix.BorderSizePixel=0
local BottomLabel=Instance.new("TextLabel")
BottomLabel.Name="BottomLabel"
BottomLabel.Parent=BottomBar
BottomLabel.BackgroundColor3=Color3.fromRGB(255,255,255)
BottomLabel.BackgroundTransparency=1
BottomLabel.Position=UDim2.new(0,15,0,0)
BottomLabel.Size=UDim2.new(1,-30,1,0)
BottomLabel.Font=Library.Theme.SubFont
BottomLabel.Text=WindowOptions.BottomText
BottomLabel.TextColor3=Library.Theme.SubTextColor
BottomLabel.TextSize=13
BottomLabel.TextXAlignment=Enum.TextXAlignment.Left
local Sidebar=Instance.new("Frame")
Sidebar.Name="Sidebar"
Sidebar.Parent=MainFrame
Sidebar.BackgroundColor3=Color3.fromRGB(20,20,25)
Sidebar.BackgroundTransparency=0.6
Sidebar.Position=UDim2.new(0,10,0,60)
Sidebar.Size=UDim2.new(0,150,1,-100)
Sidebar.BorderSizePixel=0
local SidebarCorner=Instance.new("UICorner")
SidebarCorner.CornerRadius=Library.Theme.CornerRadius
SidebarCorner.Parent=Sidebar
local SidebarStroke=Instance.new("UIStroke")
SidebarStroke.Color=Library.Theme.StrokeColor
SidebarStroke.Transparency=Library.Theme.StrokeTransparency
SidebarStroke.Thickness=1
SidebarStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
SidebarStroke.Parent=Sidebar
local SidebarScroll=Instance.new("ScrollingFrame")
SidebarScroll.Name="SidebarScroll"
SidebarScroll.Parent=Sidebar
SidebarScroll.Active=true
SidebarScroll.BackgroundColor3=Color3.fromRGB(255,255,255)
SidebarScroll.BackgroundTransparency=1
SidebarScroll.Position=UDim2.new(0,0,0,5)
SidebarScroll.Size=UDim2.new(1,0,1,-10)
SidebarScroll.CanvasSize=UDim2.new(0,0,0,0)
SidebarScroll.ScrollBarThickness=2
SidebarScroll.ScrollBarImageColor3=Library.Theme.AccentColor
SidebarScroll.BorderSizePixel=0
local SidebarLayout=Instance.new("UIListLayout")
SidebarLayout.Parent=SidebarScroll
SidebarLayout.SortOrder=Enum.SortOrder.LayoutOrder
SidebarLayout.Padding=UDim.new(0,5)
SidebarLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
local ContentContainer=Instance.new("Frame")
ContentContainer.Name="ContentContainer"
ContentContainer.Parent=MainFrame
ContentContainer.BackgroundColor3=Color3.fromRGB(255,255,255)
ContentContainer.BackgroundTransparency=1
ContentContainer.Position=UDim2.new(0,170,0,60)
ContentContainer.Size=UDim2.new(1,-180,1,-100)
ContentContainer.BorderSizePixel=0
local Minimized=false
MinimizeButton.MouseButton1Click:Connect(function()
Minimized=not Minimized
if Minimized then
CreateTween(Sidebar,{BackgroundTransparency=1},0.2)
CreateTween(ContentContainer,{Position=UDim2.new(0,170,0.5,0)},0.25)
task.wait(0.15)
CreateTween(MainFrame,{Size=UDim2.new(0,650,0,50)},0.3)
task.wait(0.3)
Sidebar.Visible=false
ContentContainer.Visible=false
BottomBar.Visible=false
else
MainFrame.Size=UDim2.new(0,650,0,50)
Sidebar.Visible=true
ContentContainer.Visible=true
BottomBar.Visible=true
ContentContainer.Position=UDim2.new(0,170,0.5,0)
Sidebar.BackgroundTransparency=1
CreateTween(MainFrame,{Size=UDim2.new(0,650,0,450)},0.3)
task.wait(0.25)
CreateTween(Sidebar,{BackgroundTransparency=0.6},0.2)
CreateTween(ContentContainer,{Position=UDim2.new(0,170,0,60)},0.25)
end
end)
CloseButton.MouseButton1Click:Connect(function()
CreateTween(Topbar,{BackgroundTransparency=1},0.2)
CreateTween(BottomBar,{BackgroundTransparency=1},0.2)
CreateTween(Sidebar,{BackgroundTransparency=1},0.2)
CreateTween(ContentContainer,{Position=UDim2.new(0.5,0,0.5,0)},0.25)
CreateTween(MainFrame,{Size=UDim2.new(0,0,0,0),BackgroundTransparency=1},0.35)
task.delay(0.35,function()
ScreenGui:Destroy()
end)
end)
local WindowElements={}
local FirstTab=true
function WindowElements:CreateTab(tabOptions)
local TabName=tabOptions.Title or "未命名标签"
local TabIcon=tabOptions.Icon or "rbxassetid://10137902766"
local TabButton=Instance.new("TextButton")
TabButton.Name=TabName.."_Button"
TabButton.Parent=SidebarScroll
TabButton.BackgroundColor3=Library.Theme.AccentColor
TabButton.BackgroundTransparency=1
TabButton.Size=UDim2.new(1,-10,0,35)
TabButton.Font=Library.Theme.SubFont
TabButton.Text=""
TabButton.AutoButtonColor=false
local TabButtonCorner=Instance.new("UICorner")
TabButtonCorner.CornerRadius=UDim.new(0,8)
TabButtonCorner.Parent=TabButton
local TabButtonIcon=Instance.new("ImageLabel")
TabButtonIcon.Name="Icon"
TabButtonIcon.Parent=TabButton
TabButtonIcon.BackgroundColor3=Color3.fromRGB(255,255,255)
TabButtonIcon.BackgroundTransparency=1
TabButtonIcon.Position=UDim2.new(0,10,0.5,-10)
TabButtonIcon.Size=UDim2.new(0,20,0,20)
TabButtonIcon.Image=TabIcon
TabButtonIcon.ImageColor3=Library.Theme.SubTextColor
local TabButtonText=Instance.new("TextLabel")
TabButtonText.Name="Title"
TabButtonText.Parent=TabButton
TabButtonText.BackgroundColor3=Color3.fromRGB(255,255,255)
TabButtonText.BackgroundTransparency=1
TabButtonText.Position=UDim2.new(0,40,0,0)
TabButtonText.Size=UDim2.new(1,-45,1,0)
TabButtonText.Font=Library.Theme.SubFont
TabButtonText.Text=TabName
TabButtonText.TextColor3=Library.Theme.SubTextColor
TabButtonText.TextSize=14
TabButtonText.TextXAlignment=Enum.TextXAlignment.Left
local TabPage=Instance.new("ScrollingFrame")
TabPage.Name=TabName.."_Page"
TabPage.Parent=ContentContainer
TabPage.Active=true
TabPage.BackgroundColor3=Color3.fromRGB(255,255,255)
TabPage.BackgroundTransparency=1
TabPage.Size=UDim2.new(1,0,1,0)
TabPage.CanvasSize=UDim2.new(0,0,0,0)
TabPage.ScrollBarThickness=3
TabPage.ScrollBarImageColor3=Library.Theme.AccentColor
TabPage.BorderSizePixel=0
TabPage.Visible=false
local PageLayout=Instance.new("UIListLayout")
PageLayout.Parent=TabPage
PageLayout.SortOrder=Enum.SortOrder.LayoutOrder
PageLayout.Padding=UDim.new(0,8)
local PagePadding=Instance.new("UIPadding")
PagePadding.Parent=TabPage
PagePadding.PaddingTop=UDim.new(0,5)
PagePadding.PaddingBottom=UDim.new(0,5)
PagePadding.PaddingLeft=UDim.new(0,5)
PagePadding.PaddingRight=UDim.new(0,5)
PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
TabPage.CanvasSize=UDim2.new(0,0,0,PageLayout.AbsoluteContentSize.Y+10)
SidebarScroll.CanvasSize=UDim2.new(0,0,0,SidebarLayout.AbsoluteContentSize.Y+10)
end)
if FirstTab then
FirstTab=false
TabPage.Visible=true
TabButton.BackgroundTransparency=0.8
TabButtonText.TextColor3=Library.Theme.AccentColor
TabButtonIcon.ImageColor3=Library.Theme.AccentColor
end
TabButton.MouseButton1Click:Connect(function()
for _,child in pairs(ContentContainer:GetChildren()) do
if child:IsA("ScrollingFrame") then
child.Visible=false
end
end
for _,child in pairs(SidebarScroll:GetChildren()) do
if child:IsA("TextButton") then
CreateTween(child,{BackgroundTransparency=1},0.2)
child.Title.TextColor3=Library.Theme.SubTextColor
child.Icon.ImageColor3=Library.Theme.SubTextColor
end
end
TabPage.Visible=true
CreateTween(TabButton,{BackgroundTransparency=0.8},0.2)
TabButtonText.TextColor3=Library.Theme.AccentColor
TabButtonIcon.ImageColor3=Library.Theme.AccentColor
end)
local TabElements={}
function TabElements:CreateButton(btnOptions)
local BtnTitle=btnOptions.Title or "按钮"
local BtnDesc=btnOptions.Desc or ""
local BtnCallback=btnOptions.Callback or function() end
local ButtonFrame=Instance.new("TextButton")
ButtonFrame.Name="ButtonFrame"
ButtonFrame.Parent=TabPage
ButtonFrame.BackgroundColor3=Library.Theme.MainColor
ButtonFrame.BackgroundTransparency=0.6
ButtonFrame.Size=UDim2.new(1,0,0,45)
ButtonFrame.Font=Enum.Font.SourceSans
ButtonFrame.Text=""
ButtonFrame.AutoButtonColor=false
ButtonFrame.ClipsDescendants=true
local BtnCorner=Instance.new("UICorner")
BtnCorner.CornerRadius=Library.Theme.CornerRadius
BtnCorner.Parent=ButtonFrame
local BtnStroke=Instance.new("UIStroke")
BtnStroke.Color=Library.Theme.StrokeColor
BtnStroke.Transparency=Library.Theme.StrokeTransparency
BtnStroke.Thickness=1
BtnStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
BtnStroke.Parent=ButtonFrame
local BtnText=Instance.new("TextLabel")
BtnText.Name="Title"
BtnText.Parent=ButtonFrame
BtnText.BackgroundColor3=Color3.fromRGB(255,255,255)
BtnText.BackgroundTransparency=1
BtnText.Position=UDim2.new(0,15,0,0)
BtnText.Size=UDim2.new(1,-30,1,0)
BtnText.Font=Library.Theme.Font
BtnText.Text=BtnTitle
BtnText.TextColor3=Library.Theme.TextColor
BtnText.TextSize=Library.Theme.TextSize
BtnText.TextXAlignment=Enum.TextXAlignment.Left
if BtnDesc~="" then
BtnText.Position=UDim2.new(0,15,0,6)
BtnText.Size=UDim2.new(1,-30,0,18)
local BtnSub=Instance.new("TextLabel")
BtnSub.Name="Desc"
BtnSub.Parent=ButtonFrame
BtnSub.BackgroundColor3=Color3.fromRGB(255,255,255)
BtnSub.BackgroundTransparency=1
BtnSub.Position=UDim2.new(0,15,0,24)
BtnSub.Size=UDim2.new(1,-30,0,15)
BtnSub.Font=Library.Theme.SubFont
BtnSub.Text=BtnDesc
BtnSub.TextColor3=Library.Theme.SubTextColor
BtnSub.TextSize=12
BtnSub.TextXAlignment=Enum.TextXAlignment.Left
end
local ClickIcon=Instance.new("ImageLabel")
ClickIcon.Name="ClickIcon"
ClickIcon.Parent=ButtonFrame
ClickIcon.BackgroundColor3=Color3.fromRGB(255,255,255)
ClickIcon.BackgroundTransparency=1
ClickIcon.Position=UDim2.new(1,-35,0.5,-10)
ClickIcon.Size=UDim2.new(0,20,0,20)
ClickIcon.Image="rbxassetid://10137902766"
ClickIcon.ImageColor3=Library.Theme.AccentColor
ButtonFrame.MouseEnter:Connect(function()
CreateTween(ButtonFrame,{BackgroundTransparency=0.4},0.2)
end)
ButtonFrame.MouseLeave:Connect(function()
CreateTween(ButtonFrame,{BackgroundTransparency=0.6},0.2)
end)
ButtonFrame.MouseButton1Click:Connect(function()
local ripple=Instance.new("Frame")
ripple.Parent=ButtonFrame
ripple.BackgroundColor3=Library.Theme.AccentColor
ripple.BackgroundTransparency=0.6
ripple.BorderSizePixel=0
ripple.Position=UDim2.new(0,Mouse.X-ButtonFrame.AbsolutePosition.X,0,Mouse.Y-ButtonFrame.AbsolutePosition.Y)
ripple.Size=UDim2.new(0,0,0,0)
ripple.AnchorPoint=Vector2.new(0.5,0.5)
local rippleCorner=Instance.new("UICorner")
rippleCorner.CornerRadius=UDim.new(1,0)
rippleCorner.Parent=ripple
local t=CreateTween(ripple,{Size=UDim2.new(0,300,0,300),BackgroundTransparency=1},0.4)
t.Completed:Connect(function() ripple:Destroy() end)
pcall(BtnCallback)
end)
end
function TabElements:CreateToggle(tglOptions)
local TglTitle=tglOptions.Title or "开关"
local TglDesc=tglOptions.Desc or ""
local TglDefault=tglOptions.Default or false
local TglCallback=tglOptions.Callback or function() end
local Toggled=TglDefault
local ToggleFrame=Instance.new("TextButton")
ToggleFrame.Name="ToggleFrame"
ToggleFrame.Parent=TabPage
ToggleFrame.BackgroundColor3=Library.Theme.MainColor
ToggleFrame.BackgroundTransparency=0.6
ToggleFrame.Size=UDim2.new(1,0,0,45)
ToggleFrame.Font=Enum.Font.SourceSans
ToggleFrame.Text=""
ToggleFrame.AutoButtonColor=false
local TglCorner=Instance.new("UICorner")
TglCorner.CornerRadius=Library.Theme.CornerRadius
TglCorner.Parent=ToggleFrame
local TglStroke=Instance.new("UIStroke")
TglStroke.Color=Library.Theme.StrokeColor
TglStroke.Transparency=Library.Theme.StrokeTransparency
TglStroke.Thickness=1
TglStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
TglStroke.Parent=ToggleFrame
local TglText=Instance.new("TextLabel")
TglText.Name="Title"
TglText.Parent=ToggleFrame
TglText.BackgroundColor3=Color3.fromRGB(255,255,255)
TglText.BackgroundTransparency=1
TglText.Position=UDim2.new(0,15,0,0)
TglText.Size=UDim2.new(1,-80,1,0)
TglText.Font=Library.Theme.Font
TglText.Text=TglTitle
TglText.TextColor3=Library.Theme.TextColor
TglText.TextSize=Library.Theme.TextSize
TglText.TextXAlignment=Enum.TextXAlignment.Left
if TglDesc~="" then
TglText.Position=UDim2.new(0,15,0,6)
TglText.Size=UDim2.new(1,-80,0,18)
local TglSub=Instance.new("TextLabel")
TglSub.Name="Desc"
TglSub.Parent=ToggleFrame
TglSub.BackgroundColor3=Color3.fromRGB(255,255,255)
TglSub.BackgroundTransparency=1
TglSub.Position=UDim2.new(0,15,0,24)
TglSub.Size=UDim2.new(1,-80,0,15)
TglSub.Font=Library.Theme.SubFont
TglSub.Text=TglDesc
TglSub.TextColor3=Library.Theme.SubTextColor
TglSub.TextSize=12
TglSub.TextXAlignment=Enum.TextXAlignment.Left
end
local SwitchBg=Instance.new("Frame")
SwitchBg.Name="SwitchBg"
SwitchBg.Parent=ToggleFrame
SwitchBg.BackgroundColor3=Toggled and Library.Theme.AccentColor or Color3.fromRGB(50,50,55)
SwitchBg.Position=UDim2.new(1,-55,0.5,-12)
SwitchBg.Size=UDim2.new(0,44,0,24)
local SwitchCorner=Instance.new("UICorner")
SwitchCorner.CornerRadius=UDim.new(1,0)
SwitchCorner.Parent=SwitchBg
local SwitchKnob=Instance.new("Frame")
SwitchKnob.Name="SwitchKnob"
SwitchKnob.Parent=SwitchBg
SwitchKnob.BackgroundColor3=Color3.fromRGB(255,255,255)
SwitchKnob.Position=Toggled and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
SwitchKnob.Size=UDim2.new(0,20,0,20)
local KnobCorner=Instance.new("UICorner")
KnobCorner.CornerRadius=UDim.new(1,0)
KnobCorner.Parent=SwitchKnob
local KnobShadow=Instance.new("UIStroke")
KnobShadow.Color=Color3.fromRGB(0,0,0)
KnobShadow.Transparency=0.8
KnobShadow.Thickness=2
KnobShadow.Parent=SwitchKnob
ToggleFrame.MouseButton1Click:Connect(function()
Toggled=not Toggled
if Toggled then
CreateTween(SwitchBg,{BackgroundColor3=Library.Theme.AccentColor},0.3)
CreateTween(SwitchKnob,{Position=UDim2.new(1,-22,0.5,-10)},0.3)
else
CreateTween(SwitchBg,{BackgroundColor3=Color3.fromRGB(50,50,55)},0.3)
CreateTween(SwitchKnob,{Position=UDim2.new(0,2,0.5,-10)},0.3)
end
pcall(TglCallback,Toggled)
end)
end
function TabElements:CreateSlider(sldOptions)
local SldTitle=sldOptions.Title or "滑块"
local SldDesc=sldOptions.Desc or ""
local Min=sldOptions.Min or 0
local Max=sldOptions.Max or 100
local Default=sldOptions.Default or 50
local SldCallback=sldOptions.Callback or function() end
local SliderValue=Default
local SliderFrame=Instance.new("Frame")
SliderFrame.Name="SliderFrame"
SliderFrame.Parent=TabPage
SliderFrame.BackgroundColor3=Library.Theme.MainColor
SliderFrame.BackgroundTransparency=0.6
SliderFrame.Size=UDim2.new(1,0,0,65)
local SldCorner=Instance.new("UICorner")
SldCorner.CornerRadius=Library.Theme.CornerRadius
SldCorner.Parent=SliderFrame
local SldStroke=Instance.new("UIStroke")
SldStroke.Color=Library.Theme.StrokeColor
SldStroke.Transparency=Library.Theme.StrokeTransparency
SldStroke.Thickness=1
SldStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
SldStroke.Parent=SliderFrame
local SldText=Instance.new("TextLabel")
SldText.Name="Title"
SldText.Parent=SliderFrame
SldText.BackgroundColor3=Color3.fromRGB(255,255,255)
SldText.BackgroundTransparency=1
SldText.Position=UDim2.new(0,15,0,8)
SldText.Size=UDim2.new(1,-80,0,18)
SldText.Font=Library.Theme.Font
SldText.Text=SldTitle
SldText.TextColor3=Library.Theme.TextColor
SldText.TextSize=Library.Theme.TextSize
SldText.TextXAlignment=Enum.TextXAlignment.Left
local ValueLabel=Instance.new("TextLabel")
ValueLabel.Name="Value"
ValueLabel.Parent=SliderFrame
ValueLabel.BackgroundColor3=Color3.fromRGB(255,255,255)
ValueLabel.BackgroundTransparency=1
ValueLabel.Position=UDim2.new(1,-65,0,8)
ValueLabel.Size=UDim2.new(0,50,0,18)
ValueLabel.Font=Library.Theme.Font
ValueLabel.Text=tostring(Default)
ValueLabel.TextColor3=Library.Theme.AccentColor
ValueLabel.TextSize=14
ValueLabel.TextXAlignment=Enum.TextXAlignment.Right
if SldDesc~="" then
local SldSub=Instance.new("TextLabel")
SldSub.Name="Desc"
SldSub.Parent=SliderFrame
SldSub.BackgroundColor3=Color3.fromRGB(255,255,255)
SldSub.BackgroundTransparency=1
SldSub.Position=UDim2.new(0,15,0,26)
SldSub.Size=UDim2.new(1,-80,0,15)
SldSub.Font=Library.Theme.SubFont
SldSub.Text=SldDesc
SldSub.TextColor3=Library.Theme.SubTextColor
SldSub.TextSize=12
SldSub.TextXAlignment=Enum.TextXAlignment.Left
end
local TrackBg=Instance.new("TextButton")
TrackBg.Name="TrackBg"
TrackBg.Parent=SliderFrame
TrackBg.BackgroundColor3=Color3.fromRGB(40,40,45)
TrackBg.Position=UDim2.new(0,15,1,-15)
TrackBg.Size=UDim2.new(1,-30,0,6)
TrackBg.Text=""
TrackBg.AutoButtonColor=false
local TrackCorner=Instance.new("UICorner")
TrackCorner.CornerRadius=UDim.new(1,0)
TrackCorner.Parent=TrackBg
local TrackFill=Instance.new("Frame")
TrackFill.Name="TrackFill"
TrackFill.Parent=TrackBg
TrackFill.BackgroundColor3=Library.Theme.AccentColor
TrackFill.Size=UDim2.new((Default-Min)/(Max-Min),0,1,0)
local FillCorner=Instance.new("UICorner")
FillCorner.CornerRadius=UDim.new(1,0)
FillCorner.Parent=TrackFill
local TrackKnob=Instance.new("Frame")
TrackKnob.Name="TrackKnob"
TrackKnob.Parent=TrackFill
TrackKnob.BackgroundColor3=Color3.fromRGB(255,255,255)
TrackKnob.Position=UDim2.new(1,-6,0.5,-6)
TrackKnob.Size=UDim2.new(0,12,0,12)
local KnobCorner=Instance.new("UICorner")
KnobCorner.CornerRadius=UDim.new(1,0)
KnobCorner.Parent=TrackKnob
local Dragging=false
local function UpdateSlider(inputX)
local relX=inputX-TrackBg.AbsolutePosition.X
local size=TrackBg.AbsoluteSize.X
local pos=math.clamp(relX/size,0,1)
local val=math.floor(Min+((Max-Min)*pos))
ValueLabel.Text=tostring(val)
TrackFill.Size=UDim2.new(pos,0,1,0)
if SliderValue~=val then
SliderValue=val
pcall(SldCallback,val)
end
end
TrackBg.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
Dragging=true
UpdateSlider(input.Position.X)
end
end)
TrackBg.InputChanged:Connect(function(input)
if Dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
UpdateSlider(input.Position.X)
end
end)
TrackBg.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
Dragging=false
end
end)
UserInputService.InputChanged:Connect(function(input)
if Dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
UpdateSlider(input.Position.X)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
Dragging=false
end
end)
UserInputService.InputChanged:Connect(function(input)
if Dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
UpdateSlider(input)
end
end)
end
function TabElements:CreateDropdown(dropOptions)
local DropTitle=dropOptions.Title or "下拉菜单"
local DropDesc=dropOptions.Desc or ""
local DropList=dropOptions.List or {}
local DropCallback=dropOptions.Callback or function() end
local Dropped=false
local DropFrame=Instance.new("Frame")
DropFrame.Name="DropFrame"
DropFrame.Parent=TabPage
DropFrame.BackgroundColor3=Library.Theme.MainColor
DropFrame.BackgroundTransparency=0.6
DropFrame.Size=UDim2.new(1,0,0,45)
DropFrame.ClipsDescendants=true
local DropCorner=Instance.new("UICorner")
DropCorner.CornerRadius=Library.Theme.CornerRadius
DropCorner.Parent=DropFrame
local DropStroke=Instance.new("UIStroke")
DropStroke.Color=Library.Theme.StrokeColor
DropStroke.Transparency=Library.Theme.StrokeTransparency
DropStroke.Thickness=1
DropStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
DropStroke.Parent=DropFrame
local DropBtn=Instance.new("TextButton")
DropBtn.Name="DropBtn"
DropBtn.Parent=DropFrame
DropBtn.BackgroundColor3=Color3.fromRGB(255,255,255)
DropBtn.BackgroundTransparency=1
DropBtn.Size=UDim2.new(1,0,0,45)
DropBtn.Text=""
local DropText=Instance.new("TextLabel")
DropText.Name="Title"
DropText.Parent=DropBtn
DropText.BackgroundColor3=Color3.fromRGB(255,255,255)
DropText.BackgroundTransparency=1
DropText.Position=UDim2.new(0,15,0,0)
DropText.Size=UDim2.new(1,-120,1,0)
DropText.Font=Library.Theme.Font
DropText.Text=DropTitle
DropText.TextColor3=Library.Theme.TextColor
DropText.TextSize=Library.Theme.TextSize
DropText.TextXAlignment=Enum.TextXAlignment.Left
if DropDesc~="" then
DropText.Position=UDim2.new(0,15,0,6)
DropText.Size=UDim2.new(1,-120,0,18)
local DropSub=Instance.new("TextLabel")
DropSub.Name="Desc"
DropSub.Parent=DropBtn
DropSub.BackgroundColor3=Color3.fromRGB(255,255,255)
DropSub.BackgroundTransparency=1
DropSub.Position=UDim2.new(0,15,0,24)
DropSub.Size=UDim2.new(1,-120,0,15)
DropSub.Font=Library.Theme.SubFont
DropSub.Text=DropDesc
DropSub.TextColor3=Library.Theme.SubTextColor
DropSub.TextSize=12
DropSub.TextXAlignment=Enum.TextXAlignment.Left
end
local SelectedLabel=Instance.new("TextLabel")
SelectedLabel.Name="SelectedLabel"
SelectedLabel.Parent=DropBtn
SelectedLabel.BackgroundColor3=Color3.fromRGB(255,255,255)
SelectedLabel.BackgroundTransparency=1
SelectedLabel.Position=UDim2.new(1,-135,0,0)
SelectedLabel.Size=UDim2.new(0,100,1,0)
SelectedLabel.Font=Library.Theme.SubFont
SelectedLabel.Text="未选择"
SelectedLabel.TextColor3=Library.Theme.AccentColor
SelectedLabel.TextSize=14
SelectedLabel.TextXAlignment=Enum.TextXAlignment.Right
local DropIcon=Instance.new("ImageLabel")
DropIcon.Name="DropIcon"
DropIcon.Parent=DropBtn
DropIcon.BackgroundColor3=Color3.fromRGB(255,255,255)
DropIcon.BackgroundTransparency=1
DropIcon.Position=UDim2.new(1,-25,0.5,-10)
DropIcon.Size=UDim2.new(0,20,0,20)
DropIcon.Image="rbxassetid://10137902766"
local ScrollContainer=Instance.new("ScrollingFrame")
ScrollContainer.Name="ScrollContainer"
ScrollContainer.Parent=DropFrame
ScrollContainer.Active=true
ScrollContainer.BackgroundColor3=Color3.fromRGB(255,255,255)
ScrollContainer.BackgroundTransparency=1
ScrollContainer.Position=UDim2.new(0,15,0,45)
ScrollContainer.Size=UDim2.new(1,-30,1,-50)
ScrollContainer.CanvasSize=UDim2.new(0,0,0,0)
ScrollContainer.ScrollBarThickness=2
ScrollContainer.ScrollBarImageColor3=Library.Theme.AccentColor
ScrollContainer.BorderSizePixel=0
local ScrollLayout=Instance.new("UIListLayout")
ScrollLayout.Parent=ScrollContainer
ScrollLayout.SortOrder=Enum.SortOrder.LayoutOrder
ScrollLayout.Padding=UDim.new(0,5)
local function RefreshList()
for _,v in pairs(ScrollContainer:GetChildren()) do
if v:IsA("TextButton") then v:Destroy() end
end
for i,item in pairs(DropList) do
local ItemBtn=Instance.new("TextButton")
ItemBtn.Name="Item_"..tostring(i)
ItemBtn.Parent=ScrollContainer
ItemBtn.BackgroundColor3=Color3.fromRGB(40,40,45)
ItemBtn.BackgroundTransparency=0.5
ItemBtn.Size=UDim2.new(1,-10,0,30)
ItemBtn.Font=Library.Theme.SubFont
ItemBtn.Text=tostring(item)
ItemBtn.TextColor3=Library.Theme.TextColor
ItemBtn.TextSize=14
local ItemCorner=Instance.new("UICorner")
ItemCorner.CornerRadius=UDim.new(0,6)
ItemCorner.Parent=ItemBtn
ItemBtn.MouseButton1Click:Connect(function()
SelectedLabel.Text=tostring(item)
Dropped=false
CreateTween(DropFrame,{Size=UDim2.new(1,0,0,45)},0.3)
CreateTween(DropIcon,{Rotation=0},0.3)
pcall(DropCallback,item)
end)
end
ScrollContainer.CanvasSize=UDim2.new(0,0,0,ScrollLayout.AbsoluteContentSize.Y)
end
RefreshList()
DropBtn.MouseButton1Click:Connect(function()
Dropped=not Dropped
if Dropped then
local totalHeight=45+(#DropList*35)+10
if totalHeight>200 then totalHeight=200 end
CreateTween(DropFrame,{Size=UDim2.new(1,0,0,totalHeight)},0.3)
CreateTween(DropIcon,{Rotation=180},0.3)
else
CreateTween(DropFrame,{Size=UDim2.new(1,0,0,45)},0.3)
CreateTween(DropIcon,{Rotation=0},0.3)
end
end)
end
function TabElements:CreateInput(inpOptions)
local InpTitle=inpOptions.Title or "输入框"
local InpDesc=inpOptions.Desc or ""
local InpPlaceholder=inpOptions.Placeholder or "请输入文本..."
local InpCallback=inpOptions.Callback or function() end
local InputFrame=Instance.new("Frame")
InputFrame.Name="InputFrame"
InputFrame.Parent=TabPage
InputFrame.BackgroundColor3=Library.Theme.MainColor
InputFrame.BackgroundTransparency=0.6
InputFrame.Size=UDim2.new(1,0,0,70)
local InpCorner=Instance.new("UICorner")
InpCorner.CornerRadius=Library.Theme.CornerRadius
InpCorner.Parent=InputFrame
local InpStroke=Instance.new("UIStroke")
InpStroke.Color=Library.Theme.StrokeColor
InpStroke.Transparency=Library.Theme.StrokeTransparency
InpStroke.Thickness=1
InpStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
InpStroke.Parent=InputFrame
local InpText=Instance.new("TextLabel")
InpText.Name="Title"
InpText.Parent=InputFrame
InpText.BackgroundColor3=Color3.fromRGB(255,255,255)
InpText.BackgroundTransparency=1
InpText.Position=UDim2.new(0,15,0,8)
InpText.Size=UDim2.new(1,-30,0,18)
InpText.Font=Library.Theme.Font
InpText.Text=InpTitle
InpText.TextColor3=Library.Theme.TextColor
InpText.TextSize=Library.Theme.TextSize
InpText.TextXAlignment=Enum.TextXAlignment.Left
if InpDesc~="" then
local InpSub=Instance.new("TextLabel")
InpSub.Name="Desc"
InpSub.Parent=InputFrame
InpSub.BackgroundColor3=Color3.fromRGB(255,255,255)
InpSub.BackgroundTransparency=1
InpSub.Position=UDim2.new(0,15,0,26)
InpSub.Size=UDim2.new(1,-30,0,15)
InpSub.Font=Library.Theme.SubFont
InpSub.Text=InpDesc
InpSub.TextColor3=Library.Theme.SubTextColor
InpSub.TextSize=12
InpSub.TextXAlignment=Enum.TextXAlignment.Left
end
local TextBoxBg=Instance.new("Frame")
TextBoxBg.Name="TextBoxBg"
TextBoxBg.Parent=InputFrame
TextBoxBg.BackgroundColor3=Color3.fromRGB(30,30,35)
TextBoxBg.Position=UDim2.new(0,15,1,-35)
TextBoxBg.Size=UDim2.new(1,-30,0,28)
local BgCorner=Instance.new("UICorner")
BgCorner.CornerRadius=UDim.new(0,6)
BgCorner.Parent=TextBoxBg
local TextBoxStroke=Instance.new("UIStroke")
TextBoxStroke.Color=Library.Theme.AccentColor
TextBoxStroke.Transparency=1
TextBoxStroke.Thickness=1
TextBoxStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
TextBoxStroke.Parent=TextBoxBg
local TextBox=Instance.new("TextBox")
TextBox.Name="TextBox"
TextBox.Parent=TextBoxBg
TextBox.BackgroundColor3=Color3.fromRGB(255,255,255)
TextBox.BackgroundTransparency=1
TextBox.Position=UDim2.new(0,10,0,0)
TextBox.Size=UDim2.new(1,-20,1,0)
TextBox.Font=Library.Theme.SubFont
TextBox.PlaceholderText=InpPlaceholder
TextBox.Text=""
TextBox.TextColor3=Library.Theme.TextColor
TextBox.TextSize=14
TextBox.TextXAlignment=Enum.TextXAlignment.Left
TextBox.ClearTextOnFocus=false
TextBox.Focused:Connect(function()
CreateTween(TextBoxStroke,{Transparency=0},0.3)
end)
TextBox.FocusLost:Connect(function(enterPressed)
CreateTween(TextBoxStroke,{Transparency=1},0.3)
if enterPressed then
pcall(InpCallback,TextBox.Text)
end
end)
end
function TabElements:CreateLabel(lblOptions)
local LblText=lblOptions.Text or "信息标签"
local LblColor=lblOptions.Color or Library.Theme.TextColor
local LabelFrame=Instance.new("Frame")
LabelFrame.Name="LabelFrame"
LabelFrame.Parent=TabPage
LabelFrame.BackgroundColor3=Library.Theme.MainColor
LabelFrame.BackgroundTransparency=0.8
LabelFrame.Size=UDim2.new(1,0,0,35)
local LblCorner=Instance.new("UICorner")
LblCorner.CornerRadius=Library.Theme.CornerRadius
LblCorner.Parent=LabelFrame
local LblStroke=Instance.new("UIStroke")
LblStroke.Color=Library.Theme.StrokeColor
LblStroke.Transparency=0.9
LblStroke.Thickness=1
LblStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
LblStroke.Parent=LabelFrame
local TextDisplay=Instance.new("TextLabel")
TextDisplay.Name="TextDisplay"
TextDisplay.Parent=LabelFrame
TextDisplay.BackgroundColor3=Color3.fromRGB(255,255,255)
TextDisplay.BackgroundTransparency=1
TextDisplay.Position=UDim2.new(0,15,0,0)
TextDisplay.Size=UDim2.new(1,-30,1,0)
TextDisplay.Font=Library.Theme.SubFont
TextDisplay.Text=LblText
TextDisplay.TextColor3=LblColor
TextDisplay.TextSize=14
TextDisplay.TextXAlignment=Enum.TextXAlignment.Center
end
function TabElements:CreateSection(secOptions)
local SecTitle=secOptions.Title or "分隔线"
local SecFrame=Instance.new("Frame")
SecFrame.Name="SecFrame"
SecFrame.Parent=TabPage
SecFrame.BackgroundColor3=Color3.fromRGB(255,255,255)
SecFrame.BackgroundTransparency=1
SecFrame.Size=UDim2.new(1,0,0,30)
local SecText=Instance.new("TextLabel")
SecText.Name="Title"
SecText.Parent=SecFrame
SecText.BackgroundColor3=Color3.fromRGB(255,255,255)
SecText.BackgroundTransparency=1
SecText.Position=UDim2.new(0,10,0,0)
SecText.Size=UDim2.new(1,-20,1,0)
SecText.Font=Library.Theme.Font
SecText.Text=SecTitle
SecText.TextColor3=Library.Theme.AccentColor
SecText.TextSize=15
SecText.TextXAlignment=Enum.TextXAlignment.Left
local Line=Instance.new("Frame")
Line.Name="Line"
Line.Parent=SecFrame
Line.BackgroundColor3=Library.Theme.StrokeColor
Line.BackgroundTransparency=0.8
Line.Position=UDim2.new(0,10,1,-5)
Line.Size=UDim2.new(1,-20,0,1)
Line.BorderSizePixel=0
end
return TabElements
end
return WindowElements
end
return Library
