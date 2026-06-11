-- "gamemodes\\mafiarp\\plugins\\hifi\\cl_plugin.lua"

local function nutHifiMenu()
    local ent = LocalPlayer():GetEyeTrace().Entity
    local isPlaying = string.len(ent:GetNWString("nowPlaying")) > 0 and ent:GetNWString("nowPlaying") or ""
	if nutHifiMenuOpen then return end
	nutHifiMenuOpen = true

    local casplugin = nut.plugin.list.cassette_player
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 350)
    frame:SetTitle("Hifi")
    frame:SetVisible(true)
    frame:SetDraggable(false)
    frame:ShowCloseButton(true)
    frame:Center()

    local searchLabel = vgui.Create("DLabel", frame)
    searchLabel:SetText("Search:")
    searchLabel:SetPos(175, 30)
    searchLabel:SetSize(50, 20)
    searchLabel:SetContentAlignment(5) 

    local searchInput = vgui.Create("DTextEntry", frame)
    searchInput:SetPos(100, 50)
    searchInput:SetSize(200, 20)
    searchInput:SetContentAlignment(5)

    local resultPanel = vgui.Create("DPanel", frame)
    resultPanel:SetPos(50, 80)
    resultPanel:SetSize(300, 150)
    resultPanel:SetBackgroundColor(Color(255, 255, 255))

    local resultLabel = vgui.Create("DLabel", resultPanel)
    resultLabel:SetText("Now Playing: " .. isPlaying)
    resultLabel:SetPos(10, 5)
    resultLabel:SetSize(280, 20)

    local resultList = vgui.Create("DListView", resultPanel)
    resultList:SetPos(10, 30) 
    resultList:SetSize(280, 110) 
    resultList:SetMultiSelect(false)
    resultList:AddColumn("Songs")

    local buttonsPanel = vgui.Create("DPanel", frame)
    buttonsPanel:SetPos(50, 240)
    buttonsPanel:SetSize(300, 40)
    buttonsPanel:SetBackgroundColor(Color(255, 255, 255))

    local volumePanel = vgui.Create("DPanel", frame)
    volumePanel:SetPos(50, 290)
    volumePanel:SetSize(300, 50)
    volumePanel:SetBackgroundColor(Color(255, 255, 255))

    local volumeSlider

    local function addButton(text, callback)
        local button = vgui.Create("DButton", buttonsPanel)
        button:SetText(text)
        button:SetSize(buttonsPanel:GetWide() / 3 - 10, buttonsPanel:GetTall() - 10)
        button:DockMargin(5, 5, 5, 5)
        button:Dock(LEFT)
        button.DoClick = callback
    end

    local function populateList()
        resultList:Clear()

        for k, v in SortedPairsByMemberValue(nut.item.list, "name") do
            if v.base ~= "base_cassettes" then continue end
            if v.plyExclusive then continue end
            if v.specialCassette then continue end
            if string.find(v.uniqueID, "christmas") then continue end
            if string.find(v.model, "casetteyellow.mdl") then continue end

            resultList:AddLine(v.name)
        end
    end

    populateList()

    local function updateSearchResults()
        resultList:Clear()

        local value = searchInput:GetValue()

        if value == "" then
            populateList()
        else
            for k, v in SortedPairsByMemberValue(nut.item.list, "name") do
				if v.base ~= "base_cassettes" then continue end
				if v.plyExclusive then continue end
				if v.specialCassette then continue end
				if string.find(v.uniqueID, "christmas") then continue end
				if string.find(v.model, "casetteyellow.mdl") then continue end
				
                if string.find(string.lower(v.name), string.lower(value)) then
                    resultList:AddLine(v.name)
                end
            end
        end
    end

    searchInput.OnValueChange = updateSearchResults

    searchInput.OnTextChanged = updateSearchResults

    resultList.OnRowRightClick = function(panel, line)
        local menu = DermaMenu()
        menu:AddOption("Play", function()
            local selectedLine = panel:GetLine(line)
            local selectedRecord = selectedLine:GetValue(1)

            for k, v in pairs(nut.item.list) do
                if v.name == selectedRecord then
                    resultLabel:SetText("Now Playing: " .. selectedRecord)
                    selectedRecord = v.uniqueID
                    break
                end
            end

            net.Start("nutHifiRequest")
                net.WriteEntity(ent)
                net.WriteString(selectedRecord)
            net.SendToServer()
        end)
        menu:Open()
    end

    addButton("Pause", function()
        net.Start("nutCassetteAction")
            net.WriteEntity(ent)
            net.WriteInt(STOP, 32)
        net.SendToServer()
    end)

    addButton("Resume", function()
        net.Start("nutCassetteAction")
            net.WriteEntity(ent)
            net.WriteInt(PLAY, 32)
        net.SendToServer()
    end)

    addButton("Toggle Freeze", function()
        net.Start("nutHifiFreeze")
            net.WriteEntity(ent)
        net.SendToServer()
    end)

    volumeSlider = vgui.Create("DNumSlider", volumePanel)
    volumeSlider:SetText("Volume")
    volumeSlider:SetSize(volumePanel:GetWide() / 1.5, 25)
    volumeSlider:SetPos((volumePanel:GetWide() - volumeSlider:GetWide()) / 2, 10)
    volumeSlider:SetMin(0)
    volumeSlider:SetMax(casplugin.MaxCPlayerVolume)
    local volume = casplugin.DefaultCPlayerVolume
    if IsValid(casplugin.RadioChannels[ent]) then
        volume = casplugin.RadioChannels[ent]:GetVolume()
    end
    volumeSlider:SetValue(volume)
    volumeSlider.OnValueChanged = function(self, value)
        local volume = math.Round(value)
        net.Start("nutCassetteAction")
            net.WriteEntity(ent)
            net.WriteInt(VOLUME, 32)
            net.WriteFloat(value)
        net.SendToServer()
    end

    frame.OnClose = function()
		nutHifiMenuOpen = false
    end

    frame:MakePopup()
end
net.Receive("nutHifiMenu", nutHifiMenu)


net.Receive("nutHifiClear", function()
    local ent = net.ReadEntity()
	local plugin = nut.plugin.list.cassette_player
    local channel = plugin.RadioChannels[ent]

    if channel and IsValid(nut.plugin.list.cassette_player.RadioChannels[ent]) then
        nut.plugin.list.cassette_player.RadioChannels[ent]:SetVolume(0)
        nut.plugin.list.cassette_player.RadioChannels[ent]:Pause()
        nut.plugin.list.cassette_player.RadioChannels[ent] = nil
    end
end)