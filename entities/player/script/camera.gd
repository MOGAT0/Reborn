@tool
extends Camera3D
class_name Camera_editor

@export var target:Node3D
@export var enemy_target:Node3D

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_update_cam_pos()
		
	if target:
		_look_at_target()

func _look_at_target() -> void:
	var target_ave = (enemy_target.global_position + target.global_position) / 2
	look_at(target_ave,Vector3.UP)

func _update_cam_pos() -> void:
	var springarm : SpringArm3D = get_parent()
	if springarm and springarm is SpringArm3D:
		var tip_pos: Vector3 = springarm.transform.basis * Vector3(0,0,springarm.get_length())
		global_position = springarm.global_position + tip_pos
