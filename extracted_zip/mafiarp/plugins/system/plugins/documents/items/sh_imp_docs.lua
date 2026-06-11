ITEM.name = "Important Documents"
ITEM.desc = "A piece of thick paper, quite fancy. Looks official. This document has something written on it."
ITEM.flag = "Y"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.uniqueID = "papers"
ITEM.netUID = "openUpID"
ITEM.additionalArg = nil
ITEM.permit = "permit_docs"

ITEM.functions = {}
ITEM.functions.show = {
    icon = "icon16/user.png",
    name = "Show",
    onRun = function(item)
        local ply = item.player
        if (ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime()) then
            ply:notify("You can't show documents that quickly!")
            return false
        end
        ply.NextDocumentCheck = SysTime() + 5
        local target = ply:GetEyeTrace().Entity
        if not target:IsPlayer() or not IsValid(target) or target:GetPos():Distance(ply:GetPos()) > 500 then
            return false
        end
        netstream.Start(target, "openUpID", ply)
        return false
    end,
    onCanRun = function(item)
        local trEnt = item.player:GetEyeTrace().Entity
        return IsValid(trEnt) and trEnt:IsPlayer()
    end,
}

ITEM.functions.showself = {
    icon = "icon16/user.png",
    name = "View",
    onRun = function(item)
        local ply = item.player
        if (ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime()) then
            ply:notify("You can't view documents that quickly!")
            return false
        end
        ply.NextDocumentCheck = SysTime() + 5
        netstream.Start(ply, item.netUID, ply, item.additionalArg)
        return false
    end,
}

-- Function to prevent the item from being transferred or dropped.
function ITEM:onCanBeTransfered(oldInventory, newInventory)
    return false
end
