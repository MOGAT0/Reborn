extends GridContainer

const INV_ITEM = preload("uid://cd7yw7uhpen6a")

var inventory_item:Dictionary

func _ready() -> void:
	#GlobalScript._Store_bulk_items("inventory",{
		#"knight_helmet":{
			#"amount":1,
			#"icon_path":"res://assets/img/knight armor set icon/knight_helmet.png",
			#"mesh":"res://entities/player/armor/knight_armor/Knight_chestplate.res",
			#"description":"a helmet of the reborn knight",
			#"type":"helmet"
		#}
	#})
	
	#GlobalScript._Update_item("inventory","knight_helmet",{
			#"amount":1,
			#"icon_path":"res://assets/img/knight armor set icon/knight_helmet.png",
			#"mesh":"res://entities/player/armor/knight_armor/Knight_chestplate.res",
			#"description":"a helmet of the reborn knight",
			#"type":"helmet"
		#})
	
	#GlobalScript._Print_debug()
	inventory_item = GlobalScript._Get_all_in_category("inventory")
	
	for item in inventory_item:
		#print(inventory_item[item])
		if int(inventory_item[item]["amount"]) > 0 and inventory_item[item]["type"] != "":
			display_item(item,inventory_item[item]["amount"],inventory_item[item].get("icon_path",""),inventory_item[item].get("mesh_path",""),inventory_item[item].get("description",""),inventory_item[item].get("type",""))
	
	
func display_item(item_name:String,amount:int,icon_path:String,mesh_path,description:String,type:String):
	var ins_item_obj = INV_ITEM.instantiate()
	var item_res: InvItem = InvItem.new()
	item_res.item_name = item_name
	item_res.item_ammount = amount
	item_res.item_icon = icon_path
	item_res.item_mesh = mesh_path
	item_res.item_desc = description
	item_res.item_type = type
	ins_item_obj.properties = item_res
	add_child(ins_item_obj)
