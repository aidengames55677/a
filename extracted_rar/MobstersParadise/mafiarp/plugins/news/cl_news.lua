surface.CreateFont( "Title_Font", {
	font = "Times New Roman", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 28,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


function Articles()
	local BaseC = vgui.Create( "DFrame" )
	BaseC:SetSize( ScrW() - 300, 475 )
	BaseC:SetTitle("Articles")
	BaseC:Center()
	BaseC:SetDraggable( false )
	BaseC:MakePopup()
	BaseC:ShowCloseButton( true )
	
	local panel3 = vgui.Create("DScrollPanel", BaseC)
	panel3:Dock(FILL)

	local category = panel3:Add("DCollapsibleCategory")
	category:SetLabel("Articles")
	category:Dock(TOP)
	category:SetExpanded(1)
	category.Paint = function( self, w, h ) 
			 category:SetBGColor(Color(0,0,0,1))
		 end
	
		category.panel = vgui.Create("DPanel", category)
		category.panel:Dock(FILL)

		category.list = vgui.Create("DListLayout", category.panel)
		category.list:Dock(FILL)
		category.list:DockPadding(3, 3, 3, 3)

		category:SetContents(category.list)

		panel3:AddItem(category)						

	local info = {}
	net.Start( "ArticleInit" )
	net.SendToServer()
	net.Receive( "ArticleReload", function()
		table.Empty( info )
		local fname = net.ReadString()
		local getInfo = net.ReadTable()
		table.insert( info, { getInfo.writer, getInfo.title, getInfo.story, getInfo.date, fname } )		
		for _,v in pairs( info ) do

	local pistol = category.list:Add( "DPanel" )
	pistol:SetTall(48)

	local car_title = vgui.Create( "DLabel", pistol )
	car_title:SetText( v[2] )
	car_title:SetPos( 3, 10 )
	car_title:SetDark( true )
	car_title:SetFont( "Title_Font" )
	car_title:SetDark(false)
	car_title:SizeToContents()
	
local invest = vgui.Create( "DButton" , pistol )
invest:Dock(RIGHT)
invest:DockMargin(5, 5, 5, 5)
invest:SetTextColor(Color(255,255,255,255))
invest:SetText( "Read" )
invest:SetSize( 70, 40 )
invest.DoClick = function()

local stats_frame = vgui.Create("DFrame")
stats_frame:SetSize( ScrW() - 450, ScrH() - 315)
stats_frame:Center()
stats_frame:MakePopup()
stats_frame:SetTitle(v[2])
stats_frame:SetBackgroundBlur( true )

local panel = vgui.Create("DPanel", stats_frame)
panel:Dock(FILL)
panel:SetPos(5,55)


local richtext = vgui.Create( "RichText", panel )
richtext:Dock( FILL )

richtext:InsertColorChange( 255, 255, 255, 255 )
richtext:AppendText( v[2] )
richtext:InsertColorChange( 255, 255, 255, 255 )
richtext:AppendText( "\n\n" .. v[3] )
richtext:InsertColorChange( 255, 0, 0, 255 )
richtext:AppendText( "\n\nReporter: " .. v[1])
richtext:AppendText( "\n\nWritten: " .. v[4] )
richtext.Paint = function()
    richtext.m_FontName = "Title_Font"
    richtext:SetFontInternal( "Title_Font" )	
    richtext:SetBGColor(Color(0,0,0,0))		
    richtext.Paint = nil
end

end

	end

	end)

end

concommand.Add("articles", Articles)


net.Receive("ArticleMenu", function()

local frame = vgui.Create( "DFrame" )
frame:SetSize(375,170)
frame:SetTitle( "New York Times" )
frame:SetDraggable( false )
frame:ShowCloseButton(false)
frame:MakePopup()
frame:Center()


local DButton = vgui.Create( "DButton", frame )
DButton:SetPos( 10, 30 )
DButton:SetText( "Write an article" )
DButton:SetTextColor(Color(255,255,255,255))
DButton:SetSize( 355, 40 )
DButton.DoClick = function()
frame:Close()

local report_frame = vgui.Create("DFrame")
report_frame:SetSize(430, 400)
report_frame:Center()
report_frame:SetTitle("Type Writer")
report_frame:MakePopup()

local title = vgui.Create( "DTextEntry", report_frame ) -- create the form as a child of frame
title:SetPos(2.5, 25)
title:SetSize( 424, 20 )
title:SetText("Title")


local story = vgui.Create( "DTextEntry", report_frame ) -- create the form as a child of frame
story:SetPos( 2.5, 50 )
story:SetSize( 424, 205 )
story:SetText( "Full story" )
story:SetMultiline(true)
story.OnEnter = function( self )
	chat.AddText( self:GetValue() )	-- print the form's text as server text
end

local submit_button = vgui.Create("DButton", report_frame)
submit_button:Dock(BOTTOM)
submit_button:SetSize(20,60)
submit_button:SetText("Submit to Newspaper")
submit_button.DoClick = function()

		--frame:Close()
		report_frame:Close()
		local title = title:GetValue()
		local story = story:GetValue()

			net.Start( "CreateArticle" )
			net.WriteString( title )
			net.WriteString( story )
			net.SendToServer()

end
end

local DButton = vgui.Create( "DButton", frame )
DButton:SetPos( 10, 75 )
DButton:SetText( "Check newspaper" )
DButton:SetTextColor(Color(255,255,255,255))
DButton:SetSize( 355, 40 )
DButton.DoClick = function()
RunConsoleCommand("articles")
end

local DButton = vgui.Create( "DButton", frame )
DButton:SetPos( 10, 120 )
DButton:SetText( "Close" )
DButton:SetTextColor(Color(255,255,255,255))
DButton:SetSize( 355, 40 )
DButton.DoClick = function()
frame:Close()
end

end)

concommand.Add( "open_notepad_2", OpenArrestMenu )
