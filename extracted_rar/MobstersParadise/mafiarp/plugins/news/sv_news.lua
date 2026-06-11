TX_Keep_Restart = 1

if not file.Exists("toxstyx", "DATA") then file.CreateDir("toxstyx") end
util.AddNetworkString( "CreateArticle" )
util.AddNetworkString( "ArticleInit" )
util.AddNetworkString( "ArticleReload" )
util.AddNetworkString( "DeleteArticle" )
util.AddNetworkString( "ArticleMenu" )
util.AddNetworkString( "ArticleMenu2" )

net.Receive( "CreateArticle", function(len, ply)
	local title = net.ReadString()
	local story = net.ReadString()
	local uniqueid = ply:UniqueID()
	local filename = uniqueid.."_"..math.Round( RealTime() )
	
	for _,v in pairs( player.GetAll() ) do
		if v:Name() == target then
			target = v
		end
	end
	--if not IsValid( target ) or not target:IsPlayer() then return end
	

	article = { writer = ply:Name(), title = string.Trim( title ), story = string.Trim( story ), date = os.date( "%m/%d %H:%M") }	
	
	if file.Exists( "toxstyx/articles/" .. filename .. ".txt", "DATA" ) then
	else
		file.Write( "toxstyx/articles/" .. filename .. ".txt", util.TableToJSON( article ), "" )
	end
	ply.GetCureTime = CurTime()
	ply:notify("Successfuly Submited")
end)

if not file.Exists( "toxstyx", "DATA" ) then
	file.CreateDir( "toxstyx" )
end

if not file.Exists( "toxstyx/articles", "DATA" ) then
	file.CreateDir( "toxstyx/articles" )
end

timer.Simple(3, function()    	
	if TX_Keep_Restart then return end
	local oldfiles = file.Find( "toxstyx/articles/*", "DATA" )
	for _,v in pairs( oldfiles ) do
		if string.EndsWith( "toxstyx/articles/" .. v, ".txt" ) then
			file.Delete( "toxstyx/articles/" .. v )
		end
	end
	MsgN( "Old data deleted" )
end)
    
net.Receive( "ArticleInit", function(len, ply)
	if not IsValid( ply ) then return end
	local pathfiles = file.Find( "toxstyx/articles/*", "DATA" )
	for _,v in pairs( pathfiles ) do
		local r = file.Read( "toxstyx/articles/" .. v, "DATA" )
		if not r then return end
		local data = util.JSONToTable( r )
		net.Start( "ArticleReload" )
		net.WriteString( v )
		if data then
			net.WriteTable( data )
		end
		net.Send( ply )
	end
end)

net.Receive( "DeleteArticle", function(len, ply)
	if not IsValid( ply ) then return end
	if table.HasValue(AGC_DeleteComplaint, team.GetName(ply:Team())) then
		local filename = net.ReadString()
		if file.Exists( "toxstyx/articles/" .. filename, "DATA" ) then
			if string.EndsWith( "toxstyx/articles/" .. filename, ".txt" ) then
				file.Delete( "toxstyx/articles/" .. filename )
			end
		end
	end
end)
