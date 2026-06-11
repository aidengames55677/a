local PLUGIN = PLUGIN

PLUGIN.name = "Spawn Menu Invisibility"
PLUGIN.author = "Adaster"
PLUGIN.desc = "Hides the spawn menu from players who don't have pet flags."

hook.Add( "SpawnMenuOpen", "FlagCheckPET", function()
   if not LocalPlayer():getChar():hasFlags("pet") then
       return false
   end
end )