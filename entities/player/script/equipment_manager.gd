extends VBoxContainer

func _ready() -> void:
	for btn in get_tree().get_nodes_in_group("equipment_btn"):
		btn.connect("pressed", Callable(self, "_on_button_pressed").bind(btn))

func _on_button_pressed(btn:Button):
	for child in btn.get_children():
		if child.get_children().size() > 0:
			for icon in child.get_children():
				if icon is Panel and icon.name == "icon":
					var panel_icon: Panel = icon
					
					# Get existing stylebox or create new one
					var stylebox = panel_icon.get_theme_stylebox("panel")
					if stylebox == null or not stylebox is StyleBoxTexture:
						stylebox = StyleBoxTexture.new()
					
					# Set your texture
					stylebox.texture = preload("uid://c23kjbift3c8k")
					
					# Apply it back as an override
					panel_icon.add_theme_stylebox_override("panel", stylebox)
					
					print("Texture applied to:", panel_icon)
