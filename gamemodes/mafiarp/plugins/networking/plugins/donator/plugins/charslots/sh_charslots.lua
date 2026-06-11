local plMeta = FindMetaTable("Player")

function plMeta:GetAdditionalCharSlots()
	return self:getNutData("AdditionalCharSlots", 0)
end

if (SERVER) then
	function plMeta:SetAdditionalCharSlots(val)
		self:setNutData("AdditionalCharSlots", val)
		self:saveNutData()
	end
	
	function plMeta:GiveAdditionalCharSlots(AddValue)
		AddValue = math.max(0, AddValue or 1)
		self:SetAdditionalCharSlots(self:GetAdditionalCharSlots() + AddValue)
	end
end