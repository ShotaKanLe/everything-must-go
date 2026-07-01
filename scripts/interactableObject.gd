extends RigidBody3D
class_name InteractableObject

@export var item_data : ShoppingItem
@export var label_offset : Vector3 = Vector3(0, 0.6, 0)
@export var break_velocity_threshold : float = 6.0

var current_price : float = 0.0
var is_label_active : bool = false
const FRACTURE_PARTICLES = preload("res://scenes/fracture_particles.tscn")

@onready var label_3d: Label3D = $Label
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var object_name_label: Label3D = $ObjectName
@onready var object_price_label: Label3D = $ObjectPrice

func _ready() -> void:
	
	if item_data:
		current_price = item_data.get_random_price()
		object_name_label.text = item_data.objectName
		object_price_label.text = "$%.2f" % current_price

	if label_3d:
		label_3d.text = ""
		label_3d.top_level = true
		
	# Mengaktifkan deteksi tabrakan fisika pada RigidBody3D
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if is_label_active and label_3d:
		label_3d.global_position = global_position + label_offset
		label_3d.global_transform.basis = Basis()

func interact(player_strength: int) -> bool:
	if item_data and player_strength >= item_data.strengthLevelToLift:
		return true
	return false

func set_label_visibility(visible: bool) -> void:
	is_label_active = visible
	if label_3d:
		if visible and item_data:
			label_3d.text = item_data.objectName
			label_3d.global_position = global_position + label_offset
			label_3d.global_transform.basis = Basis()
		else:
			label_3d.text = ""

func _on_body_entered(_body: Node) -> void:
	if item_data and item_data.isFragile:
		# Mengukur kecepatan benturan sesaat sebelum menyentuh tanah/tembok
		var impact_speed := linear_velocity.length()
		
		if impact_speed >= break_velocity_threshold:
			destroy_and_fracture()

func destroy_and_fracture() -> void:
	if mesh_instance_3d and mesh_instance_3d.mesh:
		# Membuat node partikel baru langsung dari script-nya
		var FractureParticlesScript = load("res://scripts/fracture_particles.gd")
		var spawn_particles = GPUParticles3D.new()
		spawn_particles.set_script(FractureParticlesScript)
		
		get_tree().current_scene.add_child(spawn_particles)
		spawn_particles.global_position = global_position
		
		var active_material : Material = mesh_instance_3d.get_active_material(0)
		spawn_particles.explode(mesh_instance_3d.mesh, active_material)
		
	if label_3d:
		label_3d.queue_free()
		
	queue_free()
