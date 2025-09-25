loadstring(game:HttpGet(("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))()

-- ========== CONFIG ==========
local VALID_KEYS = {"9997"}
local KEY_LINK = "https://yeumoney.com/Exrfa"

-- ========== STORAGE ==========
local savedKey, savedTime

-- Nếu exploit hỗ trợ file → lưu vào file, không thì dùng setgenv
local function saveKey(key)
    local data = {
        key = key,
        time = os.time()
    }
    local encoded = game:GetService("HttpService"):JSONEncode(data)
    pcall(function() writefile("HaiRoblox_Key.json", encoded) end)
    setgenv().HaiRoblox_Key = data
end

local function loadKey()
    local decoded
    local ok, result = pcall(function() return readfile("HaiRoblox_Key.json") end)
    if ok and result then
        decoded = game:GetService("HttpService"):JSONDecode(result)
    elseif getgenv().HaiRoblox_Key then
        decoded = getgenv().HaiRoblox_Key
    end
    return decoded
end

-- Reset key nếu quá 24h hoặc qua 6h sáng
local function isKeyValid(data)
    if not data then return false end
    local now = os.time()
    if now - data.time > 24*60*60 then
        return false
    end

    -- Kiểm tra nếu qua 6h sáng (GMT+7)
    local tNow = os.date("!*t", now)
    local tSaved = os.date("!*t", data.time)

    local hourNow = (tNow.hour + 7) % 24
    local hourSaved = (tSaved.hour + 7) % 24
    local dayNow = tNow.yday
    local daySaved = tSaved.yday

    if dayNow ~= daySaved and hourNow >= 6 then
        return false
    end

    return true
end

-- ========== MAIN UI ==========
local Window = MakeWindow({
    Hub = {
        Title = "HaiRoblox",
        Animation = "Youtube:Trung IOS"
    },
    Key = {KeySystem = false} -- tắt key system mặc định
})

MinimizeButton({
    Image = "http://www.roblox.com/asset/?id=83190276951914",
    Size = {60, 60},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

------ Tab Farm ------
local Tab1o = MakeTab({Name = "Script Farm"})

AddButton(Tab1o, {
    Name = "Redz Hub",
    Callback = function()
        local Settings = {
            JoinTeam = "Pirates",
            Translator = true,
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)
    end
})

------ Tab Key ------
local TabKey = MakeTab({Name = "Key"})

local keyBox = AddTextbox(TabKey, {
    Name = "Nhập Key",
    Default = "",
    PlaceholderText = "Nhập key tại đây...",
    ClearTextOnFocus = false,
    Callback = function(value)
        _G.InputKey = value
    end
})

AddButton(TabKey, {
    Name = "Nhập Key",
    Callback = function()
        if table.find(VALID_KEYS, _G.InputKey) then
            saveKey(_G.InputKey)
            Notify({Title="Key System", Text="Key đúng, đã lưu trong 24h!", Duration=3})
        else
            Notify({Title="Key System", Text="Key sai, vui lòng thử lại!", Duration=3})
        end
    end
})

AddButton(TabKey, {
    Name = "Get Key",
    Callback = function()
        setclipboard(KEY_LINK)
        Notify({Title="Key System", Text="Đã copy link key hôm nay", Duration=3})
    end
})

-- ========== AUTO CHECK ==========
task.spawn(function()
    local data = loadKey()
    if isKeyValid(data) then
        Notify({Title="Key System", Text="Đã tự động xác nhận key hợp lệ!", Duration=3})
    else
        Notify({Title="Key System", Text="Vui lòng nhập key mới!", Duration=5})
    end
end)