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
	target = GlobalScript.player
	if target and shader_material:
		# Update shader parameter with target position
		shader_material.set_shader_parameter("interracting_object_pos", target.global_position)
