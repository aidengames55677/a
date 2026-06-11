---------------------------------------------------------------------------------------------------------------
nut.config.add("moneyspawndelay", 60, "How long it takes for a player to use /dropmoney again.", nil, {
	data = {min = 1, max = 300},
	category = "Currency"
})
---------------------------------------------------------------------------------------------------------------
nut.config.add("PaymentInterval", 600, "How long before salaries are sent to the Salary NPC", nil, {
	data = {min = 1, max = 5600},
	category = "Currency"
})
---------------------------------------------------------------------------------------------------------------
nut.config.add("LootTime", 300, "How long before loot boxes disappear", nil, {
	data = {min = 1, max = 5600},
	category = "Death"
})
---------------------------------------------------------------------------------------------------------------