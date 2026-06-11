-- "gamemodes\\mafiarp\\plugins\\cardealer\\libs\\cl_carkeys.lua"

local function vehicleKeyUI()
	local frame = vgui.Create("DFrame")
	frame:SetSize(280, 240)
	frame:Center()
	frame:MakePopup()
	
	local listView = vgui.Create( "DListView", frame)
	listView:Dock(FILL)
	listView:AddColumn("Character ID")
	
	local SendInfo = {}
	local carData = net.ReadTable()

    frame:SetTitle("Vehicle Access")
	
	for k,v in pairs(carData) do
		listView:AddLine(k or "N/A")
	end

	listView.OnRowSelected = function( _, rowIndex, row )
		local menu = DermaMenu()
        menu:AddOption( "Remove Access", function() 
            net.Start("vehicleKeysRemove")
                net.WriteUInt(row:GetValue(1), 32)
                net.WriteUInt(LocalPlayer():GetEyeTrace().Entity:GetNW2Int("VehicleID"), 32)
            net.SendToServer()
            frame:Remove()
            
            timer.Simple(0.5, function()
                net.Start("vehicleKeysRetrieveData")
                    net.WriteUInt(LocalPlayer():GetEyeTrace().Entity:GetNW2Int("VehicleID"), 32)
                net.SendToServer()
            end)
        end )
		menu:Open()
	end

    frame.add = frame:Add("DButton")
    frame.add:Dock(BOTTOM)
    frame.add:SetText("Add")
    frame.add:SetTextColor(color_white)
    frame.add:DockMargin(0, 5, 0, 0)
    frame.add.DoClick = function(this)
        Derma_StringRequest(
            'Add Character', 
            'Enter the Character ID of the person you\'d like to add to use keys on this vehicle.', 
            '', 
            function(text)
                text = tonumber(text)
                if (!text || !isnumber(text)) then
                    nut.util.notify("The ID you provided is not a valid Character ID.")
                    return
                else
                    net.Start("vehicleKeysAdd")
                        net.WriteUInt(text, 32)
                        net.WriteUInt(LocalPlayer():GetEyeTrace().Entity:GetNW2Int("VehicleID"), 32)
                    net.SendToServer()
                    frame:Remove()

                    timer.Simple(0.5, function()
                        net.Start("vehicleKeysRetrieveData")
                            net.WriteUInt(LocalPlayer():GetEyeTrace().Entity:GetNW2Int("VehicleID"), 32)
                        net.SendToServer()
                    end)
                end
            end
        )
    end
end

net.Receive("vehicleKeysSendData", vehicleKeyUI)