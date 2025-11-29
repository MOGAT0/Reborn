extends VBoxContainer

func _ready() -> void:
	for btn in get_tree().get_nodes_in_group("item_btn"):
		btn.connect("pressed", Callable(self, "_on_button_pressed").bind(btn))

func _on_button_pressed(btn:Button):
	pass
