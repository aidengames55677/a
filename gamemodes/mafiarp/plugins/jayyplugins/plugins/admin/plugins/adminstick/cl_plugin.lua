AdminStick = AdminStick or {}
local function OpenNameUI(target)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Change Name")
    frame:SetSize(300,110)
    frame:Center()

    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end

    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(FILL)
    //edit:SetMultiline(true)
    edit:SetPlaceholderText(target:Name())

    local button = vgui.Create("DButton",frame)
    button:Dock(BOTTOM)
    button:SetText("Copy Name to Clipboard")
    function button:DoClick()
        SetClipboardText(target:Name())
        button:SetText("Copied '" .. target:Name() .. "'s' name to Clipboard")
        surface.PlaySound("buttons/lightswitch2.wav")

        timer.Simple(2, function()
            button:SetText("Copy Name to Clipboard")
        end)
    end

    local button1 = vgui.Create("DButton",frame)
    button1:Dock(BOTTOM)
    button1:SetText("Change")
    function button1:DoClick()
        local txt = edit:GetValue()
    LocalPlayer():ConCommand('say /charsetname "'..target:Name()..'" "'..edit:GetValue()..'"')
        AdminStick.IsOpen = false
    end
    frame:MakePopup()
end

local function OpenPlayerModelUI(target)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Change Playermodel")
    frame:SetSize(450,300)
    frame:Center()

    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end

    local scroll = vgui.Create("DScrollPanel",frame)
    scroll:Dock(FILL)
    local wrapper = vgui.Create("DIconLayout",scroll)
    wrapper:Dock(FILL)
    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(BOTTOM)
    edit:SetPlaceholderText("Model Path")
    
    local button = vgui.Create("DButton",frame)
    button:SetText("Change")
    button:Dock(TOP)
    function button:DoClick()
        local txt = edit:GetValue()
    LocalPlayer():ConCommand('say /charsetmodel "'..target:Name()..'" "'..edit:GetValue()..'"')
        AdminStick.IsOpen = false
    end

    for name, model in SortedPairs( player_manager.AllValidModels() ) do

			local icon = wrapper:Add("SpawnIcon")
			icon:SetModel( model )
			icon:SetSize( 64, 64 )
			icon:SetTooltip( name )
			icon.playermodel = name
			icon.model_path = model
            --icon:Dock(LEFT)
            icon.DoClick = function(self)
                edit:SetValue(self.model_path)
            end

		end

    frame:MakePopup()
end

local function OpenReasonUI(target,cmd,time)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Reason for "..cmd)
    frame:SetSize(300,150)
    frame:Center()
    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end
    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(FILL)
    edit:SetMultiline(true)
    edit:SetPlaceholderText("Reason")
    local timeedit
    if cmd=="gag" then
        local time = vgui.Create("DNumSlider",frame)
        time:Dock(TOP)
        time:SetText("Length (minutes)")
        time:SetMin(0)
        time:SetMax(365)
        time:SetDecimals(0)
        timeedit = time
    end

    local button = vgui.Create("DButton",frame)
    button:Dock(BOTTOM)
    button:SetText("Change")
    function button:DoClick()
        local txt = edit:GetValue()
        if (cmd == "gag") then
			local time = timeedit:GetValue()*1*1
            RunConsoleCommand("sam",cmd,target:Name(),time,txt)
        else
            RunConsoleCommand("sam",cmd,target:Name(),txt)
        end
        frame:Remove()
        AdminStick.IsOpen = false
    end
    frame:MakePopup()
end

local function OpenReasonUI(target,cmd,time)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Reason for "..cmd)
    frame:SetSize(300,150)
    frame:Center()
    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end
    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(FILL)
    edit:SetMultiline(true)
    edit:SetPlaceholderText("Reason")
    local timeedit
    if cmd=="ban" then
        local time = vgui.Create("DNumSlider",frame)
        time:Dock(TOP)
        time:SetText("Length (days)")
        time:SetMin(0)
        time:SetMax(365)
        time:SetDecimals(0)
        timeedit = time
    end

    local button = vgui.Create("DButton",frame)
    button:Dock(BOTTOM)
    button:SetText("Change")
    function button:DoClick()
        local txt = edit:GetValue()
        if (cmd == "ban") then
			local time = timeedit:GetValue()*64*24
            RunConsoleCommand("sam",cmd,target:Name(),time,txt)
        else
            RunConsoleCommand("sam",cmd,target:Name(),txt)
        end
        frame:Remove()
        AdminStick.IsOpen = false
    end
    frame:MakePopup()
end

