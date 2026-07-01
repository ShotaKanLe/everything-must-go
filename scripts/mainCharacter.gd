extends CharacterBody3D

@export var can_move : bool = true
@export var has_gravity : bool = true
@export var can_jump : bool = true
@export var can_sprint : bool = true
@export var can_freefly : bool = false

@export_group("Speeds")
@export var look_speed : float = 0.002
@export var base_speed : float = 7.0
@export var jump_velocity : float = 4.5
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
@export var input_left : String = "left"
@export var input_right : String = "right"
@export var input_forward : String = "forward"
@export var input_back : String = "backward"
@export var input_jump : String = "ui_accept"
@export var input_sprint : String = "run"
@export var input_freefly : String = "freefly"

@export_group("Stamina System")
@export var max_stamina : float = 100.0
@export var stamina_drain : float = 10.0
@export var stamina_regen : float = 5.0
@export var stamina_progress_bar : Range

@export_group("HP System")
@export var max_hp : float = 100.0
@export var hp_progress_bar : Range

@export_group("Interaction Settings")
@export var max_interaction_distance : float = 4.0
@export var min_grab_distance : float = 1.5
@export var max_grab_distance : float = 4.0
@export var grab_power : float = 18.0
@export var throw_momentum_factor : float = 0.4
@export var laser_thickness : float = 0.04

@export_group("Rotation Settings")
@export_group("Rotation Settings")
@export var rotation_sensitivity : float = 0.3

@export var inventory_ui : Control

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false
var current_stamina : float = 100.0
var current_hp : float = 100.0
var player_strength_level : int = 0

var hovered_object : InteractableObject = null
var grabbed_object : InteractableObject = null
var current_grab_distance : float = 2.0

var is_rotating : bool = false
var _pending_angular_velocity : Vector3 = Vector3.ZERO

var laser_mesh : MeshInstance3D
var laser_material : ORMMaterial3D

const LASER_COLOR_GRAB   := Color(0.0, 1.0, 0.0, 0.4)
const LASER_COLOR_ROTATE := Color(0.6, 0.0, 1.0, 0.6)

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var collider: CollisionShape3D = $Collider
var current_item_instance: Node3D = null
@onready var ray = $Head/Camera3D/RayCast3D

func _ready() -> void:
	max_stamina = LevelData.get_max_stamina()
	max_hp = LevelData.get_max_hp()
	current_stamina = max_stamina
	current_hp = max_hp
	base_speed = LevelData.get_base_speed()
	stamina_regen = LevelData.get_stamina_regen()
	max_grab_distance = LevelData.get_max_grab_distance()
	player_strength_level = LevelData.strength_level

	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	setup_laser_visual()
	Inventory.item_drop.connect(drop_from_player)
	
	if hp_progress_bar:
		hp_progress_bar.max_value = max_hp
		hp_progress_bar.value = current_hp
	
	if stamina_progress_bar:
		stamina_progress_bar.max_value = max_stamina
		stamina_progress_bar.value = current_stamina

	for node in get_tree().get_nodes_in_group("category_areas"):
		if node is CategoryArea:
			node.spawn_contents()
		
func setup_laser_visual() -> void:
	laser_mesh = MeshInstance3D.new()
	var cylinder_mesh := CylinderMesh.new()
	cylinder_mesh.top_radius = laser_thickness
	cylinder_mesh.bottom_radius = laser_thickness
	cylinder_mesh.height = 1.0
	cylinder_mesh.radial_segments = 8
	laser_mesh.mesh = cylinder_mesh
	laser_material = ORMMaterial3D.new()
	laser_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	laser_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	laser_material.albedo_color = LASER_COLOR_GRAB
	laser_material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	laser_mesh.set_material_override(laser_material)
	add_child(laser_mesh)
	laser_mesh.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()

	if Input.is_key_pressed(KEY_H):
		take_damage(25.0)

	if mouse_captured and event is InputEventMouseMotion:
		if is_rotating and grabbed_object:
			_apply_object_rotation(event.relative)
			get_viewport().set_input_as_handled()
		else:
			rotate_look(event.relative)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and grabbed_object:
			current_grab_distance = clamp(current_grab_distance + 0.2, min_grab_distance, max_grab_distance)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and grabbed_object:
			current_grab_distance = clamp(current_grab_distance - 0.2, min_grab_distance, max_grab_distance)

		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if hovered_object and not grabbed_object:
					try_grab_object(hovered_object)
			else:
				if grabbed_object:
					drop_object()

		if event.button_index == MOUSE_BUTTON_RIGHT and grabbed_object:
			if event.pressed:
				_enter_rotation_mode()
			else:
				_exit_rotation_mode()

	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

	if event.is_action_pressed("interact"):
		process_interaction()

