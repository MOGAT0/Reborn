extends Area3D
class_name DAMAGE_RECIEVER

@export var parent:Node3D

func _damage(damage_ammount: float):
	if parent and parent.has_node("Health"):

		parent.get_node("Health")._take_damage(damage_ammount)