function AdminStick:OpenAdminStickUI(isright,target)
    isright = isright or false
    if isright then target = LocalPlayer() end
    AdminStick.IsOpen = true
    AdminStick.AdminMenu = DermaMenu()
    local AdminMenu = AdminStick.AdminMenu
    
    local name = AdminMenu:AddOption( "Name: "..target:Name().." (left click to copy)",function() 
        SetClipboardText(target:Name())
        AdminStick.IsOpen = false
    end)
    name:SetIcon( "icon16/information.png" )

    local name = AdminMenu:AddOption( "CharID: "..target:Name().." (left click to copy)",function() 
        SetClipboardText(target:Name())
        AdminStick.IsOpen = false
    end)
    name:SetIcon( "icon16/information.png" )

    local steamid = AdminMenu:AddOption( "SteamID: "..target:SteamID().." (left click to copy)",function() 
        SetClipboardText(target:SteamID())
        AdminStick.IsOpen = false
    end)
    steamid:SetIcon( "icon16/information.png" )

    local steamid64 = AdminMenu:AddOption( "SteamID64: "..target:SteamID64().." (left click to copy)",function() 
        SetClipboardText(target:SteamID64())
        AdminStick.IsOpen = false
    end)
    steamid64:SetIcon( "icon16/information.png" )

    AdminMenu:AddSpacer()

    for i,fac in pairs(nut.faction.teams) do
        if fac.index == target:getChar():getFaction() then
                local faction = AdminMenu:AddSubMenu("Set Faction ("..fac.name..")")
                for i,v in pairs(nut.faction.teams) do
                    faction:AddOption(v.name,function()
                        LocalPlayer():ConCommand('say /plytransfer "'..target:Name()..'" "'..v.name..'"')
						AdminStick.IsOpen = false
                    end)
                end
        end
    end

    local administration = AdminMenu:AddSubMenu("Administration")
    
    local character = AdminMenu:AddSubMenu("Character")

    local teleportation = AdminMenu:AddSubMenu("Teleportation")

    local utility = AdminMenu:AddSubMenu("Utility")

    local desc = administration:AddOption( "Change Name",function() 
        OpenNameUI(target)
    end)

    local desc = character:AddOption( "Change Playermodel",function() 
        OpenPlayerModelUI(target)
    end)

    if (target:IsFrozen()) then
        local unfreeze = administration:AddOption( "Unfreeze",function() 
            RunConsoleCommand("sam","unfreeze",target:Name())
            AdminStick.IsOpen = false
        end)
    else
        local freeze = administration:AddOption( "Freeze",function() 
            RunConsoleCommand("sam","freeze",target:Name())
            AdminStick.IsOpen = false
        end)
    end

    local jail = administration:AddOption( "Jail",function() 
            RunConsoleCommand("sam","jail",target:Name())
            AdminStick.IsOpen = false
        end)

    local unjail = administration:AddOption( "Unjail",function() 
            RunConsoleCommand("sam","unjail",target:Name())
            AdminStick.IsOpen = false
        end)

    local ban = administration:AddOption("Ban",function()
        OpenReasonUI(target,"ban",0)
    end)

    local kick = administration:AddOption( "Kick",function() 
            OpenReasonUI(target,"kick",0)
        end)
	
	    local decals = utility:AddOption( "Clear Decals",function() 
        net.Start("AS_ClearDecals")
        net.SendToServer()
        AdminStick.IsOpen = false
    end)
	
    local bring = teleportation:AddOption( "Bring",function() 
        RunConsoleCommand("sam","bring",target:Name())
        AdminStick.IsOpen = false
    end)

    local returnf = teleportation:AddOption( "Return",function() 
        RunConsoleCommand("sam","return",target:Name())
        AdminStick.IsOpen = false
    end)

    local returnf = teleportation:AddOption( "Goto",function() 
        RunConsoleCommand("sam","goto",target:Name())
        AdminStick.IsOpen = false
    end)
	
    local pk = character:AddOption( "Permakill Active",function() 
        LocalPlayer():ConCommand('say /pkenable '..target:Name())
        AdminStick.IsOpen = false
    end)

    local gag = administration:AddOption("Gag",function()
        OpenReasonUI(target,"gag",0)
    end)

    local ungag = administration:AddOption( "Ungag",function() 
        RunConsoleCommand("sam","ungag",target:Name())
        AdminStick.IsOpen = false
    end)

    local stopsound = utility:AddOption( "Stop Sound",function() 
        RunConsoleCommand("sam","stopsound",target:Name())
        AdminStick.IsOpen = false
    end)

    local time = utility:AddOption( "Time",function() 
        RunConsoleCommand("sam","time",target:Name())
        AdminStick.IsOpen = false
    end)

    function AdminMenu:OnClose()
        AdminStick.IsOpen = false
    end
    AdminMenu:Open()
    AdminMenu:Center()
end
