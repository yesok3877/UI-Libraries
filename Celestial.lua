local Library = {}
local Window = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Color = {Background = Color3.fromRGB(20, 20, 20), Border = Color3.fromRGB(0, 0, 0), Gradient = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))}}
local Drag = {Bool, Start, Input, Object, Position}
local Blacklist = {"Unknown", "W", "A", "S", "D", "Slash", "Tab", "Backspace", "Escape"}
local Keybind = {}
local Rainbow

coroutine.wrap(function()
    Rainbow = Color3.fromHSV(tick() % 5 / 5, 1, 1)
end)()

function Library:Create(Object, Data)
    Data = (typeof(Data) == "table" and Data)
    Object = Instance.new(Object)

    syn.protect_gui(Object)
    Object.Name = syn.crypto.random(math.random(12, 16))

    for Property, Value in next, Data do
        Object[Property] = Value
    end

    return Object
end

function Library:Window(Name, Accent)
    Window.Name = (Name or "Window")
    Window.Accent = (Accent or Color3.fromRGB(27, 168, 240))
    Window.Gui = Library:Create("ScreenGui", {
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = math.huge,
        ResetOnSpawn = false
    })
    Window.Watermark = Library:Create("Folder", {Parent = Window.Gui})
    Window.Notification = Library:Create("Folder", {Parent = Window.Gui})
    Window.Keybind = Library:Create("Folder", {Parent = Window.Gui})
    Window.Frame = Library:Create("Frame", {Parent = Window.Gui})
end

function Library:Watermark(Text, Position)
    local Frame = Library:Create("Frame", {
        Parent = Window.Watermark,
        BackgroundColor3 = Color.Background,
        BorderColor3 = Color.Border,
        Position = (Position or UDim2.new(0.06, 0, -0.026, 0)),
        Size = UDim2.new(0, 291, 0, 21)
    })
    local Background = Library:Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(0, 289, 0, 19)
    })

    Library:Create("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))},
        Rotation = 90,
        Parent = Background
    })
    Library:Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Window.Accent,
        BorderColor3 = Color.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(0, 289, 0, 2)
    })
    Library:Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 3),
        Size = UDim2.new(0, 284, 0, 17),
        ZIndex = 2,
        Font = Enum.Font.Code,
        Text = (Text or "Text"),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextStrokeTransparency = 0.3,
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

function Library:Notification(Text, Duration)
    local In = Enum.EasingDirection.In
    local Out = Enum.EasingDirection.Out
    local Quad = Enum.EasingStyle.Quad
    local Scale = 0.005
    local Frame = Library:Create("Frame", {
        Parent = Window.Notification,
        BackgroundTransparency = 1,
        BackgroundColor3 = Color.Background,
        BorderColor3 = Color.Border,
        Position = UDim2.new(-1, 0, 0, 0),
        Size = UDim2.new(0, 291, 0, 21)
    })
    local Background = Library:Create("Frame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(0, 289, 0, 19)
    })
    local Gradient = Library:Create("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))},
        Rotation = 90,
        Parent = Background
    })
    local Accent = Library:Create("Frame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        BackgroundColor3 = Window.Accent,
        BorderColor3 = Color.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(0, 2, 0, 19)
    })
    local Label = Library:Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0, 2),
        Size = UDim2.new(0, 281, 0, 18),
        ZIndex = 2,
        Font = Enum.Font.Code,
        Text = (Text or ""),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextStrokeTransparency = 0.3,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local function TweenNotification(Information, Transparency)
        TweenService:Create(Frame, Information, {BackgroundTransparency = Transparency}):Play()
        TweenService:Create(Background, Information, {BackgroundTransparency = Transparency}):Play()
        TweenService:Create(Accent, Information, {BackgroundTransparency = Transparency}):Play()
        TweenService:Create(Label, Information, {TextTransparency = Transparency}):Play()
    end

    for Notification = 1, (#Window.Notification:GetChildren() - 1) do
        Scale = (Scale + 0.029)
    end
    Frame.Position = UDim2.new(-0.2, 0, Scale, 0)
    
    Frame:TweenPosition(UDim2.new(0.06, 0, Scale, 0), In, Quad, 0.3, true, function()
        wait(Duration or 4)
        Frame:TweenPosition(UDim2.new(-0.2, 0, Scale, 0), Out, Quad, 2, false, function() Frame:Destroy() end)
        TweenNotification(TweenInfo.new(0.4, Quad, Out), 1)
    end)
    TweenNotification(TweenInfo.new(0.5, Quad, In), 0)
end

return Library
