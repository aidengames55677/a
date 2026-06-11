-- "gamemodes\\mafiarp\\plugins\\stafftracking\\cl_plugin.lua"

/*
    Commands
*/

nut.command.add("staffdata", {
	onRun = function(client)
	end
})

nut.command.add("staffdatareset", {
	onRun = function(client)
	end
})

/*
    Networking
*/

net.Receive("BroadcastStaffAFK", function(len, ply)
	local staff = net.ReadEntity()
	local bool = net.ReadBool()

	if bool then
		staff.isAFK = true
	elseif bool == false then
		staff.isAFK = false
	end
end)

local function convertTimestamp(time)
	if time < 60 then
		return (time.." s")
	elseif time > 60 then
		return sam.reverse_parse_length(time/60)
	end
end

local function SendStaffData()
	local frame = vgui.Create("DFrame")
	frame:SetSize(800, 600)
	frame:Center()
	frame:MakePopup()
	
	local listView = vgui.Create( "DListView", frame)
	listView:Dock(FILL)
	listView:AddColumn("Name")
	listView:AddColumn("Steam ID")
	listView:AddColumn("Rank")
	listView:AddColumn("Time RP")
	listView:AddColumn("Time Staff")
	listView:AddColumn("Time AFK")
	listView:AddColumn("Time Total")
	
	local SendInfo = {}
	local StaffTable = net.ReadTable()

    frame:SetTitle("Staff Information: "..#StaffTable)
	table.SortByMember(StaffTable, "_name")
	
	for k,v in pairs(StaffTable) do
		listView:AddLine(v._name or "N/A", v._steamid or "N/A", v._rank or "N/A", convertTimestamp(v._timeRP) or "N/A", convertTimestamp(v._timeStaff) or "N/A", convertTimestamp(v._timeAFK) or "N/A", convertTimestamp(v._timeTotal) or "N/A")
	end

	listView:SortByColumn(5, true)

	listView.OnRowSelected = function( _, rowIndex, row )
		local menu = DermaMenu()
		menu:Open()
	end
end
net.Receive("SendStaffData", SendStaffData)