NITORIA = NITORIA or {}
NT = NT or {}
nitoria = nitoria or {}
nt = nt or {}

util.AddNetworkString("purchase_function")
util.AddNetworkString("sell_func")
util.AddNetworkString("buyfunc")


net.Receive("purchase_function", function(len, ply)
	local uniqueID = net.ReadString()
	local amnt = net.ReadInt(6) 
	local itemTable = nut.item.list[uniqueID]  
	local price = (itemTable.price or 50)
	local tax = (price*nut.config.get("salesTax"))
	local price = math.Round((price + tax))
	local character = ply:getChar()

	if character:hasMoney(price) then
		if amnt != 1 then
			if character:hasMoney(price*amnt) then
				for i = 1, amnt do
					character:getInv():add(uniqueID)
				end
				character:takeMoney(price*amnt)
				ply:notify("You've purchased x" .. amnt .. " an item for $" .. price*amnt .."." )
			else
				ply:notify("You do not have enough money to purchase this item.")
			end
		else
			character:getInv():add(uniqueID)
			character:takeMoney(price)
			ply:notify("You've purchased an item for $" .. price ..".")
		end
	else
		ply:notify("You do not have enough money to purchase this item.")
	end
end)

net.Receive("sell_func", function(len, ply)
	local uniqueID = net.ReadString()
	local itemTable = nut.item.list[uniqueID]  
	local price = (itemTable.price or 50)
	local character = ply:getChar()

	if character:getInv():hasItem(uniqueID) then
		character:removeItem(uniqueID, 1)
		character:giveMoney(price/2)
		ply:notify("You've sold an item for $" .. price .. ".")
	else
		ply:notify("You do not have this item to sell.")
	end
end)