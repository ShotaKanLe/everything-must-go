extends RigidBody3D
class_name InteractableObject

@export var item_data : BaseItem
@export var break_velocity_threshold : float = 6.0

var current_price : float = 0.0
var is_label_active : bool = false
var is_showing_feedback : bool = false 

var name_label_offset : Vector3 = Vector3.ZERO
var price_label_offset : Vector3 = Vector3.ZERO

@onready var name_label: Label3D = get_node_or_null("ObjectName")
@onready var price_label: Label3D = get_node_or_null("ObjectPrice")
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var cardboxScene = preload("res://scenes/objects/Tools/Cardbox.tscn")

func _ready() -> void:
	if item_data and item_data is ShoppingItem and item_data.objectNameId != "":
		_auto_fill_item_data()

	if item_data and current_price == 0.0:
		if item_data.has_method("get_random_price"):
			current_price = item_data.get_random_price()
		else:
			current_price = randf_range(item_data.minimumPrice, item_data.maximumPrice)
		
	if name_label:
		name_label_offset = name_label.position
		name_label.visible = false
	if price_label:
		price_label_offset = price_label.position
		price_label.visible = false
		
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _auto_fill_item_data() -> void:
	var db = ShoppingItemArrayList.new()
	var target_name = item_data.objectNameId

	for type_dict in db.shoppingItemArrayList:
		for category_dict in type_dict["list"]:
			for item in category_dict["listItem"]:
				if item["objectName"] == target_name:
					item_data.objectName = item["objectName"]
					item_data.minimumPrice = item["minimumPrice"]
					item_data.maximumPrice = item["maximumPrice"]
					item_data.weight = item["weight"]
					item_data.strengthLevelToLift = item["strenghtLevelToLift"]
					
					item_data.objectCategory = category_dict["category"]
					item_data.isFragile = item["isFragile"]
					item_data.availableFromDay = item["availableFromDay"]
					item_data.isIllegalToSteal = item["isIllegalToSteal"]
					
					db.queue_free()
					return
					
	db.queue_free()

func _process(_delta: float) -> void:
	if is_label_active:
		if name_label and name_label.visible:
			name_label.global_position = global_position + name_label_offset
			name_label.global_transform.basis = Basis()
			
		if price_label and price_label.visible:
			price_label.global_position = global_position + price_label_offset
			price_label.global_transform.basis = Basis()

func interact(player_strength: int) -> bool:
	if not item_data:
		return false
		
	if item_data is ShoppingItem:
		return player_strength >= item_data.strengthLevelToLift
	elif item_data is ToolItem:
		return true 
	elif item_data is UpgradeItem:
		return true 
		
	return false

func set_label_visibility(visible: bool) -> void:
	is_label_active = visible
	
	if visible and item_data:
		if name_label:
			name_label.text = item_data.objectName
			name_label.visible = true
			name_label.global_position = global_position + name_label_offset
			name_label.global_transform.basis = Basis()
			
		if price_label:
			price_label.text = "$ %.2f" % current_price
			price_label.visible = true
			price_label.global_position = global_position + price_label_offset
			price_label.global_transform.basis = Basis()
	else:
		if name_label:
			name_label.text = ""
			name_label.visible = false
		if price_label:
			price_label.text = ""
			price_label.visible = false

func _on_body_entered(_body: Node) -> void:
	if item_data is ShoppingItem and item_data.isFragile:
		var impact_speed := linear_velocity.length()
		if impact_speed >= break_velocity_threshold:
			destroy_and_fracture()

func destroy_and_fracture() -> void:
	if mesh_instance_3d and mesh_instance_3d.mesh:
		var FractureParticlesScript = load("res://scripts/fracture_particles.gd")
		var spawn_particles = GPUParticles3D.new()
		spawn_particles.set_script(FractureParticlesScript)
		
		get_tree().current_scene.add_child(spawn_particles)
		spawn_particles.global_position = global_position
		spawn_particles.emitting = true
		
		queue_free()

func process_scanner_ui(label: Label) -> void:
	if is_showing_feedback:
		return
		
	var scanner_raycast: RayCast3D = get_node_or_null("RayCast3D")
	if not scanner_raycast or not label: return

	if scanner_raycast.is_colliding():
		var col = scanner_raycast.get_collider()
		if col is InteractableObject and col.item_data is ShoppingItem:
			var s_item = col.item_data as ShoppingItem
			if s_item.isPaid:
				label.text = "Item already paid"
			else:
				label.text = "Press E to pay: $ %.2f" % col.current_price
			label.visible = true
			return

	label.text = "Scanner Active"
	label.visible = true

func execute_scan(label: Label) -> void:
	if is_showing_feedback:
		return
		
	var scanner_raycast: RayCast3D = get_node_or_null("RayCast3D")
	if not scanner_raycast or not label: return

	if scanner_raycast.is_colliding():
		var col = scanner_raycast.get_collider()
		if col is InteractableObject and col.item_data is ShoppingItem:
			var s_item = col.item_data as ShoppingItem

			if s_item.isPaid:
				return

			var in_paying_area = false
			var paying_areas = get_tree().get_nodes_in_group("paying_area")
			for area in paying_areas:
				if area.overlaps_body(col):
					in_paying_area = true
					break

			if not in_paying_area:
				show_temporary_feedback(label, "Must pay in cashier")
				return

			if LevelData.money >= col.current_price:
				LevelData.money -= col.current_price
				LevelData.money = snapped(LevelData.money, 0.01)
				s_item.isPaid = true
				print("(item berhasil dibayarkan)")
				show_temporary_feedback(label, "Paid successfully!")
				col.create_into_box()
			else:
				show_temporary_feedback(label, "Not enough money")

func show_temporary_feedback(label: Label, text: String) -> void:
	is_showing_feedback = true
	label.text = text
	label.visible = true
	await get_tree().create_timer(1.5).timeout
	is_showing_feedback = false

func create_into_box() -> void:
	var cardbox_scene = load("res://scenes/objects/Tools/Cardbox.tscn")
	if cardbox_scene:
		var box_instance = cardbox_scene.instantiate()
		
		if item_data and item_data is ShoppingItem:
			box_instance.item_data = item_data.duplicate(true)
			box_instance.item_data.isPaid = true
			
		box_instance.current_price = current_price
		
		get_tree().current_scene.add_child(box_instance)
		box_instance.global_position = global_position
		box_instance.global_rotation = global_rotation
		
		_spawn_box_particles()
		
	queue_free()

func _spawn_box_particles() -> void:
	var particles = GPUParticles3D.new()
	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 0.4
	material.direction = Vector3.UP
	material.initial_velocity_min = 2.0
	material.initial_velocity_max = 4.0
	material.gravity = Vector3(0, -3, 0)
	
	var pass_mesh = BoxMesh.new()
	pass_mesh.size = Vector3(0.08, 0.08, 0.08)
	var spatial_mat = StandardMaterial3D.new()
	spatial_mat.albedo_color = Color(0.6, 0.4, 0.2) 
	pass_mesh.material = spatial_mat
	
	particles.process_material = material
	particles.draw_pass_1 = pass_mesh
	particles.emitting = true
	particles.one_shot = true
	particles.explosiveness = 0.9
	
	get_tree().current_scene.add_child(particles)
	particles.global_position = global_position
	
	get_tree().create_timer(1.5).timeout.connect(particles.queue_free)
