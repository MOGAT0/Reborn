extends Node

var player:Player
var can_damage:bool = false

#region ~Inventory setter and getter~
const SAVE_PATH := "res://data.json"
const DEFAULT_STRUCTURE : Dictionary = {
	"inventory": {},
}

func _load_json() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		_save_json(DEFAULT_STRUCTURE)
		return DEFAULT_STRUCTURE.duplicate(true)

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text := file.get_as_text()

	var json := JSON.new()
	var result := json.parse(text)

	if result != OK:
		push_error("JSON Parse Error: %s" % json.get_error_message())
		return DEFAULT_STRUCTURE.duplicate(true)

	return json.get_data() as Dictionary
	
func _save_json(data: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))

#setter and getter
func _Store_item(category: String, key: String, value: Variant) -> void:
	var data := _load_json()

	if not data.has(category):
		data[category] = {}

	data[category][key] = value
	_save_json(data)

func _Remove_item(category: String, key: String) -> void:
	var data := _load_json()

	if data.has(category) and data[category].has(key):
		data[category].erase(key)
		_save_json(data)
	else:
		print("Key or category does not exist:", category, key)

func _Get_item(category: String, key: String) -> Variant:
	var data := _load_json()

	if data.has(category) and data[category].has(key):
		return data[category][key]

	return null

func _Update_item(category: String, key: String, new_value: Variant) -> bool:
	var data := _load_json()

	if data.has(category) and data[category].has(key):
		data[category][key] = new_value
		_save_json(data)
		return true
	
	print("Cannot update: key '%s' in category '%s' does not exist." % [key, category])
	return false

func _Get_all_in_category(category: String) -> Dictionary:
	var data := _load_json()
	if data.has(category):
		return data[category].duplicate(true)
	return {}

func _Category_exists(category: String) -> bool:
	var data := _load_json()
	return data.has(category)

func _Delete_category(category: String) -> void:
	var data := _load_json()
	if data.has(category):
		data.erase(category)
		_save_json(data)

func _Store_bulk_items(category: String, items: Dictionary) -> void:
	for key in items.keys():
		_Store_item(category, key, items[key])

func _Print_debug() -> void:
	var data := _load_json()
	print(JSON.stringify(data, "\t"))

func _String_to_Vector3(str_val: String) -> Variant:
	if str_val.begins_with("(") and str_val.ends_with(")"):
		var temp_str:String
		var array_val:Array
		var result:Vector3
		
		temp_str = str_val.replace("(","").replace(")","")
		array_val = temp_str.split(",")
		
		result = Vector3(int(array_val[0]),int(array_val[1]),int(array_val[2]))
		
		return result
	else:
		return false


#endregion inv
