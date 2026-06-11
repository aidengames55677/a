-- "gamemodes\\mafiarp\\plugins\\typewriter\\items\\sh_typewriter.lua"

ITEM.name = "Typewriter"
ITEM.desc = "A machine with keys for producing alphabetical characters, numerals, \nand typographical symbols one at a time on paper inserted round a roller."
ITEM.model = "models/props_c17/cashregister01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Documents"
ITEM.price = 250

ITEM.functions.use = {
	name = "Use",
	onClick = function(item)
		vgui.Create("nutTypewriter")
	end,
	onRun = function(item)
		return false
	end,
	onCanRun = function(item)
		return IsValid(item.entity)
	end
}