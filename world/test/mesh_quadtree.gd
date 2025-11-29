@tool
extends MeshInstance3D
class_name QuadTreeChunk
# or extends MeshInstance3D if you prefer the root itself to be a MeshInstance3D

@export var normal : Vector3 = Vector3(0, 1, 0)
@export var focus_position: Vector3 = Vector3.ZERO
@export var max_depth: int = 3
@export var root_size: float = 1.0

var bounds : AABB
var children : Array
var depth : int
var max_chunk_depth : int
var identifier : String

func _init(_bounds: AABB, _depth: int, _max_chunk_depth: int) -> void:
	bounds = _bounds
	depth = _depth
	max_chunk_depth = _max_chunk_depth
	children = []
	identifier = "%s_%s_%d" % [bounds.position, bounds.size, depth]

func subdivide(focus_point: Vector3, axisA: Vector3, axisB: Vector3, face_origin: Vector3) -> void:
	# Only subdivide if not at max depth
	var size = bounds.size.x
	if depth >= max_chunk_depth:
		return
	
	var half = size * 0.5
	var quarter = size * 0.25
	
	# offsets in 2D (x,z plane in your quadtree)
	var offsets = [
		Vector2(-quarter, -quarter),
		Vector2( quarter, -quarter),
		Vector2(-quarter,  quarter),
		Vector2( quarter,  quarter),
	]
	
	for off in offsets:
		var child_center_2d = Vector2(bounds.position.x, bounds.position.z) + off * 2.0
		# map to 3D center on face plane
		var center_3d = face_origin + child_center_2d.x * axisA + child_center_2d.y * axisB
		var distance = center_3d.distance_to(focus_point)
		# choose whether to subdivide based on distance
		var child_bounds = AABB(Vector3(child_center_2d.x, 0, child_center_2d.y) - Vector3(half, half, half), Vector3(half*2, half*2, half*2))
		var child = QuadTreeChunk.new(child_bounds, depth + 1, max_chunk_depth)
		children.append(child)
		# subdivide further if close
		if distance < size * 0.75 and child.depth < child.max_chunk_depth:
			child.subdivide(focus_point, axisA, axisB, face_origin)


# Data structures for tracking created chunks / nodes
var quadTree : QuadTreeChunk
var chunk_list = {} # id -> MeshInstance3D


func _ready() -> void:
	_generate_mesh()


func _generate_mesh() -> void:
	# create root quadtree
	var root_aabb = AABB(Vector3(0, 0, 0) - Vector3(root_size * 0.5, root_size * 0.5, root_size * 0.5), Vector3(root_size, root_size, root_size))
	quadTree = QuadTreeChunk.new(root_aabb, 0, max_depth)
	
	# compute local axes for the face from normal
	var axisA = Vector3(normal.y, normal.z, normal.x).normalized()
	var axisB = normal.cross(axisA).normalized()
	var face_origin = Vector3.ZERO  # adjust if you want the face offset
	
	quadTree.subdivide(focus_position, axisA, axisB, face_origin)
	visualize_quadtree(quadTree, face_origin, axisA, axisB)


func visualize_quadtree(chunk: QuadTreeChunk, face_origin: Vector3, axisA: Vector3, axisB: Vector3) -> void:
	# leaf => create a quad mesh
	if chunk.children.size() == 0:
		var id = chunk.identifier
		if chunk_list.has(id):
			return
		
		var pos2d = Vector2(chunk.bounds.position.x, chunk.bounds.position.z)
		var size = chunk.bounds.size.x
		
		# corners in 2D (x,y)
		var corners2d = [
			Vector2(pos2d.x, pos2d.y),
			Vector2(pos2d.x + size, pos2d.y),
			Vector2(pos2d.x + size, pos2d.y + size),
			Vector2(pos2d.x, pos2d.y + size),
		]
		
		var verts = PackedVector3Array()
		for c in corners2d:
			var p3 = face_origin + c.x * axisA + c.y * axisB
			verts.append(p3)  # do NOT normalize unless you really want unit vectors
		
		var indices = PackedInt32Array([0,2,1, 0,3,2])  # two triangles
		
		var arrays = []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = verts
		arrays[Mesh.ARRAY_INDEX] = indices
		
		var surf_mesh = ArrayMesh.new()
		surf_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		
		# optional: add a simple material so it's visible
		var mat = StandardMaterial3D.new()
		mat.metallic = 0.0
		mat.roughness = 1.0
		surf_mesh.surface_set_material(0, mat)
		
		var mi = MeshInstance3D.new()
		mi.mesh = surf_mesh
		add_child(mi)
		chunk_list[id] = mi
	else:
		# recurse
		for c in chunk.children:
			visualize_quadtree(c, face_origin, axisA, axisB)
