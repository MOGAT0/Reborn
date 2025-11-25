extends State
class_name Fall_idle

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]

@onready var ground_ray: ShapeCast3D = %ground_ray

@export var weapon_manager: WeaponManager

func enter():
	animation_tree["parameters/conditions/fall"] = true
	
	player.is_crouching = false
	
func update(delta:float):
	if ground_ray.is_colliding():
		if player.velocity.x != 0 or player.velocity.z != 0:
			state_machine.change_state("move")
			return
		if player.velocity.length() == 0 and player.player_dir == Vector2.ZERO:
			state_machine.change_state("idle")
			return

func physics_update(delta:float):
	player.movements(delta)

func exit():
	animation_tree["parameters/conditions/fall"] = false
