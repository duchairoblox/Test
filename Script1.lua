--[[ 
Key System đơn giản (không hiệu ứng 3D)
Đặt script này trong ServerScriptService
Nó sẽ:
 - Tạo RemoteEvent/RemoteFunction trong ReplicatedStorage
 - Quản lý key server-side
 - Reset key mỗi ngày lúc 06:00 (GMT+7)
 - Tự động tạo LocalScript trong StarterPlayerScripts để hiển thị GUI
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")

-- ==== CONFIG ====
local CONFIG = {
    HubTitle = "HaiRoblox",
    AnimationText = "Youtube: Trung IOS",
    KeyLinkToday = "https://yeumoney.com/Exrfa", -- link key hôm nay
    InitialKeys = {"9997","ABC-123-TEST"},
    OneTimeUse = true
}

-- ==== REMOTES ====
local VerifyKey = ReplicatedStorage:FindFirstChild("VerifyKey") or Instance.new("RemoteEvent", ReplicatedStorage)
VerifyKey.Name = "VerifyKey"
local KeyResponse = ReplicatedStorage:FindFirstChild("KeyResponse") or Instance.new("RemoteEvent", ReplicatedStorage)
KeyResponse.Name = "KeyResponse"
local RequestKeyLink = ReplicatedStorage:FindFirstChild("RequestKeyLink") or Instance.new("RemoteFunction", ReplicatedStorage)
RequestKeyLink.Name = "RequestKeyLink"

-- ==== KEY SERVER ====
local validKeys = {}
local function resetKeys()
    validKeys = {}
    for _,k in ipairs(CONFIG.InitialKeys) do
        validKeys[k] = {used=false}
    end
end
resetKeys()

VerifyKey.OnServerEvent:Connect(function(player, key)
    if not validKeys[key] then
        KeyResponse:FireClient(player, false, "Sai key hoặc không tồn tại.")
        return
    end
    if CONFIG.OneTimeUse and validKeys[key].used then
        KeyResponse:FireClient(player, false, "Key đã được sử dụng.")
        return
    end
    validKeys[key].used = true
    KeyResponse:FireClient(player, true, "Key hợp lệ, đã kích hoạt!")
end)

RequestKeyLink.OnServerInvoke = function(player)
    return CONFIG.KeyLinkToday
end

-- ==== DAILY RESET 6h GMT+7 ====
task.spawn(function()
    while true do
        local now = os.date("!*t", os.time()) -- UTC
        -- thời gian GMT+7
        local gmt7Hour = (now.hour + 7) % 24
        if gmt7Hour == 6 and now.min == 0 then
            resetKeys()
            print("[KeyServer] Reset key lúc 6h sáng (GMT+7)")
            task.wait(60) -- tránh reset nhiều lần trong cùng phút
        end
        task.wait(30)
    end
end)

-- ==== CLIENT UI SCRIPT ====
local clientSource = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local VerifyKey = ReplicatedStorage:WaitForChild("VerifyKey")
local KeyResponse = ReplicatedStorage:WaitForChild("KeyResponse")
local RequestKeyLink = ReplicatedStorage:WaitForChild("RequestKeyLink")

local HubTitle = "]] .. CONFIG.HubTitle .. [["
local AnimationText = "]] .. CONFIG.AnimationText .. [["

-- GUI chính
local screen = Instance.new("ScreenGui")
screen.Name = "HaiRoblox_KeyUI"
screen.ResetOnSpawn = false
screen.Parent = guiParent

local main = Instance.new("Frame", screen)
main.Size = UDim2.new(0,400,0,250)
main.Position = UDim2.new(0.5,-200,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(28,28,28)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = HubTitle .. " - " .. AnimationText
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)

-- menu bên trái
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0,100,1,-40)
left.Position = UDim2.new(0,0,0,40)
left.BackgroundTransparency = 1

local right = Instance.new("Frame", main)
right.Size = UDim2.new(1,-100,1,-40)
right.Position = UDim2.new(0,100,0,40)
right.BackgroundTransparency = 1

local function makeTab(text, y)
    local btn = Instance.new("TextButton", left)
    btn.Size = UDim2.new(1,-10,0,35)
    btn.Position = UDim2.new(0,5,0,y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    return btn
end

local pageFarm = Instance.new("Frame", right)
pageFarm.Size = UDim2.new(1,0,1,0)
pageFarm.BackgroundTransparency = 1

local pageKey = Instance.new("Frame", right)
pageKey.Size = UDim2.new(1,0,1,0)
pageKey.BackgroundTransparency = 1
pageKey.Visible = false

local farmBtn = makeTab("Script Farm", 0)
local keyBtn = makeTab("Key", 40)

farmBtn.MouseButton1Click:Connect(function()
    pageFarm.Visible = true
    pageKey.Visible = false
end)
keyBtn.MouseButton1Click:Connect(function()
    pageFarm.Visible = false
    pageKey.Visible = true
end)

-- Trang farm
local btnRedz = Instance.new("TextButton", pageFarm)
btnRedz.Size = UDim2.new(0,200,0,40)
btnRedz.Position = UDim2.new(0.05,0,0.05,0)
btnRedz.Text = "Redz Hub"
btnRedz.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnRedz.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnRedz).CornerRadius = UDim.new(0,6)
btnRedz.MouseButton1Click:Connect(function()
    game.StarterGui:SetCore("SendNotification",{Title="Info", Text="Redz Hub chạy (demo)", Duration=2})
end)

-- Trang Key
local keyBox = Instance.new("TextBox", pageKey)
keyBox.Size = UDim2.new(0.9,0,0,35)
keyBox.Position = UDim2.new(0.05,0,0.1,0)
keyBox.PlaceholderText = "Nhập key..."
keyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
keyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,6)

