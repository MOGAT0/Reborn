extends Node3D

const CURSOR = preload("uid://bd3owytigobfj")
@onready var enemy_detector: Area3D = %enemy_detector
@onready var cam_target: Node3D = %cam_target
var target_lock: bool = false
@onready var cam_holder_y: SpringArm3D = %y

var register_target: Array[Node3D] = []
var sorted_target_distance: Array[Node3D] = []
var current_target_index: int = 0

var lock_cursor: Node3D = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("target"):
		if register_target.size() > 0:
			target_lock = !target_lock
		#else:
			#cam_holder_y

	_selecting_target(delta)
	_cursor_handler()
	#print(sorted_target_distance)

func target_selection_sort(array: Array[Node3D], player_pos: Vector3) -> Array[Node3D]:
	var n = array.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			var dist_j = array[j].global_position.distance_to(player_pos)
			var dist_j1 = array[j + 1].global_position.distance_to(player_pos)
			if dist_j > dist_j1:
				var temp = array[j]
				array[j] = array[j + 1]
				array[j + 1] = temp
	return array

func _selecting_target(delta: float) -> void:
	if register_target.size() == 0:
		current_target_index = 0
		sorted_target_distance = []
		_lock_on(cam_target, Vector3.ZERO, delta)
		return

	if not target_lock:
		sorted_target_distance = target_selection_sort(register_target, owner.global_position)

	current_target_index = clamp(current_target_index, 0, sorted_target_distance.size() - 1)
	if target_lock and sorted_target_distance.size() > 0:
		_lock_on(sorted_target_distance[current_target_index], Vector3(0, 2, 0), delta)
	else:
		current_target_index = 0
		_lock_on(cam_target, Vector3.ZERO, delta)
		
		

func _lock_on(target:Node3D,incrementation:Vector3,delta:float):
	if target.has_node("target_pos"):
		global_position = lerp(global_position,target.get_node("target_pos").global_position, delta * 10)
	else:
		global_position = lerp(global_position,target.global_position + incrementation, delta * 10)
		
	
	if owner.global_position.distance_to(target.global_position) > 16 and target_lock:
		target_lock = !target_lock
	


func _cursor_handler():
	if target_lock and sorted_target_distance.size() > 0:
		var target = sorted_target_distance[current_target_index]

		# Spawn cursor if not already existing
		if not is_instance_valid(lock_cursor):
			lock_cursor = CURSOR.instantiate()
			get_tree().current_scene.add_child(lock_cursor)  # Keep in world space

		# Update cursor position above the target
		if target.has_node("target_pos"):
			lock_cursor.global_position = target.get_node("target_pos").global_position
	else:
		# Remove cursor if lock is released
		if is_instance_valid(lock_cursor):
			lock_cursor.queue_free()
			lock_cursor = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and target_lock:
		if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if sorted_target_distance.size()-1 == current_target_index:
				current_target_index = 0
			else:
				current_target_index += 1

		if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if current_target_index == 0:
				current_target_index = sorted_target_distance.size() - 1
			else:
				current_target_index -= 1

			
func _on_enemy_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("targetable") and not register_target.has(body):
		register_target.append(body)

func _on_enemy_detector_body_exited(body: Node3D) -> void:
	if target_lock: return
	if body.is_in_group("targetable"):
		register_target.erase(body)
