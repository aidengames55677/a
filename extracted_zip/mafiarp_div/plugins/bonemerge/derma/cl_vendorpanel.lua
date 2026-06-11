-- "gamemodes\\mafiarp\\plugins\\bonemerge\\derma\\cl_vendorpanel.lua"


-- Config
local whitelist = {
    ["models/cultist/clothing/male/robbers/r_closed_suit.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_long_coat.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_open_suit_w_tie.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_open_waistcoat.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_shirt_tie_closedcollar.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_shirt_tie_closedcollar_rolled.mdl"] = true,
    ["models/cultist/clothing/male/robbers/r_shirt_tie_closedcollar_short.mdl"] = true,
    ["models/cultist/clothing/male/robbers/gucci_suit.mdl"] = true,
    ["models/cultist/clothing/male/aquila/blacksiltsuit.mdl"] = true,
    ["models/cultist/clothing/male/aquila/gtaivsuit.mdl"] = true,
    ["models/cultist/clothing/male/aquila/shelbyvest.mdl"] = true,
    ["models/diverge/gimpsuit/gimpsuit.mdl"] = true,
    ["models/diverge/spacedsuits/spacedbeige/spacedbeige.mdl"] = true,
    ["models/diverge/spacedsuits/spacedred/spacedred.mdl"] = true,
    ["models/diverge/spacedsuits/spacedblack/spacedblack.mdl"] = true,
}

local clothingCategories = {
    ["hats"] = {
        name = "Hats",
        order = 2,
        canSee = function()
            for _, item in next, LocalPlayer():getChar():getInv():getItems() do
                if item:getData( "equip" ) and ( item.slot == "hats" ) then
                    return false, "You are already wearing a hat!\nUnequip your hat in order to buy another one.", "Incompatible"
                end
            end

            return true
        end,
        bone = "ValveBiped.Bip01_Head1",
        fov = 50,
    },
    ["glasses"] = {
        name = "Glasses",
        order = 3,
        bone = "ValveBiped.Bip01_Head1",
        fov = 50,
    },
    ["neck"] = {
        name = "Neck",
        order = 4,
        bone = "ValveBiped.Bip01_Head1",
        fov = 50,
    },
    ["face"] = {
        name = "Face",
        order = 5,
        bone = "ValveBiped.Bip01_Head1",
        fov = 50,
    },
    ["wrist"] = {
        name = "Wrist/Hands",
        order = 6,
        bone = "ValveBiped.Bip01_L_Thigh",
        fov = 50,
    },
    ["leftring"] = {
        name = "Rings (Left)",
        order = 7,
        bone = "ValveBiped.Bip01_L_Hand",
        fov = 50,
    },
    ["rightring"] = {
        name = "Rings (Right)",
        order = 8,
        bone = "ValveBiped.Bip01_R_Hand",
        fov = 50,
    },
    ["shirt"] = {
        name = "Shirts",
        order = 9,
        canSee = function()
            for _, item in next, LocalPlayer():getChar():getInv():getItems() do
                if item:getData( "equip" ) and ( item.slot == "fulloutfit" or item.slot == "shirt" ) then
                    return false, "You cannot wear shirts while wearing another shirt!\nUnequip your shirt in order to buy shirts.", "Incompatible"
                end
            end

            return true
        end,
        bone = "ValveBiped.Bip01_Spine2",
        fov = 50,
    },
    ["vest"] = {
        name = "Chest Accessories",
        order = 10,
        bone = "ValveBiped.Bip01_Spine2",
        fov = 50,
    },
    ["pants"] = {
        name = "Pants",
        order = 11,
        canSee = function()
            for _,item in next, LocalPlayer():getChar():getInv():getItems() do
                if item:getData( "equip" ) and ( item.slot == "fulloutfit" or item.slot == "pants" ) then
                    return false, "You cannot wear pants while wearing another pants!\nUnequip your pants in order to buy pants.", "Incompatible"
                end
            end

            return true
        end,
        bone = "ValveBiped.Bip01_R_Calf",
        fov = 65,
    },
    ["shoes"] = {
        name = "Shoes",
        order = 12,
        canSee = function()
            for _,item in next, LocalPlayer():getChar():getInv():getItems() do
                if item.slot == "pants" and item:getData("equip") and item.CanWearShoes then
                    return true
                end
            end

            return false, "You cannot wear shoes with the pants you have equipped!\nEquip a compatible pair in order to buy shoes.", "Incompatible"
        end,
        bone = "ValveBiped.Bip01_R_Foot",
        fov = 50,
    },
    -- yuck
    ["tie"] = {
        name = "Ties",
        order = 1,
        canSee = function()
            for _,item in next, LocalPlayer():getChar():getInv():getItems() do
                if item.RemoveBody and item:getData("equip") then
                    for k, v in ipairs( item.Bonemerge ) do
                        if whitelist[v.Model] then
                            return true
                        end
                    end
                end
            end

            return false, "You cannot wear ties with the shirt you have equipped!\nEquip a compatible shirt in order to buy ties.", "Incompatible"
        end,
        bone = "ValveBiped.Bip01_Spine2",
        fov = 50,
    },
    ["fulloutfit"] = {
        name = "Outfits",
        bone = "ValveBiped.Bip01_Pelvis",
        order = 0,
        canSee = function()
            for _, item in next, LocalPlayer():getChar():getInv():getItems() do
                if item:getData( "equip" ) and ( item.slot == "pants" or item.slot == "shirt" or item.slot == "fulloutfit" ) then
                    return false, "You cannot wear a full outfit when you have a shirt or pants equipped!\nUnequip your shirt or pants in order to buy a full outfit.", "Incompatible"
                end
            end

            return true
        end,
    },
}

