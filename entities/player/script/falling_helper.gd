extends Area3D

func _process(delta: float) -> void:
	_update_collision_color()
	
func _update_collision_color():
	var bodies = get_overlapping_bodies()
	var col: CollisionShape3D = get_child(0)

	col.debug_color = Color.RED if bodies.size() > 0 else Color.GREEN