local submitBtn = Instance.new("TextButton", pageKey)
submitBtn.Size = UDim2.new(0.42,0,0,35)
submitBtn.Position = UDim2.new(0.05,0,0.35,0)
submitBtn.Text = "Nhập Key"
submitBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
submitBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,6)

local getBtn = Instance.new("TextButton", pageKey)
getBtn.Size = UDim2.new(0.42,0,0,35)
getBtn.Position = UDim2.new(0.53,0,0.35,0)
getBtn.Text = "Get Key"
getBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
getBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0,6)

local msg = Instance.new("TextLabel", pageKey)
msg.Size = UDim2.new(0.9,0,0,30)
msg.Position = UDim2.new(0.05,0,0.7,0)
msg.BackgroundTransparency = 1
msg.Text = ""
msg.TextColor3 = Color3.fromRGB(255,255,255)

submitBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    if key == "" then
        msg.Text = "Vui lòng nhập key."
        msg.TextColor3 = Color3.fromRGB(255,120,120)
        return
    end
    VerifyKey:FireServer(key)
end)

getBtn.MouseButton1Click:Connect(function()
    local link = RequestKeyLink:InvokeServer()
    if link then
        pcall(function() setclipboard(link) end)
        msg.Text = "Đã sao chép link key hôm nay."
        msg.TextColor3 = Color3.fromRGB(140,255,140)
    end
end)

KeyResponse.OnClientEvent:Connect(function(success,message)
    msg.Text = message
    if success then
        msg.TextColor3 = Color3.fromRGB(140,255,140)
    else
        msg.TextColor3 = Color3.fromRGB(255,120,120)
    end
end)
]]

-- Ghi LocalScript vào StarterPlayerScripts
local function writeLocalScript()
    local sps = StarterPlayer:FindFirstChild("StarterPlayerScripts")
    if not sps then
        sps = Instance.new("StarterPlayerScripts")
        sps.Parent = StarterPlayer
    end
    local existing = sps:FindFirstChild("HaiRoblox_KeyClient")
    if existing then existing:Destroy() end
    local ls = Instance.new("LocalScript")
    ls.Name = "HaiRoblox_KeyClient"
    ls.Source = clientSource
    ls.Parent = sps
end
writeLocalScript()
print("[KeySystem] Ready - GUI không 3D, rõ ràng")