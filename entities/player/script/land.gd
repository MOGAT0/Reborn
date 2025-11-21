extends State
class_name Land_state

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
@onready var ground_ray: ShapeCast3D = %ground_ray


@export var weapon_manager: WeaponManager

var counter : float = 1

func enter():
		animation_tree["parameters/conditions/land"] = true
		player.FOV = player.normal_fov
func update(delta:float):
	if counter <= 0:
		if player.is_on_floor() and player.velocity.length() == 0.0:
			state_machine.change_state("idle")
		elif player.is_on_floor() and player.velocity.length() != 0.0:
			state_machine.change_state("move")
		elif player.velocity.y > 0.0:
			state_machine.change_state("jump")
			
			
		counter = 1
	counter -= delta * 10


func exit():
		animation_tree["parameters/conditions/land"] = false
