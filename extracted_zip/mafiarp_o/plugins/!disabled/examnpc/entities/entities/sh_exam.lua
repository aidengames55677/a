ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Exam NPC"
ENT.Category = "RedDawn MafiaRP"
ENT.Spawnable = true
ENT.
ENT.Exam = {"Question 1", "Question 2", "Question 3"} -- Default exam

function ENT:Initialize()
    if (SERVER) then
        self:SetModel("models/player/breen.mdl")
        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:DrawShadow(true)
        self:SetSolid(SOLID_OBB)
        self:PhysicsInit(SOLID_OBB)
        self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)
        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end
    end
end


function ENT:SetExam(exam)
    self.Exam = exam
end

function ENT:AcceptInput(name, activator)
    if name == "Use" and IsValid(activator) and activator:IsPlayer() then
        net.Start("OpenExam")
        net.WriteTable(self.Exam)
        net.Send(activator)
    end
end
