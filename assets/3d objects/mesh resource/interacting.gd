extends MultiMeshInstance3D

var target: Node3D

var shader_material: ShaderMaterial

func _ready() -> void:
	# Get the ShaderMaterial from material_override
	if material_override:
		shader_material = material_override as ShaderMaterial
	else:
		push_warning("No material_override set on MultiMeshInstance3D!")

func _process(delta: float) -> void:
	if target and shader_material:
		# Update shader parameter with target position
		shader_material.set_shader_parameter("interracting_object_pos", target.global_position)
		print(target)

func _on_area_3d_body_entered(body: Node3D) -> void:
	target = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == target:
		target = null
