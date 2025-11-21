extends Area3D

var stair_counter: int = 0


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("climbable"):
		stair_counter += 1


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("climbable"):
		stair_counter -= 1
