local function facingWall(client)
	local data = {}
	data.start = client:GetPos()
	data.endpos = data.start + client:GetAimVector()*54
	data.filter = client

	if (!util.TraceLine(data).HitWorld) then
		return "@faceWall"
	end
end

local function facingWallBack(client)
	local data = {}
	data.start = client:GetPos()
	data.endpos = data.start - client:GetAimVector()*54
	data.filter = client

	if (!util.TraceLine(data).HitWorld) then
		return "@faceWallBack"
	end
end

ACT_ENDSEQ = 0
ACT_STARTSEQ = 1

PLUGIN.acts["sit"] = {
	["player"] =  {sequence = {"pose_ducking_02", "sit_zen", "sit"}, untimed = true}
}
PLUGIN.acts["knee"] = {
	["player"] =  {sequence = "pose_ducking_01", untimed = true}
}
PLUGIN.acts["dance"] = {
	["player"] = {sequence = {"taunt_dance", "taunt_robot", "taunt_muscle", "taunt_persistence"}, untimed = false}
}
PLUGIN.acts["salute"] = {
	["player"] = {sequence = "gesture_salute_original", untimed = false}
}
PLUGIN.acts["pose"] = {
	["player"] = {sequence = {"pose_standing_01", "pose_standing_02", "pose_standing_03", "pose_standing_04"}, untimed = true}
}
PLUGIN.acts["cheer"] = {
	["player"] = {sequence = "taunt_cheer", untimed = false}
}
PLUGIN.acts["wave"] = {
	["player"] = {sequence = "gesture_wave_original", untimed = false}
}
PLUGIN.acts["agree"] = {
	["player"] = {sequence = "gesture_agree_original", untimed = false}
}
PLUGIN.acts["disagree"] = {
	["player"] = {sequence = "gesture_disagree_original", untimed = false}
}
PLUGIN.acts["come"] = {
	["player"] = {sequence = "gesture_becon_original", untimed = false}
}
PLUGIN.acts["there"] = {
	["player"] =  {sequence = {"gesture_point_original"}, untimed = true}
}
