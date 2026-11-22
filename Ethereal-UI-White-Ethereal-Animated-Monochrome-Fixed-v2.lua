-- Ethereal Product

--// [ ENVIRONMENT ] ---------------------------------------------------------
if typeof(getgenv) ~= 'function' then
    getgenv = function()
        return _G
    end
end

if typeof(cloneref) ~= 'function' then
    cloneref = function(Service)
        return Service
    end
end

local ENV = getgenv()

-- Defaults for every global the library / notify code reads.
local DEFAULTS = {
    Product_Name = 'Ethereal',
    Product_Version = 'v2.0.0',
    Product_Text = 'Ethereal',
    Config_Enabled = true,
    Save_Enabled = true,
    Interface_Keybind_Enabled = true,
    Tweaks_Enabled = {},
}
for Key, Value in pairs(DEFAULTS) do
    if ENV[Key] == nil then
        ENV[Key] = Value
    end
end

--// [ LIBRARY ] ------------------------------------------------------------
local Library = (function()

--[[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣷⢸⣿⣿⡜⢯⣷⡌⡻⣿⣿⣿⣆⢈⠻⠿⢿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡁⢳⣿⣿⣿⣿⣿⣿⡜⣿⣿⣧⢀⢻⣷⠰⠈⢿⣿⣿⣧⢣⠉⠑⠪⢙⠿⠿⠿⠿⠿⠿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣱⡇⡞⣿⣿⣿⣿⣿⣿⡇⣿⣿⡏⡄⣧⠹⡇⠧⠈⢻⣿⣿⡇⢧⢢⠀⠀⠑⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣇⢃⢿⣿⣿⣿⣿⣿⣷⣿⣿⠇⢃⣡⣤⡹⠐⣿⣀⢻⣿⣿⢸⡎⠳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣾⣿⣿⠘⡸⣿⣿⣿⣿⣿⣿⣿⡿⣰⣿⣿⢟⡷⠈⠋⠃⠎⢿⣿⡏⣿⠀⠘⢆⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⡐⢹⣿⣿⡐⢡⢹⣿⣿⣿⣿⡏⣿⢣⣿⣿⡑⠁⠔⠀⠉⠉⠢⡘⣿⡇⣿⡇⠀⡀⠡⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠘⣿⣿⣇⠇⢣⢻⣿⣿⣿⡇⢇⣾⣿⣿⡆⢸⣤⡀⠚⢂⠀⢡⢿⡇⣿⡇⠀⢿⠀⠀⠄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠠⠹⣿⣿⡘⣆⢣⠻⣿⣿⢈⣾⣿⣿⣿⣶⣸⣏⢀⣬⣋⡼⣠⢸⢹⣿⡇⢠⣼⠙⡄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡇⠁⠹⣿⣇⠹⡃⠃⠙⡇⠘⢿⣿⣿⣿⣿⣿⣏⣓⣉⣭⣴⣿⠘⢸⣿⠁⠘⠋⠀⠹⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⠀⠀⠈⢿⣇⠂⣷⠄⠐⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢠⢸⡏⠀⢀⣠⣴⣾⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⠀⠀⠀⠙⠆⠈⠢⠲⠥⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡞⣸⠁⠀⢸⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠄⠃⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⡏⠹⣿⣿⡿⠫⠊⠀⠀⠀⣶⠀⢻⣿⣿⣿⣿⡿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠻⠿⠿⠿⢋⠀⠀⠀⠀⢀⣼⣿⡆⠈⣿⣿⣿⡟⣱⡷⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢁⣁⡀⠨⣛⠿⠶⠄⢀⣠⣾⣿⣿⣷⠀⢹⣿⡟⣴⠈⢃⣶⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⡄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠈⣿⣿⡿⠀⡀⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⠻⣿⣿⢀⠙⠻⠿⣿⣿⣿⣿⣿⣿⡇⠁⣿⠟⡀⠈⣧⢰⣿⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠿⠴⠮⣥⠻⢧⣤⣄⣀⡉⢩⣭⣍⣃⣀⣩⠎⢀⣼⠉⣼⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠁⣛⠓⢒⣒⣢⡭⢁⡈⠿⠿⠟⠹⠛⠁⠀⠀⠀⠰⠃⠂⠀⠀⠀⠀⠀⠀

@ Ethereal | © COPYRIGHT
--// Hey, before skidding read — LICENSE ✨.]]

local EtherealIsTheBestDev = cloneref or function(service) return service end
if typeof(EtherealIsTheBestDev) ~= 'function' then return warn('[Product] ─ Dependency Issue. ✨') end

local UserInputService = EtherealIsTheBestDev(game:GetService('UserInputService'))
local TweenService = EtherealIsTheBestDev(game:GetService('TweenService'))
local RunService = EtherealIsTheBestDev(game:GetService('RunService'))
local Workspace = EtherealIsTheBestDev(game:GetService('Workspace'))
local CoreGui = EtherealIsTheBestDev(game:GetService('CoreGui'))
local Players = EtherealIsTheBestDev(game:GetService('Players'))
local Stats = EtherealIsTheBestDev(game:GetService('Stats'))

local Local_Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Place_Id = game.PlaceId

local Library = {
    Flags = {},
    Control_Objects = {},
    Tabs = {},
    Tab_Buttons = {},
    Tab_Icons = {},
    Search_Items = {},
	Saved_Config = {},
    Active_Tab = 1,
    Visible = true,
    Minimized = false,
    Tweening = false,
    Auto_Debounce = false,
    Save_Dirty = false,
    Loading = false,
    Open_Dropdown = nil,
    Capturing = nil,
    Switching = false,
    Searching = false
}

Library.__index = Library

function Library:exist()
    if not self.Gui then return end
    if not self.Gui.Parent then return end
    return true
end

if getgenv then
    getgenv().Ethereal_Loaded = true
end

local Device = {
    ['Mobile'] = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
}

local File_Support = pcall(function() 
    if not isfolder('Ethereal') then
        makefolder('Ethereal')
    end
end)

local Theme = {
    Accent = Color3.fromRGB(24, 24, 27),
    Accent_Hover = Color3.fromRGB(55, 55, 60),
    Panel = Color3.fromRGB(248, 248, 250),
    Panel_2 = Color3.fromRGB(239, 239, 242),
    Panel_3 = Color3.fromRGB(225, 225, 230),
    Border = Color3.fromRGB(195, 195, 202),
    Text = Color3.fromRGB(24, 24, 28),
    Muted = Color3.fromRGB(76, 76, 84),
    Dim = Color3.fromRGB(112, 112, 120),
    Not_Enabled = Color3.fromRGB(205, 205, 211),
    White = Color3.fromRGB(255, 255, 255),
}

local Raw_Connections = {}

Connection = setmetatable({}, {
    __newindex = function(_, Key, Value)
        if Raw_Connections[Key] then
            pcall(function() Raw_Connections[Key]:Disconnect() end)
            Raw_Connections[Key] = nil
        end
        if Value then
            Raw_Connections[Key] = Value
        end
    end,
    __index = function(_, Key)
        return Raw_Connections[Key]
    end,
})

local function Clear_All_Connections()
    for Key, Conn in pairs(Raw_Connections) do
        pcall(function() Conn:Disconnect() end)
        Raw_Connections[Key] = nil
    end
end

function Library:clear()
    Clear_All_Connections()
    for _, object in ipairs(CoreGui:GetChildren()) do
        if object.Name ~= 'Ethereal' then
            continue
        end
        object:Destroy()
    end
end

function Library:Destroy()
    self:clear()
    self.Flags = {}
    self.Control_Objects = {}
    self.Tabs = {}
    self.Tab_Buttons = {}
    self.Tab_Icons = {}
    self.Search_Items = {}
    self.Visible = false
    self.Minimized = false
    self.Tweening = false
    if getgenv then
        getgenv().Ethereal_Loaded = false
    end
end

local Badge_Colors = {
    Hot = {
        Background = Color3.fromRGB(50, 20, 25), 
        Text = Theme.Accent, 
        Border = Color3.fromRGB(100, 40, 50)
    },
    New = {
        Background = Color3.fromRGB(16, 46, 36),
        Text = Color3.fromRGB(96, 212, 160), 
        Border = Color3.fromRGB(40, 110, 80)
    },
    Beta = {
        Background = Color3.fromRGB(32, 22, 55), 
        Text = Color3.fromRGB(176, 136, 238), 
        Border = Color3.fromRGB(80, 56, 140)
    },
	Risky = {
        Background = Color3.fromRGB(54, 42, 12), 
        Text = Color3.fromRGB(230, 188, 64), 
        Border = Color3.fromRGB(120, 92, 30)
    }
}

local Spring_Style, Spring_Direction = Enum.EasingStyle.Back, Enum.EasingDirection.Out
local Animated_Buttons = setmetatable({}, {__mode = 'k'})

local function Create_Instance(Class_Name, Properties, Parent)
    local Object = Instance.new(Class_Name)
    for Key, Value in pairs(Properties) do
        Object[Key] = Value
    end
    if Parent then Object.Parent = Parent end

    if (Class_Name == 'TextButton' or Class_Name == 'ImageButton')
        and Object.BackgroundTransparency < 1 then
        Animated_Buttons[Object] = Object.BackgroundColor3
    end

    return Object
end

local function Create_Tween(Object, Duration, Properties, Easing_Style, Easing_Direction)
    local Tween_Info = TweenInfo.new(Duration, Easing_Style or Enum.EasingStyle.Quint, Easing_Direction or Enum.EasingDirection.Out)
    local Tween_Object = TweenService:Create(Object, Tween_Info, Properties)
    Tween_Object:Play()
    return Tween_Object
end

local function Create_Corner(Parent, Radius)
    return Create_Instance('UICorner', {
        CornerRadius = UDim.new(0, Radius or 8)
    }, Parent)
end

local function Create_Sound(Parent, Id, Volume)
    return Create_Instance('Sound', {
        Name = 'dsc.gg/getnoryn',
        SoundId = 'rbxassetid://' .. tostring(Id),
        Volume = Volume or 0.5,
    }, Parent)
end

local function Create_Stroke(Parent, Color, Thickness, Transparency)
    return Create_Instance('UIStroke', {
        Color = Color or Theme.Border,
        Thickness = Thickness or 1,
        Transparency = Transparency or 0,
    }, Parent)
end

local function Color_To_Hex(Color)
    return string.format('#%02X%02X%02X', math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5))
end

local function Hex_To_Color(Hex)
    Hex = tostring(Hex):gsub('#', '')
    if #Hex ~= 6 then return nil end
    local Red = tonumber(Hex:sub(1, 2), 16)
    local Green = tonumber(Hex:sub(3, 4), 16)
    local Blue = tonumber(Hex:sub(5, 6), 16)
    if Red and Green and Blue then 
        return Color3.fromRGB(Red, Green, Blue) 
    end
    return nil
end

local function Get_Config_Path()
    return `Ethereal/Data/Configs/{tostring(Place_Id)}.lua`
end

local function Ensure_Folders()
    pcall(function()
        if not isfolder('Ethereal') then 
            makefolder('Ethereal')              
        end
        if not isfolder('Ethereal/Data') then 
            makefolder('Ethereal/Data')         
        end
        if not isfolder('Ethereal/Data/Configs') then 
            makefolder('Ethereal/Data/Configs') 
        end
    end)
end

local function Serialize_Value(Value)
    local Value_Type = typeof(Value)
    if Value_Type == 'string'  then 
        return string.format('%q', Value) 
    end
    if Value_Type == 'boolean' then 
        return tostring(Value) 
    end
    if Value_Type == 'number'  then
        if Value ~= Value then 
            return '0' 
        end
        if Value == math.huge or Value == -math.huge then 
            return '0' 
        end
        return tostring(Value)
    end
    if Value_Type == 'Color3' then 
        return string.format('%q', Color_To_Hex(Value)) 
    end
    if Value_Type == 'EnumItem' then 
        return string.format('%q', tostring(Value):gsub('Enum.KeyCode.', '')) 
    end
    return string.format('%q', tostring(Value))
end

local function Save_Config(States)
    Ensure_Folders()
    local Line = 'return { '
    for Flag, Value in pairs(States) do
        Line = Line .. string.format(
            '["%s"] = %s, ',
            tostring(Flag):gsub('"', '\\"'),
            Serialize_Value(Value)
        )
    end
    Line = Line .. '}'
    local Success = pcall(writefile, Get_Config_Path(), Line)
    return Success
end

local function Load_Config()
    local Success, Result = pcall(function()
        local Path = Get_Config_Path()
        if isfile(Path) then
            local Function = loadstring(readfile(Path))
            if Function then return Function() end
        end
        return nil
    end)
    if Success and type(Result) == 'table' then 
        return Result 
    end
    return nil
end

print('Interface by Neon Twillight') --// [Attribution required if removed 💖]

function Library.New()
    local self = setmetatable({}, Library)

    self:clear()
	self.Saved_Config = {}

	local Config_Was_Loaded = false
    if not (getgenv and getgenv().Config_Enabled == false) then
        self.Loading = true
        local Loaded = Load_Config()
        self.Saved_Config = Loaded or {}
        self.Loading = false
        if Loaded and next(Loaded) ~= nil then
            Config_Was_Loaded = true
        end
    end

    local Keybind = self.Interface_Keybind or Enum.KeyCode.N
    local Title = (getgenv and getgenv().Product_Name) or 'Ethereal'
    local Version = (getgenv and getgenv().Product_Version) or ''

    local Existing = CoreGui:FindFirstChild('Ethereal')
    if Existing then Existing:Destroy() end

    local Screen_Gui = Create_Instance('ScreenGui', {
        Name = 'Ethereal',
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    local Sounds = {
        ['Tab'] = 6895079853,
        ['Minimize'] = 104184340183231
    }

    self.Gui = Screen_Gui
    self.Custom_Size = Vector2.new(700, 450)
	local Volume = self.Clicks_Volume_Enabled or 1

    local Main_Panel = Create_Instance('CanvasGroup', {
        Name = 'Panel',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(700, 450),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        GroupTransparency = 1,
        ZIndex = 10,
    }, Screen_Gui)

    Create_Corner(Main_Panel, 14)
    local Panel_Gradient = Create_Instance('UIGradient', {
        Rotation = 90,
        Offset = Vector2.new(0, -1),
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(232, 232, 238)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(198, 198, 207)),
        }),
    }, Main_Panel)

    -- One lightweight repeating tween moves the monochrome gradient.
    local Gradient_Tween = TweenService:Create(
        Panel_Gradient,
        TweenInfo.new(14, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Offset = Vector2.new(0, 1)}
    )
    Gradient_Tween:Play()

    -- Shared light monochrome palette for the UI controls and text.
    local Animated_UI_Colors = {
        Light = Color3.fromRGB(250, 250, 253),
        Mid = Color3.fromRGB(232, 232, 238),
        Soft = Color3.fromRGB(214, 214, 222),
        Text = Color3.fromRGB(35, 35, 42),
        Muted = Color3.fromRGB(92, 92, 102),
    }

    -- Buttons keep readable contrast and gently shift within the same grayscale palette.
    task.spawn(function()
        while Main_Panel and Main_Panel.Parent do
            for Button, Base in pairs(Animated_Buttons) do
                if Button and Button.Parent and Button.BackgroundTransparency < 1 then
                    local Is_Dark = (Base.R + Base.G + Base.B) / 3 < 0.28
                    local Target = Is_Dark
                        and Base:Lerp(Color3.fromRGB(62, 62, 69), 0.24)
                        or Base:Lerp(Color3.fromRGB(211, 211, 218), 0.22)

                    TweenService:Create(
                        Button,
                        TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                        {BackgroundColor3 = Target}
                    ):Play()
                end
            end

            task.wait(3.2)

            for Button, Base in pairs(Animated_Buttons) do
                if Button and Button.Parent and Button.BackgroundTransparency < 1 then
                    TweenService:Create(
                        Button,
                        TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                        {BackgroundColor3 = Base}
                    ):Play()
                end
            end

            task.wait(9)
        end
    end)

    self.Panel = Main_Panel

    task.spawn(function()
        local Bright = true
        while Main_Panel and Main_Panel.Parent do
            Bright = not Bright
            for _, Object in ipairs(Main_Panel:GetDescendants()) do
                if not Object.Parent then
                    continue
                end

                if Object:IsA('TextLabel') or Object:IsA('TextButton') or Object:IsA('TextBox') then
                    local Base = Object:GetAttribute('EtherealBaseTextColor')
                    if not Base then
                        Base = Object.TextColor3
                        Object:SetAttribute('EtherealBaseTextColor', Base)
                    end
                    local Target = Bright
                        and Base:Lerp(Animated_UI_Colors.Text, 0.16)
                        or Base:Lerp(Animated_UI_Colors.Muted, 0.10)
                    TweenService:Create(Object, TweenInfo.new(3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        TextColor3 = Target
                    }):Play()
                end

                if Object:IsA('TextButton') or Object:IsA('ImageButton') then
                    local Base = Object:GetAttribute('EtherealBaseBackground')
                    if not Base then
                        Base = Object.BackgroundColor3
                        Object:SetAttribute('EtherealBaseBackground', Base)
                    end
                    local Target = Bright
                        and Base:Lerp(Animated_UI_Colors.Light, 0.12)
                        or Base:Lerp(Animated_UI_Colors.Soft, 0.10)
                    TweenService:Create(Object, TweenInfo.new(3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        BackgroundColor3 = Target
                    }):Play()
                end
            end
            task.wait(14)
        end
    end)

	local Interface_Scale = Create_Instance('UIScale', {
    	Scale = 1,
	}, Main_Panel)

	self.Interface_Scale = Interface_Scale

	local function Update_Interface_Scale(Instant)
    	if not Camera then return end
    	local Viewport_Y = Camera.ViewportSize.Y
    	local Target_Scale = math.clamp(Viewport_Y / 1080, 1, 1.6)

    	if Instant then
        	Interface_Scale.Scale = Target_Scale
    	else
        	Create_Tween(Interface_Scale, 0.3, {Scale = Target_Scale}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    	end
	end

	Update_Interface_Scale(true)

	Connection.Viewport_Scale = Workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
    	Camera = Workspace.CurrentCamera
    	Update_Interface_Scale(true)
    	if Camera then
        	Connection.Viewport_Resize = Camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
            	Update_Interface_Scale(false)
        	end)
    	end
	end)

	if Camera then
    	Connection.Viewport_Resize = Camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
        	Update_Interface_Scale(false)
    	end)
	end

	local function Safe_Clamp_X(Abs_X, Half_W, Viewport_X)
        local Min_X, Max_X = Half_W, Viewport_X - Half_W
        if Min_X > Max_X then
            return Viewport_X / 2
        end
        return math.clamp(Abs_X, Min_X, Max_X)
    end

    local function Safe_Clamp_Y(Abs_Y, Half_H, Viewport_Y)
        local Min_Y, Max_Y = Half_H, Viewport_Y - Half_H
        if Min_Y > Max_Y then
            return Viewport_Y / 2
        end
        return math.clamp(Abs_Y, Min_Y, Max_Y)
    end

	local function Drag_Duration()
        local Smoothness = tonumber(self.Interface_Drag_Smoothness_Enabled)
        if not Smoothness or Smoothness < 0 then Smoothness = 1 end
        return 0.05 * Smoothness
    end

    local function Button_Drag_Duration()
        local Smoothness = tonumber(self.Interface_Button_Drag_Smoothness_Enabled)
        if not Smoothness or Smoothness < 0 then Smoothness = 1 end
        return 0.05 * Smoothness
    end

    local Title_Bar = Create_Instance('Frame', {
        Name = 'Top',
        Size = UDim2.new(1, 0, 0, 46), 
        BackgroundTransparency = 1, 
        ZIndex = 11,
    }, Main_Panel)

    do
        local Dragging, Drag_Start, Start_Position = false, nil, nil
        local Drag_Handle = Create_Instance('TextButton', {
            Name = 'Drag',
            Size = UDim2.new(1, 0, 0, 46),  
            BackgroundTransparency = 1,
            Text = '', 
            ZIndex = 50, 
            AutoButtonColor = false,
        }, Title_Bar)

        Drag_Handle.InputBegan:Connect(function(Input)
            if self.Interface_Drag_Enabled == false then return end
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging, Drag_Start, Start_Position = true, Input.Position, Main_Panel.Position
            end
       	end)

        Drag_Handle.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                Dragging = false 
            end
        end)

        Connection.Title_Drag_Input = UserInputService.InputChanged:Connect(function(Input)
            if not Dragging then return end
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then 
                return 
            end
            local Delta = Input.Position - Drag_Start
            local Viewport = Screen_Gui.AbsoluteSize
            local Abs_X = Start_Position.X.Scale * Viewport.X + Start_Position.X.Offset + Delta.X
            local Abs_Y = Start_Position.Y.Scale * Viewport.Y + Start_Position.Y.Offset + Delta.Y
            local Half_W = Main_Panel.AbsoluteSize.X / 2
            local Half_H = Main_Panel.AbsoluteSize.Y / 2
            local Freedom = self.Freedom_Enabled == true
            if not Freedom then
                Abs_X = Safe_Clamp_X(Abs_X, Half_W, Viewport.X)
                Abs_Y = Safe_Clamp_Y(Abs_Y, Half_H, Viewport.Y)
            end
            Create_Tween(Main_Panel, Drag_Duration(), {Position = UDim2.new(0, Abs_X, 0, Abs_Y)}, Enum.EasingStyle.Linear)
        end)
    end

	task.spawn(function()
        local Was_Free = self.Freedom_Enabled == true
        local Was_Drag_Enabled = self.Interface_Drag_Enabled ~= false
        while Main_Panel and Main_Panel.Parent do
            local Freedom = self.Freedom_Enabled == true
            local Drag_Enabled = self.Interface_Drag_Enabled ~= false

            local Viewport_Now = Screen_Gui.AbsoluteSize
            local Panel_Size_Now = Main_Panel.AbsoluteSize
            local Is_Oversized = Panel_Size_Now.X > Viewport_Now.X or Panel_Size_Now.Y > Viewport_Now.Y
            local Freedom_Turned_Off = Was_Free and not Freedom
            local Drag_Turned_Off = Was_Drag_Enabled and not Drag_Enabled

            local Should_Fit = Is_Oversized or Freedom_Turned_Off

            if Drag_Turned_Off and not Should_Fit then
                Create_Tween(Main_Panel, 0.4, {
                    Position = UDim2.fromScale(0.5, 0.5),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end

            if Should_Fit then
                local Viewport = Viewport_Now
                local Current_Size = Panel_Size_Now

                local New_Width = math.min(Current_Size.X, Viewport.X)
                local New_Height = math.min(Current_Size.Y, Viewport.Y)

                if New_Width ~= Current_Size.X or New_Height ~= Current_Size.Y then
                    Create_Tween(Main_Panel, 0.35, {
                        Size = UDim2.fromOffset(New_Width, New_Height)
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

                    if not self.Minimized then
                        self.Custom_Size = Vector2.new(New_Width, New_Height)
                    end
                end

                local Half_W = New_Width / 2
                local Half_H = New_Height / 2
                local Current_Pos = Main_Panel.Position
                local Abs_X = Current_Pos.X.Scale * Viewport.X + Current_Pos.X.Offset
                local Abs_Y = Current_Pos.Y.Scale * Viewport.Y + Current_Pos.Y.Offset
                Abs_X = Safe_Clamp_X(Abs_X, Half_W, Viewport.X)
                Abs_Y = Safe_Clamp_Y(Abs_Y, Half_H, Viewport.Y)
                Create_Tween(Main_Panel, 0.35, {Position = UDim2.new(0, Abs_X, 0, Abs_Y)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end

            Was_Free = Freedom
            Was_Drag_Enabled = Drag_Enabled
            task.wait(0.1)
        end
    end)

	task.spawn(function()
        local Was_Dynamic = self.Dynamic_Tabs_Enabled ~= false
        local Toggle_Reaction_Speed = 0.12
        while Main_Panel and Main_Panel.Parent do
            local Dynamic_Tabs_Enabled = self.Dynamic_Tabs_Enabled ~= false
            if Dynamic_Tabs_Enabled ~= Was_Dynamic then
                for Tab_Index, _ in ipairs(self.Tab_Buttons) do
                    local Icon_Object = self.Tab_Icons[Tab_Index]
                    local Is_Active = (Tab_Index == self.Active_Tab)
                    if Icon_Object and not Is_Active then
                        Icon_Object.Rotation = 0
                        Icon_Object.Position = UDim2.fromOffset(0, 0)
                        if Dynamic_Tabs_Enabled then
                            Create_Tween(Icon_Object, Toggle_Reaction_Speed, {
                                Size = UDim2.fromOffset(0, 16),
                                ImageTransparency = 1,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                        else
                            Create_Tween(Icon_Object, Toggle_Reaction_Speed, {
                                Size = UDim2.fromOffset(16, 16),
                                ImageTransparency = 0,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                        end
                    end
                end
            end
            Was_Dynamic = Dynamic_Tabs_Enabled
            task.wait(0.1)
        end
    end)

	Create_Instance('Frame', {
    	Name = 'Accent',
    	Position = UDim2.new(0, 0, 0, 0),
    	Size = UDim2.new(1, 0, 0, 3),
    	BackgroundColor3 = Theme.Accent,
    	BorderSizePixel = 0,
    	ZIndex = 50,
	}, Title_Bar)

    local Warper = Create_Instance('Frame', {
        Name = 'Warper',
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 5, 0.5, 0),
        Size = UDim2.fromOffset(50, 40),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 20,
    }, Title_Bar)

    local Animated = Create_Instance('ImageLabel', {
        Name = 'Animated',
        Size = UDim2.new(3, 0, 3, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://133009150415671',
        ImageTransparency = 1,
        ZIndex = 21,
    }, Warper)

    do
        local Warper_Framerate = self.Animation_Frame_Rate or 12
        local Current_Frame = 1
        local Total_Frames = 8
        local Row_Count = 3
        local Column_Count = 3
        local Last_Time = tick()
        local Animation_Connection
        Animation_Connection = RunService.Heartbeat:Connect(function()
            if not Animated or not Animated.Parent then 
                Animation_Connection:Disconnect() 
                return 
            end
            local Real_Time = tick()
            if Real_Time - Last_Time >= 1 / Warper_Framerate then
                Current_Frame = (Current_Frame % Total_Frames) + 1
                local Current_Column = ((Current_Frame - 1) % Column_Count) + 1
                local Current_Row = math.floor((Current_Frame - 1) / Column_Count) + 1
                Animated.Position = UDim2.new(-(Current_Column - 1), 0, -(Current_Row - 1), 0)
                Last_Time = Real_Time
            end
        end)
        Create_Tween(Animated, 0.8, {ImageTransparency = 0})
    end

    local Title_Label = Create_Instance('TextLabel', {
        Name = 'Name',
        Position = UDim2.fromOffset(52, 0), 
        Size = UDim2.new(0, 300, 1, 0),
        BackgroundTransparency = 1, 
        FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
        TextSize = 20,
        Text = Title, 
        TextColor3 = Theme.Accent, 
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true, 
        ZIndex = 12,
    }, Title_Bar)

    self.Title_Label = Title_Label

    -- The title ("Ethereal") at 20px is wider than the old fixed 120px slot,
    -- so the version text was clipping through it. Measure the title and put
    -- the version just after it, falling back to a fixed slot if TextService
    -- is not available.
    local Title_Width = 96
    pcall(function()
        local TextService = EtherealIsTheBestDev(game:GetService('TextService'))
        Title_Width = TextService:GetTextSize(Title, 20, Title_Label.FontFace, Vector2.new(1000, 40)).X
        Title_Width = math.clamp(Title_Width, 0, 240)
    end)

    Create_Instance('TextLabel', {
        Name = 'Version',
        Position = UDim2.fromOffset(52 + Title_Width + 10, 0), 
        Size = UDim2.new(0, 80, 1, 0),
        BackgroundTransparency = 1, 
        FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
        TextSize = 13,
        Text = Version, 
        TextColor3 = Color3.fromRGB(105, 105, 112),
        TextXAlignment = Enum.TextXAlignment.Left, 
        ZIndex = 12,
    }, Title_Bar)

    if Device['Mobile'] then
    	local Close_Button = Create_Instance('ImageButton', {
    		Name = 'Close',
    		AnchorPoint = Vector2.new(1, 0.5),
    		Position = UDim2.new(1, -14, 0.5, 0),
    		Size = UDim2.fromOffset(34, 28),
    		BackgroundColor3 = Color3.fromRGB(232, 232, 236),
    		BorderSizePixel = 0,
    		Image = '',
    		ZIndex = 60,
    		AutoButtonColor = false,
		}, Title_Bar)

		Create_Stroke(Close_Button, Theme.Border, 1, 0.8)
		Create_Corner(Close_Button, 6)

		local Close_Icon = Create_Instance('ImageLabel', {
    		Name = 'Icon',
    		AnchorPoint = Vector2.new(0.5, 0.5),
    		Position = UDim2.fromScale(0.5, 0.5),
    		Size = UDim2.fromOffset(16, 16),
    		BackgroundTransparency = 1,
    		Image = 'rbxassetid://7733771982',
    		ImageColor3 = Theme.Accent,
    		ZIndex = 61,
		}, Close_Button)

		self.Close_Icon = Close_Icon

		Close_Button.MouseButton1Click:Connect(function()
    		self:Hide()
		end)
	end

    local Minimize_Button = Create_Instance('TextButton', {
        Name = 'Minimize',
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, Device['Mobile'] and -56 or -14, 0.5, 0),
        Size = UDim2.fromOffset(72, 26), 
        BackgroundColor3 = Theme.Panel_2,
        BorderSizePixel = 0, 
		FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
        TextSize = 12, 
        Text = '▼  Min',
        TextColor3 = Theme.Muted, 
        ZIndex = 60, 
        AutoButtonColor = false,
    }, Title_Bar)

    Create_Corner(Minimize_Button, 6)
    Create_Stroke(Minimize_Button, Theme.Border, 1, 0.4)

    self.Minimize_Button = Minimize_Button
	self.Minimize_Sound = Create_Sound(Minimize_Button, Sounds['Minimize'], Volume)

    Minimize_Button.MouseButton1Click:Connect(function() 
        self:Toggle_Minimize() 
    end)

    Minimize_Button.MouseEnter:Connect(function() 
        Create_Tween(Minimize_Button, 0.12, {BackgroundColor3 = Color3.fromRGB(224,224,229), TextColor3 = Theme.Accent}) 
    end)

    Minimize_Button.MouseLeave:Connect(function() 
        Create_Tween(Minimize_Button, 0.12, {BackgroundColor3 = Theme.Panel_2, TextColor3 = Theme.Muted}) 
    end)

    -- Circular social buttons beside Minimize.
    local Social_Container = Create_Instance('Frame', {
        Name = 'SocialLinks',
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, Device['Mobile'] and -178 or -174, 0.5, 0),
        Size = UDim2.fromOffset(87, 30),
        BackgroundTransparency = 1,
        ZIndex = 60,
    }, Title_Bar)

    Create_Instance('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Social_Container)

    local Social_Icons = {}

    local function Copy_Social_Link(Name, Asset_Id, Link, Order)
        local Social_Button = Create_Instance('ImageButton', {
            Name = Name,
            LayoutOrder = Order,
            Size = UDim2.fromOffset(25, 25),
            BackgroundColor3 = Color3.fromRGB(246, 246, 249),
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Image = '',
            ZIndex = 61,
        }, Social_Container)

        Create_Instance('UICorner', {CornerRadius = UDim.new(1, 0)}, Social_Button)
        local Social_Stroke = Create_Stroke(Social_Button, Theme.Border, 1, 0.35)

        local Social_Icon = Create_Instance('ImageLabel', {
            Name = 'SocialIcon',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(19, 19),
            BackgroundTransparency = 1,
            Image = 'rbxthumb://type=Asset&id=' .. tostring(Asset_Id) .. '&w=150&h=150',
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 62,
        }, Social_Button)

        local Icon_Scale = Create_Instance('UIScale', {Scale = 1}, Social_Icon)
        table.insert(Social_Icons, {
            Button = Social_Button,
            Icon = Social_Icon,
            Scale = Icon_Scale,
            Stroke = Social_Stroke,
        })

        task.spawn(function()
            pcall(function()
                local ContentProvider = game:GetService('ContentProvider')
                ContentProvider:PreloadAsync({Social_Icon})
            end)
            task.wait(4)
            if Social_Icon and Social_Icon.Parent and not Social_Icon.IsLoaded then
                Social_Icon.Image = 'rbxassetid://' .. tostring(Asset_Id)
            end
        end)

        Social_Button.MouseEnter:Connect(function()
            Create_Tween(Social_Button, 0.16, {
                BackgroundColor3 = Color3.fromRGB(226, 226, 232),
                Size = UDim2.fromOffset(25, 25),
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end)

        Social_Button.MouseLeave:Connect(function()
            Create_Tween(Social_Button, 0.16, {
                BackgroundColor3 = Color3.fromRGB(246, 246, 249),
                Size = UDim2.fromOffset(25, 25),
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end)

        Social_Button.MouseButton1Click:Connect(function()
            local Copied = false
            if typeof(setclipboard) == 'function' then
                Copied = pcall(setclipboard, Link)
            elseif typeof(toclipboard) == 'function' then
                Copied = pcall(toclipboard, Link)
            elseif typeof(writeclipboard) == 'function' then
                Copied = pcall(writeclipboard, Link)
            end

            if not Copied then
                warn('[Ethereal] Clipboard is not supported by this executor.')
            end
        end)

        return Social_Button
    end

    self.Social_Container = Social_Container
    self.Discord_Button = Copy_Social_Link('Discord', 10367063084, 'https://dsc.gg/get-ethereal', 1)
    self.YouTube_Button = Copy_Social_Link('YouTube', 1275974022, 'https://youtube.com/@human_noid?si=DglRlrsnIcxi7ZDx', 2)
    self.TikTok_Button = Copy_Social_Link('TikTok', 114617227673334, 'https://www.tiktok.com/@invis_in', 3)

    -- One icon performs a polished keyframed-style spin at a time.
    -- The Quint InOut curve gives a slow start, fast middle, and soft finish.
    task.spawn(function()
        local Randomizer = Random.new()
        local Previous_Index = 0

        while Social_Container and Social_Container.Parent do
            task.wait(Randomizer:NextNumber(5, 10))
            if not (Social_Container and Social_Container.Parent) then
                break
            end

            local Count = #Social_Icons
            if Count > 0 then
                local Picked_Index = Randomizer:NextInteger(1, Count)
                if Count > 1 and Picked_Index == Previous_Index then
                    Picked_Index = (Picked_Index % Count) + 1
                end
                Previous_Index = Picked_Index

                local Data = Social_Icons[Picked_Index]
                if Data.Button and Data.Button.Parent and Data.Icon and Data.Icon.Parent then
                    Data.Icon.Rotation = 0
                    Data.Scale.Scale = 1
                    Data.Stroke.Thickness = 1
                    Data.Stroke.Transparency = 0.35

                    local Spin = TweenService:Create(
                        Data.Icon,
                        TweenInfo.new(0.82, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
                        {Rotation = 360}
                    )
                    local Pop = TweenService:Create(
                        Data.Scale,
                        TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        {Scale = 1.18}
                    )
                    local Settle = TweenService:Create(
                        Data.Scale,
                        TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        {Scale = 1}
                    )
                    local Glow = TweenService:Create(
                        Data.Stroke,
                        TweenInfo.new(0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                        {Thickness = 1.8, Transparency = 0.05}
                    )
                    local Glow_Off = TweenService:Create(
                        Data.Stroke,
                        TweenInfo.new(0.48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        {Thickness = 1, Transparency = 0.35}
                    )

                    Spin:Play()
                    Pop:Play()
                    Glow:Play()
                    task.delay(0.22, function()
                        if Data.Scale and Data.Scale.Parent then Settle:Play() end
                    end)
                    task.delay(0.24, function()
                        if Data.Stroke and Data.Stroke.Parent then Glow_Off:Play() end
                    end)
                    Spin.Completed:Wait()
                    if Data.Icon and Data.Icon.Parent then Data.Icon.Rotation = 0 end
                end
            end
        end
    end)

    local Panic_Button = Create_Instance('ImageButton', {
        Name = 'Panic',
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, Device['Mobile'] and -278 or -270, 0.5, 0),
        Size = UDim2.fromOffset(30, 26),
        BackgroundColor3 = Theme.Panel_2,
        BorderSizePixel = 0,
        Image = '',
        ZIndex = 60,
        AutoButtonColor = false,
    }, Title_Bar)

    Create_Corner(Panic_Button, 6)
    Create_Stroke(Panic_Button, Theme.Border, 1, 0.8)

    local Panic_Icon = Create_Instance('ImageLabel', {
        Name = 'Icon',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://7734052653',
        ImageColor3 = Color3.fromRGB(144, 144, 160),
        ZIndex = 61,
    }, Panic_Button)

    self.Panic_Icon = Panic_Icon

    local Default_Color = Color3.fromRGB(144, 144, 160)

    Panic_Button.MouseEnter:Connect(function()
        Create_Tween(Panic_Icon, 0.3, {
            ImageColor3 = Theme.Accent
        })
    end)

    Panic_Button.MouseLeave:Connect(function()
        Create_Tween(Panic_Icon, 0.3, {
            ImageColor3 = Default_Color
        })
    end)

    Panic_Button.MouseButton1Click:Connect(function()
        self.Interface_Mode = 'Locked'
		task.wait(1)
        self:Destroy_Interface()
        self.Interface_Mode = 'Unlocked'
    end)

    local Uptime_Position = UDim2.new(1, Device['Mobile'] and -326 or -314, 0.5, 0)

	local Uptime_Container = Create_Instance('Frame', {
    	Name = 'Uptime',
    	AnchorPoint = Vector2.new(1, 0.5),
    	Position = Uptime_Position,
    	Size = UDim2.fromOffset(0, 20),
    	AutomaticSize = Enum.AutomaticSize.X,
    	BackgroundTransparency = 1,
    	ZIndex = 60,
	}, Title_Bar)

	Create_Instance('UIListLayout', {
    	FillDirection = Enum.FillDirection.Horizontal,
    	Padding = UDim.new(0, 4),
    	SortOrder = Enum.SortOrder.LayoutOrder,
    	VerticalAlignment = Enum.VerticalAlignment.Center,
	}, Uptime_Container)

	local function Make_Unit_Slot(Order)
    	local Slot = Create_Instance('Frame', {
        	Size = UDim2.fromOffset(0, 20),
        	AutomaticSize = Enum.AutomaticSize.X,
        	BackgroundTransparency = 1,
        	ClipsDescendants = true,
        	LayoutOrder = Order,
        	Visible = false,
        	ZIndex = 60,
    	}, Uptime_Container)

    	local Label = Create_Instance('TextLabel', {
        	Size = UDim2.fromOffset(0, 20),
        	AutomaticSize = Enum.AutomaticSize.X,
        	BackgroundTransparency = 1,
        	Font = Enum.Font.Code,
        	TextSize = 12,
        	Text = '',
        	TextTransparency = 1,
        	TextColor3 = Theme.Dim,
        	TextXAlignment = Enum.TextXAlignment.Left,
        	ZIndex = 61,
    	}, Slot)
    	return Slot, Label
	end

	local Hours_Slot, Hours_Label = Make_Unit_Slot(1)
	local Minutes_Slot, Minutes_Label = Make_Unit_Slot(2)
	local Seconds_Slot, Seconds_Label = Make_Unit_Slot(3)

	self.Uptime_Container = Uptime_Container
	self.Start_Time = os.clock()

	local function Fade_In_Slot(Slot)
    	local Label = Slot:FindFirstChildOfClass('TextLabel')
    	if not Label then return end

    	Label.TextTransparency = 1
    	Create_Tween(Label, 0.35, {
        	TextTransparency = 0,
    	}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	end

	local function Animate_Segment(Label, New_Text)
    	Create_Tween(Label, 0.12, {
        	TextTransparency = 1,
    	}, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

    	task.delay(0.12, function()
        	if not Label or not Label.Parent then return end

        	Label.Text = New_Text

        	Create_Tween(Label, 0.25, {
            	TextTransparency = 0,
        	}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    	end)
	end

	local Last_Hours, Last_Minutes, Last_Seconds = nil, nil, nil

	task.spawn(function()
    	while Uptime_Container and Uptime_Container.Parent do
        	local Elapsed = math.floor(os.clock() - self.Start_Time)
        	local Hours = math.floor(Elapsed / 3600)
        	local Minutes = math.floor((Elapsed % 3600) / 60)
        	local Seconds = Elapsed % 60

        	if Seconds ~= Last_Seconds then
            	Last_Seconds = Seconds
            	local Text = Seconds .. 's'

            	if Seconds_Label.Text == '' then
                	Seconds_Label.Text = Text
                	Seconds_Slot.Visible = true
                	Fade_In_Slot(Seconds_Slot)
            	else
                	Animate_Segment(Seconds_Label, Text)
            	end
        	end

        	if Minutes ~= Last_Minutes and (Minutes > 0 or Last_Minutes ~= nil) then
            	Last_Minutes = Minutes
            	local Text = Minutes .. 'm'

            	if Minutes_Label.Text == '' then
                	Minutes_Label.Text = Text
                	Minutes_Slot.Visible = true
                	Fade_In_Slot(Minutes_Slot)
            	else
                	Animate_Segment(Minutes_Label, Text)
            	end
        	end

        	if Hours ~= Last_Hours and (Hours > 0 or Last_Hours ~= nil) then
            	Last_Hours = Hours
            	local Text = Hours .. 'h'

            	if Hours_Label.Text == '' then
                	Hours_Label.Text = Text
                	Hours_Slot.Visible = true
                	Fade_In_Slot(Hours_Slot)
            	else
                	Animate_Segment(Hours_Label, Text)
            	end
        	end
        	task.wait(0.2)
    	end
	end)

    local Tab_Bar = Create_Instance('ScrollingFrame', {
        Name = 'Tabs',
        Position = UDim2.new(0, 8, 0, 122),
        Size = UDim2.new(0, 42, 1, -166),
        BackgroundColor3 = Theme.Panel_2,
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        ZIndex = 12,
    }, Main_Panel)
    Create_Corner(Tab_Bar, 18)
    local Tab_Rail_Stroke = Create_Stroke(Tab_Bar, Theme.Border, 1, 0.45)
    Create_Instance('UIGradient', {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Panel),
            ColorSequenceKeypoint.new(1, Theme.Panel_3),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.04),
            NumberSequenceKeypoint.new(1, 0.18),
        }),
    }, Tab_Bar)

    Create_Instance('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, Tab_Bar)

    Create_Instance('UIPadding', {
        PaddingTop = UDim.new(0, 9),
        PaddingBottom = UDim.new(0, 9),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
    }, Tab_Bar)

    self.Tab_Bar = Tab_Bar
	self.Tab_Sound = Create_Sound(Tab_Bar, Sounds['Tab'], Volume)

    local Search_Bar = Create_Instance('Frame', {
        Name = 'Search Bar',
        Position = UDim2.new(0, 0, 0, 84), 
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1, 
        ZIndex = 11,
    }, Main_Panel)

    local Search_Box = Create_Instance('Frame', {
        Name = 'Box',
        AnchorPoint = Vector2.new(0.5, 0.5), 
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -28, 0, 26), 
        BackgroundColor3 = Theme.Panel_2,
        BorderSizePixel = 0, 
        ZIndex = 12,
    }, Search_Bar)

    Create_Corner(Search_Box, 6)

    local Search_Stroke = Create_Stroke(Search_Box, Theme.Border, 1, 0.5)

	local Search_Icon = Create_Instance('ImageLabel', {
        Name = 'Icon',
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0.00999999978, 0, 0.100000001, 0),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://17441620727',
        ImageColor3 = Color3.fromRGB(112, 112, 120),
        LayoutOrder = 1,
        ZIndex = 13,
    }, Search_Box)

    local Search_Input = Create_Instance('TextBox', {
    	Name = 'Input',
    	Position = UDim2.fromOffset(30, 0), 
    	Size = UDim2.new(1, -64, 1, 0),
    	BackgroundTransparency = 1, 
    	FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
    	TextSize = 12,
    	Text = '', 
    	PlaceholderText = 'Search features...', 
    	PlaceholderColor3 = Theme.Dim,
    	TextColor3 = Theme.Text, 
    	TextXAlignment = Enum.TextXAlignment.Left,
    	ClearTextOnFocus = false, 
    	ClipsDescendants = true,
    	ZIndex = 13,
	}, Search_Box)

    self.Search_Input = Search_Input

    local Clear_Button = Create_Instance('TextButton', {
        Name = 'Clear',
        AnchorPoint = Vector2.new(1, 0.5), 
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(18, 18), 
        BackgroundTransparency = 1,
        Font = Enum.Font.Code, 
        TextSize = 13, 
        Text = 'X', 
        TextColor3 = Theme.Dim,
        Visible = false, 
        ZIndex = 13, 
        AutoButtonColor = false,
    }, Search_Box)

    Search_Input.Focused:Connect(function() 
        Create_Tween(Search_Stroke, 0.3, {Color = Theme.Border, Transparency = 0.3}) 
        Create_Tween(Search_Icon, 0.3, {ImageColor3 = Theme.Accent})
    end)

    Search_Input.FocusLost:Connect(function() 
        Create_Tween(Search_Stroke, 0.3, {Color = Theme.Border, Transparency = 0.3}) 
        Create_Tween(Search_Icon, 0.3, {ImageColor3 = Color3.fromRGB(112, 112, 120)})
    end)

    Search_Input:GetPropertyChangedSignal('Text'):Connect(function()
        Clear_Button.Visible = Search_Input.Text ~= ''
        self:Search(Search_Input.Text)
    end)
    
    Clear_Button.MouseButton1Click:Connect(function()
        Search_Input.Text = ''
    end)

    local Body_Scroller = Create_Instance('ScrollingFrame', {
        Name = 'Container',
        Position = UDim2.new(0, 58, 0, 119), 
        Size = UDim2.new(1, -66, 1, -157),
        BackgroundTransparency = 1, 
        BorderSizePixel = 0, 
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent, 
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, 
        ClipsDescendants = true, 
        ZIndex = 11,
    }, Main_Panel)

    self.Body = Body_Scroller

    local No_Results = Create_Instance('Frame', {
    	Name = 'No Results',
    	Position = UDim2.new(0, 58, 0, 119),
    	Size = UDim2.new(1, -66, 1, -157),
    	BackgroundTransparency = 1,
    	Visible = false,
    	ZIndex = 30,
	}, Main_Panel)

	local No_Results_Image = Create_Instance('ImageLabel', {
    	AnchorPoint = Vector2.new(0.5, 0.5),
    	Position = UDim2.new(0.5, 0, 0.5, 12),
    	Size = UDim2.fromOffset(42, 42),
    	BackgroundTransparency = 1,
    	Image = 'rbxassetid://7733911621',
    	ImageColor3 = Theme.Accent,
    	ImageTransparency = 1,
    	ZIndex = 31,
	}, No_Results)

	local No_Results_Label = Create_Instance('TextLabel', {
    	AnchorPoint = Vector2.new(0.5, 0.5),
    	Position = UDim2.new(0.5, 0, 0.5, 38),
    	Size = UDim2.fromOffset(220, 20),
    	BackgroundTransparency = 1,
    	FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
    	TextSize = 13,
    	Text = 'Nothing found.',
    	TextColor3 = Theme.Dim,
    	TextTransparency = 1,
    	ZIndex = 31,
	}, No_Results)

	self.No_Results = No_Results
	self.No_Results_Image = No_Results_Image
	self.No_Results_Label = No_Results_Label

	local Interface = {
        ['Locked'] = 'rbxassetid://121830702067948',
        ['Unlocked'] = 'rbxassetid://102151842256737',
    }

	self.Interface = Interface
    self.Lock_Overlay = nil
	self.Lock_Glyph = nil
	self.Lock_Caption = nil

    local Footer = Create_Instance('Frame', {
        Name = 'Status',
        AnchorPoint = Vector2.new(0, 1), 
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 38), 
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0, 
        ZIndex = 12,
    }, Main_Panel)

    Create_Instance('Frame', {
        Name = 'Divider',
        Size = UDim2.new(1, 0, 0, 1), 
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.3, 
        BorderSizePixel = 0, 
        ZIndex = 13,
    }, Footer)

    self.Footer = Footer

	do
    	local Footer_Dragging, Footer_Drag_Start, Footer_Start_Position = false, nil, nil

    	local Footer_Drag = Create_Instance('TextButton', {
        	Name = 'Drag',
        	Size = UDim2.new(1, 0, 1, 0),
        	BackgroundTransparency = 1,
        	Text = '',
        	ZIndex = 13,
        	AutoButtonColor = false,
    	}, Footer)

    	Footer_Drag.InputBegan:Connect(function(Input)
            if self.Interface_Drag_Enabled == false then return end
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Footer_Dragging = true
                Footer_Drag_Start = Input.Position
                Footer_Start_Position = Main_Panel.Position
            end
        end)

    	Footer_Drag.InputEnded:Connect(function(Input)
        	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            	Footer_Dragging = false
        	end
    	end)

    	Connection.Footer_Drag_Input = UserInputService.InputChanged:Connect(function(Input)
        	if not Footer_Dragging then return end
        	if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end

        	local Delta = Input.Position - Footer_Drag_Start
        	local Viewport = Screen_Gui.AbsoluteSize
        	local Abs_X = Footer_Start_Position.X.Scale * Viewport.X + Footer_Start_Position.X.Offset + Delta.X
        	local Abs_Y = Footer_Start_Position.Y.Scale * Viewport.Y + Footer_Start_Position.Y.Offset + Delta.Y
        	local Half_W = Main_Panel.AbsoluteSize.X / 2
        	local Half_H = Main_Panel.AbsoluteSize.Y / 2
        	local Freedom = self.Freedom_Enabled == true
        	if not Freedom then
            	Abs_X = Safe_Clamp_X(Abs_X, Half_W, Viewport.X)
            	Abs_Y = Safe_Clamp_Y(Abs_Y, Half_H, Viewport.Y)
        	end
        	Create_Tween(Main_Panel, Drag_Duration(), {Position = UDim2.new(0, Abs_X, 0, Abs_Y)}, Enum.EasingStyle.Linear)
    	end)
	end

    local Resize_Button = Create_Instance('ImageButton', {
        Name = 'Resize',
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -6, 1, -6),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        Image = 'rbxassetid://10734961133',
        ImageColor3 = Theme.Dim,
        ZIndex = 60,
    }, Main_Panel)

    self.Resizing = false
    self.Resize_Start = nil
    self.Size_Start = nil

    local Min_Width, Min_Height = 600, 300
    local Max_Width, Max_Height = 1000, 700

    local function Apply_Resize(New_Width, New_Height, Instant)
        if self.Minimized then return end

        New_Width = math.clamp(New_Width, Min_Width, Max_Width)
        New_Height = math.clamp(New_Height, Min_Height, Max_Height)

        local Viewport = Screen_Gui.AbsoluteSize
        New_Width = math.min(New_Width, Viewport.X)
        New_Height = math.min(New_Height, Viewport.Y)

        self.Custom_Size = Vector2.new(New_Width, New_Height)

        if Instant then
            Main_Panel.Size = UDim2.fromOffset(New_Width, New_Height)
        else
            Create_Tween(Main_Panel, 0.05, {Size = UDim2.fromOffset(New_Width, New_Height)}, Enum.EasingStyle.Linear)
        end
    end

    if Device['Mobile'] then
        local Resize_Hitbox = Create_Instance('Frame', {
            Name = 'Hitbox',
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, 0, 1, 0),
            Size = UDim2.fromOffset(50, 50),
            BackgroundTransparency = 1,
            ZIndex = 59,
        }, Main_Panel)

        Resize_Hitbox.InputBegan:Connect(function(Input)
            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
            self.Resizing = true
            self.Resize_Start = Vector2.new(Input.Position.X, Input.Position.Y)
            self.Size_Start = Main_Panel.Size
        end)

        Resize_Hitbox.InputChanged:Connect(function(Input)
            if not self.Resizing or Input.UserInputType ~= Enum.UserInputType.Touch then return end
            local Current_Pos = Vector2.new(Input.Position.X, Input.Position.Y)
            local Delta = Current_Pos - self.Resize_Start
            Apply_Resize(self.Size_Start.X.Offset + Delta.X, self.Size_Start.Y.Offset + Delta.Y, true)
        end)

        Resize_Hitbox.InputEnded:Connect(function(Input)
            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
            self.Resizing = false
        end)
    end

    Resize_Button.MouseButton1Down:Connect(function()
        if Device['Mobile'] then return end
        self.Resizing = true
        self.Resize_Start = UserInputService:GetMouseLocation()
        self.Size_Start = Main_Panel.Size
    end)

    Resize_Button.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.Touch then return end
        self.Resizing = true
        self.Resize_Start = Vector2.new(Input.Position.X, Input.Position.Y)
        self.Size_Start = Main_Panel.Size
    end)

    Resize_Button.InputChanged:Connect(function(Input)
        if not self.Resizing or Input.UserInputType ~= Enum.UserInputType.Touch then return end
        local Current_Pos = Vector2.new(Input.Position.X, Input.Position.Y)
        local Delta = Current_Pos - self.Resize_Start
        Apply_Resize(self.Size_Start.X.Offset + Delta.X, self.Size_Start.Y.Offset + Delta.Y, true)
    end)

    Resize_Button.InputEnded:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.Touch then return end
        self.Resizing = false
    end)

    Connection.Resize_Mouse_End = UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        self.Resizing = false
    end)

    Connection.Resize_Mouse_Drag = UserInputService.InputChanged:Connect(function(Input)
        if not self.Resizing or Input.UserInputType ~= Enum.UserInputType.MouseMovement or Device['Mobile'] then return end
        local Delta = UserInputService:GetMouseLocation() - self.Resize_Start
        Apply_Resize(self.Size_Start.X.Offset + Delta.X, self.Size_Start.Y.Offset + Delta.Y, false)
    end)

    local Status_Dot = Create_Instance('Frame', {
        Name = 'Dot',
        AnchorPoint = Vector2.new(0, 0.5), 
        Position = UDim2.new(0, 16, 0.5, 0),
        Size = UDim2.fromOffset(6, 6), 
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, 
        ZIndex = 14,
    }, Footer)

    Create_Corner(Status_Dot, 3)
    self.Status_Dot = Status_Dot

    task.spawn(function()
    	if not self.Status_Dot then return end
    	while self.Status_Dot and self.Status_Dot.Parent do
            local In = TweenService:Create(self.Status_Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.35
            })
            local Out = TweenService:Create(self.Status_Dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0
            })
            In:Play()
            In.Completed:Wait()
            Out:Play()
            Out.Completed:Wait()
        end
    end)

    local Status_Label = Create_Instance('TextLabel', {
        AnchorPoint = Vector2.new(0, 0.5), 
        Position = UDim2.new(0, 28, 0.5, 0),
        Size = UDim2.fromOffset(300, 20), 
        BackgroundTransparency = 1,
        Font = Enum.Font.Code, 
        TextSize = 12, 
        Text = 'Active session running',
        TextColor3 = Theme.Muted, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        ZIndex = 14,
    }, Footer)

    self.Status_Label = Status_Label

    local Clock_Label = Create_Instance('TextLabel', {
        AnchorPoint = Vector2.new(1, 0.5), 
        Position = UDim2.new(1, -82, 0.5, 0),
        Size = UDim2.fromOffset(170, 20), 
        BackgroundTransparency = 1,
        Font = Enum.Font.Code, 
        TextSize = 11, 
        Text = '', 
        TextColor3 = Theme.Dim,
        TextXAlignment = Enum.TextXAlignment.Right, 
        ZIndex = 14,
    }, Footer)

    -- The three rising bars in the bottom-right corner already read as a
    -- signal icon, so it doubles as the ping indicator: instead of adding a
    -- second icon, this tints the existing one from the live latency (green
    -- while healthy, yellow when it starts to lag, red when it is poor).
    local Ping_Colors = {
        Good = Color3.fromRGB(96, 210, 140),
        Okay = Color3.fromRGB(230, 190, 64),
        Bad  = Color3.fromRGB(230, 80, 80),
    }

    self.Ping_Icon = Resize_Button
    self.Ping_Value = 0
    self.Ping_Color = Ping_Colors.Good

    local function Get_Ping()
        local Success, Value = pcall(function()
            return Stats.Network.ServerStatsItem['Data Ping']:GetValue()
        end)
        if Success and type(Value) == 'number' then
            return Value
        end
        return 0
    end

    local function Apply_Ping()
        local Ping = Get_Ping()
        self.Ping_Value = Ping

        local Color = Ping_Colors.Good
        if Ping >= 160 then
            Color = Ping_Colors.Bad
        elseif Ping >= 80 then
            Color = Ping_Colors.Okay
        end
        self.Ping_Color = Color

        if Resize_Button and Resize_Button.Parent then
            Resize_Button.ImageColor3 = Color
        end
    end

    Apply_Ping()

    task.spawn(function()
        while Resize_Button and Resize_Button.Parent do
            Apply_Ping()
            task.wait(0.5)
        end
    end)

    if Device['Mobile'] then
        local Float_Button = Create_Instance('ImageButton', {
            Name = 'Open', 
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -24), 
            Size = UDim2.fromOffset(150, 40),
            BackgroundColor3 = Theme.Panel_2, 
            BorderSizePixel = 0,
            Image = '',
            ImageTransparency = 1,
            ZIndex = 100, 
            Visible = false, 
            BackgroundTransparency = 1,
            AutoButtonColor = false,
        }, Screen_Gui)

        Create_Corner(Float_Button, 10)
        local Float_Stroke = Create_Stroke(Float_Button, Theme.Border, 1, 1)

        local Float_Scale = Create_Instance('UIScale', {
            Scale = 1,
        }, Float_Button)

        local Float_Icon_Wrap = Create_Instance('Frame', {
            Name = 'Icon',
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.fromOffset(34, 30),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            ZIndex = 101,
        }, Float_Button)

        -- Same 3x3 spritesheet + frame-stepping animation used by the logo on
        -- the left of the title bar, so the floating "open" pill shows the
        -- Ethereal 2D animation while the interface is hidden.
        local Float_Icon = Create_Instance('ImageLabel', {
            Name = 'Animated',
            Size = UDim2.new(3, 0, 3, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://133009150415671',
            ImageTransparency = 1,
            ZIndex = 102,
        }, Float_Icon_Wrap)

        do
            local Frame_Rate = self.Animation_Frame_Rate or 12
            local Current_Frame = 1
            local Last_Time = tick()
            Connection.Float_Logo_Animation = RunService.Heartbeat:Connect(function()
                if not Float_Icon or not Float_Icon.Parent then
                    return
                end
                local Real_Time = tick()
                if Real_Time - Last_Time >= 1 / Frame_Rate then
                    Current_Frame = (Current_Frame % 8) + 1
                    local Current_Column = ((Current_Frame - 1) % 3) + 1
                    local Current_Row = math.floor((Current_Frame - 1) / 3) + 1
                    Float_Icon.Position = UDim2.new(-(Current_Column - 1), 0, -(Current_Row - 1), 0)
                    Last_Time = Real_Time
                end
            end)
        end

        local Float_Label = Create_Instance('TextLabel', {
            Name = 'Title',
            Position = UDim2.fromOffset(56, 0),
            Size = UDim2.new(1, -64, 1, 0),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 16,
            Text = Title,
            TextColor3 = Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
            ZIndex = 101,
        }, Float_Button)

        self.Float_Button = Float_Button
        self.Float_Icon = Float_Icon
        self.Float_Icon_Wrap = Float_Icon_Wrap
        self.Float_Scale = Float_Scale
        self.Float_Label = Float_Label
        self.Float_Stroke = Float_Stroke

        local Dragging, Drag_Start, Start_Position, Did_Drag = false, nil, nil, false
        Float_Button.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging, Did_Drag, Drag_Start, Start_Position = true, false, Input.Position, Float_Button.Position
            end
        end)

        Float_Button.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                Dragging = false 
            end
        end)

        Connection.Float_Drag_Input = UserInputService.InputChanged:Connect(function(Input)
            if not Dragging then return end
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then 
                return 
            end
            local Delta = Input.Position - Drag_Start
            if Delta.Magnitude > 4 then Did_Drag = true end
            if not Did_Drag then return end
            local Viewport = Screen_Gui.AbsoluteSize
            local Abs_X = Start_Position.X.Scale * Viewport.X + Start_Position.X.Offset + Delta.X
            local Abs_Y = Start_Position.Y.Scale * Viewport.Y + Start_Position.Y.Offset + Delta.Y
            Abs_X = math.clamp(Abs_X, Float_Button.AbsoluteSize.X/2, Viewport.X - Float_Button.AbsoluteSize.X/2)
            Abs_Y = math.clamp(Abs_Y, Float_Button.AbsoluteSize.Y/2, Viewport.Y - Float_Button.AbsoluteSize.Y/2)
            Create_Tween(Float_Button, Button_Drag_Duration(), {Position = UDim2.new(0, Abs_X, 0, Abs_Y)}, Enum.EasingStyle.Linear)
        end)
        Float_Button.MouseButton1Click:Connect(function()
            if Did_Drag then Did_Drag = false return end
            if not self.Visible then self:Show() end
        end)
    end

    Connection.Global_Input = UserInputService.InputBegan:Connect(function(Input, Processed)
        if self.Capturing and Input.UserInputType == Enum.UserInputType.Keyboard then
            self.Capturing(Input.KeyCode)
            return
        end
        if Processed then return end
        local Live_Keybind = self.Interface_Keybind or Keybind
        if Input.KeyCode == Live_Keybind then self:Toggle() end
    end)

    task.spawn(function()
        while Main_Panel and Main_Panel.Parent do
            local Time = os.date('*t')
            local Hour = Time.hour % 12
            if Hour == 0 then Hour = 12 end
            local Live_Keybind = self.Interface_Keybind or Keybind
            Clock_Label.Text = string.format('[%s] toggle  ·  %d:%02d %s',
                tostring(Live_Keybind):gsub('Enum.KeyCode.', ''), Hour, Time.min, Time.hour >= 12 and 'PM' or 'AM')
            task.wait(1)
        end
    end)

    task.spawn(function()
        local Dot = true
        while Title_Label and Title_Label.Parent do
            Title_Label.Text = Title .. (Dot and '.' or '')
            Dot = not Dot
            task.wait(0.55)
        end
    end)

    local Mode_Debounce = false
	task.spawn(function()
    	local Last_Mode = self.Interface_Mode or 'Unlocked'
    	while Main_Panel and Main_Panel.Parent do
        	local Current_Mode = self.Interface_Mode or 'Unlocked'
        	if Current_Mode ~= Last_Mode and not Mode_Debounce then
            	Mode_Debounce = true
            	self:Set_Lock(Current_Mode == 'Locked')
            	Last_Mode = Current_Mode
            	task.delay(0.7, function() Mode_Debounce = false end)
        	end
        	task.wait(0.1)
    	end
	end)

    Main_Panel.GroupTransparency = 1
    task.wait(0.05)
    self:Show()

    if Config_Was_Loaded then
        task.delay(0.6, function()
            self:Status('Config loaded', Color3.fromRGB(96, 200, 140), 2)
        end)
    end
    return self
end

function Library:Status(Message, Color, Duration)
    self.Status_Label.Text = Message
    self.Status_Dot.BackgroundColor3 = Color or Theme.Accent
    task.delay(Duration or 1.6, function()
        if self.Status_Label.Text == Message then
            self.Status_Label.Text = 'Active session running'
            self.Status_Dot.BackgroundColor3 = Theme.Accent
        end
    end)
end

function Library:Set_No_Results(Show)
    if not self.No_Results then return end
    
    if Show then
        if self.No_Results.Visible then return end
        
        self.No_Results.Visible = true
        self.No_Results_Image.ImageTransparency = 1
        self.No_Results_Image.Position = UDim2.new(0.5, 0, 0.5, 12)
        
        self.No_Results_Label.TextTransparency = 1
        self.No_Results_Label.Position = UDim2.new(0.5, 0, 0.5, 38)

        Create_Tween(self.No_Results_Image, 0.28, {
            ImageTransparency = 0,
            Position = UDim2.new(0.5, 0, 0.5, -6),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        task.delay(0.13, function()
            if not self.No_Results.Visible then return end
            Create_Tween(self.No_Results_Label, 0.28, {
                TextTransparency = 0,
                Position = UDim2.new(0.5, 0, 0.5, 28),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
        
    else
        if not self.No_Results.Visible then return end
        
        Create_Tween(self.No_Results_Image, 0.08, {
            ImageTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 10),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        
        Create_Tween(self.No_Results_Label, 0.08, {
            TextTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 36),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        
        task.delay(0.09, function()
            if self.No_Results then
                self.No_Results.Visible = false
            end
        end)
    end
end

function Library:Search(Query)
    Query = tostring(Query or ''):lower():gsub('^%s*(.-)%s*$', '%1')

    self.Search_Generation = (self.Search_Generation or 0) + 1
    local My_Generation = self.Search_Generation

    local function Refresh_Active_Layout()
        local Pane = self.Tabs[self.Active_Tab]
        if not Pane then return end
        task.spawn(function()
            RunService.Heartbeat:Wait()
            Pane.AutomaticSize = Enum.AutomaticSize.None
            RunService.Heartbeat:Wait()
            Pane.AutomaticSize = Enum.AutomaticSize.Y
            RunService.Heartbeat:Wait()
            if self.Body then
                self.Body.AutomaticCanvasSize = Enum.AutomaticSize.None
                RunService.Heartbeat:Wait()
                self.Body.AutomaticCanvasSize = Enum.AutomaticSize.Y
            end
        end)
    end

    if Query == '' then
        self.Searching = false
        for _, Item in ipairs(self.Search_Items) do
            Item.Object.Visible = true
        end
        Refresh_Active_Layout()
        self:Set_No_Results(false)
        return
    end

    self.Searching = true
    local First_Match_Tab = nil
    local Any_Match = false
    for _, Item in ipairs(self.Search_Items) do
        local Is_Match = string.find(Item.Name:lower(), Query, 1, true) ~= nil
        Item.Object.Visible = Is_Match
        if Is_Match then
            Any_Match = true
            if not First_Match_Tab then
                First_Match_Tab = Item.Tab_Index
            end
        end
    end

    Refresh_Active_Layout()
	self:Set_No_Results(not Any_Match)

    if First_Match_Tab and First_Match_Tab ~= self.Active_Tab then
        task.delay(0.18, function()
            if self.Search_Generation ~= My_Generation then return end
            if not self.Search_Input then return end
            if self.Search_Input.Text:lower():gsub('^%s*(.-)%s*$', '%1') ~= Query then return end
            self:Switch_Tab(First_Match_Tab)
        end)
    end
end

function Library:Autosave()
    if self.Loading then return end
    if getgenv and getgenv().Config_Enabled == false then return end
    self.Save_Dirty = true
    if self.Auto_Debounce then return end
    self.Auto_Debounce = true
    task.spawn(function()
        while self.Save_Dirty do
            self.Save_Dirty = false
            task.wait(0.4)
            if self.Save_Dirty then continue end
            if getgenv and getgenv().Config_Enabled == false then break end
            local Success = Save_Config(self.Flags)
            if Success then
                self:Status('Saved', Color3.fromRGB(96, 200, 140), 1.2)
            else
                self:Status('Save failed', Color3.fromRGB(220, 120, 90), 2)
            end
        end
        self.Auto_Debounce = false
    end)
end

function Library:Apply_Flag(Flag, Value, Silent)
    local Control = self.Control_Objects[Flag]
    if not Control then return end
    pcall(Control.Apply, Value, Silent)
end

function Library:Switch_Tab(Index)
    if Index == self.Active_Tab or not self.Tabs[Index] or self.Switching then return end
    if self.Open_Dropdown then self.Open_Dropdown() end
    if self.Tab_Sound then
        self.Tab_Sound.Volume = self.Clicks_Volume_Enabled or 0.5
        self.Tab_Sound:Play()
    end

    self.Switching = true
    self.Switch_Generation = (self.Switch_Generation or 0) + 1
    local Generation = self.Switch_Generation
    local Previous = self.Active_Tab
    local Out_Pane = self.Tabs[Previous]
    local In_Pane = self.Tabs[Index]

    task.spawn(function()
        if Out_Pane and Out_Pane.Visible then
            local Fade_Out = Create_Tween(Out_Pane, 0.28, {
                GroupTransparency = 1,
                Position = UDim2.fromScale(0, -0.018),
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
            Fade_Out.Completed:Wait()
            if self.Switch_Generation ~= Generation then return end
            Out_Pane.Visible = false
            Out_Pane.Position = UDim2.fromScale(0, 0)
        end

        if self.Switch_Generation ~= Generation then return end
        In_Pane.Visible = true
        In_Pane.GroupTransparency = 1
        In_Pane.Position = UDim2.fromScale(0, 0.025)
        RunService.Heartbeat:Wait()
        if self.Switch_Generation ~= Generation then return end

        local Fade_In = Create_Tween(In_Pane, 0.46, {
            GroupTransparency = 0,
            Position = UDim2.fromScale(0, 0),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        for _, Descendant in ipairs(In_Pane:GetDescendants()) do
            if Descendant:GetAttribute('IsDivider') then
                Descendant:SetAttribute('Replay', tick())
            end
        end

        Fade_In.Completed:Wait()
        if self.Switch_Generation ~= Generation then return end
        task.spawn(function()
            RunService.Heartbeat:Wait()
            In_Pane.AutomaticSize = Enum.AutomaticSize.None
            RunService.Heartbeat:Wait()
            In_Pane.AutomaticSize = Enum.AutomaticSize.Y
        end)
        self.Active_Tab = Index
        self.Switching = false
    end)

    for Tab_Index, Button in ipairs(self.Tab_Buttons) do
        local Is_Active = Tab_Index == Index
        local Dot = Button:FindFirstChild('ActiveDot')
        local Ring = Button:FindFirstChildOfClass('UIStroke')
        Create_Tween(Button, 0.26, {
            BackgroundColor3 = Is_Active and Color3.fromRGB(255, 255, 255) or Theme.Panel_3,
            BackgroundTransparency = Is_Active and 0.02 or 0.58,
            TextColor3 = Is_Active and Theme.Accent or Theme.Dim,
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        if Dot then
            Create_Tween(Dot, 0.28, {
                BackgroundTransparency = Is_Active and 0 or 1,
                Size = Is_Active and UDim2.fromOffset(5, 5) or UDim2.fromOffset(3, 3),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
        if Ring then
            Create_Tween(Ring, 0.28, {
                Transparency = Is_Active and 0.12 or 0.72,
                Thickness = Is_Active and 1.4 or 1,
                Color = Is_Active and Theme.Accent or Theme.Border,
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
        local Icon_Object = self.Tab_Icons[Tab_Index]
        if Icon_Object then
            Create_Tween(Icon_Object, 0.25, {
                ImageTransparency = Is_Active and 0 or 0.28,
                Size = UDim2.fromOffset(Is_Active and 17 or 15, Is_Active and 17 or 15),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
    end
end

function Library:Show()
    if self.Tweening then return end
    self.Tweening = true
    if self.Float_Button then self:Fade_Float(false) end
    local Target_Width = self.Custom_Size and self.Custom_Size.X or 700
    local Target_Height = self.Custom_Size and self.Custom_Size.Y or 450
    self.Panel.Visible, self.Panel.GroupTransparency = true, 1
    self.Panel.Size = UDim2.fromOffset(Target_Width * 0.985, math.min(Target_Height, 120))
    self.Body.Visible, self.Footer.Visible = true, true
    self.Footer.BackgroundTransparency = 1
    self.Minimize_Button.Text, self.Minimized = '▲  Expand', true
    Create_Tween(self.Panel, 0.34, {
        GroupTransparency = 0,
        Size = UDim2.fromOffset(Target_Width, Target_Height),
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Create_Tween(self.Footer, 0.30, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    task.delay(0.36, function()
        self.Minimized = false
        self.Minimize_Button.Text = '▼  Min'
        self.Tweening = false
    end)
    self.Visible = true
end

function Library:Hide()
    if self.Tweening then return end
    self.Tweening, self.Visible = true, false
    self.Minimize_Button.Text, self.Minimized = '▲  Expand', true
    local Target_Width = self.Custom_Size and self.Custom_Size.X or 700
    Create_Tween(self.Footer, 0.22, {BackgroundTransparency = 1}, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    Create_Tween(self.Panel, 0.34, {
        GroupTransparency = 1,
        Size = UDim2.fromOffset(Target_Width * 0.985, 92),
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.delay(0.36, function()
        self.Panel.Visible = false
        self.Body.Visible, self.Footer.Visible = false, false
        if self.Float_Button then
            self:Fade_Float(true)
        end
        self.Tweening, self.Minimized = false, false
    end)
end

function Library:Toggle()
    if self.Visible then
        self:Hide()
    else
        self:Show()
    end
end

function Library:Fade_Float(Visible)
    local Float = self.Float_Button
    if not Float then return end

    local Target = Visible and 0 or 1

    if Visible then
        Float.Visible = true
        if self.Float_Scale then
            self.Float_Scale.Scale = 0.82
            Create_Tween(self.Float_Scale, 0.34, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
        Create_Tween(Float, 0.26, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    else
        Create_Tween(Float, 0.16, {BackgroundTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        if self.Float_Scale then
            Create_Tween(self.Float_Scale, 0.16, {Scale = 0.82}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        end
        task.delay(0.18, function()
            if Float then Float.Visible = false end
        end)
    end

    if self.Float_Icon then
        Create_Tween(self.Float_Icon, 0.24, {ImageTransparency = Target}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end
    if self.Float_Label then
        Create_Tween(self.Float_Label, 0.24, {TextTransparency = Target}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end
    if self.Float_Stroke then
        Create_Tween(self.Float_Stroke, 0.24, {Transparency = Visible and 0.4 or 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end
end

function Library:Set_Lock(State)
    State = State and true or false
    self.Locked = State

    self.Lock_Generation = (self.Lock_Generation or 0) + 1
    local My_Generation = self.Lock_Generation

    if getgenv then self.Interface_Mode = State and 'Locked' or 'Unlocked' end

    for _, Button in ipairs(self.Tab_Buttons) do
        Button.Active = not State
    end

    self.Body.ScrollingEnabled = not State

    if self.Search_Input then
        self.Search_Input.TextEditable = not State
    end

    if State then
        if self.Lock_Overlay then
            self.Lock_Overlay:Destroy()
            self.Lock_Overlay = nil
            self.Lock_Glyph = nil
            self.Lock_Caption = nil
        end

        local Lock_Overlay = Create_Instance('Frame', {
            Name = 'Locked',
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(248, 248, 250),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 70,
        }, self.Panel)

        Create_Corner(Lock_Overlay, 14)

        Create_Instance('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 234)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10)),
            }),
            Rotation = 90,
        }, Lock_Overlay)

        local Lock_Glyph = Create_Instance('ImageLabel', {
            Name = 'Glyph',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.44),
            Size = UDim2.fromOffset(64, 64),
            BackgroundTransparency = 1,
            Image = self.Interface['Locked'],
            ImageColor3 = Theme.Accent,
            ImageTransparency = 1,
            Rotation = -90,
            ZIndex = 72,
        }, Lock_Overlay)

        local Lock_Caption = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0.44, 28),
            Size = UDim2.fromOffset(200, 18),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = 'Interface Locked',
            TextColor3 = Theme.Accent,
            TextTransparency = 1,
            ZIndex = 32,
        }, Lock_Overlay)

        Create_Instance('TextButton', {
            Name = 'Shield',
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 73,
            AutoButtonColor = false,
        }, Lock_Overlay)

        self.Lock_Overlay = Lock_Overlay
        self.Lock_Glyph = Lock_Glyph
        self.Lock_Caption = Lock_Caption

        Create_Tween(Lock_Overlay, 0.40, {BackgroundTransparency = 0.12}, Enum.EasingStyle.Quint)

        task.delay(0.10, function()
            if self.Lock_Generation ~= My_Generation then return end
            if not Lock_Glyph or not Lock_Glyph.Parent then return end
            Create_Tween(Lock_Glyph, 0.20, {ImageTransparency = 0}, Enum.EasingStyle.Quint)
            Create_Tween(Lock_Glyph, 0.55, {
                Rotation = 0,
                Size = UDim2.fromOffset(52, 52),
            }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            task.delay(0.40, function()
                if self.Lock_Generation ~= My_Generation then return end
                if not Lock_Caption or not Lock_Caption.Parent then return end
                Create_Tween(Lock_Caption, 0.28, {TextTransparency = 0}, Enum.EasingStyle.Quint)
            end)
        end)
    else
        local Glyph = self.Lock_Glyph
        local Caption = self.Lock_Caption
        local Overlay = self.Lock_Overlay

        if not Overlay then
            self:Status('Interface unlocked', Theme.Accent, 1.6)
            return
        end

        self.Lock_Overlay = nil
        self.Lock_Glyph = nil
        self.Lock_Caption = nil

        if Caption then
            Create_Tween(Caption, 0.18, {TextTransparency = 1}, Enum.EasingStyle.Quint)
        end

        task.delay(0.10, function()
            if self.Lock_Generation ~= My_Generation then return end
            if not Glyph or not Glyph.Parent then return end
            Glyph.Image = self.Interface['Unlocked']
            Glyph.ImageColor3 = Color3.new(1, 1, 1)
            Glyph.Rotation = 0
            Glyph.ImageTransparency = 0
            Glyph.Size = UDim2.fromOffset(52, 52)
            Create_Tween(Glyph, 0.25, {Rotation = 180}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            Create_Tween(Glyph, 0.20, {Size = UDim2.fromOffset(64, 64)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            task.delay(0.25, function()
                if self.Lock_Generation ~= My_Generation then return end
                if not Glyph or not Glyph.Parent then return end
                Create_Tween(Glyph, 0.25, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            end)
        end)

        task.delay(0.07, function()
            if self.Lock_Generation ~= My_Generation then return end
            if not Overlay or not Overlay.Parent then return end
            Create_Tween(Overlay, 0.45, {BackgroundTransparency = 1}, Enum.EasingStyle.Sine)
        end)

        task.delay(0.62, function()
            if self.Lock_Generation ~= My_Generation then return end
            if Overlay and Overlay.Parent then
                Overlay:Destroy()
            end
        end)
    end

    self:Status(
        State and 'Interface locked' or 'Interface unlocked',
        State and Color3.fromRGB(230, 188, 64) or Theme.Accent, 1.6
    )
end

function Library:Toggle_Minimize()
    if self.Tweening then return end
    if self.Minimize_Sound then
    	self.Minimize_Sound.Volume = self.Clicks_Volume_Enabled or 0.5
    	self.Minimize_Sound:Play()
	end
    self.Minimized = not self.Minimized
    local Target_Width = self.Custom_Size and self.Custom_Size.X or 700
    local Target_Height = self.Minimized and 92 or (self.Custom_Size and self.Custom_Size.Y or 450)
    Create_Tween(self.Panel, 0.28, {Size = UDim2.fromOffset(Target_Width, Target_Height)})
    self.Body.Visible, self.Footer.Visible = not self.Minimized, not self.Minimized
    self.Minimize_Button.Text = self.Minimized and '▲  Expand' or '▼  Min'
end

function Library:Destroy_Interface(Callback)
    if not self:exist() then
        self:Destroy()
        if Callback then pcall(Callback) end
        return
    end

    if self.Tweening then
        task.delay(0.32, function() self:Destroy_Interface(Callback) end)
        return
    end

    self.Tweening = true
    Clear_All_Connections()

	if self.Body then self.Body.Visible = false end
    if self.Footer then self.Footer.Visible = false end
    if self.Minimize_Button then self.Minimize_Button.Text = '▲  Expand' end

    Create_Tween(self.Panel, 0.38, {
        Position = self.Panel.Position - UDim2.fromOffset(0, 18),
        GroupTransparency = 1,
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    Create_Tween(self.Interface_Scale, 0.38, {
        Scale = self.Interface_Scale.Scale * 0.88,
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    if self.Float_Button then
        Create_Tween(self.Float_Button, 0.22, {
            BackgroundTransparency = 1,
            ImageTransparency = 1,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end

    task.delay(0.40, function()
        self.Tweening = false
        self:Destroy()
        if Callback then pcall(Callback) end
    end)
end

function Library:Create_Tab(Name, Icon)
    local Tab_Index = #self.Tabs + 1
    local Is_First = Tab_Index == 1

    local Tab_Button = Create_Instance('TextButton', {
        Name = Name,
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = Is_First and Color3.fromRGB(255, 255, 255) or Theme.Panel_3,
        BackgroundTransparency = Is_First and 0.02 or 0.58,
        BorderSizePixel = 0,
        FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Bold),
        TextSize = 14,
        TextScaled = false,
        TextWrapped = false,
        TextStrokeTransparency = 1,
        Text = (not Icon or Icon == '') and string.upper(string.sub(Name, 1, 1)) or '',
        TextColor3 = Is_First and Theme.Accent or Theme.Dim,
        LayoutOrder = Tab_Index,
        ZIndex = 13,
        AutoButtonColor = false,
    }, self.Tab_Bar)
    Create_Corner(Tab_Button, 16)
    local Button_Stroke = Create_Stroke(Tab_Button, Is_First and Theme.Accent or Theme.Border, 1.2, Is_First and 0.12 or 0.72)

    local Tooltip = Create_Instance('Frame', {
        Name = 'TabNameTooltip',
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromOffset(58, 49),
        Size = UDim2.fromOffset(176, 27),
        BackgroundColor3 = Color3.fromRGB(248, 248, 250),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Active = false,
        ZIndex = 60,
    }, self.Panel)
    Create_Corner(Tooltip, 11)
    local Tooltip_Stroke = Create_Stroke(Tooltip, Theme.Border, 1, 1)
    Create_Instance('UIGradient', {
        Rotation = 0,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(222, 222, 228)),
        }),
    }, Tooltip)
    local Tooltip_Text = Create_Instance('TextLabel', {
        Name = 'Title',
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -24, 1, 0),
        BackgroundTransparency = 1,
        FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
        Text = Name,
        TextColor3 = Color3.fromRGB(28, 28, 32),
        TextSize = 13,
        TextScaled = false,
        TextWrapped = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextStrokeTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTransparency = 1,
        ZIndex = 61,
    }, Tooltip)

    local Tooltip_Generation = 0
    local function Hide_Tab_Tooltip()
        Tooltip_Generation += 1
        local Hide_Generation = Tooltip_Generation
        if not Tooltip.Visible then return end
        local Hide_Tween = Create_Tween(Tooltip, 0.16, {
            BackgroundTransparency = 1,
            Position = Tooltip.Position - UDim2.fromOffset(4, 0),
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        Create_Tween(Tooltip_Text, 0.12, {TextTransparency = 1}, Enum.EasingStyle.Sine)
        if Tooltip_Stroke then
            Create_Tween(Tooltip_Stroke, 0.12, {Transparency = 1}, Enum.EasingStyle.Sine)
        end
        Hide_Tween.Completed:Connect(function()
            if Tooltip_Generation == Hide_Generation then Tooltip.Visible = false end
        end)
    end
    local function Schedule_Tab_Tooltip()
        Tooltip_Generation += 1
        local My_Generation = Tooltip_Generation
        task.delay(0.55, function()
            if My_Generation ~= Tooltip_Generation or not Tab_Button.Parent then return end
            -- Keep the tab name in the reserved strip between the title and search bar.
            -- This avoids covering the tab content, controls, or the tab rail itself.
            local Target_Position = UDim2.fromOffset(58, 49)
            Tooltip.Position = Target_Position + UDim2.fromOffset(0, -3)
            Tooltip.Visible = true
            Create_Tween(Tooltip, 0.22, {
                BackgroundTransparency = 0.08,
                Position = Target_Position,
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            Create_Tween(Tooltip_Text, 0.22, {TextTransparency = 0}, Enum.EasingStyle.Sine)
            if Tooltip_Stroke then
                Create_Tween(Tooltip_Stroke, 0.22, {Transparency = 0.45}, Enum.EasingStyle.Sine)
            end
        end)
    end

    if Icon and Icon ~= '' then
        local Image = Create_Instance('ImageLabel', {
            Name = 'Icon',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://' .. Icon,
            ImageColor3 = Is_First and Theme.Accent or Theme.Dim,
            ImageTransparency = Is_First and 0 or 0.28,
            ZIndex = 14,
        }, Tab_Button)
        Tab_Button:GetPropertyChangedSignal('TextColor3'):Connect(function()
            Image.ImageColor3 = Tab_Button.TextColor3
        end)
    end

    local Active_Dot = Create_Instance('Frame', {
        Name = 'ActiveDot',
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -2),
        Size = Is_First and UDim2.fromOffset(5, 5) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = Is_First and 0 or 1,
        BorderSizePixel = 0,
        ZIndex = 15,
    }, Tab_Button)
    Create_Corner(Active_Dot, 4)

    Tab_Button.MouseEnter:Connect(function()
        if self.Active_Tab ~= Tab_Index then
            Create_Tween(Tab_Button, 0.18, {BackgroundTransparency = 0.28}, Enum.EasingStyle.Sine)
        end
        Schedule_Tab_Tooltip()
    end)
    Tab_Button.MouseLeave:Connect(function()
        if self.Active_Tab ~= Tab_Index then
            Create_Tween(Tab_Button, 0.18, {BackgroundTransparency = 0.58}, Enum.EasingStyle.Sine)
        end
        Hide_Tab_Tooltip()
    end)
    Tab_Button.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Schedule_Tab_Tooltip()
        end
    end)
    Tab_Button.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Hide_Tab_Tooltip()
        end
    end)

    table.insert(self.Tab_Buttons, Tab_Button)
    self.Tab_Icons[Tab_Index] = Tab_Button:FindFirstChild('Icon')
    
	local Captured_Index = Tab_Index
    
	Tab_Button.MouseButton1Click:Connect(function()
        if self.Search_Input and self.Search_Input.Text ~= '' then self.Search_Input.Text = '' end
        self:Switch_Tab(Captured_Index)
    end)

    local Pane = Create_Instance('CanvasGroup', {
        Name = Name .. ' Pane', 
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, 
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        Visible = Is_First, 
        Position = Is_First and UDim2.fromScale(0, 0.025) or UDim2.fromScale(0, 0),
        ZIndex = 12,
    }, self.Body)

    Create_Instance('UIPadding', {
        PaddingTop = UDim.new(0, 10), 
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 14), 
        PaddingRight = UDim.new(0, 14),
    }, Pane)

    Create_Instance('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal, 
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder, 
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, Pane)

    table.insert(self.Tabs, Pane)

	if Is_First then
    	task.spawn(function()
        	task.wait(0.05)
            Create_Tween(Pane, 0.46, {
                GroupTransparency = 0,
                Position = UDim2.fromScale(0, 0),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
    end

    local function Make_Column(Order_Number)
        local Column = Create_Instance('Frame', {
            Name = 'Section',
            Size = UDim2.new(0.5, -6, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, 
            LayoutOrder = Order_Number, 
            ZIndex = 12,
        }, Pane)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 6), 
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        }, Column)
        return Column
    end

    local Left_Column = Make_Column(1)
    local Right_Column = Make_Column(2)

    local Tab = {}
    local Order_Left, Order_Right = 0, 0

    local function Target_Column(Section)
        if type(Section) == 'table' then
            return Section.Frame
        end
        if Section == 'right' then return Right_Column end
        return Left_Column
    end

    local function Next_Order(Section)
        if type(Section) == 'table' then
            Section.Order = Section.Order + 1
            return Section.Order
        end
        if Section == 'right' then Order_Right += 1; return Order_Right end
        Order_Left += 1; return Order_Left
    end

    local function Register_Search(Object, Search_Name, Search_Info, Search_Flag)
    	local Combined = table.concat({
        	tostring(Search_Name or ''),
        	tostring(Search_Info or ''),
        	tostring(Search_Flag or ''),
    	}, ' ')
    	table.insert(self.Search_Items, {Object = Object, Name = Combined, Tab_Index = Tab_Index})
	end

    local function Row_Frame(Height, Section)
        local Row = Create_Instance('Frame', {
            Size = UDim2.new(1, 0, 0, Height), 
            BackgroundColor3 = Theme.Panel_2,
            BorderSizePixel = 0, 
            LayoutOrder = Next_Order(Section), 
            ZIndex = 15,
        }, Target_Column(Section))
        Create_Corner(Row, 8)
        local Row_Stroke = Create_Stroke(Row, Theme.Border, 1, 0.5)
        return Row, Row_Stroke
    end

    local function Row_Header(Parent, Name, Badge, Y_Offset)
        local Head = Create_Instance('Frame', {
            Position = UDim2.fromOffset(14, Y_Offset or 9), 
            Size = UDim2.new(1, -112, 0, 18),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            ZIndex = 16,
        }, Parent)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal, 
            Padding = UDim.new(0, 6),
            VerticalAlignment = Enum.VerticalAlignment.Center, 
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Head)

        Create_Instance('TextLabel', {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 14,
            Text = Name,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            LayoutOrder = 1,
            ZIndex = 16,
        }, Head)

        if Badge then
            local Badge_Color = Badge_Colors[Badge] or Badge_Colors.New
            local Badge_Label = Create_Instance('TextLabel', {
                AutomaticSize = Enum.AutomaticSize.X, 
                Size = UDim2.fromOffset(0, 16),
                BackgroundColor3 = Badge_Color.Background, 
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
                TextSize = 10,
                Text = Badge, 
                TextColor3 = Badge_Color.Text, 
                LayoutOrder = 2, 
                ZIndex = 16,
            }, Head)

            Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Badge_Label)
            Create_Corner(Badge_Label, 4)
            Create_Stroke(Badge_Label, Badge_Color.Border, 1, 0.5)
        end
    end

    local function Row_Hover(Row)
        local Hover_Button = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1), 
            BackgroundTransparency = 1, 
            Text = '',
            ZIndex = 14, 
            AutoButtonColor = false,
        }, Row)
        Hover_Button.MouseEnter:Connect(function() 
            Create_Tween(Row, 0.14, {BackgroundColor3 = Theme.Panel_3}) 
        end)
        Hover_Button.MouseLeave:Connect(function() 
            Create_Tween(Row, 0.14, {BackgroundColor3 = Theme.Panel_2}) 
        end)
        return Hover_Button
    end

    function Tab.Create_Title(Options)
        local Title_Object = Create_Instance('TextLabel', {
            Name = 'Title',
            Size = UDim2.new(1, 0, 0, 24), 
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
            TextSize = 13, 
            Text = Options.name or '',
            TextColor3 = Theme.Accent, 
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = Next_Order(Options.section), 
            ZIndex = 15,
        }, Target_Column(Options.section))
        Register_Search(Title_Object, '')
    end

    function Tab.Create_Label(Options)
        local Label = Create_Instance('TextLabel', {
            Size = UDim2.new(1, 0, 0, 20), 
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
            TextSize = 11, 
            Text = Options.name or '',
            TextColor3 = Theme.Dim, 
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = Next_Order(Options.section), 
            ZIndex = 15,
        }, Target_Column(Options.section))
        Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 4)}, Label)
        Register_Search(Label, Options.name)
    end

    function Tab.Create_Paragraph(Options)
        local Row = Create_Instance('Frame', {
            Name = 'Paragraph',
            Size = UDim2.new(1, 0, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Panel_2, 
            BorderSizePixel = 0,
            LayoutOrder = Next_Order(Options.section), 
            ZIndex = 15,
        }, Target_Column(Options.section))
        
        Create_Corner(Row, 8)
        Create_Stroke(Row, Theme.Border, 1, 0.5)

        Create_Instance('UIPadding', {
            PaddingLeft = UDim.new(0, 14), 
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10), 
            PaddingBottom = UDim.new(0, 12),
        }, Row)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 6), 
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
        }, Row)

        local Head = Create_Instance('Frame', {
            Size = UDim2.new(1, 0, 0, 18), 
            BackgroundTransparency = 1,
            LayoutOrder = 1, 
            ZIndex = 16,
        }, Row)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal, 
            Padding = UDim.new(0, 6),
            VerticalAlignment = Enum.VerticalAlignment.Center, 
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Head)

        Create_Instance('TextLabel', {
            AutomaticSize = Enum.AutomaticSize.X, 
            Size = UDim2.fromOffset(0, 18),
            BackgroundTransparency = 1, 
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
			TextSize = 14,
            Text = Options.title or '', 
            TextColor3 = Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Left, 
            LayoutOrder = 1, ZIndex = 16,
        }, Head)

        if Options.badge then
            local Badge_Color = Badge_Colors[Options.badge] or Badge_Colors.New
            local Badge_Label = Create_Instance('TextLabel', {
                AutomaticSize = Enum.AutomaticSize.X, 
                Size = UDim2.fromOffset(0, 16),
                BackgroundColor3 = Badge_Color.Background, 
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
                TextSize = 10,
                Text = Options.badge, 
                TextColor3 = Badge_Color.Text, 
                LayoutOrder = 2, 
                ZIndex = 16,
            }, Head)
            Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Badge_Label)
            Create_Corner(Badge_Label, 4)
            Create_Stroke(Badge_Label, Badge_Color.Border, 1, 0.5)
        end

        Create_Instance('TextLabel', {
            Size = UDim2.new(1, 0, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, 
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
            TextSize = 12,
            Text = Options.content or '', 
            TextColor3 = Theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.None,
            RichText = true,
            LineHeight = 1.15,
            LayoutOrder = 2, 
            ZIndex = 16,
        }, Row)

        Register_Search(Row, Options.title, Options.content, Options.flag)
    end

	function Tab.Create_Divider(Options)
        Options = Options or {}

        local Column = Target_Column(Options.section)
        local Order = Next_Order(Options.section)

        local Divider = Create_Instance('Frame', {
            Name = 'Divider',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Options.color or Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            LayoutOrder = Order,
            ZIndex = 15,
        }, Column)

        Create_Instance('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(248, 248, 250)),   
                ColorSequenceKeypoint.new(0.15, Options.color or Color3.fromRGB(32, 32, 36)),
                ColorSequenceKeypoint.new(0.85, Options.color or Color3.fromRGB(32, 32, 36)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(248, 248, 250)), 
            }),
            Transparency = NumberSequence.new(0),
            Rotation = 0,
        }, Divider)

        local function Play()
            Divider.Size = UDim2.new(0, 0, 0, 1)
            Create_Tween(Divider, 0.35, {
                Size = UDim2.new(1, 0, 0, 1),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
        Divider:SetAttribute('IsDivider', true)
        Divider:GetAttributeChangedSignal('Replay'):Connect(function() Play() end)
        task.spawn(function() task.wait(0.05) Play() end)
		Register_Search(Divider, '')
        return Divider
    end

    function Tab.Create_Image(Options)
        local Height = (Options.size and Options.size[2]) or 100

        local Row = Create_Instance('Frame', {
            Name = 'Thumbnail',
            Size = UDim2.new(1, 0, 0, Height),
            BackgroundColor3 = Theme.Panel_2,
            BorderSizePixel = 0,
            LayoutOrder = Next_Order(Options.section),
            ZIndex = 15,
        }, Target_Column(Options.section))

        Create_Corner(Row, 8)
        Create_Stroke(Row, Theme.Border, 1, 0.5)

        local Picture = Create_Instance('ImageLabel', {
            Name = 'Picture',
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://' .. (Options.image or '137740310403393'),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 16,
        }, Row)

        Create_Corner(Picture, 8)

        local Fade = Create_Instance('Frame', {
            Name = 'Gradient',
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0.6, 0),
            BackgroundColor3 = Color3.fromRGB(248, 248, 250),
            BorderSizePixel = 0,
            ZIndex = 17,
        }, Row)

        Create_Instance('UIGradient', {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
        }, Fade)

        Create_Corner(Fade, 8)
        Register_Search(Row, Options.name or 'Image')
        return Row
    end

    function Tab.Create_Playerlist(Options)
        local Flag = Options.flag or Options.name

        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Saved_User_Id = tonumber(Saved_Value)

        local Row_Height = 30
        local Max_Visible = 5
        local List_Height = Max_Visible * Row_Height

        local Diddy = Row_Frame(List_Height + 38, Options.section)
        Diddy.Name = Flag
        Diddy.ClipsDescendants = true

        local Head = Create_Instance('Frame', {
            Position = UDim2.fromOffset(14, 9),
            Size = UDim2.new(1, -28, 0, 18),
            BackgroundTransparency = 1,
            ZIndex = 16,
        }, Diddy)

        Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(0, 0),
            Size = UDim2.fromOffset(160, 18),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 14,
            Text = Options.name or 'Players',
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 16,
        }, Head)

        local Count_Label = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.fromOffset(140, 18),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = 'Online: 0',
            TextColor3 = Theme.Dim,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 16,
        }, Head)

        local List = Create_Instance('ScrollingFrame', {
            Name = 'List',
            Position = UDim2.fromOffset(14, 34),
            Size = UDim2.new(1, -28, 0, List_Height),
            BackgroundColor3 = Theme.Panel,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ZIndex = 16,
        }, Diddy)

        Create_Corner(List, 6)
        Create_Stroke(List, Theme.Border, 1, 0.5)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, List)

        Create_Instance('UIPadding', {
            PaddingTop = UDim.new(0, 3),
            PaddingBottom = UDim.new(0, 3),
        }, List)

		local Empty_Label = Create_Instance('TextLabel', {
            Name = 'Empty State',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, -16, 0, 18),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = 'Server is empty',
            TextColor3 = Theme.Dim,
            Visible = true,
            ZIndex = 17,
        }, List)

        local Rows = {}
        local Selected_User_Id = nil
        local Initialized = false

        local Last_Selected_User_Id = nil
        local function Force_Callback(Player)
            if Options.callback then
                pcall(Options.callback, Player)
            end
        end

        local function Set_Status_Selection(Player_Name, Is_Selected)
            self:Status((Is_Selected and 'Selected: ' or 'Unselected: ') .. Player_Name, Is_Selected and Theme.Accent or Theme.Dim, 1.4)
        end

        local function Update_Count()
            Count_Label.Text = 'Online: ' .. tostring(#Players:GetPlayers())
        end

		local function Update_Empty_State()
            Empty_Label.Visible = next(Rows) == nil
        end

        local function Render_Row_State(Row_Data, Is_Selected, Animate)
            if Animate then
                Create_Tween(Row_Data.Dot, 0.14, {
                    Size = Is_Selected and UDim2.fromOffset(6, 6) or UDim2.fromOffset(0, 0)
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                Create_Tween(Row_Data.Name_Label, 0.14, {
                    Position = Is_Selected and UDim2.fromOffset(24, 0) or UDim2.fromOffset(8, 0),
                    TextColor3 = Is_Selected and Theme.Accent or Theme.Dim,
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            else
                Row_Data.Dot.Size = Is_Selected and UDim2.fromOffset(6, 6) or UDim2.fromOffset(0, 0)
                Row_Data.Name_Label.Position = Is_Selected and UDim2.fromOffset(24, 0) or UDim2.fromOffset(8, 0)
                Row_Data.Name_Label.TextColor3 = Is_Selected and Theme.Accent or Theme.Dim
            end
        end

        local function Apply_Selection(Player, Silent, Animate)
            local New_User_Id = Player and Player.UserId or nil

            if Selected_User_Id and Rows[Selected_User_Id] then
                Render_Row_State(Rows[Selected_User_Id], false, Animate)
            end

            Last_Selected_User_Id = New_User_Id

            Selected_User_Id = New_User_Id
            self.Flags[Flag] = New_User_Id

            if New_User_Id and Rows[New_User_Id] then
                Render_Row_State(Rows[New_User_Id], true, Animate)
            end

            if not Silent then
                if Player then
                    Set_Status_Selection(Player.DisplayName, true)
                end
                if Options.callback then
                    pcall(Options.callback, Player)
                end
            end
        end

        local function Make_Row(Player)
            local Row = Create_Instance('Frame', {
                Name = tostring(Player.UserId),
                Size = UDim2.new(1, 0, 0, Row_Height),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 0,
                ZIndex = 17,
                ClipsDescendants = true,
            }, List)

            local Dot = Create_Instance('Frame', {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 13, 0.5, 0),
                Size = UDim2.fromOffset(0, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 18,
            }, Row)

            Create_Corner(Dot, 3)

            local Name_Label = Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(8, 0),
                Size = UDim2.new(1, -18, 1, 0),
                BackgroundTransparency = 1,
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
                TextSize = 12,
                Text = Player.DisplayName ~= Player.Name and (Player.DisplayName .. ' (' .. Player.Name .. ')') or Player.Name,
                TextColor3 = Theme.Dim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 18,
            }, Row)

            local Click = Create_Instance('TextButton', {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = '',
                ZIndex = 19,
                AutoButtonColor = false,
            }, Row)

            local Row_Data = {
                Row = Row,
                Dot = Dot,
                Name_Label = Name_Label,
                Player = Player,
            }

            Click.MouseButton1Click:Connect(function()
                if Selected_User_Id == Player.UserId then
                    local Left_Player = Player
                    Apply_Selection(nil, false, true)
                    Set_Status_Selection(Left_Player.DisplayName, false)
                    self:Autosave()
                else
                    Apply_Selection(Player, false, true)
                    self:Autosave()
                end
            end)

            Render_Row_State(Row_Data, Selected_User_Id == Player.UserId, false)
            return Row_Data
        end

        local function Sort_Rows()
            local Order_List = {}
            for _, Row_Data in pairs(Rows) do
                table.insert(Order_List, Row_Data)
            end

            table.sort(Order_List, function(A, B)
                return A.Player.Name:lower() < B.Player.Name:lower()
            end)

            for Index, Row_Data in ipairs(Order_List) do
                Row_Data.Row.LayoutOrder = Index
            end
        end

        local function Add_Player(Player, Animate)
            if Player == Local_Player then return end
            if Rows[Player.UserId] then return end

            local Row_Data = Make_Row(Player)
            Rows[Player.UserId] = Row_Data

            Sort_Rows()
            Update_Count()
            Update_Empty_State()

            if Animate then
                Row_Data.Row.Size = UDim2.new(1, 0, 0, 0)
                Create_Tween(Row_Data.Row, 0.2, {
                    Size = UDim2.new(1, 0, 0, Row_Height)
                })
            end

            if Saved_User_Id and Saved_User_Id == Player.UserId and Selected_User_Id == nil then
                Apply_Selection(Player, true, false)
            end

            if Selected_User_Id == Player.UserId then
                Render_Row_State(Row_Data, true, false)
            end

            if Last_Selected_User_Id and Player.UserId == Last_Selected_User_Id then
                task.defer(function()
                    Apply_Selection(Player, true, true)
                    Force_Callback(Player)
                end)
            end
        end

        local function Remove_Player(Player, Animate)
            local Row_Data = Rows[Player.UserId]
            if not Row_Data then return end

            Rows[Player.UserId] = nil
            Update_Count()
            Update_Empty_State()

            if Selected_User_Id == Player.UserId then
                self.Flags[Flag] = Saved_User_Id
                Selected_User_Id = nil

                if Options.callback then
                    pcall(Options.callback, nil)
                end
            end

            if Animate then
                Create_Tween(Row_Data.Row, 0.18, {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1
                })

                Create_Tween(Row_Data.Name_Label, 0.15, {
                    TextTransparency = 1
                })

                Create_Tween(Row_Data.Dot, 0.15, {
                    BackgroundTransparency = 1
                })

                task.delay(0.2, function()
                    if Row_Data.Row then
                        Row_Data.Row:Destroy()
                    end
                end)
            else
                Row_Data.Row:Destroy()
            end
        end

        for _, Player in ipairs(Players:GetPlayers()) do
            Add_Player(Player, false)
        end

        Update_Count()
        Update_Empty_State()

        Connection['Added' .. Flag] = Players.PlayerAdded:Connect(function(Player) Add_Player(Player, true) end)
        Connection['Removed' .. Flag] = Players.PlayerRemoving:Connect(function(Player) Remove_Player(Player, true) end)

        self.Flags[Flag] = Selected_User_Id

        self.Control_Objects[Flag] = {
            Kind = 'playerlist',
            Apply = function(Value, Silent)
                local Target_Id = tonumber(Value)
                local Target_Player = nil

                if Target_Id then
                    for _, Row_Data in pairs(Rows) do
                        if Row_Data.Player.UserId == Target_Id then
                            Target_Player = Row_Data.Player
                            break
                        end
                    end
                end
                Apply_Selection(Target_Player, Silent, true)
            end,
        }

        Register_Search(Diddy, Options.name or Flag, nil, Flag)

        if Options.callback and not Initialized then
            Initialized = true

            local Initial_Player = nil
            if Selected_User_Id then
                for _, Row_Data in pairs(Rows) do
                    if Row_Data.Player.UserId == Selected_User_Id then
                        Initial_Player = Row_Data.Player
                        break
                    end
                end
            end
            pcall(Options.callback, Initial_Player)
        end
    end

    function Tab.Create_Button(Options)
        local Has_Description = Options.info and Options.info ~= ''
        local Row = Row_Frame(Has_Description and 64 or 40, Options.section)
        Row.Name = Options.name or 'Button'
        Row_Header(Row, Options.name or 'Button', Options.badge, Has_Description and 9 or 11)

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 29),
                Size = UDim2.new(1, -76, 0, 30),
                BackgroundTransparency = 1,
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme.Dim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                TextTruncate = Enum.TextTruncate.None,
                ZIndex = 16,
            }, Row)
        end

        local Action_Button = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(1, 0.5), 
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(76, 26), 
            BackgroundColor3 = Color3.fromRGB(225, 225, 230),
            BorderSizePixel = 0, 
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
            TextSize = 12, 
            Text = '▶  Run',
            TextColor3 = Theme.Accent, 
            ZIndex = 18, 
            AutoButtonColor = false,
        }, Row)

        Create_Corner(Action_Button, 6)
        Create_Stroke(Action_Button, Theme.Accent, 1, 0.5)

        --// [Row_Hover(Row)]

        Action_Button.MouseEnter:Connect(function() 
            Create_Tween(Action_Button, 0.12, {BackgroundColor3 = Color3.fromRGB(224, 224, 229)}) 
        end)
        Action_Button.MouseLeave:Connect(function() 
            Create_Tween(Action_Button, 0.12, {BackgroundColor3 = Color3.fromRGB(225, 225, 230)}) 
        end)
        Action_Button.MouseButton1Click:Connect(function()
            Create_Tween(Action_Button, 0.08, {Size = UDim2.fromOffset(70, 24)})
            task.delay(0.08, function() Create_Tween(Action_Button, 0.12, {Size = UDim2.fromOffset(76, 26)}, Spring_Style, Spring_Direction) end)
            self:Status('Ran: ' .. (Options.name or 'Button'), Theme.Accent, 1.2)
            if Options.callback then pcall(Options.callback) end
        end)

        Register_Search(Row, Options.name, Options.info, Options.flag)
    end

    function Tab.Create_Toggle(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
		local Default

		if self.Saved_Config and self.Saved_Config[Flag] ~= nil then
    		Default = self.Saved_Config[Flag] == true
		else
    		Default = Options.enabled == true
		end

        local Has_Description = Options.info and Options.info ~= ''

        local Row = Row_Frame(Has_Description and 64 or 40, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, Has_Description and 9 or 11)

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 29),
                Size = UDim2.new(1, -76, 0, 30),
                BackgroundTransparency = 1,
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
                TextSize = 11,
                Text = Options.info or '', 
                TextColor3 = Theme.Dim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                TextTruncate = Enum.TextTruncate.None,
                ZIndex = 16,
            }, Row)
        end

        local Track = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0.5), 
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(42, 22), 
            BackgroundColor3 = Default and Theme.Accent or Theme.Not_Enabled,
            BorderSizePixel = 0, 
            ZIndex = 16,
        }, Row)

        Create_Corner(Track, 11)

        local Thumb = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = Default and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
            Size = UDim2.fromOffset(16, 16), 
            BackgroundColor3 = Theme.White,
            BorderSizePixel = 0, 
            ZIndex = 17,
        }, Track)

        Create_Corner(Thumb, 8)

        --// [Row_Hover(Row)]

        local State = Default

        local function Render(Value)
            Create_Tween(Track, 0.22, {BackgroundColor3 = Value and Theme.Accent or Theme.Not_Enabled})
            Create_Tween(Thumb, 0.30, {Position = Value and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}, Spring_Style, Spring_Direction)
        end

        local function Apply(Value, Silent)
            Value = Value and true or false
            State = Value
            self.Flags[Flag] = Value
            Render(Value)
            if not Silent and Options.callback then pcall(Options.callback, Value) end
        end

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {Kind = 'toggle', Apply = Apply}

		Render(Default)

		if Options.callback then
    		pcall(Options.callback, Default)
		end
	
        local Click_Button = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1), 
            BackgroundTransparency = 1, 
            Text = '', 
            ZIndex = 18,
        }, Row)

        Click_Button.MouseButton1Click:Connect(function()
            Apply(not State, false)
            self:Status((State and 'Enabled: ' or 'Disabled: ') .. (Options.name or Flag),
                State and Theme.Accent or Theme.Dim, 1.4)
            self:Autosave()
        end)

        Register_Search(Row, Options.name or Flag, Options.info, Flag)
    end

	function Tab.Create_Checkbox(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Default

        if self.Saved_Config and self.Saved_Config[Flag] ~= nil then
            Default = self.Saved_Config[Flag] == true
        else
            Default = Options.enabled == true
        end

        local Has_Description = Options.info and Options.info ~= ''

        local Row = Row_Frame(Has_Description and 64 or 40, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, Has_Description and 9 or 11)

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 30),
                Size = UDim2.fromOffset(300, 14),
                BackgroundTransparency = 1,
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme.Dim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 16,
            }, Row)
        end

        local Box = Create_Instance('Frame', {
            Name = 'Box',
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(24, 24),
            BackgroundColor3 = Theme.Not_Enabled,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 16,
        }, Row)

        Create_Corner(Box, 9)

        local Box_Stroke = Create_Stroke(Box, Theme.Border, 1, 0.35)

        local Fill = Create_Instance('Frame', {
            Name = 'Fill',
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = Default and 0 or 1,
            BorderSizePixel = 0,
            ZIndex = 17,
        }, Box)

        Create_Corner(Fill, 9)

        local Check = Create_Instance('ImageLabel', {
            Name = 'Check',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = Default and UDim2.fromOffset(13, 13) or UDim2.fromOffset(9, 9),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://7733774602',
            ImageColor3 = Theme.White,
            ImageTransparency = Default and 0 or 1,
            ZIndex = 18,
        }, Box)

        --// [Row_Hover(Row)]

        local State = Default

        local function Render(Value)
            Create_Tween(Box_Stroke, 0.16, {
                Color = Value and Theme.Accent or Theme.Border,
                Transparency = Value and 0.1 or 0.35,
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

            Create_Tween(Fill, 0.18, {
                BackgroundTransparency = Value and 0 or 1,
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

            Create_Tween(Check, 0.18, {
                Size = Value and UDim2.fromOffset(13, 13) or UDim2.fromOffset(9, 9),
                ImageTransparency = Value and 0 or 1,
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end

        local function Apply(Value, Silent)
            Value = Value and true or false
            State = Value
            self.Flags[Flag] = Value
            Render(Value)
            if not Silent and Options.callback then pcall(Options.callback, Value) end
        end

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {Kind = 'fillbox', Apply = Apply}

        if Options.callback then
            pcall(Options.callback, Default)
        end

        local Click_Button = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 18,
        }, Row)

        Click_Button.MouseButton1Click:Connect(function()
            Apply(not State, false)
            self:Status((State and 'Enabled: ' or 'Disabled: ') .. (Options.name or Flag),
                State and Theme.Accent or Theme.Dim, 1.4)
            self:Autosave()
        end)

        Register_Search(Row, Options.name or Flag, Options.info, Flag)
    end

    function Tab.Create_Slider(Options)
        local Flag = Options.flag or Options.name
        local Min = Options.min or 0
        local Max = Options.max or 100
        local Step = Options.step or 0
        local Decimals = Options.decimals or math.max(0, -math.floor(math.log10(Step or 1)))
        local Suffix = Options.suffix or ''

        local function Snap(Value)
    		local Number = tonumber(Value)
    		if not Number then return nil end
    		if Step and Step > 0 then
        		local Steps = math.floor((Number - Min) / Step + 0.5)
        		Number = Min + Steps * Step
    		end
    		local Multiplier = 10 ^ Decimals
    		Number = math.floor(Number * Multiplier + 0.5) / Multiplier
    		return math.clamp(Number, Min, Max)
		end

        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
		local Default = Snap(Saved_Value)
		if Default == nil then
   	 		Default = Snap(Options.default) or Min
		end

        local Row = Row_Frame(56, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, 9)

        local Value_Label = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(1, 0), 
            Position = UDim2.new(1, -14, 0, 9),
            Size = UDim2.fromOffset(120, 18), 
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
            TextSize = 13, 
            Text = '',
            TextColor3 = Theme.Accent, 
            TextXAlignment = Enum.TextXAlignment.Right, 
            ZIndex = 16,
        }, Row)

        local Bar_Background = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0, 0.5), 
            Position = UDim2.new(0, 14, 1, -16),
            Size = UDim2.new(1, -28, 0, 6), 
            BackgroundColor3 = Theme.Not_Enabled,
            BorderSizePixel = 0, 
            ZIndex = 16,
        }, Row)

        Create_Corner(Bar_Background, 3)

        local Fill = Create_Instance('Frame', {
            Size = UDim2.fromScale(0, 1), 
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0, 
            ZIndex = 17,
        }, Bar_Background)

        Create_Corner(Fill, 3)

        local Knob = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0.5, 0.5), 
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromOffset(14, 14), 
            BackgroundColor3 = Theme.White,
            BorderSizePixel = 0, 
            ZIndex = 18,
        }, Bar_Background)

        Create_Corner(Knob, 7)
        Create_Stroke(Knob, Theme.Accent, 2, 0)

        --// [Row_Hover(Row)]

        local function Set_Value(Value, Silent, Instant)
    	local Number = Snap(Value)
    	if Number == nil then return end
    	self.Flags[Flag] = Number
    	local Alpha = (Max == Min) and 0 or (Number - Min) / (Max - Min)
    	Value_Label.Text = tostring(Number) .. Suffix
    	if Instant then
        	Create_Tween(Fill, 0.045, {Size = UDim2.fromScale(Alpha, 1)}, Enum.EasingStyle.Linear)
        	Create_Tween(Knob, 0.045, {Position = UDim2.fromScale(Alpha, 0.5)}, Enum.EasingStyle.Linear)
    	else
        	Create_Tween(Fill, 0.12, {Size = UDim2.fromScale(Alpha, 1)}, Enum.EasingStyle.Quint)
        	Create_Tween(Knob, 0.12, {Position = UDim2.fromScale(Alpha, 0.5)}, Enum.EasingStyle.Quint)
    	end
    		if not Silent and Options.callback then pcall(Options.callback, Number) 
			end
		end

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {Kind = 'slider', Apply = function(Value, Silent) Set_Value(Value, Silent, false) end}

        local Dragging = false
        local function Value_From_X(Pixel_X)
            local Absolute_X = Bar_Background.AbsolutePosition.X
            local Width = Bar_Background.AbsoluteSize.X
            return Min + math.clamp((Pixel_X - Absolute_X) / math.max(Width, 1), 0, 1) * (Max - Min)
        end

        local Hit_Area = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(0.5, 0.5), 
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1.09, 0, 0, 25), 
            BackgroundTransparency = 1, 
            Text = '',
            ZIndex = 19, 
            AutoButtonColor = false,
        }, Bar_Background)

        Hit_Area.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                Set_Value(Value_From_X(Input.Position.X), false, true)
            end
        end)

        Connection['Slider_End_' .. Flag] = UserInputService.InputEnded:Connect(function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
                Dragging = false
                self:Autosave()
            end
        end)

        Connection['Slider_Drag_' .. Flag] = UserInputService.InputChanged:Connect(function(Input)
            if not Dragging then return end
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch then return end
            Set_Value(Value_From_X(Input.Position.X), false, true)
        end)

        Set_Value(Default, true, true)

		if Options.callback then
    		pcall(Options.callback, Default)
		end

        Register_Search(Row, Options.name or Flag, nil, Flag)
    end

    function Tab.Create_Dropdown(Options)
    	local Flag = Options.flag or Options.name
    	local Choices = Options.options or {}
    	local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
		local Default = Saved_Value ~= nil and Saved_Value or (Options.default or Choices[1])
    	local Row_Height = 28
    	local Max_List = math.min(#Choices, 5)
    	local Needs_Scroll = #Choices > 5

    	local Row = Row_Frame(46, Options.section)
    	Row.Name = Flag
    	Row_Header(Row, Options.name or Flag, Options.badge, 14)

    	local Box = Create_Instance('TextButton', {
        	AnchorPoint = Vector2.new(1, 0), 
        	Position = UDim2.new(1, -14, 0, 9),
        	Size = UDim2.fromOffset(140, 28), 
        	BackgroundColor3 = Theme.Not_Enabled,
        	BorderSizePixel = 0, 
       	 	FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
        	TextSize = 12,
        	Text = '', 
        	TextColor3 = Theme.Text, 
        	ZIndex = 17, 
        	AutoButtonColor = false,
    	}, Row)

    	Create_Corner(Box, 6)
    	Create_Stroke(Box, Theme.Border, 1, 0.5)

    	local Selected_Label = Create_Instance('TextLabel', {
        	Position = UDim2.fromOffset(10, 0), 
        	Size = UDim2.new(1, -34, 1, 0),
        	BackgroundTransparency = 1, 
        	FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
        	TextSize = 12,
        	Text = tostring(Default), 
        	TextColor3 = Theme.Text,
        	TextXAlignment = Enum.TextXAlignment.Left, 
        	TextTruncate = Enum.TextTruncate.AtEnd,
        	ZIndex = 18,
    	}, Box)

    	local Arrow = Create_Instance('TextLabel', {
        	AnchorPoint = Vector2.new(1, 0.5), 
        	Position = UDim2.new(1, -8, 0.5, 0),
        	Size = UDim2.fromOffset(14, 14), 
        	BackgroundTransparency = 1,
        	FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
        	TextSize = 12,
        	Text = '▼', 
        	TextColor3 = Theme.Muted, 
        	ZIndex = 18,
    	}, Box)

    	local List = Create_Instance('ScrollingFrame', {
    		Position = UDim2.new(0, 14, 0, 46),
    		Size = UDim2.new(1, -28, 0, 0),
    		BackgroundColor3 = Theme.Panel,
    		BorderSizePixel = 0,
    		ClipsDescendants = true,
    		CanvasSize = UDim2.new(0, 0, 0, 0),
    		AutomaticCanvasSize = Needs_Scroll and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
    		ScrollBarThickness = Needs_Scroll and 4 or 0,
    		ScrollBarImageColor3 = Theme.Accent,
    		ScrollingDirection = Enum.ScrollingDirection.Y,
    		ScrollingEnabled = Needs_Scroll,
    		ZIndex = 19,
		}, Row)

    	Create_Corner(List, 6)
    	Create_Stroke(List, Theme.Border, 1, 0.5)
    	Create_Instance('UIListLayout', {SortOrder = Enum.SortOrder.LayoutOrder}, List)
    	Create_Instance('UIPadding', {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3)}, List)

    	local Is_Open = false
    	local Full_Height = Max_List * Row_Height + 6

    	local function Close()
        	if not Is_Open then return end
        	Is_Open = false
        	self.Open_Dropdown = nil
        	List.Visible = false
        	List.CanvasPosition = Vector2.new(0, 0)
        	Create_Tween(Arrow, 0.18, {Rotation = 0})
        	Create_Tween(List, 0.20, {Size = UDim2.new(1, -28, 0, 0)})
        	Create_Tween(Row, 0.22, {Size = UDim2.new(1, 0, 0, 46)})
    	end

    	List.Visible = false
    	List.Size = UDim2.new(1, -28, 0, 0)
    	List.CanvasPosition = Vector2.new(0, 0)

        local function Set_Value(Value, Silent)
            self.Flags[Flag] = Value
            Selected_Label.Text = tostring(Value)
            for _, Child in ipairs(List:GetChildren()) do
                if Child:IsA('TextButton') then
                    Child.TextColor3 = (Child.Text == '   ' .. tostring(Value)) and Theme.Accent or Theme.Muted
                end
            end
            if not Silent and Options.callback then pcall(Options.callback, Value) end
        end

        local function Open_List()
    		if Is_Open then Close() return end
    		if self.Open_Dropdown then self.Open_Dropdown() end
    		Is_Open = true
    		self.Open_Dropdown = Close
    		List.Visible = true
    		List.CanvasPosition = Vector2.new(0, 0)
    		Create_Tween(Arrow, 0.18, {Rotation = 180})
    		Create_Tween(List, 0.22, {Size = UDim2.new(1, -28, 0, Full_Height)})
    		Create_Tween(Row, 0.24, {Size = UDim2.new(1, 0, 0, 46 + Full_Height + 8)})
		end

        for Index, Choice in ipairs(Choices) do
            local Item = Create_Instance('TextButton', {
                Size = UDim2.new(1, 0, 0, Row_Height), 
                BackgroundColor3 = Theme.Panel,
                BackgroundTransparency = 1, 
                BorderSizePixel = 0, 
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
                TextSize = 12, 
                Text = '   ' .. tostring(Choice),
                TextColor3 = (Choice == Default) and Theme.Accent or Theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left, 
                LayoutOrder = Index,
                ZIndex = 20, 
                AutoButtonColor = false,
            }, List)

            Item.MouseButton1Click:Connect(function()
    			Set_Value(Choice, false)
    			self:Status('Selected: ' .. tostring(Choice), Theme.Accent, 1.2)
    			self:Autosave()
    			if Options.trigger ~= false then
       				Close()
    			end
			end)
        end

        Box.MouseButton1Click:Connect(Open_List)

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {Kind = 'dropdown', Apply = function(Value, Silent) Set_Value(Value, Silent) end}

		Set_Value(Default, true)

		if Options.callback then
    		pcall(Options.callback, Default)
		end

        Register_Search(Row, Options.name or Flag)
    end

    function Tab.Create_Keybind(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
		local Default = Options.default or Enum.KeyCode.None

		if Saved_Value ~= nil then
    		Default = Enum.KeyCode[tostring(Saved_Value)] or Default
		end

        local Row = Row_Frame(46, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, 14)

        local function Key_Text(Key)
            if not Key or Key == Enum.KeyCode.None then return 'None' end
            return tostring(Key):gsub('Enum.KeyCode.', '')
        end

        local Box = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(1, 0.5), 
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(120, 28), 
            BackgroundColor3 = Theme.Not_Enabled,
            BorderSizePixel = 0, 
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), 
            TextSize = 12,
            Text = Key_Text(Default), 
            TextColor3 = Theme.Text, 
            ZIndex = 17, 
            AutoButtonColor = false,
        }, Row)

        Create_Corner(Box, 6)
        local Box_Stroke = Create_Stroke(Box, Theme.Border, 1, 0.5)

        local Current = Default

        local function Set_Key(Key, Silent)
            Current = Key
            self.Flags[Flag] = Key_Text(Key)
            Box.Text = Key_Text(Key)
            if not Silent and Options.callback then pcall(Options.callback, Key) end
        end

        Box.MouseButton1Click:Connect(function()
            Box.Text = '...'
            Create_Tween(Box_Stroke, 0.12, {Color = Theme.Accent, Transparency = 1}) --// [Change if you want (its lowk ass tho)] 
            self.Capturing = function(Key_Code)
                self.Capturing = nil
                Create_Tween(Box_Stroke, 0.12, {Color = Theme.Border, Transparency = 0.3})
                if Key_Code == Enum.KeyCode.Escape then
                    Set_Key(Enum.KeyCode.None, false)
                else
                    Set_Key(Key_Code, false)
                end
                self:Status('Bound: ' .. Key_Text(Current), Theme.Accent, 1.2)
                self:Autosave()
            end
        end)

        Connection['Keybind_Input_' .. Flag] = UserInputService.InputBegan:Connect(function(Input, Game_Processed)
            if Game_Processed or self.Capturing then return end
            if Current and Current ~= Enum.KeyCode.None and Input.KeyCode == Current then
                if Options.callback then pcall(Options.callback, Current) end
            end
        end)

        self.Flags[Flag] = Key_Text(Default)
        self.Control_Objects[Flag] = {
            Kind = 'keybind',
            Apply = function(Value, Silent)
                local Key_Code = Enum.KeyCode[tostring(Value)]
                if Key_Code then Set_Key(Key_Code, Silent) end
            end,
        }

		Set_Key(Default, true)

		if Options.callback then
    		pcall(Options.callback, Default)
		end

        Register_Search(Row, Options.name or Flag)
    end

    function Tab.Create_Separator(Options)
        Options = Options or {}
        local Column = Target_Column(Options.section)
        local Order = Next_Order(Options.section)

        local Row = Create_Instance('Frame', {
            Name = 'Separator',
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            LayoutOrder = Order,
            ZIndex = 15,
        }, Column)

        local Left_Line = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Options.color or Theme.Border,
            BorderSizePixel = 0,
            ZIndex = 15,
        }, Row)

        local Right_Line = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Options.color or Theme.Border,
            BorderSizePixel = 0,
            ZIndex = 15,
        }, Row)

        local Label = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(0, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 11,
            Text = Options.name or '',
            TextColor3 = Options.color or Theme.Dim,
            ZIndex = 16,
        }, Row)

        local function Play()
            local Label_Width = Label.AbsoluteSize.X
            local Total_Width = Row.AbsoluteSize.X
            local Line_Width = math.max(0, (Total_Width - Label_Width - 12) / 2)

            Left_Line.Size = UDim2.new(0, 0, 0, 1)
            Right_Line.Size = UDim2.new(0, 0, 0, 1)

            Create_Tween(Left_Line, 0.35, {
                Size = UDim2.new(0, Line_Width, 0, 1)
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            Create_Tween(Right_Line, 0.35, {
                Size = UDim2.new(0, Line_Width, 0, 1)
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end

        local function Snap()
            local Label_Width = Label.AbsoluteSize.X
            local Total_Width = Row.AbsoluteSize.X
            local Line_Width = math.max(0, (Total_Width - Label_Width - 12) / 2)

            Left_Line.Size = UDim2.new(0, Line_Width, 0, 1)
            Right_Line.Size = UDim2.new(0, Line_Width, 0, 1)
        end

        Row:SetAttribute('IsDivider', true)
        Row:GetAttributeChangedSignal('Replay'):Connect(function() Play() end)
        Row:GetPropertyChangedSignal('AbsoluteSize'):Connect(Snap)
        task.spawn(function() task.wait(0.05) Play() end)

        Register_Search(Row, '')
        return Row
    end

    function Tab.Create_Textbox(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Default = (Saved_Value ~= nil and tostring(Saved_Value)) or (Options.default or '')

        local Has_Description = Options.info and Options.info ~= ''

        local Row = Row_Frame(Has_Description and 64 or 40, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, Has_Description and 9 or 11)

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 30),
                Size = UDim2.fromOffset(200, 14),
                BackgroundTransparency = 1,
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme.Dim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 16,
            }, Row)
        end

        local Box = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(140, 26),
            BackgroundColor3 = Theme.Not_Enabled,
            BorderSizePixel = 0,
            ZIndex = 17,
        }, Row)

        Create_Corner(Box, 6)
        local Box_Stroke = Create_Stroke(Box, Theme.Border, 1, 0.5)

        local Input = Create_Instance('TextBox', {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -16, 1, 0),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = Default,
            PlaceholderText = Options.placeholder or 'Enter text...',
            PlaceholderColor3 = Theme.Dim,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ClearTextOnFocus = Options.clear_on_focus == true,
            ZIndex = 18,
        }, Box)

        local Current = Default
        self.Flags[Flag] = Current

        local function Set_Value(Text, Silent)
            Current = Text
            self.Flags[Flag] = Text
            if not Silent and Options.callback then
                pcall(Options.callback, Text)
            end
        end

        Input.Focused:Connect(function()
            Create_Tween(Box_Stroke, 0.12, {Color = Theme.Accent, Transparency = 1})
        end)

        Input.FocusLost:Connect(function(Enter_Pressed)
            Create_Tween(Box_Stroke, 0.12, {Color = Theme.Border, Transparency = 1})
            local Text = Input.Text
            if Options.max_length then
                Text = Text:sub(1, Options.max_length)
                Input.Text = Text
            end
            Set_Value(Text, false)
            self:Status((Options.name or Flag) .. ': ' .. tostring(Text), Theme.Accent, 1.2)
            self:Autosave()
        end)

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {
            Kind = 'textbox',
            Apply = function(Value, Silent)
                Input.Text = tostring(Value or '')
                Set_Value(tostring(Value or ''), Silent)
            end,
        }

        Set_Value(Default, true)
        if Options.callback then
            pcall(Options.callback, Default)
        end
        Register_Search(Row, Options.name or Flag, Flag)
    end

    function Tab.Create_Color_Picker(Options)
        local Flag = Options.flag or Options.name
        local Saved_Value = self.Saved_Config and self.Saved_Config[Flag]
        local Default = Options.default or Theme.Accent

        if Saved_Value ~= nil then
            local Saved_Color = typeof(Saved_Value) == 'Color3' and Saved_Value or Hex_To_Color(Saved_Value)
            if Saved_Color then
                Default = Saved_Color
            end
        end

        local Row = Row_Frame(46, Options.section)
        Row.Name = Flag
        Row_Header(Row, Options.name or Flag, Options.badge, 14)

        local Hue, Saturation, Value = Color3.toHSV(Default)
        local SV_Target_X, SV_Target_Y = Saturation, 1 - Value
        local Hue_Target = Hue

        local Swatch = Create_Instance('TextButton', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -14, 0, 12),
            Size = UDim2.fromOffset(40, 22),
            BackgroundColor3 = Default,
            BorderSizePixel = 0,
            Text = '',
            ZIndex = 17,
            AutoButtonColor = false,
        }, Row)

        Create_Corner(Swatch, 6)
        Create_Stroke(Swatch, Theme.Border, 1, 0.5)

        local Icon = Create_Instance('TextLabel', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -60, 0, 12),
            Size = UDim2.fromOffset(14, 18),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 12,
            Text = '▼',
            TextColor3 = Theme.Muted,
            ZIndex = 17,
        }, Row)

        local Picker = Create_Instance('Frame', {
            Position = UDim2.new(0, 14, 0, 46),
            Size = UDim2.new(1, -28, 0, 0),
            BackgroundColor3 = Theme.Panel,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 19,
        }, Row)

        Create_Corner(Picker, 6)
        Create_Stroke(Picker, Theme.Border, 1, 0.5)

        local Pad = Create_Instance('Frame', {
            Position = UDim2.fromOffset(10, 10),
            Size = UDim2.new(1, -20, 0, 90),
            BackgroundTransparency = 1,
            ZIndex = 20,
        }, Picker)

        local SV_Box = Create_Instance('Frame', {
            Size = UDim2.new(1, -26, 1, 0),
            BackgroundColor3 = Color3.fromHSV(Hue, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 20,
        }, Pad)

        Create_Corner(SV_Box, 4)

        local White_Gradient = Create_Instance('Frame', {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 20
        }, SV_Box)

        Create_Corner(White_Gradient, 4)
        Create_Instance('UIGradient', {
            Transparency = NumberSequence.new(0, 1)
        }, White_Gradient)

        local Black_Gradient = Create_Instance('Frame', {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 21
        }, SV_Box)

        Create_Corner(Black_Gradient, 0)
        Create_Instance('UIGradient', {
            Rotation = 90,
            Transparency = NumberSequence.new(1, 0)
        }, Black_Gradient)

        local SV_Cursor = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(8, 8),
            BackgroundColor3 = Theme.White,
            BorderSizePixel = 0,
            ZIndex = 22,
            Position = UDim2.fromScale(Saturation, 1 - Value),
        }, SV_Box)

        Create_Corner(SV_Cursor, 4)
        Create_Stroke(SV_Cursor, Color3.new(0, 0, 0), 1, 0.2)

        local Hue_Bar = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.fromOffset(18, 90),
            BorderSizePixel = 0,
            ZIndex = 20,
        }, Pad)

        Create_Corner(Hue_Bar, 4)

        Create_Instance('UIGradient', {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
            })
        }, Hue_Bar)

        local Hue_Cursor = Create_Instance('Frame', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, Hue, 0),
            Size = UDim2.new(1, 4, 0, 3),
            BackgroundColor3 = Theme.White,
            BorderSizePixel = 0,
            ZIndex = 22,
        }, Hue_Bar)

        Create_Corner(Hue_Cursor, 2)

        local Is_Open = false
        local SV_Dragging, Hue_Dragging = false, false

        local function Recolor(Silent)
            local Color = Color3.fromHSV(Hue, Saturation, Value)
            Swatch.BackgroundColor3 = Color
            SV_Box.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
            self.Flags[Flag] = Color
            if not Silent and Options.callback then
                pcall(Options.callback, Color)
            end
        end

        local function Set_Open(State_Open)
            Is_Open = State_Open
            Create_Tween(Icon, 0.18, {Rotation = Is_Open and 180 or 0})
            Create_Tween(Picker, 0.22, {Size = UDim2.new(1, -28, 0, Is_Open and 110 or 0)})
            Create_Tween(Row, 0.24, {Size = UDim2.new(1, 0, 0, Is_Open and (46 + 110 + 8) or 46)})
        end

        Swatch.MouseButton1Click:Connect(function()
            Set_Open(not Is_Open)
        end)

        local function Update_SV(Pixel_X, Pixel_Y)
            local Alpha_X = math.clamp((Pixel_X - SV_Box.AbsolutePosition.X) / math.max(SV_Box.AbsoluteSize.X, 1), 0, 1)
            local Alpha_Y = math.clamp((Pixel_Y - SV_Box.AbsolutePosition.Y) / math.max(SV_Box.AbsoluteSize.Y, 1), 0, 1)
            Saturation, Value = Alpha_X, 1 - Alpha_Y
            SV_Target_X, SV_Target_Y = Alpha_X, Alpha_Y
            Recolor(false)
        end

        local function Update_Hue(Pixel_Y)
            local Alpha_Y = math.clamp((Pixel_Y - Hue_Bar.AbsolutePosition.Y) / math.max(Hue_Bar.AbsoluteSize.Y, 1), 0, 1)
            Hue = Alpha_Y
            Hue_Target = Alpha_Y
            Recolor(false)
        end

        local SV_Hit = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 23,
            AutoButtonColor = false
        }, SV_Box)

        local Hue_Hit = Create_Instance('TextButton', {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = '',
            ZIndex = 23,
            AutoButtonColor = false
        }, Hue_Bar)

        SV_Hit.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SV_Dragging = true
                Update_SV(Input.Position.X, Input.Position.Y)
            end
        end)

        Hue_Hit.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Hue_Dragging = true
                Update_Hue(Input.Position.Y)
            end
        end)

        Connection['Color_Drag_' .. Flag] = UserInputService.InputChanged:Connect(function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end

            if SV_Dragging then
                Update_SV(Input.Position.X, Input.Position.Y)
            end

            if Hue_Dragging then
                Update_Hue(Input.Position.Y)
            end
        end)

        Connection['Color_End_' .. Flag] = UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if SV_Dragging or Hue_Dragging then
                    self:Autosave()
                end
                SV_Dragging, Hue_Dragging = false, false
            end
        end)

        Connection['Color_Smooth_' .. Flag] = RunService.Heartbeat:Connect(function(dt)
            local Alpha = 1 - math.exp(-18 * dt)
            local X = SV_Cursor.Position.X.Scale
            local Y = SV_Cursor.Position.Y.Scale
            local Alpha_X = X + (SV_Target_X - X) * Alpha
            local Alpha_Y = Y + (SV_Target_Y - Y) * Alpha
            SV_Cursor.Position = UDim2.fromScale(Alpha_X, Alpha_Y)
            local Ethereal = Hue_Cursor.Position.Y.Scale
            local On_Top = Ethereal + (Hue_Target - Ethereal) * Alpha
            Hue_Cursor.Position = UDim2.new(0.5, 0, On_Top, 0)
        end)

        self.Flags[Flag] = Default
        self.Control_Objects[Flag] = {
            Kind = 'color',
            Apply = function(Value_Argument, Silent)
                local Color = Value_Argument
                if type(Value_Argument) == 'string' then
                    Color = Hex_To_Color(Value_Argument)
                end
                if typeof(Color) == 'Color3' then
                    Hue, Saturation, Value = Color3.toHSV(Color)

                    SV_Target_X, SV_Target_Y = Saturation, 1 - Value
                    Hue_Target = Hue

                    SV_Cursor.Position = UDim2.fromScale(Saturation, 1 - Value)
                    Hue_Cursor.Position = UDim2.new(0.5, 0, Hue, 0)

                    Recolor(Silent)
                end
            end,
        }

        self.Control_Objects[Flag].Apply(Default, true)

        if Options.callback then
            pcall(Options.callback, Default)
        end

        Register_Search(Row, Options.name or Flag)
    end

    function Tab.Create_Menu(Options)
        Options = Options or {}
        local Has_Description = Options.info and Options.info ~= ''
        local Header_Height = Has_Description and 46 or 38

        local Menu = Create_Instance('Frame', {
            Name = Options.name or 'Menu',
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Panel_2,
            BorderSizePixel = 0,
            LayoutOrder = Next_Order(Options.section),
            ZIndex = 15,
        }, Target_Column(Options.section))

        Create_Corner(Menu, 8)
		Create_Stroke(Menu, Theme.Border, 1, 0.5)

        Create_Instance('UIListLayout', {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 0),
        }, Menu)

        local Header = Create_Instance('TextButton', {
            Name = 'Header',
            Size = UDim2.new(1, 0, 0, Header_Height),
            BackgroundTransparency = 1,
            Text = '',
            AutoButtonColor = false,
            LayoutOrder = 1,
            ZIndex = 16,
        }, Menu)

        local Head_Row = Create_Instance('Frame', {
            Position = UDim2.fromOffset(14, Has_Description and 9 or 11),
            Size = UDim2.new(1, -40, 0, 18),
            BackgroundTransparency = 1,
            ZIndex = 17,
        }, Header)

        Create_Instance('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Head_Row)

        Create_Instance('TextLabel', {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 18),
            BackgroundTransparency = 1,
            FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
            TextSize = 14,
            Text = Options.name or 'Menu',
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1,
            ZIndex = 17,
        }, Head_Row)

        if Options.badge then
            local Badge_Color = Badge_Colors[Options.badge] or Badge_Colors.New
            local Badge_Label = Create_Instance('TextLabel', {
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromOffset(0, 16),
                BackgroundColor3 = Badge_Color.Background,
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
                TextSize = 10,
                Text = Options.badge,
                TextColor3 = Badge_Color.Text,
                LayoutOrder = 2,
                ZIndex = 17,
            }, Head_Row)
            Create_Instance('UIPadding', {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Badge_Label)
            Create_Corner(Badge_Label, 4)
            Create_Stroke(Badge_Label, Badge_Color.Border, 1, 0.5)
        end

        if Has_Description then
            Create_Instance('TextLabel', {
                Position = UDim2.fromOffset(14, 28),
                Size = UDim2.fromOffset(300, 14),
                BackgroundTransparency = 1,
                FontFace = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold),
                TextSize = 11,
                Text = Options.info or '',
                TextColor3 = Theme.Dim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 17,
            }, Header)
        end

        local Arrow = Create_Instance('ImageLabel', {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0, Header_Height / 2),
            Size = UDim2.fromOffset(14, 14),
            BackgroundTransparency = 1,
            Image = 'rbxassetid://7733717447',
            ImageColor3 = Theme.Muted,
            Rotation = -90,
            ZIndex = 17,
        }, Header)

        local Clipper = Create_Instance('Frame', {
            Name = 'Clipper',
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            LayoutOrder = 2,
            ZIndex = 15,
        }, Menu)

        local Body = Create_Instance('Frame', {
            Name = 'Body',
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex = 15,
        }, Clipper)

        Create_Instance('UIPadding', {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 10),
        }, Body)

        Create_Instance('UIListLayout', {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        }, Body)

        local Container = {Frame = Body, Order = 0}

        local Is_Open = (tostring(Options.default or ''):lower() == 'open') or (Options.opened == true)
        local function Set_Open(State_Open, Instant)
            Is_Open = State_Open

            Create_Tween(Arrow, Instant and 0.001 or 0.20, {Rotation = Is_Open and 0 or -90})

            local Target_Height = Is_Open and Body.AbsoluteSize.Y or 0
            Create_Tween(Clipper, Instant and 0.001 or 0.24, {
                Size = UDim2.new(1, 0, 0, Target_Height)
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            if Is_Open then
                for _, Descendant in ipairs(Body:GetDescendants()) do
                    if Descendant:GetAttribute('IsDivider') then
                        Descendant:SetAttribute('Replay', tick())
                    end
                end
            end
        end

        Body:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            if Is_Open then
                Create_Tween(Clipper, 0.16, {
                    Size = UDim2.new(1, 0, 0, Body.AbsoluteSize.Y)
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end
        end)

        Header.MouseButton1Click:Connect(function()
            Set_Open(not Is_Open, false)
        end)

        task.defer(function()
            Set_Open(Is_Open, true)
        end)

        Register_Search(Menu, Options.name, Options.info, Options.flag)

        local function Wrap(Func)
            return function(Sub_Options)
                Sub_Options = Sub_Options or {}
                Sub_Options.section = Container
                return Func(Sub_Options)
            end
        end

        return {
            Create_Title = Wrap(Tab.Create_Title),
            Create_Label = Wrap(Tab.Create_Label),
            Create_Paragraph = Wrap(Tab.Create_Paragraph),
            Create_Divider = Wrap(Tab.Create_Divider),
            Create_Separator = Wrap(Tab.Create_Separator),
            Create_Image = Wrap(Tab.Create_Image),
            Create_Button = Wrap(Tab.Create_Button),
            Create_Toggle = Wrap(Tab.Create_Toggle),
			Create_Checkbox = Wrap(Tab.Create_Checkbox),
            Create_Slider = Wrap(Tab.Create_Slider),
            Create_Dropdown = Wrap(Tab.Create_Dropdown),
            Create_Keybind = Wrap(Tab.Create_Keybind),
            Create_Textbox = Wrap(Tab.Create_Textbox),
            Create_Color_Picker = Wrap(Tab.Create_Color_Picker),
            Create_Playerlist = Wrap(Tab.Create_Playerlist),
            Instance = Menu,
            Set_Open = Set_Open
        }
    end

    return Tab
end

function Library:Get_Flag(Flag) 
    return self.Flags[Flag] 
end

function Library:Set_Flag(Flag, Value) 
    self:Apply_Flag(Flag, Value, false) 
    self:Autosave() 
end

function Library:Save() 
    Save_Config(self.Flags) 
end

return Library

--// © 2026 Ethereal — All Rights Reserved.
end)()

--// [ WINDOW ] --------------------------------------------------------------
local Window = Library.New()
--// [ NOTIFY ] --------------------------------------------------------------
local Notify = (function()

local EtherealIsTheBestDev = cloneref or function(service) return service end
if typeof(EtherealIsTheBestDev) ~= 'function' then return warn('[Product] ─ Dependency Issue. ✨') end

local UserInputService = EtherealIsTheBestDev(game:GetService('UserInputService'))
local TweenService = EtherealIsTheBestDev(game:GetService('TweenService'))
local HttpService = EtherealIsTheBestDev(game:GetService('HttpService'))
local CoreGui = EtherealIsTheBestDev(game:GetService('CoreGui'))

local Ethereal = CoreGui:FindFirstChild('Ethereal')
if not Ethereal then
	Ethereal = Instance.new('ScreenGui')
	Ethereal.Name = 'Ethereal'
	Ethereal.ResetOnSpawn = false
	Ethereal.Parent = CoreGui
end

local Module = {}
Module.Config = {
    Translate_Enabled = false,
    Translate_Type = 'English',
    Position = 'Down-Right',
    Volume = 0.5,
    Sound_Type = 'Huh',
}

function Module.Set(Key, Value)
    Module.Config[Key] = Value
end

local Theme = {
    Accent = Color3.fromRGB(24, 24, 27),
    Panel = Color3.fromRGB(248, 248, 250),
    Panel_2 = Color3.fromRGB(239, 239, 242),
    Panel_3 = Color3.fromRGB(225, 225, 230),
    Border = Color3.fromRGB(195, 195, 202),
    Text = Color3.fromRGB(24, 24, 28),
    Muted = Color3.fromRGB(76, 76, 84),
    Dim = Color3.fromRGB(112, 112, 120),
    White = Color3.fromRGB(255, 255, 255)
}

local Kind_Colors = {
    Info = {Accent = Theme.Accent},
    Success = {Accent = Color3.fromRGB(96, 200, 140)},
    Warning = {Accent = Color3.fromRGB(230, 188, 64)},
    Error = {Accent = Color3.fromRGB(220, 90, 100)},
	Ethereal = {Accent = Color3.fromRGB(183, 176, 209)}
}

local Text_Font = Enum.Font.Gotham
local Title_Font = Enum.Font.GothamBold

local Device = {
    ['Mobile'] = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
}

local Language_Codes = {
    English = 'en',
    Spanish = 'es',
    Chinese = 'zh-cn',
    Hindi = 'hi',
    Russian = 'ru',
    French = 'fr',
    Portuguese = 'pt',
    Vietnamese = 'vi',
    German = 'de',
    Arabic = 'ar',
}

local function Http_Request(Options)
    local Signal = (syn and syn.request) or (http and http.request) or http_request or request
    if Signal then return Signal(Options) end
    return HttpService:RequestAsync(Options)
end

local function Translate_Via_Google(Text, Target_Code, Source_Code)
    Source_Code = Source_Code or 'auto'
    local Url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' .. Source_Code .. '&tl=' .. Target_Code .. '&dt=t&q=' .. HttpService:UrlEncode(Text)
    local Ok, Result = pcall(function()
        local Response = Http_Request({Url = Url, Method = 'GET'})
        local Body = Response.Body or Response.body
        local Decoded = HttpService:JSONDecode(Body)

        local Combined_Text = ''
        if Decoded and Decoded[1] then
            for _, Section in ipairs(Decoded[1]) do
                if Section[1] then Combined_Text = Combined_Text .. Section[1] end
            end
        end
        return Combined_Text
    end)

    if Ok and Result and Result ~= '' then
        return Result
    end
    return nil
end

local function Get_Translate_Type()
    local Selected = Module.Config.Translate_Type
    if type(Selected) ~= 'string' then return 'English' end
    for Name, _ in pairs(Language_Codes) do
        if Name:lower() == Selected:lower() then
            return Name
        end
    end
    return 'English'
end

local function Is_Translate_Enabled()
    return Module.Config.Translate_Enabled == true
end

local Translation_Cache = {}

local function Translate_Text(Text)
    if not Is_Translate_Enabled() then return Text end
    if type(Text) ~= 'string' or Text == '' then return Text end

    local Target_Language = Get_Translate_Type()
    if Target_Language == 'English' then return Text end

    local Cache_Key = Target_Language .. '|' .. Text
    if Translation_Cache[Cache_Key] then
        return Translation_Cache[Cache_Key]
    end

    local Translated = Translate_Via_Google(Text, Language_Codes[Target_Language])
    if Translated then
        Translation_Cache[Cache_Key] = Translated
        return Translated
    end
    return Text
end

local function Create_Instance(Class_Name, Properties, Parent)
    local Object = Instance.new(Class_Name)
    for Key, Value in pairs(Properties) do
        Object[Key] = Value
    end
    if Parent then Object.Parent = Parent end
    return Object
end

local function Create_Tween(Object, Duration, Properties, Easing_Style, Easing_Direction)
    local Tween_Info = TweenInfo.new(Duration, Easing_Style or Enum.EasingStyle.Quint, Easing_Direction or Enum.EasingDirection.Out)
    local Tween_Object = TweenService:Create(Object, Tween_Info, Properties)
    Tween_Object:Play()
    return Tween_Object
end

local function Create_Corner(Parent, Radius)
    return Create_Instance('UICorner', {
        CornerRadius = UDim.new(0, Radius or 8)
    }, Parent)
end

local function Create_Stroke(Parent, Color, Thickness, Transparency)
    return Create_Instance('UIStroke', {
        Color = Color or Theme.Border,
        Thickness = Thickness or 1,
        Transparency = Transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, Parent)
end

local Existing = Ethereal:FindFirstChild('Notify')
if Existing then Existing:Destroy() end

local Screen_Gui = Create_Instance('ScreenGui', {
    Name = 'Notify',
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
}, Ethereal)

local Container_Width = 300
local Edge_Margin = Device['Mobile'] and 12 or 16

local Position_Map = {
    ['Down-Right'] = {
        Anchor = Vector2.new(1, 1),
        Position = UDim2.new(1, -Edge_Margin, 1, -Edge_Margin),
        List_Vertical = Enum.VerticalAlignment.Bottom
    },
    ['Down-Left']  = {
        Anchor = Vector2.new(0, 1),
        Position = UDim2.new(0,  Edge_Margin, 1, -Edge_Margin),
        List_Vertical = Enum.VerticalAlignment.Bottom
    },
    ['Up-Right']   = {
        Anchor = Vector2.new(1, 0),
        Position = UDim2.new(1, -Edge_Margin, 0,  Edge_Margin),
        List_Vertical = Enum.VerticalAlignment.Top
    },
    ['Up-Left']    = {
        Anchor = Vector2.new(0, 0),
        Position = UDim2.new(0,  Edge_Margin, 0,  Edge_Margin),
        List_Vertical = Enum.VerticalAlignment.Top
    },
    ['Down-Center'] = {
        Anchor = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -Edge_Margin),
        List_Vertical = Enum.VerticalAlignment.Bottom
    },
    ['Up-Center'] = {
        Anchor = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, Edge_Margin),
        List_Vertical = Enum.VerticalAlignment.Top
    },
    ['Mid-Left'] = {
        Anchor = Vector2.new(0, 0.5),
        Position = UDim2.new(0, Edge_Margin, 0.5, 0),
        List_Vertical = Enum.VerticalAlignment.Center
    },
    ['Mid-Right'] = {
        Anchor = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -Edge_Margin, 0.5, 0),
        List_Vertical = Enum.VerticalAlignment.Center
    },
}

local function Get_Position()
    local Selected = Module.Config.Position
    return Position_Map[Selected] or Position_Map['Down-Right']
end

local Initial_Pos = Get_Position()

local Container = Create_Instance('Frame', {
    Name = 'Container',
    AnchorPoint = Initial_Pos.Anchor,
    Position = Initial_Pos.Position,
    Size = UDim2.fromOffset(Container_Width, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ZIndex = 1000,
}, Screen_Gui)

local List_Layout = Create_Instance('UIListLayout', {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Initial_Pos.List_Vertical,
}, Container)

local Last_Position_Key = Module.Config.Position or 'Down-Right'

task.spawn(function()
    while Container and Container.Parent do
        local Current_Key = Module.Config.Position or 'Down-Right'
        if Current_Key ~= Last_Position_Key then
            local New_Pos = Position_Map[Current_Key] or Position_Map['Down-Right']
            Last_Position_Key = Current_Key
            Container.AnchorPoint = New_Pos.Anchor
            List_Layout.VerticalAlignment = New_Pos.List_Vertical
            Create_Tween(Container, 0.35, {Position = New_Pos.Position}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
        task.wait(0.1)
    end
end)

local Order_Counter = 0
local Active_Notifications = {}

local Tweaks = {
    ['Notify'] = {
		['Eh'] = 'rbxassetid://105117264394463',
		['Huh'] = 'rbxassetid://18548307445',
		['Uwu'] = 'rbxassetid://124356179581089',
		['MGS5'] = 'rbxassetid://654933978',
		['Meow'] = 'rbxassetid://134699420140804',
		['Moan'] = 'rbxassetid://83299235145654',
        ['Soft Ping'] = 'rbxassetid://133118130342644',
		['Windows 8'] = 'rbxassetid://1862045322',
        ['Old Discord'] = 'rbxassetid://91271439961236'
    }
}

function Module.Notify(Options)
    Options = Options or {}
 
    local Title = Translate_Text(tostring(Options.Title or 'Notification'))
    local Description = Translate_Text(tostring(Options.Description or ''))
    local Duration = tonumber(Options.Duration) or 5
    local Kind = Kind_Colors[Options.Kind] or Kind_Colors.Info
    local Notify_Key = Title .. '|' .. Description

    if Active_Notifications[Notify_Key] then
        local Previous = Active_Notifications[Notify_Key]
        Active_Notifications[Notify_Key] = nil

        local Finished = false
        Previous.Dismiss(function()
            Finished = true
        end)

        repeat task.wait() until Finished
        task.wait()
    end
 
    Order_Counter += 1
    
    local My_Order = Order_Counter
    local Has_Description = Description ~= ''
 
    local Card = Create_Instance('Frame', {
        Name = 'Card',
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Panel_2,
        BorderSizePixel = 0,
        LayoutOrder = My_Order,
        ClipsDescendants = true,
        ZIndex = 1001,
    }, Container)
 
    local Card_Radius = 10
    Create_Corner(Card, Card_Radius)
    local Card_Stroke = Create_Stroke(Card, Theme.Border, 1, 0.35)
 
    Create_Instance('UIPadding', {
        PaddingTop = UDim.new(0, 11),
        PaddingBottom = UDim.new(0, 18),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
    }, Card)
 
    local Content = Create_Instance('Frame', {
        Name = 'Content',
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 1002,
    }, Card)
 
    Create_Instance('UIListLayout', {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Content)
 
    local Title_Row = Create_Instance('Frame', {
        Name = 'Title Row',
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ZIndex = 1003,
    }, Content)
 
    Create_Instance('TextLabel', {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Title_Font,
        TextSize = 13,
        Text = Title,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 1003,
    }, Title_Row)
 
    if Has_Description then
        Create_Instance('TextLabel', {
            Name = 'Description',
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = Text_Font,
            TextSize = 12,
            Text = Description,
            TextColor3 = Theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            LineHeight = 1.15,
            LayoutOrder = 2,
            ZIndex = 1003,
        }, Content)
    end
 
    local Underline_Inset = 10

    local Progress_Track = Create_Instance('Frame', {
        Name = 'Progress',
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, 12),
        Size = UDim2.new(1, -Underline_Inset * 2, 0, 2),
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 1002,
    }, Card)

    Create_Corner(Progress_Track, 2)
 
    local Progress_Fill = Create_Instance('Frame', {
        Name = 'Fill',
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Kind.Accent,
        BorderSizePixel = 0,
        ZIndex = 1003,
    }, Progress_Track)
    
    Create_Corner(Progress_Fill, 2)

	if Options.Notify ~= false then
        local Sound_Volume = tonumber(Module.Config.Volume) or 0.5
        local Sound_Type = Module.Config.Sound_Type or 'Huh'
        local Sound_Id = Tweaks.Notify[Sound_Type] or Tweaks.Notify['Huh']

        local Notify_Sound = Create_Instance('Sound', {
            Name = 'NotifySound',
            SoundId = Sound_Id,
            Volume = Sound_Volume * 5,
            PlayOnRemove = false,
        }, Card)

        Notify_Sound:Play()

        Notify_Sound.Ended:Connect(function()
            Notify_Sound:Destroy()
        end)
    end
 
    local Dismissed = false
    local Notification_Object

    local function Dismiss(On_Complete)
        if Dismissed then
            if On_Complete then On_Complete() end
            return
        end
        Dismissed = true
        if Active_Notifications[Notify_Key] == Notification_Object then
            Active_Notifications[Notify_Key] = nil
        end
        Create_Tween(Card, 0.22, {Size = UDim2.new(1, 0, 0, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Create_Tween(Card, 0.20, {BackgroundTransparency = 1})
        Create_Tween(Card_Stroke, 0.20, {Transparency = 1})
        for _, Descendant in ipairs(Card:GetDescendants()) do
            if Descendant:IsA('TextLabel') or Descendant:IsA('TextButton') then
                Create_Tween(Descendant, 0.18, {TextTransparency = 1, BackgroundTransparency = 1})
            elseif Descendant:IsA('Frame') then
                Create_Tween(Descendant, 0.18, {BackgroundTransparency = 1})
            elseif Descendant:IsA('UIStroke') then
                Create_Tween(Descendant, 0.18, {Transparency = 1})
            end
        end
        task.delay(0.24, function()
            if Card and Card.Parent then Card:Destroy() end
            if On_Complete then On_Complete() end
        end)
    end

    Card.Position = UDim2.fromOffset(40, 0)
    Card.BackgroundTransparency = 1
    Card_Stroke.Transparency = 1

    for _, Descendant in ipairs(Content:GetDescendants()) do
        if Descendant:IsA('TextLabel') then
            Descendant.TextTransparency = 1
        end
    end
 
    Create_Tween(Card, 0.26, {Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Create_Tween(Card_Stroke, 0.26, {Transparency = 0.35})

    for _, Descendant in ipairs(Content:GetDescendants()) do
        if Descendant:IsA('TextLabel') then
            Create_Tween(Descendant, 0.22, {TextTransparency = 0})
        end
    end
 
    task.spawn(function()
        local Elapsed = 0
        while Elapsed < Duration do
            local dt = task.wait()
            if Dismissed then break end
            Elapsed += dt
            local Alpha = math.clamp(1 - (Elapsed / Duration), 0, 1)
            if Progress_Fill and Progress_Fill.Parent then
                Progress_Fill.Size = UDim2.fromScale(Alpha, 1)
            end
        end
        if not Dismissed then
            Dismiss()
        end
    end)
    Notification_Object = {
        Dismiss = Dismiss,
        Card = Card,
    }
    Active_Notifications[Notify_Key] = Notification_Object
    return Notification_Object
end
 
return Module
end)()

Library.Notify = function(Options)
    return Notify.Notify(Options or {})
end