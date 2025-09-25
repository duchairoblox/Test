--[[ 
Custom UI System (Roblox Studio safe version)
Đặt script này vào StarterPlayer > StarterPlayerScripts
--]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ===== CONFIG =====
local CONFIG = {
    HubTitle = "HaiRoblox",
    AnimationText = "Youtube: Trung IOS",
    KeySystem = true,
    KeyLink = "https://yeumoney.com/Exrfa",
    Keys = {"9997"},
    Notifications = {
        CorrectKey = "Running the Script...",
        IncorrectKey = "The key is incorrect",
        CopyKeyLink = "Copied to Clipboard"
    }
}

-- ===== HELPER: UI Create =====
local function create(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props) do
        inst[k] = v
    end
    inst.Parent = parent
    return inst
end

-- ===== MAIN GUI =====
local screen = create("ScreenGui", {Name="HaiGui", ResetOnSpawn=false}, player:WaitForChild("PlayerGui"))

local mainFrame = create("Frame", {
    Size = UDim2.new(0, 400, 0, 250),
    Position = UDim2.new(0.5, -200, 0.5, -125),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = not CONFIG.KeySystem
}, screen)

create("UICorner", {CornerRadius=UDim.new(0,8)}, mainFrame)

local title = create("TextLabel", {
    Size = UDim2.new(1,0,0,40),
    BackgroundTransparency = 1,
    Text = CONFIG.HubTitle .. " - " .. CONFIG.AnimationText,
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 20
}, mainFrame)

-- ===== MINIMIZE BUTTON =====
local minimizeBtn = create("TextButton", {
    Size = UDim2.new(0,60,0,30),
    Position = UDim2.new(1,-65,0,5),
    BackgroundColor3 = Color3.fromRGB(10,10,10),
    Text = "-",
    TextColor3 = Color3.fromRGB(255,0,0)
}, mainFrame)

create("UICorner", {CornerRadius=UDim.new(0,8)}, minimizeBtn)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,child in pairs(mainFrame:GetChildren()) do
        if child:IsA("GuiObject") and child ~= title and child ~= minimizeBtn then
            child.Visible = not minimized
        end
    end
end)

-- ===== TABS =====
local tabFrame = create("Frame", {
    Size = UDim2.new(0,120,1,-40),
    Position = UDim2.new(0,0,0,40),
    BackgroundColor3 = Color3.fromRGB(35,35,35)
}, mainFrame)

local contentFrame = create("Frame", {
    Size = UDim2.new(1,-120,1,-40),
    Position = UDim2.new(0,120,0,40),
    BackgroundColor3 = Color3.fromRGB(50,50,50)
}, mainFrame)

local function MakeTab(name)
    local btn = create("TextButton", {
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        Text = name,
        TextColor3 = Color3.fromRGB(255,255,255)
    }, tabFrame)
    local page = create("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false
    }, contentFrame)

    btn.MouseButton1Click:Connect(function()
        for _,pg in pairs(contentFrame:GetChildren()) do
            if pg:IsA("Frame") then pg.Visible = false end
        end
        page.Visible = true
    end)
    return page
end

local function AddButton(tab, opt)
    local b = create("TextButton", {
        Size = UDim2.new(0,200,0,40),
        Position = UDim2.new(0,10,0,#tab:GetChildren()*45),
        BackgroundColor3 = Color3.fromRGB(70,70,70),
        Text = opt.Name or "Button",
        TextColor3 = Color3.fromRGB(255,255,255)
    }, tab)
    b.MouseButton1Click:Connect(opt.Callback or function() end)
end

-- ====== EXAMPLE TAB + BUTTON ======
local tab1 = MakeTab("Script Farm")
tab1.Visible = true

AddButton(tab1, {
    Name = "Redz Hub",
    Callback = function()
        warn("Redz Hub chạy ở đây (server-side action)")
        -- Thay vì loadstring, bạn hãy require ModuleScript an toàn của bạn
    end
})

-- ===== KEY SYSTEM =====
if CONFIG.KeySystem then
    local keyFrame = create("Frame", {
        Size = UDim2.new(0,300,0,150),
        Position = UDim2.new(0.5,-150,0.5,-75),
        BackgroundColor3 = Color3.fromRGB(20,20,20)
    }, screen)
    create("UICorner",{CornerRadius=UDim.new(0,8)},keyFrame)

    local box = create("TextBox", {
        Size = UDim2.new(0.8,0,0,40),
        Position = UDim2.new(0.1,0,0.2,0),
        PlaceholderText = "Enter key...",
        Text = ""
    }, keyFrame)

    local submit = create("TextButton", {
        Size = UDim2.new(0.8,0,0,40),
        Position = UDim2.new(0.1,0,0.6,0),
        Text = "Submit"
    }, keyFrame)

    submit.MouseButton1Click:Connect(function()
        local txt = box.Text
        local ok = false
        for _,k in ipairs(CONFIG.Keys) do
            if txt == k then
                ok = true
                break
            end
        end
        if ok then
            mainFrame.Visible = true
            keyFrame:Destroy()
            warn(CONFIG.Notifications.CorrectKey)
        else
            warn(CONFIG.Notifications.Incorrectkey)
        end
    end)
end