extends Node3D

func _process(delta: float) -> void:
	_position_markers()

func _position_markers():
	for child in get_children():
		if child is RayCast3D:
			
			if child.is_colliding():
				child.get_child(0).global_position = child.get_collision_point()
			else:
				var tip: Vector3 = child.global_transform.origin + (child.global_transform.basis * child.target_position)
				child.get_child(0).global_position = tip
