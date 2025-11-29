extends Area3D
class_name ATTACK_SENDER

@export var damage_ammount: float


func _on_area_entered(area: Area3D) -> void:
	if area is DAMAGE_RECIEVER:
		area._damage(damage_ammount)


func _on_area_exited(area: Area3D) -> void:
	pass # Replace with function body.