local pendrettiBlacklist = {
    ["hats"] = true,
    ["glasses"] = true,
    ["neck"] = true,
    ["wrist"] = true,
    ["leftring"] = true,
    ["rightring"] = true,
    ["tie"] = true,
    ["fulloutfit"] = true,
    ["face"] = true,
}

local URBAN_OUTFITTERS_MAT = CreateMaterial( "urbanoutfits_ui", "UnlitGeneric", {
    ["$basetexture"] = "unioncity2/signs/urbanoutfits",
} )

-- Panel
local currentlyHoveredItem
local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
    self:SetSize( ScrW(), ScrH() )
    self:MakePopup()

    self.menu = vgui.Create( "DFrame", self )
    self.menu:SetSize( ScrW() * 0.25, ScrH() * 0.85 )
    self.menu:SetPos( ScrW() * 0.05, ScrH() * 0.05 )
    self.menu:SetTitle( "" )
    self.menu:SetSkin( "ClothingVendor" )
    self.menu:ShowCloseButton( false )
    self.menu:SetDraggable( false )
    self.menu:DockPadding( 0, self.menu:GetTall() * 0.23, 0, 0 )
    function self.menu:Paint( w, h )
        derma.SkinHook( "Paint", "Frame", self, w, h )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( URBAN_OUTFITTERS_MAT )
        surface.DrawTexturedRect( 0, 0, w, h * 0.23 )
    end

    self.menu.container = self.menu:Add( "DScrollPanel" )
    self.menu.container:Dock( FILL )
    self.menu.container:SetZPos( 1 )
    function self.menu.container:Paint()
    end
end

function PANEL:ResetBonemergeDisplay()
    local previewModel = self.PreviewModel
    if not IsValid( previewModel ) then return end

    local equippedItemClasses = PLUGIN:GetEquippedItemClasses( LocalPlayer() )

    if currentlyHoveredItem and currentlyHoveredItem.class then
        equippedItemClasses[currentlyHoveredItem.class] = true
    end

    PLUGIN:UpdateVendorModel( equippedItemClasses )
end

function PANEL:SetInfo( vendor, previewModel )
    self.Vendor = vendor
    self.PreviewModel = previewModel
    self:CreateClothingOptions()
    self:ResetBonemergeDisplay()
