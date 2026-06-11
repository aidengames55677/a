-- "gamemodes\\mafiarp\\plugins\\moneyaudit\\cl_plugin.lua"

nut.command.add( "topmoney", {
	onRun = function()
	end
} )

nut.command.add( "topbanks", {
	onRun = function()
	end
} )

nut.command.add( "topfactions", {
	onRun = function()
	end
} )

net.Receive( "Moneyaudit.TopMoney", function()
	local topMoney = net.ReadTable()

	table.sort( topMoney, function( a, b ) return a.Money > b.Money end )

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 1280, 720 )
	frame:Center()
	frame:SetTitle( "Top Money" )
	frame:MakePopup()

	local list = vgui.Create( "DListView", frame )
	list:Dock( FILL )
	list:SetMultiSelect( false )
	list:AddColumn( "CharID" )
	list:AddColumn( "Owner" )
	list:AddColumn( "Wallet Balance" )
	list:AddColumn( "Total Bank Balance" )
	list:AddColumn( "Faction" )
	list:AddColumn( "Last Join Time" )
	list:AddColumn( "SteamID" )

	for _, money in pairs( topMoney ) do
		list:AddLine( money.CharID, money.Name, string.Comma( money.Money ), string.Comma( money.BankBalance ), money.Faction, money.LastJoinTime, money.SteamID )
	end

	list.OnRowRightClick = function( self, line )
		local menu = DermaMenu()
        local steamID = self:GetLine( line ):GetValue( 8 )

		menu:AddOption( "Copy Char ID", function()
            SetClipboardText( self:GetLine( line ):GetValue( 1 ) )
		end ):SetIcon( "icon16/page_copy.png" )

		menu:AddOption( "Copy SteamID", function()
            SetClipboardText( steamID )
		end ):SetIcon( "icon16/user.png" )

		menu:AddOption( "Open Steam", function()
            gui.OpenURL( "https://steamcommunity.com/profiles/" .. util.SteamIDTo64( steamID ) )
		end ):SetIcon( "icon16/world.png" )

        menu:AddSpacer()
		
		menu:AddOption( "Lookup Character", function() 
            LocalPlayer():ConCommand( [[say "/lookupid ]] .. self:GetLine( line ):GetValue( 3 ) .. [["]] ) 
		end ):SetIcon( "icon16/user_go.png" )

		menu:AddOption( "Lookup Character List", function() 
            LocalPlayer():ConCommand( [[say "/charlist ]] .. steamID  .. [["]] ) 
		end ):SetIcon( "icon16/group_go.png" )
		
		menu:Open()
	end
end )

net.Receive( "Moneyaudit.TopBanks", function()
	local topBanks = net.ReadTable()

	table.sort( topBanks, function( a, b ) return a.BankBalance > b.BankBalance end )

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 1280, 720 )
	frame:Center()
	frame:SetTitle( "Top Banks" )
	frame:MakePopup()

	local list = vgui.Create( "DListView", frame )
	list:Dock( FILL )
	list:SetMultiSelect( false )
	list:AddColumn( "Bank ID" )
	list:AddColumn( "Bank Balance" )
	list:AddColumn( "CharID" )
	list:AddColumn( "Owner" )
	list:AddColumn( "Wallet Balance" )
	list:AddColumn( "Faction" )
	list:AddColumn( "Last Join Time" )
	list:AddColumn( "SteamID" )

	for _, bank in pairs( topBanks ) do
		list:AddLine( bank.BankID, string.Comma( bank.BankBalance ), bank.CharID, bank.Name, string.Comma( bank.Money ), bank.Faction, bank.LastJoinTime, bank.SteamID )
	end

	list.OnRowRightClick = function( self, line )
		local menu = DermaMenu()
        local steamID = self:GetLine( line ):GetValue( 8 )
        local bankID = self:GetLine( line ):GetValue( 1 )

		menu:AddOption( "Copy Bank ID", function()
            SetClipboardText( bankID )
		end ):SetIcon( "icon16/page_copy.png" )

		menu:AddOption( "Copy SteamID", function()
            SetClipboardText( steamID )
		end ):SetIcon( "icon16/user.png" )

		menu:AddOption( "Open Steam", function()
            gui.OpenURL( "https://steamcommunity.com/profiles/" .. util.SteamIDTo64( steamID ) )
		end ):SetIcon( "icon16/world.png" )

        menu:AddSpacer()
		
		menu:AddOption( "Search Bank", function() 
			LocalPlayer():ConCommand( [[say "/adminbanksearch ]] .. bankID .. [["]] ) 
		end ):SetIcon( "icon16/magnifier.png" )

		menu:AddOption( "Lookup Character", function() 
            LocalPlayer():ConCommand( [[say "/lookupid ]] .. self:GetLine( line ):GetValue( 3 ) .. [["]] ) 
		end ):SetIcon( "icon16/user_go.png" )

		menu:AddOption( "Lookup Character List", function() 
            LocalPlayer():ConCommand( [[say "/charlist ]] .. steamID  .. [["]] ) 
		end ):SetIcon( "icon16/group_go.png" )
		
		menu:Open()
	end
end )

net.Receive( "Moneyaudit.TopFactions", function()
	local topFactions = net.ReadTable()

	table.sort( topFactions, function( a, b ) return a.TotalWealth > b.TotalWealth end )

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 1280, 720 )
	frame:Center()
	frame:SetTitle( "Top Factions - Combined wealth from all members who have logged in the last 12 months." )
	frame:MakePopup()

	local list = vgui.Create( "DListView", frame )
	list:Dock( FILL )
	list:SetMultiSelect( false )
	list:AddColumn( "Faction" )
	list:AddColumn( "Total Wealth" )

	for _, faction in pairs( topFactions ) do
		list:AddLine( faction.Faction, string.Comma(faction.TotalWealth) )
	end

	list.OnRowRightClick = function( self, line )
		local menu = DermaMenu()

		menu:AddOption( "Copy Faction", function()
            SetClipboardText( self:GetLine( line ):GetValue( 1 ) )
		end ):SetIcon( "icon16/page_copy.png" )

		menu:Open()
	end
end )