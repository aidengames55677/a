-- "gamemodes\\mafiarp\\plugins\\holsteredweps\\cl_plugin.lua"

local PLUGIN = PLUGIN

PLUGIN.CharacterOwnership = PLUGIN.CharacterOwnership or {}

/*
	Micro optimizations
*/

-- god cant wait for macros in new gamemode
local function GetMetaMethod(c, m)
	return FindMetaTable(c)[m]
end

local LocalPlayer = LocalPlayer
local IsValid = IsValid
local ClientsideModel = ClientsideModel
local ipairs = ipairs
local next = next

local string_lower = string.lower

local config_get = nut.config.get

local Player_ShouldDrawLocalPlayer = GetMetaMethod("Player", "ShouldDrawLocalPlayer")
local Player_GetActiveWeapon = GetMetaMethod("Player", "GetActiveWeapon")
local Player_GetCharacter = GetMetaMethod("Player", "getChar")
local Player_GetWeapons = GetMetaMethod("Player", "GetWeapons")

local Entity_IsValid = GetMetaMethod("Entity", "IsValid")
local Entity_GetClass = GetMetaMethod("Entity", "GetClass")
local Entity_SetNoDraw = GetMetaMethod("Entity", "SetNoDraw")
local Entity_LookupBone = GetMetaMethod("Entity", "LookupBone")
local Entity_GetBonePosition = GetMetaMethod("Entity", "GetBonePosition")
local Entity_SetRenderAngles = GetMetaMethod("Entity", "SetRenderAngles")
local Entity_SetRenderOrigin = GetMetaMethod("Entity", "SetRenderOrigin")
local Entity_DrawModel = GetMetaMethod("Entity", "DrawModel")
local Entity_GetBoneMatrix = GetMetaMethod("Entity", "GetBoneMatrix")
local Entity_GetNetVar = GetMetaMethod("Entity", "getNetVar")

local Angle_Right = GetMetaMethod("Angle", "Right")
local Angle_Up = GetMetaMethod("Angle", "Up")
local Angle_Forward = GetMetaMethod("Angle", "Forward")
local Angle_RotateAroundAxis = GetMetaMethod("Angle", "RotateAroundAxis")

local Matrix_GetTranslation = GetMetaMethod("VMatrix", "GetTranslation")
local Matrix_GetAngles = GetMetaMethod("VMatrix", "GetAngles")

PLUGIN.StoredWeaponEntities = PLUGIN.StoredWeaponEntites or {}
local StoredWeaponEntities = PLUGIN.StoredWeaponEntities

/*
	Hooks
*/

-- this code runs a lot so better optimize it heavily
local function drawWeapon(ply, class, curClass)
	local drawInfo = HOLSTER_DRAWINFO[class]
	if (not drawInfo or not drawInfo.model) then return end

	if not IsValid(StoredWeaponEntities[class]) then
		local model = ClientsideModel(drawInfo.model, RENDERGROUP_TRANSLUCENT)
		Entity_SetNoDraw(model, true)

		StoredWeaponEntities[class] = model
	end

	local drawModel = StoredWeaponEntities[class]
	local boneIndex = Entity_LookupBone(ply, drawInfo.bone)

	if (not boneIndex or boneIndex < 0) then return end
	
	local matrix = Entity_GetBoneMatrix(ply, boneIndex)
	local bonePos = Matrix_GetTranslation(matrix)
	local boneAng = Matrix_GetAngles(matrix)

	if (curClass ~= class and IsValid(drawModel)) then
		local right = Angle_Right(boneAng)
		local up = Angle_Up(boneAng)
		local forward = Angle_Forward(boneAng)

		Angle_RotateAroundAxis(boneAng, right, drawInfo.ang[1])
		Angle_RotateAroundAxis(boneAng, up, drawInfo.ang[2])
		Angle_RotateAroundAxis(boneAng, forward, drawInfo.ang[3])

		bonePos = bonePos
			+ drawInfo.pos[1] * right
			+ drawInfo.pos[2] * forward
			+ drawInfo.pos[3] * up

		Entity_SetRenderOrigin(drawModel, bonePos)
		Entity_SetRenderAngles(drawModel, boneAng)
		Entity_DrawModel(drawModel)
	end
end

-- this code runs a lot so better optimize it heavily
function PLUGIN:PostPlayerDraw(client)
	-- return value of localplayer never changes so best to cache it
	if !self.LocalPlayer then
		self.LocalPlayer = LocalPlayer()
	end

	local LocalPlayer = self.LocalPlayer

	if (not config_get("showHolsteredWeps")) then return end
	if (not Player_GetCharacter(client)) then return end
	if (client == LocalPlayer and not Player_ShouldDrawLocalPlayer(client)) then
		return
	end

	local wep = Player_GetActiveWeapon(client)
	local curClass = ((wep and Entity_IsValid(wep)) and string_lower(Entity_GetClass(wep)) or "")

	-- Create holstered models for each weapon.
	local ownedWeapons = self.CharacterOwnership[client:getNetVar("char", 0)]
	if !ownedWeapons then return end

	for _,id in ipairs(PLUGIN.TotalWeapons) do
		local data = ownedWeapons[id]
		if !data then continue end
		if !data.show then continue end

		local class = data.class

		drawWeapon(client, class, curClass)
	end

	for _,wep in ipairs(Player_GetWeapons(client)) do
		local class = Entity_GetClass(wep)

		drawWeapon(client, class, curClass)
	end
