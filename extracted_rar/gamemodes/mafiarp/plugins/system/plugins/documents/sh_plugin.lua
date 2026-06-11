PLUGIN.name = "Important Document"
PLUGIN.desc = "Adds an important document with all the information about a player's appearance."
PLUGIN.author = "Robert Bearson, berko"

nut.util.include("cl_docgui.lua")
nut.util.include("cl_missingInfos.lua")
nut.util.include("sv_networking.lua")

charCharacteristics = {
  ["Age"] = "number",
  ["Date of Birth"] = "string",
  ["Place of Birth"] = "string",
  ["Height"] = "string",
  ["Hair Color"] = {valueType = "choice", choices={"Auburn", "Black", "Blond", "Brown", "Bald", "Grey"}},
  ["Eye Color"] = {valueType = "choice", choices={"Amber", "Brown", "Black", "Blue", "Green"}},
  ["Religion"] = "string",
  ["Blood Type"] = {valueType = "choice", choices={"O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"}},
  ["Ethnicity"] = {valueType = "choice", choices={"Ukranian", "Turkic", "Russian", "Romanian", "Jewish", "Hungarian", "Finnish", "Caucasian", "Byelorussian", "Baltic", "Danish", "Dutch", "French", "German", "Italian", "Japanese", "Polish", "Swedish"}},
  ["Occupation"] = "string",
  ["Weight"] = "number"
}

nut.command.add("chareditpapers", {
	syntax = "",
	onRun = function(ply,args)
		netstream.Start(ply,"missingCharacteristics", "Edit your information", true)
	end
})
