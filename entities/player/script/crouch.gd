extends State
class_name CrouchState

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
@onready var ground_ray: ShapeCast3D = %ground_ray

@onready var collider: CollisionShape3D = %collider
@onready var weapon_manager: WeaponManager = %weapon_manager
@onready var offhand_manager: Node3D = %offhand_manager

var crouch_timer:float = 0.3

func enter():
	animation_tree["parameters/conditions/move"] = true
	animation_tree["parameters/movement/move_speed/transition_request"] = "crouch"
	collider.disabled = true
	player.SPEED = player.walk_speed
	player.FOV = player.normal_fov
	

func _process(delta: float) -> void:
	if player.velocity.y > 0.0:
		state_machine.change_state("jump")
	elif !player.is_on_floor() and !ground_ray.is_colliding():
		state_machine.change_state("fall_idle")
	elif Input.is_action_just_pressed("attack") and weapon_manager.get_children().size() > 0:
		state_machine.change_state("attack")
	elif state_machine.current_state.name == "crouch" and Input.is_action_just_pressed("crouch"):
		state_machine.change_state("idle")
	
	#print(state_machine.current_state.name)
func physics_update(delta:float):
	
	player.movements(delta)

	if player.velocity.length() == 0:
		animation_tree["parameters/movement/crouch_transition/transition_request"] = "crouch_idle"
	else:
		animation_tree["parameters/movement/crouch_transition/transition_request"] = "crouch"


func exit():
	animation_tree["parameters/conditions/move"] = false
	collider.disabled = false