func process_interaction():
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider and collider.has_method("interact"):
			collider.interact()
		elif ray == null:
			push_warning("RayCast3D tidak ditemukan di path: $Head/Camera3D/RayCast3D")

func _enter_rotation_mode() -> void:
	if not grabbed_object:
		return
	is_rotating = true
	_pending_angular_velocity = Vector3.ZERO
	grabbed_object.angular_velocity = Vector3.ZERO
	laser_material.albedo_color = LASER_COLOR_ROTATE

func _exit_rotation_mode() -> void:
	is_rotating = false
	_pending_angular_velocity = Vector3.ZERO
	if grabbed_object:
		grabbed_object.angular_velocity = Vector3.ZERO
		laser_material.albedo_color = LASER_COLOR_GRAB

func _apply_object_rotation(mouse_delta: Vector2) -> void:
	if not grabbed_object or not is_rotating:
		return

	var to_player := global_position - grabbed_object.global_position
	to_player.y = 0.0
	if to_player.length_squared() < 0.001:
		to_player = -global_transform.basis.z
		to_player.y = 0.0
	to_player = to_player.normalized()

	var rad_per_px := deg_to_rad(rotation_sensitivity) * Engine.get_physics_ticks_per_second()
	var pitch_axis := Vector3.UP.cross(to_player).normalized()

	_pending_angular_velocity = Vector3.ZERO
	_pending_angular_velocity += pitch_axis * (mouse_delta.y * rad_per_px)
	_pending_angular_velocity += Vector3.UP * (-mouse_delta.x * rad_per_px)

func _physics_process(delta: float) -> void:
	if not grabbed_object:
		process_raycast_detection()
	else:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			drop_object()
		else:
			process_grabbed_object_physics(delta)

	update_laser_transform()

	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return

	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	var is_moving := Input.get_vector(input_left, input_right, input_forward, input_back) != Vector2.ZERO
	var speed_modifier : float = 1.0

	if grabbed_object and grabbed_object.item_data:
		speed_modifier = calculate_movement_penalty(grabbed_object.item_data, player_strength_level, 1.0)

	var is_currently_sprinting := can_sprint and Input.is_action_pressed(input_sprint) and is_moving and current_stamina > 0.0

	if is_currently_sprinting:
		move_speed = (base_speed * 2) * speed_modifier
		current_stamina -= stamina_drain * delta
		current_stamina = max(current_stamina, 0.0)
	else:
		move_speed = base_speed * speed_modifier
		
		if not is_consuming_stamina():
			current_stamina += stamina_regen * delta
			current_stamina = min(current_stamina, max_stamina)

	if stamina_progress_bar:
		stamina_progress_bar.value = current_stamina

	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func take_damage(amount: float) -> void:
	current_hp -= amount
	current_hp = max(current_hp, 0.0)
	if hp_progress_bar:
		hp_progress_bar.value = current_hp

func is_consuming_stamina() -> bool:
	var is_moving := Input.get_vector(input_left, input_right, input_forward, input_back) != Vector2.ZERO
	var is_currently_sprinting := can_sprint and Input.is_action_pressed(input_sprint) and is_moving and current_stamina > 0.0
	
	if is_currently_sprinting:
		return true
		
	return false

