extends RigidBody3D
class_name InteractableObject

@export var item_data : ShoppingItem
@export var break_velocity_threshold : float = 6.0

var current_price : float = 0.0
var is_label_active : bool = false

# Menyimpan posisi relatif (offset) yang sudah Anda atur di editor
var name_label_offset : Vector3 = Vector3.ZERO
var price_label_offset : Vector3 = Vector3.ZERO

@onready var name_label: Label3D = get_node_or_null("ObjectName")
@onready var price_label: Label3D = get_node_or_null("ObjectPrice")
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	if item_data and current_price == 0.0:
		current_price = item_data.get_random_price()
		
	# Ambil posisi Y dan XZ yang sudah Anda set manual di editor scene masing-masing
	if name_label:
		name_label_offset = name_label.position
		name_label.visible = false
	if price_label:
		price_label_offset = price_label.position
		price_label.visible = false
		
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if is_label_active:
		# Posisikan label secara global berdasarkan posisi object + offset dari editor
		# Basis() direset agar rotasi label tetap tegak dan tidak ikut berputar
		if name_label and name_label.visible:
			name_label.global_position = global_position + name_label_offset
			name_label.global_transform.basis = Basis()
			
		if price_label and price_label.visible:
			price_label.global_position = global_position + price_label_offset
			price_label.global_transform.basis = Basis()

func interact(player_strength: int) -> bool:
	if item_data and player_strength >= item_data.strengthLevelToLift:
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
	if item_data and item_data.isFragile:
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
