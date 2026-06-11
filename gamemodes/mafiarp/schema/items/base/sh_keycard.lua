ITEM.name = "Keycard Items"
ITEM.desc = "Opens Doors."
ITEM.model = "models/weapons/w_package.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.permit = "permit_code"
ITEM.DoorName = "fort1"
ITEM.DoorName2 = "fort2"
ITEM.DoorName3 = "fort3"
ITEM.DoorName4 = "fort4"
ITEM.DoorName5 = "fort5"
ITEM.DoorName6 = "fort6"
ITEM.DoorName7 = "fort7"
ITEM.DoorName8 = "fort8"
ITEM.DoorName9 = "fort9"
ITEM.DoorName10 = "fort10"

ITEM.functions.use = {
    name = "Use",
    icon = "icon16/arrow_up.png",
    onRun = function(item)
        local client = item.player
        local trace = client:GetEyeTraceNoCursor()
        local target = trace.Entity

        if target:IsValid() and (target:GetName() == item.DoorName or target:GetName() == item.DoorName2 or target:GetName() == item.DoorName3 or target:GetName() == item.DoorName4 or target:GetName() == item.DoorName5 or target:GetName() == item.DoorName6 or target:GetName() == item.DoorName7 or target:GetName() == item.DoorName8 or target:GetName() == item.DoorName9 or target:GetName() == item.DoorName10) then
            local tab = target:GetSaveTable()

            if tab.m_bLocked then
                target:Fire("unlock", "", .1)
				target:EmitSound("doors/door_latch1.wav")
				client:notifyLocalized("Door-Unlocked")
            else
                target:Fire("lock", "", .1)
				target:EmitSound("doors/door_latch1.wav")
				client:notifyLocalized("Door-Locked")
            end
        end

        return false
    end,
    onCanRun = function(item) return not IsValid(item.entity) end
}