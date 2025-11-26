extends Control

@onready var hud: CanvasLayer = %HUD
@onready var inventory: CanvasLayer = %Inventory

var is_inv_open:bool = false

func _process(delta: float) -> void:
	inventory.visible = is_inv_open
	hud.visible = !inventory.visible
	
	if Input.is_action_just_pressed("inventory"):
		is_inv_open = !is_inv_open
	
	if is_inv_open:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
