extends CharacterBody3D
class_name Player

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
@onready var lock_on: Node3D = %lock_on
@onready var state_machine: StateMachine = %StateMachine
@onready var weapon_manager: WeaponManager = %weapon_manager
@onready var offhand_manager: Node3D = %offhand_manager

@export var sprint_speed: float = 8.0
@export var jog_speed: float = 5.0
@export var walk_speed: float = 1.7
var SPEED:float = jog_speed
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 2
var player_dir: Vector2 = Vector2.ZERO

@export var sprint_fov:float = 80.0
@export var normal_fov:float = 70.0
@export var FOV:float = sprint_fov

@onready var body: Node3D = %body
@onready var cam_holder_x:SpringArm3D = %y
@onready var cam_holder_y:  Node3D = %x
@onready var camera: Camera_editor = %Camera

var camX_val:float = 0.0
var camY_val:float = 0.0
@export var sensitivity: float = 0.005
@onready var ground_ray: ShapeCast3D = %ground_ray

var is_crouching: bool = false

@onready var collider: CollisionShape3D = %collider
@onready var crouch_collider: CollisionShape3D = %crouch_collider
@onready var crouch_ray: ShapeCast3D = %crouch_ray

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam_holder_y.rotate_y(deg_to_rad(180))

func _process(delta: float) -> void:
	camera.fov = lerp(camera.fov,FOV,delta*10)
	_camera_rotation()
	_handle_lock(delta)
	gravity_handling(delta)
	collider.disabled = is_crouching
	crouch_collider.disabled = !collider.disabled
	
	move_and_slide()

func gravity_handling(delta:float) -> void:
	if !is_on_floor():
		velocity.y -= (gravity * delta) * 3
	elif Input.is_action_just_pressed("jump"):
		velocity.y = gravity

	#print(animation_state.get_current_node())

func _accelerate(amount: float = 2.0, delay_sec: float = 0.3) -> void:
	await get_tree().create_timer(delay_sec).timeout
	print("accelerate")

	var input_dir: Vector2 = Input.get_vector("d", "a", "s", "w")

	var accel_dir := (cam_holder_y.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var forward_dir: Vector3 = -body.global_transform.basis.z.normalized()
	if accel_dir:
		velocity.x = accel_dir.x * (amount * SPEED)
		velocity.z = accel_dir.z * (amount * SPEED)
	else:
		velocity.x = forward_dir.x * (amount * SPEED)
		velocity.z = forward_dir.z * (amount * SPEED)


func movements(delta:float):
	player_dir = Input.get_vector("a","d","w","s")
	
	var cam_dir = (cam_holder_y.basis * Vector3(player_dir.x,0,player_dir.y)).normalized()
	
	if player_dir:
		velocity.x = cam_dir.x * SPEED
		velocity.z = cam_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		velocity.z = move_toward(velocity.z,0,SPEED)
		
	if Input.is_action_just_pressed("crouch") and !crouch_ray.is_colliding():
		is_crouching = !is_crouching
		
	#print(is_crouching)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED: return
		camY_val = -event.relative.x * sensitivity
		camX_val = -event.relative.y * sensitivity

var cam_y_smoothing_done := false

func _handle_lock(delta: float):

	if !lock_on.target_lock:
		if player_dir and state_machine.current_state is not Move_state:
			body.rotation.y = lerp_angle(body.rotation.y, atan2(velocity.x,velocity.z),delta * 30)
		else:
			if player_dir == Vector2.ZERO:
				return

			var cam_holder_yaw : float = cam_holder_y.rotation.y
			var input_vec : Vector3 = Vector3(player_dir.x, 0, player_dir.y)
			var rotated_vec : Vector3 = input_vec.rotated(Vector3.UP, cam_holder_yaw).normalized()

			body.rotation.y = lerp_angle(body.rotation.y, atan2(rotated_vec.x, rotated_vec.z), delta * 20.0)
	else:
		if Input.is_action_pressed("sprint"):

			var cam_holder_yaw : float = cam_holder_y.rotation.y
			var input_vec : Vector3 = Vector3(player_dir.x, 0, player_dir.y)
			var rotated_vec : Vector3 = input_vec.rotated(Vector3.UP, cam_holder_yaw).normalized()

			body.rotation.y = lerp_angle(body.rotation.y, atan2(rotated_vec.x, rotated_vec.z), delta * 20.0)
		else:
			body.look_at(lock_on.global_transform.origin)
			body.rotate_y(deg_to_rad(180))
			body.rotation.x = deg_to_rad(0)

			var cam_target_dir = -(lock_on.global_transform.origin - cam_holder_y.global_transform.origin).normalized()
			var cam_yaw = atan2(cam_target_dir.x, cam_target_dir.z)
			
			if not cam_y_smoothing_done:
				cam_holder_y.rotation.y = lerp_angle(cam_holder_y.rotation.y, cam_yaw, delta * 5)
				if abs(cam_holder_y.rotation.y - cam_yaw) < deg_to_rad(0.5):
					cam_y_smoothing_done = true
			else:
				cam_holder_y.rotation.y = cam_yaw
				
				
			cam_holder_x.rotation.x = lerp(cam_holder_x.rotation.x, deg_to_rad(-30), delta * 10)
		
func _camera_rotation():
	if lock_on.target_lock: return
	cam_holder_y.rotate_y(camY_val)
	cam_holder_x.rotate_x(camX_val)
	cam_holder_x.rotation.x = clamp(cam_holder_x.rotation.x, deg_to_rad(-60), deg_to_rad(40))
	camX_val = 0
	camY_val = 0
	
	
func weapon_stance_handler() -> void:
	var stance := ""

	if Input.is_action_pressed("shield") and (offhand_manager.get_child(0) is NormalShield or offhand_manager.get_child(0) is GreatShield):
		stance = "shielding"
	elif weapon_manager.get_child(0) is LongSword:
		stance = "longsword_equiped"
	else:
		stance = "no_equiped"

	_set_stance("parameters/idle/stance/transition_request", stance)
	_set_stance("parameters/movement/move_dir/0/stance/transition_request", stance)
	_set_stance("parameters/movement/move_dir/1/stance/transition_request", stance)
	_set_stance("parameters/movement/move_dir/2/stance/transition_request", stance)
	_set_stance("parameters/movement/move_dir/3/stance/transition_request", stance)
	_set_stance("parameters/movement/run_stance/transition_request", stance)


func _set_stance(path: String, stance: String) -> void:
	animation_tree[path] = stance
