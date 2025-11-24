@tool
extends Camera3D

@export var player: Node3D
@export var rot_target:Node3D

func _process(delta: float) -> void:
	if player:
		global_position = Vector3(player.global_position.x,1000,player.global_position.z)
		rotation.y = rot_target.rotation.y
