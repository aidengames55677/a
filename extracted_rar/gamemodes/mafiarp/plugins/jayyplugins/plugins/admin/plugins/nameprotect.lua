local PLUGIN = PLUGIN

PLUGIN.name = "Name No, no"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "Stops Bad Names"

if SERVER then
    util.AddNetworkString("ChangeName")
end

-- List of disallowed words
local disallowedWords = {
    "Nigga",
    "Nigger",
    "n1gga",
    "n1gger",
    "nazi",
    "nigg3r",
    "nigg4h",
    "nigga",
    "niggah",
    "niggas",
    "niggaz",
    "nigger",
    "niggers"
}

-- Function to check if a string contains any disallowed words
local function containsDisallowedWords(str)
    for _, word in ipairs(disallowedWords) do
        if string.find(string.lower(str), string.lower(word)) then
            return true
        end
    end
    return false
end

-- Function to handle character creation
function PLUGIN:PlayerCreatedCharacter(client, character)
    local name = character:getName()

    if containsDisallowedWords(name) then
        -- Prompt the player to change their name
        client:notify("Your character's name contains disallowed words. Please choose a different name.")
        
        -- Force the player to change their name
        -- You'll need to implement this part based on how your server handles name changes
    end
end

-- Function to handle character loading
function PLUGIN:PlayerLoadedChar(client, character)
    local name = character:getName()

    if containsDisallowedWords(name) then
        -- Prompt the player to change their name
        client:notify("Your character's name contains disallowed words. Please choose a different name.")
        
        -- Force the player to change their name
        net.Start("ChangeName")
        net.Send(client)
    end    
end

local function openNameChangeMenu()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Change Name")
    frame:SetSize(300, 200) -- Increase the height to accommodate the button
    frame:Center()
    frame:MakePopup()
    frame:SetDeleteOnClose(false)
    frame:ShowCloseButton(false)

    local TextEntry = vgui.Create("DTextEntry", frame)
    TextEntry:SetSize(280, 30)
    TextEntry:SetPos(10, 50)
    TextEntry:RequestFocus()

    local ApplyButton = vgui.Create("DButton", frame)
    ApplyButton:SetText("Apply")
    ApplyButton:SetPos(10, 100)
    ApplyButton:SetSize(280, 30)
    ApplyButton.DoClick = function()
        local newName = TextEntry:GetValue()
        if not containsDisallowedWords(newName) then -- Check if the new name is valid
            net.Start("ChangeName")
            net.WriteString(newName)
            net.SendToServer()
            frame:Close()
        else
            client:notify("Your new name still contains disallowed words. Please choose a different name.")
        end
    end
end

if CLIENT then
    net.Receive("ChangeName", openNameChangeMenu)
end
