extends VBoxContainer

@onready var equipment: VBoxContainer = %equipment
@onready var inventory: ScrollContainer = %inventory

@onready var instruction: HBoxContainer = %instruction
@onready var settings: VBoxContainer = %settings

@onready var equipment_btn: Button = %equipment_btn

func _ready() -> void:
	equipment_btn.grab_click_focus()
	for btn in get_tree().get_nodes_in_group("tab_btn"):
		btn.connect("pressed", Callable(self, "_on_button_pressed").bind(btn))
	
	_show_only(equipment)
	
func _process(delta: float) -> void:
	instruction.visible = inventory.visible

func _on_button_pressed(btn: Button) -> void:
	match btn.name:
		"equipment_btn":
			_show_only(equipment)
		"inventory_btn":
			_show_only(inventory)
		"settings_btn":
			_show_only(settings)

func _show_only(container_to_show: Control) -> void:
	
	for container in [equipment, inventory, settings]:
		container.visible = container == container_to_show
