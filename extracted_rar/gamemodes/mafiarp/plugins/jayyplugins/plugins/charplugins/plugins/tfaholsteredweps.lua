PLUGIN.name = "TFA Support"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "TFA Support"

function PLUGIN:InitializedPlugins()
	do
		hook.Remove("EntityTakeDamage","TFA_TurretPhysics")
		hook.Remove("HUDPaint", "TFAPatchTTT")
		hook.Remove("InitPostEntity", "TFAPatchTTT")
		hook.Remove("EntityEmitSound", "zzz_TFA_EntityEmitSound")
		hook.Remove("PreDrawEffects", "TFAMuzzleUpdate")
		hook.Remove("PopulateMenuBar", "NPCOptions_MenuBar_TFA")
		hook.Remove("PostDrawTranslucentRenderables", "PreDrawViewModel_TFA_INSPECT")
		hook.Remove("InitPostEntity","InitTFABlur")
		hook.Remove("PlayerFootstep", "TFAWalkcycle")
		hook.Remove("Tick", "TFAInspectionScreenClicker")
		hook.Remove("AllowPlayerPickup", "TFAPickupDisable")
		hook.Remove("ContextMenuOpen", "TFAContextBlock")
		hook.Remove("Think", "TFAInspectionMenu")
		hook.Remove("PlayerSay", "TFAJoinGroupChat")
		hook.Remove("HUDPaint", "tfa_debugcrosshair")
		hook.Remove("canPocket", "TFA_PockBlock")
		hook.Remove("HUDPaint", "TFA_DISPLAY_CHANGELOG")
		hook.Remove("PostDrawOpaqueRenderables", "TFABallisticsRender")
		hook.Remove("PreRender", "TFABallisticsTick")
		hook.Remove("HUDPaint", "TFA_TRIGGERCLIENTLOAD")
		hook.Remove("Tick", "TFABallisticsTick")
	end
end