func process_raycast_detection() -> void:
	var space_state := get_world_3d().direct_space_state
	var mouse_position := get_viewport().get_mouse_position()
	var ray_origin := camera_3d.project_ray_origin(mouse_position)
	var ray_end := ray_origin + camera_3d.project_ray_normal(mouse_position) * max_interaction_distance
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result := space_state.intersect_ray(query)
	if result and result.collider is InteractableObject:
		if hovered_object != result.collider:
			if hovered_object:
				hovered_object.set_label_visibility(false)
			hovered_object = result.collider
			hovered_object.set_label_visibility(true)
	else:
		if hovered_object:
			hovered_object.set_label_visibility(false)
			hovered_object = null

func drop_from_player(item):
	var forward = -transform.basis.z.normalized()
	var drop_pos = global_position + forward * 2.0
	item.global_position = drop_pos

func try_grab_object(object: InteractableObject) -> void:
	if object.interact(player_strength_level):
		grabbed_object = object
		
		# Jangan matikan visibilitas label saat di-grab, melainkan pertahankan posisinya tetap aktif
		if hovered_object == object:
			hovered_object = null
		
		grabbed_object.set_label_visibility(true) # Memastikan label tetap menyala saat di-grab
		
		current_grab_distance = camera_3d.global_position.distance_to(grabbed_object.global_position)
		current_grab_distance = clamp(current_grab_distance, min_grab_distance, max_grab_distance)
		grabbed_object.gravity_scale = 0.0
		if grabbed_object.item_data:
			grabbed_object.mass = grabbed_object.item_data.weight
		laser_material.albedo_color = LASER_COLOR_GRAB
		is_rotating = false

func drop_object() -> void:
	if grabbed_object:
		if is_rotating:
			_exit_rotation_mode()
		
		grabbed_object.set_label_visibility(false) # Sembunyikan label saat dilepas/dijatuhkan
		
		grabbed_object.gravity_scale = 1.0
		grabbed_object.linear_velocity *= throw_momentum_factor
		grabbed_object.angular_velocity *= throw_momentum_factor
		grabbed_object = null

func process_grabbed_object_physics(_delta: float) -> void:
	if not grabbed_object:
		return

	var target_pos := camera_3d.global_position + (-camera_3d.global_transform.basis.z * current_grab_distance)
	var direction := target_pos - grabbed_object.global_position

	grabbed_object.linear_velocity = direction * grab_power

	if is_rotating:
		grabbed_object.angular_velocity = _pending_angular_velocity
		_pending_angular_velocity = Vector3.ZERO

func update_laser_transform() -> void:
	if not grabbed_object:
		laser_mesh.visible = false
		return
	laser_mesh.visible = true
	var start_pos := camera_3d.global_position + (camera_3d.global_transform.basis.y * -0.2) + (camera_3d.global_transform.basis.x * 0.2)
	var end_pos := grabbed_object.global_position
	var laser_vector := end_pos - start_pos
	var distance := laser_vector.length()
	laser_mesh.global_position = start_pos + (laser_vector / 2.0)
	laser_mesh.scale.x = 1.0
	laser_mesh.scale.y = distance
	laser_mesh.scale.z = 1.0
	laser_mesh.look_at(end_pos, Vector3.UP)
	laser_mesh.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))

func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)

func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func can_lift_object(item: ShoppingItem, player_strength_level_param: int) -> bool:
	if player_strength_level_param >= item.strengthLevelToLift:
		return true
	return false

func calculate_movement_penalty(item: ShoppingItem, player_strength_level_param: int, current_base_speed: float) -> float:
	var strength_factor : float = float(player_strength_level_param + 1)
	var weight_penalty : float = item.weight / strength_factor
	var final_speed : float = current_base_speed - (weight_penalty * 0.1)
	return max(final_speed, current_base_speed * 0.2)
	
func hold_item(interactable: InteractableObject):
	if interactable.item_data and inventory_ui:
		inventory_ui.add_item_to_active_slot(interactable.item_data)
		# Menghapus objek dari dunia 3D karena sudah masuk inventori
		interactable.queue_free()

func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false
