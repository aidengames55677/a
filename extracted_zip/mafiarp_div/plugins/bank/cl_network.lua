-- "gamemodes\\mafiarp\\plugins\\bank\\cl_network.lua"


local PLUGIN = PLUGIN

function PLUGIN:CloseAllMenus()
    if IsValid( PLUGIN.ATM ) then
        PLUGIN.ATM:Close()
        PLUGIN.ATM = nil
    end

    if IsValid( PLUGIN.AccountSelect ) then
        PLUGIN.AccountSelect:Close()
        PLUGIN.AccountSelect = nil
    end
end

net.Receive( "Banking.ShowAccountList", function()
    local accounts = net.ReadTable()

    PLUGIN:CloseAllMenus()

    PLUGIN.AccountSelect = vgui.Create( "Banking.AccountSelect" )
    PLUGIN.AccountSelect:PopulateScrollPanel( accounts )

	if #accounts == 0 then
		nut.util.notify("You do not own a bank account! Visit City Hall to purchase one. NPC has been marked on your screen.")
        for k, v in ipairs( ents.FindByClass( "bankaccount_npc" ) ) do
            LocalPlayer():SetWeighPoint( "Bank Account NPC", Vector( v:GetPos() ) )
        end
	end
end )

net.Receive( "Banking.ShowAccount", function()
    local accountData = net.ReadTable()
    local perms = net.ReadUInt( 16 )

    PLUGIN:CloseAllMenus()

    PLUGIN.ATM = vgui.Create( "Banking.ATM" )
    PLUGIN.ATM:InitializeInfo( accountData, perms )
end )