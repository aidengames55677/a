-- "gamemodes\\mafiarp\\plugins\\plynotes\\sh_plugin.lua"

PLUGIN.name = "Notepad"
PLUGIN.author = 'ZeMysticalTaco, Pendred'
PLUGIN.description = 'Adds a personalized note system for characters.'

nut.util.include("sv_plugin.lua")

nut.command.add("notepad", {
    syntax = "",
    onRun = function(client)
        net.Start('nutOpenNotes')
        net.Send(client)
    end
})

if CLIENT then
    net.Receive('nutOpenNotes', function()
        local frame = vgui.Create('DFrame')
        frame:SetSize(385, ScrH() / 2)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle('My Notes')

        frame.Save = frame:Add('DButton')
        frame.Save:Dock(BOTTOM)
        frame.Save:SetText('Save Notes')

        frame.Save.DoClick = function()
            if string.len(frame.TextBox:GetText()) > 8000 then
                nut.util.notify('Your notes cannot be longer than 8000 characters!')
                return
            end

            nut.util.notify("Your notes have been saved.")
            net.Start('nutSaveNotes')
                net.WriteString(frame.TextBox:GetText())
            net.SendToServer()
        end

        frame.TextBox = frame:Add('DTextEntry')
        frame.TextBox:Dock(FILL)
        frame.TextBox:SetMultiline(true)
        frame.TextBox:SetText(LocalPlayer():getChar():getData('notes', ''))
    end)
end