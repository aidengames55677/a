ITEM.name = "Newspaper Base"
ITEM.desc = "A newspaper."
ITEM.category = "literature"
ITEM.model = "models/props_lab/bindergraylabel01b.mdl"
ITEM.contents = ""
ITEM.functions.Read = {
	onClick = function(item)
	item.player:ConCommand("articles")
	end,
	onRun = function(item)
		return false
	end,
	icon = "icon16/book_open.png"
}
ITEM.permit = "admin"