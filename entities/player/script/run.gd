extends State
class_name RunState

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
@onready var ground_ray: ShapeCast3D = %ground_ray
@onready var weapon_manager: WeaponManager = %weapon_manager
@onready var offhand_manager: Node3D = %offhand_manager
@onready var camera: Camera_editor = %Camera

func enter():
	animation_tree["parameters/conditions/move"] = true
	animation_tree["parameters/movement/move_speed/transition_request"] = "running"
	player.SPEED = player.sprint_speed
	player.FOV = player.sprint_fov
	
	player.is_crouching = false

func update(delta: float):
	player.weapon_stance_handler()

	# --- FALL CHECK ---
	if player.velocity.y < 0.0 and !player.is_on_floor() and !ground_ray.is_colliding():
		state_machine.change_state("fall_idle")
		print("switched")
		return

	# --- JUMP CHECK ---
	if player.velocity.y > 0.0:
		state_machine.change_state("jump")
		return

	# --- ATTACK ---
	if Input.is_action_just_pressed("attack") and weapon_manager.get_child_count() > 0:
		state_machine.change_state("attack")
		return

	# --- STOP MOVING ---
	if player.velocity.length() == 0.0 and player.player_dir == Vector2.ZERO:
		state_machine.change_state("idle")
		return

	# --- STOP SPRINTING ---
	if !Input.is_action_pressed("sprint"):
		state_machine.change_state("move")
		return

func physics_update(delta:float):
	player.movements(delta)

func  exit():
	animation_tree["parameters/conditions/move"] = false
