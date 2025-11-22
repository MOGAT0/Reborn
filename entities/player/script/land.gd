#extends State
#class_name Land_state
#
#@onready var player: Player = $"../.."
#@onready var animation_tree: AnimationTree = %AnimationTree
#@onready var animation_state = animation_tree["parameters/playback"]
#@onready var ground_ray: ShapeCast3D = %ground_ray
#
#
#@export var weapon_manager: WeaponManager
#
#var counter : float = 1
#
#func enter():
	#animation_tree["parameters/conditions/land"] = true
	#player.FOV = player.normal_fov
	#
	#player.is_crouching = false
		#
#func update(delta:float):
	#
	#if counter <= 0:
		#if player.is_on_floor() and player.velocity.length() == 0.0:
			#state_machine.change_state("idle")
			#return
		#if player.is_on_floor() and player.velocity.length() != 0.0:
			#state_machine.change_state("move")
			#return
		#if player.velocity.y > 0.0:
			#state_machine.change_state("jump")
			#return
			#
			#
		#counter = 1
	#counter -= delta * 10
#
#
#func exit():
		#animation_tree["parameters/conditions/land"] = false


extends State
class_name Land_state

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]
@onready var ground_ray: ShapeCast3D = %ground_ray

@export var weapon_manager: WeaponManager


func enter():
	animation_tree["parameters/conditions/land"] = true
	player.FOV = player.normal_fov
	player.is_crouching = false


func update(delta: float):
	# Wait until the "land" animation finishes
	if animation_state.get_current_node() == "land" \
	and animation_state.get_current_play_position() >= animation_state.get_current_length():

		# Animation is fully finished — now decide where to go
		if !player.is_on_floor() and !ground_ray.is_colliding():
			state_machine.change_state("fall_idle")
			return

		if player.velocity.y > 0.0:
			state_machine.change_state("jump")
			return
		
		if player.velocity.length() == 0.0:
			state_machine.change_state("idle")
			return
		else:
			state_machine.change_state("move")
			return


func exit():
	animation_tree["parameters/conditions/land"] = false
