extends State
class_name Jump_state

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]

@onready var ground_ray: ShapeCast3D = %ground_ray

@export var weapon_manager: WeaponManager

func enter():
	animation_tree["parameters/conditions/jump"] = true

	player.is_crouching = false
	
func update(delta:float):
	
	if animation_state.get_current_node() == "fall_idle":
		state_machine.change_state("fall_idle")
		return
		
func physics_update(delta:float):
	player.movements(delta)

func exit():
	animation_tree["parameters/conditions/jump"] = false
	animation_tree["parameters/conditions/fall"] = false
	
