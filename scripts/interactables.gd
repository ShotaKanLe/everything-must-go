extends RigidBody3D

@export var item_data: ItemData

func _ready() -> void:
	name = item_data.item_name
	_setup_mesh(item_data.mesh_scene)

func interact() -> void:
	if Inventory.add_item(item_data):
		call_deferred("queue_free")
	else:
		print("Inventory penuh")


# ── Private ───────────────────────────────────────────────────────

func _setup_mesh(scene: PackedScene) -> void:
	freeze = true
 
	var inst: Node3D = scene.instantiate()
	add_child(inst)
 
	var mesh := _find_mesh(inst)
	if mesh:
		_attach_collision(mesh)
 
	await get_tree().process_frame
	freeze = false

func _find_mesh(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result := _find_mesh(child)
		if result:
			return result
	return null

func _attach_collision(mesh: MeshInstance3D) -> void:
	var col_shape := CollisionShape3D.new()
	col_shape.shape = mesh.mesh.create_convex_shape()
	add_child(col_shape)
	col_shape.global_transform = mesh.global_transform