end

function PANEL:CreateClothingOptions()
    local vendor = self.Vendor

    local container = self.menu.container
    container:Clear()
    container.Categories = {}

    for slot, info in SortedPairsByMemberValue( clothingCategories, "order" ) do
        if vendor.Pendretti and pendrettiBlacklist[slot] then continue end

        -- Yikes!
        local amount = 0
        for uniqueID,data in next, nut.item.list do
            if not vendor.VIP and ( data.slot == slot and not data.NoClothingVendor and not data.VIP ) then
                amount = amount + 1
            end
            if vendor.VIP and ( data.slot == slot and not data.NoClothingVendor and data.VIP and ( data.FactionsBuy and data.FactionsBuy[LocalPlayer():Team()] or data.PlayersBuy and data.PlayersBuy[LocalPlayer():SteamID()] or LocalPlayer():IsUserGroup("founder"))) then
                amount = amount + 1
            end
        end

        if amount == 0 then continue end

        if not container.Categories[slot] then
            local categoryButton = container:Add( "DButton" )
            categoryButton:SetText( info.name )
            categoryButton:SetFont( "nutBigFont" )
            categoryButton:DockMargin( 5, 5, 5, 0 )
            categoryButton:SetContentAlignment( 5 )
            categoryButton:Dock( TOP )
            categoryButton:SetTall( 36 )
            categoryButton:SetZPos( table.Count( container.Categories ) )
            categoryButton.DoClick = function( btn )
                if info.canSee then
                    local canSee, mainText, titleText = info.canSee()
                    if not canSee then
                        Derma_Query( mainText, titleText, "Okay" )
                        return
                    end
                end

                container:Clear()
                self:SelectClothingCategory( slot )
            end

            container.Categories[slot] = categoryButton
        end
    end

    if not self.close then
        self.close = self.menu:Add( "DButton" )
        self.close:SetText( "Exit" )
        self.close:SetFont( "nutBigFont" )
        self.close:DockMargin( 5, 0, 5, 5 )
        self.close:Dock( BOTTOM )
        self.close:SetTall( 36 )
        self.close:SetZPos( 999 )
        self.close.Paint = function( btn, w, h )
            local alpha = 2

            if ( btn.Depressed ) then
                alpha = 160
            elseif ( btn.Hovered ) then
                alpha = 200
            end

            surface.SetDrawColor( 255, 255, 255, alpha )
            surface.DrawRect( 0, 0, w, h )
        end
        self.close.DoClick = function( btn )
            self:Remove()
        end
    end
end

