
-----------------------------------------------------
local PLUGIN = PLUGIN
PLUGIN.name = "Ambient Sounds"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Ambient Sounds"

PLUGIN.config = {}
PLUGIN.config.activated = true

if CLIENT then

	PLUGIN.timeData = {
	}
	PLUGIN.sndWind = nil
	PLUGIN.sndInternal = nil
	
	function PLUGIN:Think()
		PLUGIN.sndWind = PLUGIN.sndWind or CreateSound( LocalPlayer(), "vehicles/fast_windloop1.wav" )
		PLUGIN.sndInternal = PLUGIN.sndInternal or CreateSound( LocalPlayer(), "ambient/atmosphere/town_ambience.wav" )
	
		
		local data = {}
			data.start = LocalPlayer():GetShootPos()
			data.endpos = data.start + Vector( 0, 0, 10000 )
			data.filter = LocalPlayer()
		local trace = util.TraceLine(data)
		if trace.HitSky then
			if !self.sndWind:IsPlaying() then
				self.sndWind:Play()
			end
			self.sndWind:ChangeVolume( 0, 0 )
			self.sndInternal:ChangeVolume( .1, .1 )
		else
			if !self.sndInternal:IsPlaying() then
				self.sndInternal:Play()
			end
			self.sndWind:ChangeVolume( 0, 0 )
			self.sndInternal:ChangeVolume( 0, 0 )
		end
	end
	
end