-- "gamemodes\\mafiarp\\plugins\\bonemerge\\derma\\cl_character_slot.lua"


local PLUGIN = PLUGIN

hook.Add("InitializedPlugins", "Bonemerge.DetourCharacterSlot", function()
    local PANEL = vgui.GetControlTable("nutCharacterSlot")

    function PANEL:setCharacter(character)
        self.character = character

        self.name:SetText(character:getName():gsub("#", "\226\128\139#"):upper())
        self.model:SetModel(character:getModel())
        self.model.enableHook = true
        self.faction:SetBackgroundColor(team.GetColor(character:getFaction()))
        self:setBanned(character:getData("banned"))

        local entity = self.model.Entity
        if (IsValid(entity)) then
            -- Match the skin and bodygroups.
            entity:SetSkin(character:getData("skin", 0))
            for k, v in pairs(character:getData("groups", {})) do
                entity:SetBodygroup(k, v)
            end

            if entity.Bonemerge and #entity.Bonemerge > 0 then
                for _,ent in ipairs(entity.Bonemerge) do
                    ent:Remove()
                    ent.Bonemerge[_] = nil
                end
            end

            entity.Bonemerge = {}

            if PLUGIN.ModelCheck[character:getModel()] then
                local isFemale = string.lower(character:getModel()):find("female", 1, true) ~= nil
                local hands = isFemale and FEMALE_HANDS or MALE_HANDS
                local body = isFemale and FEMALE_BODY or MALE_BODY
                local legs = isFemale and FEMALE_LEGS or MALE_LEGS

                local handsEntity = ClientsideModel(hands, RENDERGROUP_BOTH)
                if not IsValid(handsEntity) then return end

                handsEntity:SetParent(entity)
                handsEntity:AddEffects(EF_BONEMERGE)
                handsEntity:SetNoDraw(true)
                handsEntity:SetSkin(PLUGIN.SkinTranslation[character:getModel()] or 0)

                entity.Bonemerge[#entity.Bonemerge + 1] = handsEntity

                local bodyEntity = ClientsideModel(body, RENDERGROUP_BOTH)
                if not IsValid(bodyEntity) then return end

                bodyEntity:SetParent(entity)
                bodyEntity:AddEffects(EF_BONEMERGE)
                bodyEntity:SetNoDraw(true)

                entity.Bonemerge[#entity.Bonemerge + 1] = bodyEntity

                local legsEntity = ClientsideModel(legs, RENDERGROUP_BOTH)
                if not IsValid(legsEntity) then return end

                legsEntity:SetParent(entity)
                legsEntity:AddEffects(EF_BONEMERGE)
                legsEntity:SetNoDraw(true)

                entity.Bonemerge[#entity.Bonemerge + 1] = legsEntity
            end

            -- Approximate the upper body position.
            local mins, maxs = entity:GetRenderBounds()
            local height = math.abs(mins.z) + math.abs(maxs.z)
            local scale = math.max((960 / ScrH()) * 0.5, 0.5)
            self.model:SetLookAt(entity:GetPos() + Vector(0, 0, height * scale))
        end
    end

    vgui.Register("nutCharacterSlot", PANEL, "DPanel")
end)