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
	print(weapon_manager.get_children().size())
	player.FOV = player.normal_fov

func update(delta:float):
	player.weapon_stance_handler()
	if player.velocity.y > 0.0:
		state_machine.change_state("jump")
	elif player.velocity.length() != 0.0:
		state_machine.change_state("move")
	elif !player.is_on_floor() and !ground_ray.is_colliding():
		state_machine.change_state("fall_idle")
	elif Input.is_action_just_pressed("attack") and weapon_manager.get_children().size() > 0:
		state_machine.change_state("attack")
	#elif Input.is_action_just_pressed("crouch"):
		#state_machine.change_state("crouch")
		


		
		
func physics_update(delta:float):
	player.movements(delta)

func exit():
	animation_tree["parameters/conditions/idle"] = false
