extends CharacterBody3D
class_name Dummy

@export var min_distance: float = 2.0     # smallest patrol distance
@export var max_distance: float = 6.0     # largest patrol distance
@export var move_speed: float = 2.0       # speed
@export var is_moving : bool

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var direction: int = 1
var start_x: float
var target_distance: float = 0.0   # current random limit


func _ready() -> void:
	start_x = global_position.x

	# Randomize initial direction
	direction = -1 if randf() < 0.5 else 1

	# Randomize first distance
	_set_new_random_distance()


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= gravity * 2.0
	if is_moving:
		velocity.x = direction * move_speed

		# Check if dummy reached its random boundary
		if direction == 1 and global_position.x >= start_x + target_distance:
			direction = -1
			_set_new_random_distance()
		elif direction == -1 and global_position.x <= start_x - target_distance:
			direction = 1
			_set_new_random_distance()

	# Gravity

	move_and_slide()


func _set_new_random_distance() -> void:
	target_distance = randf_range(min_distance, max_distance)
