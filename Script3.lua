-- Tải lib
local success, UiLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)

if not success then
    warn("Không tải được UI Lib")
    return
end

-- Tạo cửa sổ
local Window = MakeWindow({
    Hub = {
        Title = "HaiRoblox",
        Animation = "Youtube:Trung IOS"
    },
    Key = {KeySystem = false} -- để false thì menu mới hiện ngay
})

-- Nút thu nhỏ
MinimizeButton({
    Image = "http://www.roblox.com/asset/?id=83190276951914",
    Size = {60, 60},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

------ Tab Farm ------
local TabFarm = MakeTab({Name = "Script Farm"})

AddButton(TabFarm, {
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
local VALID_KEYS = {"9997"}
local KEY_LINK = "https://yeumoney.com/Exrfa"
local savedKey

local TabKey = MakeTab({Name = "Key"})

AddTextbox(TabKey, {
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
            savedKey = _G.InputKey
            Notify({Title="Key System", Text="Key đúng, lưu trong 24h!", Duration=3})
        else
            Notify({Title="Key System", Text="Key sai!", Duration=3})
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