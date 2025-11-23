extends State
class_name CrouchState

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
@onready var ground_ray: ShapeCast3D = %ground_ray
@onready var crouch_ray: ShapeCast3D = %crouch_ray

@onready var collider: CollisionShape3D = %collider
@onready var weapon_manager: WeaponManager = %weapon_manager
@onready var offhand_manager: Node3D = %offhand_manager



func enter():
	animation_tree["parameters/conditions/crouch"] = true

	player.SPEED = player.walk_speed
	player.FOV = player.normal_fov


func _process(delta: float) -> void:
	if crouch_ray.is_colliding():return
	
	if !player.is_crouching and state_machine.current_state.name != "attack" \
	and state_machine.current_state.name != "run" \
	and state_machine.current_state.name != "jump" \
	and state_machine.current_state.name != "fall_idle" \
	and state_machine.current_state.name != "land":

		if player.velocity.length() > 0.1:
			state_machine.change_state("move")
			return

		if player.velocity.length() <= 0.1 and player.player_dir == Vector2.ZERO:
			state_machine.change_state("idle")
			return
			
		

	if player.velocity.y > 0.0:
		state_machine.change_state("jump")
		return

	if Input.is_action_just_pressed("attack") and weapon_manager.get_children().size() > 0:
		state_machine.change_state("attack")
		return
		
	if Input.is_action_pressed("sprint") and player.velocity.length() > 0.1 and state_machine.current_state.name != "attack":
		state_machine.change_state("run")
		return

	if !player.is_on_floor() and !ground_ray.is_colliding():
		state_machine.change_state("fall_idle")
		return
		
	if Input.is_action_pressed("shield") and state_machine.current_state.name != "attack":
		state_machine.change_state("idle")
		return






func physics_update(delta: float):
	player.movements(delta)

	# Smooth crouch speed blend (0 = idle, 1 = full crouch walk)
	var target :float = clamp(player.velocity.length(), 0.0, 1.0)
	var current :float = animation_tree["parameters/crouch/crouch_dir/blend_position"]

	var smoothed :float = lerp(current, target, delta * 10.0)
	animation_tree["parameters/crouch/crouch_dir/blend_position"] = smoothed



func exit():
	animation_tree["parameters/conditions/crouch"] = false
