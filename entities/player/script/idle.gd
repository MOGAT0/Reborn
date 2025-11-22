extends State
class_name Idle_state

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]

@onready var ground_ray: ShapeCast3D = %ground_ray

@onready var weapon_manager: WeaponManager = %weapon_manager
@onready var offhand_manager: Node3D = %offhand_manager


func enter():
	animation_tree["parameters/conditions/idle"] = true
	player.FOV = player.normal_fov
	player.is_crouching = false

func update(delta:float):
	player.weapon_stance_handler()
	
	if player.velocity.y > 0.0:
		state_machine.change_state("jump")
		return
	elif player.is_crouching:
		state_machine.change_state("crouch")
		return
	elif player.velocity.length() != 0.0:
		state_machine.change_state("move")
		return
	elif !player.is_on_floor() and !ground_ray.is_colliding():
		state_machine.change_state("fall_idle")
		return
	elif Input.is_action_just_pressed("attack") and weapon_manager.get_children().size() > 0:
		state_machine.change_state("attack")
		return

func physics_update(delta:float):
	player.movements(delta)

func exit():
	animation_tree["parameters/conditions/idle"] = false
