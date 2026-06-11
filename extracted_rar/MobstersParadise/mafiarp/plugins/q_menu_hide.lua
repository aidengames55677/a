PLUGIN.name = "Hide Q Menu"
PLUGIN.author = "Requiem Servers"
PLUGIN.desc = "No PET flags = no Q Menu."

hook.Add( "SpawnMenuOpen", "FlagCheckPET", function()
   if not LocalPlayer():getChar():hasFlags("pet") then
       return false
   end
end )
