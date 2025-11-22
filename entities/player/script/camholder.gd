@tool
extends Node3D

@export var default_cam_heigth: Vector3 = Vector3(0, 2.744, 0)
@export var smoothing_speed: float = 10.0

@onready var crouch_ray: ShapeCast3D = %crouch_ray


func _ready() -> void:
	_update_camera_position(1.0) # start instantly at correct position


func _process(delta: float) -> void:
	_update_camera_position(delta)


func _update_camera_position(delta: float) -> void:
	var target_global: Vector3

	# If something above the head (crouch clearance)
	if crouch_ray.is_colliding():
		target_global = crouch_ray.global_position
	else:
		target_global = owner.global_position + default_cam_heigth

	# Smooth global interpolation
	var new_pos := global_position.lerp(target_global, delta * smoothing_speed)

	global_position = new_pos