end

-- get all the existing weapon data
function PLUGIN:InitPostEntity()
	net.Start("nutReceiveWeapon")
	net.SendToServer()
end

/*
	Networking
*/

local function nutReceiveWeapon(len)
	local count = net.ReadUInt(8)
	for i = 1, count do
		local charID = net.ReadUInt(32)
		local itemID = net.ReadUInt(32)
		local class = net.ReadString()
		local show = net.ReadBool()

		local character = nut.char.loaded[charID]
		if !character then return end

		local entity = character:getPlayer()

		if !PLUGIN.CharacterOwnership[charID] then
			PLUGIN.CharacterOwnership[charID] = {}
		end

		PLUGIN.CharacterOwnership[charID][itemID] = {class = class, show = show}
		if show and !table.HasValue(PLUGIN.TotalWeapons, itemID) then
			table.insert(PLUGIN.TotalWeapons, itemID)
		elseif !show and table.HasValue(PLUGIN.TotalWeapons, itemID) then
			table.RemoveByValue(PLUGIN.TotalWeapons, itemID)
		end
	end
end
net.Receive("nutReceiveWeapon", nutReceiveWeapon)


/*
	Commands
*/

-- Awesome helper command, feel free to steal :P (It's so awesome right)
concommand.Add( "holsterpos", function( ply, cmd, args )
    if !ply:IsSuperAdmin() then return end
    if !args[1] then return end

    local wepModel
    for k, v in pairs(nut.item.list) do
        if v.isWeapon && v.class == args[1] then
            wepModel = tostring(v.model)
            break
        end
    end

    if !wepModel then return end
    
    if usingModelEntity then return end
    if !usingModelEntity then
        usingModelEntity = true
    end
    
    local modelEntity
    local modelPos = Vector(6, 8, 0)
    local modelAng = Angle(20, 180, 0)
    local step = 0.02
    
    local function CreateOrUpdateModel()
        if not IsValid(LocalPlayer()) then return end
    
        if not IsValid(modelEntity) then
            modelEntity = ClientsideModel(wepModel)
            modelEntity:SetParent(LocalPlayer())
        end
    
        local boneId = LocalPlayer():LookupBone("ValveBiped.Bip01_Spine2")
        if boneId then
            local bonePos, boneAng = LocalPlayer():GetBonePosition(boneId)
    
            local right = boneAng:Right()
            local up = boneAng:Up()
            local forward = boneAng:Forward()
    
            boneAng:RotateAroundAxis(right, modelAng[1])
            boneAng:RotateAroundAxis(up, modelAng[2])
            boneAng:RotateAroundAxis(forward, modelAng[3])
    
            bonePos = bonePos
                + modelPos[1] * right
                + modelPos[2] * forward
                + modelPos[3] * up
    
            modelEntity:SetPos(bonePos)
            modelEntity:SetAngles(boneAng)
        end
    end
    
    hook.Add("Think", "ModelMover", function()
        CreateOrUpdateModel()
    
        if input.IsKeyDown(KEY_S) then
            modelPos = modelPos - Vector(step, 0, 0)
        elseif input.IsKeyDown(KEY_W) then
            modelPos = modelPos + Vector(step, 0, 0)
        end
    
        if input.IsKeyDown(KEY_A) then
            modelPos = modelPos + Vector(0, 0, step)
        elseif input.IsKeyDown(KEY_D) then
            modelPos = modelPos - Vector(0, 0, step)
        end
    
        if input.IsKeyDown(KEY_LEFT) then
            modelAng = modelAng + Angle(0, step, 0)
        elseif input.IsKeyDown(KEY_RIGHT) then
            modelAng = modelAng - Angle(0, step, 0)
        end
    
        if input.IsKeyDown(KEY_UP) then
            modelAng = modelAng + Angle(step, 0, 0)
        elseif input.IsKeyDown(KEY_DOWN) then
            modelAng = modelAng - Angle(step, 0, 0)
        end
    
        if input.IsKeyDown(KEY_PAD_MINUS) then
            modelPos = modelPos - Vector(0, step, 0)
        elseif input.IsKeyDown(KEY_PAD_PLUS) then
            modelPos = modelPos + Vector(0, step, 0)
        end
        
    end)
    
    hook.Add("PlayerButtonDown", "ModelMoverRemove", function(ply, button)
        if ply == LocalPlayer() and button == MOUSE_MIDDLE then
            ply:ChatPrint("Angles: " .. tostring(modelAng) .. "\nPosition: " .. tostring(modelPos))

            ply:ChatPrint([[		]]..args[1]..[[ = {
                bone = "ValveBiped.Bip01_Spine2",
                ang = Angle(]]..modelAng.x..", "..modelAng.y..", "..modelAng.z..[[),
                pos = Vector(]]..modelPos.x..", "..modelPos.y..", "..modelPos.z..[[),
            },]])
            if IsValid(modelEntity) then
                modelEntity:Remove()
            end
    
            hook.Remove("Think", "ModelMover")
            hook.Remove("PlayerButtonDown", "ModelMoverRemove")
            usingModelEntity = false
        end
    end)
    
end )