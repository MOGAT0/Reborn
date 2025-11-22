extends State
class_name Move_state

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]

@onready var ground_ray: ShapeCast3D = %ground_ray

@onready var weapon_manager: WeaponManager = %weapon_manager
@onready var offhand_manager: Node3D = %offhand_manager


func enter():
	animation_tree["parameters/conditions/move"] = true
	animation_tree["parameters/movement/move_speed/transition_request"] = "jogging"
	player.SPEED = player.jog_speed
	player.FOV = player.normal_fov
	
	player.is_crouching = false

func update(delta:float):
	_lock_movement(delta)
	player.weapon_stance_handler()
	
	if player.velocity.y > 0.0:
		state_machine.change_state("jump")
		return
	elif player.is_crouching:
		state_machine.change_state("crouch")
		return
	elif Input.is_action_pressed("sprint") and player.velocity.length() > 0.1 and state_machine.current_state.name != "attack":
		state_machine.change_state("run")
		return
	elif !player.is_on_floor() and !ground_ray.is_colliding():
		state_machine.change_state("fall_idle")
		return
	elif Input.is_action_just_pressed("attack") and weapon_manager.get_children().size() > 0:
		state_machine.change_state("attack")
		return
	elif player.velocity.length() == 0 and player.player_dir == Vector2.ZERO:
		state_machine.change_state("idle")
		return


func _lock_movement(delta: float) -> void:
	if player.lock_on.target_lock:
		
		var target := Vector2(player.player_dir.x, -player.player_dir.y)
		var current: Vector2 = animation_tree["parameters/movement/move_dir/blend_position"]

		# Smooth movement blending
		var smoothed := current.lerp(target, delta * 10.0)

		animation_tree["parameters/movement/move_dir/blend_position"] = smoothed
		#print(smoothed)
	else:
		# Smooth reset toward forward (0,1)
		var current: Vector2 = animation_tree["parameters/movement/move_dir/blend_position"]
		var target := Vector2(0.0, 1.0)

		var smoothed := current.lerp(target, delta * 10.0)

		animation_tree["parameters/movement/move_dir/blend_position"] = smoothed


func physics_update(delta:float):
	player.movements(delta)

func exit():
	animation_tree["parameters/conditions/move"] = false
