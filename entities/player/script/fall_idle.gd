extends State
class_name Fall_idle

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]

@onready var ground_ray: ShapeCast3D = %ground_ray

@export var weapon_manager: WeaponManager

func enter():
	animation_tree["parameters/conditions/fall"] = true
	player.FOV = player.normal_fov
	
	player.is_crouching = false
	
func update(delta:float):
	
	if player.is_on_floor() and ground_ray.is_colliding():
		state_machine.change_state("land")
		return

func physics_update(delta:float):
	player.movements(delta)

func exit():
	animation_tree["parameters/conditions/fall"] = false