function PANEL:SelectClothingCategory( slot )
    if self.close then
        self.close:Remove()
        self.close = nil
    end

    local ply = LocalPlayer()
    local vendor = self.Vendor

    local category = clothingCategories[slot]
    if not category then
        self:CreateClothingOptions()
        PLUGIN.BonePos = PLUGIN.VendorOrigin + WorldToLocal( ply:GetBonePosition( ply:LookupBone( PLUGIN.DefaultBone ) ), ply:GetAngles(), ply:GetPos(), Angle( 0, 0, 0 ) )
        PLUGIN.CameraFOV = nil
        return
    end

    PLUGIN.BonePos = PLUGIN.VendorOrigin + WorldToLocal( ply:GetBonePosition( ply:LookupBone( category.bone ) ), ply:GetAngles(), ply:GetPos(), Angle( 0, 0, 0 ) )
    PLUGIN.CameraFOV = category.fov

    local itemlist = {}
    for uniqueID, data in next, nut.item.list do
        if data.base ~= "base_bonemerge" and data.base ~= "base_ties" then continue end
        if data.slot ~= slot then continue end
        if data.gender and data.gender ~= LocalPlayer():GetGender() then continue end
        if data.NoClothingVendor then continue end

        if LocalPlayer():IsUserGroup( "founder" ) then
            table.insert( itemlist, data )
        end
            
        if ( data.isPendretti and not vendor.Pendretti ) or ( vendor.Pendretti and not data.isPendretti ) then continue end
        if ( data.VIP and not vendor.VIP ) or ( vendor.VIP and not data.VIP ) then continue end
        if data.VIP and ( ( data.FactionsBuy and not data.FactionsBuy[LocalPlayer():Team()] ) or data.PlayersBuy and not data.PlayersBuy[LocalPlayer():SteamID()] ) then continue end

        table.insert( itemlist, data )
    end

    table.SortByMember( itemlist, "name" )

    local container = self.menu.container
    for _, data in ipairs( itemlist ) do
        local item = container:Add( "DButton" )
        item:SetText( data.name )
        item:SetContentAlignment( 4 )
        item:SetFont( "nutSmallFont" )
        item:SetZPos( #container:GetChildren() )
        item:DockMargin( 5, 5, 5, 0 )
        item:Dock( TOP )
        item:SetTall( 36 )
        item.class = data.uniqueID
        item.DoClick = function( btn )
            if LocalPlayer():getChar():getMoney() >= ( data.price or 0 ) then
                Derma_Query(
                    Format( "Are you sure you want to purchase %s?", data.name),
                    "Purchase",
                    "Yes",
                    function()
                        net.Start( "Bonemerge.PurchaseClothing" )
                        net.WriteEntity( vendor )
                        net.WriteString( data.uniqueID )
                        net.SendToServer()
                    end,
                    "No" )
            else
                Derma_Query(
                    Format( "You don't have enough money to purchase %s!", data.name),
                    "Not enough money",
                    "Okay" )
            end
        end
        item.Think = function()
            if item:IsHovered() and currentlyHoveredItem ~= item then
                currentlyHoveredItem = item
                self:OnItemHover( item )
            end
        end

        item.price = item:Add( "DLabel" )
        item.price:SetText( nut.currency.symbol .. string.Comma( data.price ) )
        item.price:SetTextColor( color_white )
        item.price:SetFont( "nutBigFont" )
        item.price:SizeToContents()
        item.price:SetTall( 36 )
        item.price:Dock( RIGHT )
    end

    self.back = self.menu:Add( "DButton" )
    self.back:SetText( "Back" )
    self.back:SetFont( "nutBigFont" )
    self.back:DockMargin( 5, 5, 5, 5 )
    self.back:Dock( BOTTOM )
    self.back:SetTall( 36 )
    self.back.Paint = function( btn, w, h )
        local alpha = 2

        if ( btn.Depressed ) then
            alpha = 160
        elseif ( btn.Hovered ) then
            alpha = 200
        end

        surface.SetDrawColor( 255, 255, 255, alpha )
        surface.DrawRect( 0, 0, w, h )
    end
    self.back.DoClick = function( btn )
        btn:Remove()
        currentlyHoveredItem = nil
        self:ResetBonemergeDisplay()
        self:SelectClothingCategory()
    end
end

function PANEL:OnMousePressed( keyCode )
    if keyCode == MOUSE_LEFT then
        self.lastAngles = self.PreviewModel:GetAngles()
        self.beginMouse = gui.MouseX()
        self.mouseLeftDown = true
    end
end

function PANEL:OnMouseReleased( keyCode )
    if keyCode == MOUSE_LEFT then
        self.mouseLeftDown = false
    end
end

function PANEL:Paint( w, h )
    if self.mouseLeftDown then
        self.PreviewModel:SetAngles( Angle( 0, self.lastAngles[2] - ( self.beginMouse - ( gui.MouseX() % 360 ) ), 0 ) )
    elseif self.mouseLeftDown and not self:IsHovered() then
        self.mouseLeftDown = false
    end
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        self:Remove()
        RunConsoleCommand( "cancelselect" )
    end
end

function PANEL:OnItemHover()
    self:ResetBonemergeDisplay()
end

function PANEL:OnRemove()
    PLUGIN:CloseVendor()
end

vgui.Register( "nsClothingVendor", PANEL, "EditablePanel" )