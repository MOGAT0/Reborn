@tool
extends Button
@onready var icon_texture: Panel = %icon
@onready var amount: Label = %amount

@export var properties: InvItem

func _ready() -> void:
	
	self.pressed.connect(_on_button_pressed)
	
	# Prepare stylebox for icon
	var stylebox = icon_texture.get_theme_stylebox("panel")
	if stylebox == null or not stylebox is StyleBoxTexture:
		stylebox = StyleBoxTexture.new()
	
	# Load texture from string path
	if properties.item_icon != "":
		stylebox.texture = load(properties.item_icon) as Texture2D
	
	icon_texture.add_theme_stylebox_override("panel", stylebox)
	
	amount.text = str(properties.item_ammount)
	
func _on_button_pressed() -> void:
	print(properties.item_type, get_instance_id())
	
	
