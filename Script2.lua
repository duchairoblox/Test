loadstring(game:HttpGet(("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))()

-- Tạo cửa sổ chính
local Window = MakeWindow({
    Hub = {
        Title = "HaiRoblox",
        Animation = "Youtube:Trung IOS"
    },
    Key = {
        KeySystem = true, -- bật KeySystem
        Title = "Key System",
        Description = "Nhập key để tiếp tục",
        KeyLink = "https://yeumoney.com/Exrfa", -- Link key hôm nay
        Keys = {"9997"}, -- Key hợp lệ
        Notifi = {
            Notifications = true,
            CorrectKey = "Key đúng, đang chạy script...",
            Incorrectkey = "Key sai, vui lòng thử lại",
            CopyKeyLink = "Đã sao chép link key"
        }
    }
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
local Tab1o = MakeTab({Name = "Script Farm"})

-- Nút chạy Redz Hub
AddButton(Tab1o, {
    Name = "Redz Hub",
    Callback = function()
        local Settings = {
            JoinTeam = "Pirates", -- Pirates/Marines
            Translator = true, -- true/false
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)
    end
})

------ Tab Key ------
local TabKey = MakeTab({Name = "Key"})

-- Ô nhập key
local keyBox = AddTextbox(TabKey, {
    Name = "Nhập Key",
    Default = "",
    PlaceholderText = "Nhập key tại đây...",
    ClearTextOnFocus = false,
    Callback = function(value)
        _G.InputKey = value
    end
})

-- Nút xác nhận key
AddButton(TabKey, {
    Name = "Nhập Key",
    Callback = function()
        if table.find({"9997"}, _G.InputKey) then
            Notify({Title="Key System", Text="Key đúng, script đang chạy...", Duration=3})
        else
            Notify({Title="Key System", Text="Key sai, vui lòng thử lại!", Duration=3})
        end
    end
})

-- Nút lấy key
AddButton(TabKey, {
    Name = "Get Key",
    Callback = function()
        setclipboard("https://yeumoney.com/Exrfa")
        Notify({Title="Key System", Text="Đã copy link key hôm nay", Duration=3})
    end
})