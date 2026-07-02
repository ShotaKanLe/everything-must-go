extends CharacterBody3D

# ===================== STATE MACHINE =====================
enum State { PATROL, CHASE, ATTACK }
var state: State = State.PATROL

# ===================== MOVEMENT =====================
@export var patrol_speed: float = 4
@export var chase_speed: float = 4.5

# ===================== DETEKSI (via Area3D) =====================
## Radius diatur langsung lewat gizmo/Inspector di DetectionArea & LoseSightArea
## (CollisionShape3D > Shape > Radius) — tidak diduplikasi di sini
@export var use_line_of_sight: bool = true   # raycast tambahan, biar tidak "melihat" tembus tembok

# ===================== SERANGAN =====================
@export var attack_range: float = 1.8
@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 1.2

# ===================== PATROL =====================
## Isi di Inspector dengan NodePath ke Marker3D titik-titik patroli
@export var patrol_points: Array[NodePath] = []
@export var patrol_wait_time: float = 2.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@onready var detection_area: Area3D = $DetectionArea
@onready var lose_sight_area: Area3D = $LoseSightArea
@onready var stop_area: Area3D = $StopArea

var player: Node3D = null
var patrol_targets: Array[Vector3] = []
var current_patrol_index: int = 0
var patrol_wait_timer: float = 0.0
var attack_timer: float = 0.0

# true selama player secara fisik berada di dalam DetectionArea
var player_in_detection_area: bool = false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	add_to_group("guards")
	
	for path in patrol_points:
		var node := get_node_or_null(path)
		if node:
			patrol_targets.append(node.global_position)

	if patrol_targets.size() > 0:
		navigation_agent.set_target_position(patrol_targets[current_patrol_index])

	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	lose_sight_area.body_exited.connect(_on_lose_sight_area_body_exited)
	stop_area.area_entered.connect(_on_stop_area_area_entered)

func _physics_process(delta: float) -> void:
	match state:
		State.PATROL:
			_state_patrol(delta)
			_move_towards_navigation(patrol_speed)
		State.CHASE:
			_state_chase(delta)
			_move_towards_navigation(chase_speed)
		State.ATTACK:
			_state_attack(delta)
			velocity = Vector3.ZERO
			move_and_slide()

# ===================== SIGNAL AREA3D =====================	
func _on_detection_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_detection_area = true

func _on_detection_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_detection_area = false

func _on_lose_sight_area_body_exited(body: Node3D) -> void:
	# Player keluar dari radius lose_sight -> guard pasti kehilangan jejak, langsung balik patroli
	if body == player and state != State.PATROL:
		_enter_patrol()

func _on_stop_area_area_entered(area: Area3D) -> void:
	if area.name == "GatewayArea" and state != State.PATROL:
		_enter_patrol()

# ===================== PATROL =====================
func _state_patrol(delta: float) -> void:
	_check_player_detection()

	if patrol_targets.is_empty():
		return

	if navigation_agent.is_navigation_finished():
		patrol_wait_timer += delta
		if patrol_wait_timer >= patrol_wait_time:
			patrol_wait_timer = 0.0
			_go_to_next_patrol_point()

func _go_to_next_patrol_point() -> void:
	if patrol_targets.is_empty():
		return
	current_patrol_index = (current_patrol_index + 1) % patrol_targets.size()
	navigation_agent.set_target_position(patrol_targets[current_patrol_index])

# ===================== DETEKSI =====================
func _check_player_detection() -> void:
	if player == null or not player_in_detection_area:
		return
		
	var grabbed_object: InteractableObject = _get_player_grabbed_object()
	
	if player.get("grabbed_object") == null:
		return
	
	if not grabbed_object.item_data.isIllegalToSteal:
		return
		
	# Player sudah masuk radius (dijamin oleh Area3D) — tinggal cek line-of-sight
	if _has_line_of_sight():
		_enter_chase()

func _get_player_grabbed_object() -> InteractableObject:
	if player == null:
		return null
	return player.get("grabbed_object") as InteractableObject

func _has_line_of_sight() -> bool:
	if not use_line_of_sight or player == null:
		return true

	var space_state := get_world_3d().direct_space_state
	var from := global_position + Vector3.UP * 1.0
	var to := player.global_position + Vector3.UP * 1.0

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)

	if result.is_empty():
		return true
	return result.collider == player

# ===================== CHASE =====================
func _enter_chase() -> void:
	if state != State.CHASE:
		state = State.CHASE

func _state_chase(delta: float) -> void:
	if player == null:
		_enter_patrol()
		return

	var dist := global_position.distance_to(player.global_position)
	navigation_agent.set_target_position(player.global_position)

	if dist <= attack_range:
		_enter_attack()
	# Kehilangan jejak sudah ditangani oleh signal _on_lose_sight_area_body_exited

func _enter_patrol() -> void:
	state = State.PATROL
	if patrol_targets.size() > 0:
		navigation_agent.set_target_position(patrol_targets[current_patrol_index])

# ===================== ATTACK =====================
func _enter_attack() -> void:
	state = State.ATTACK
	attack_timer = 0.0

func _state_attack(delta: float) -> void:
	if player == null:
		_enter_patrol()
		return

	var dist := global_position.distance_to(player.global_position)

	if dist > attack_range * 1.2:
		state = State.CHASE
		return

	var look_target := Vector3(player.global_position.x, global_position.y, player.global_position.z)
	if look_target.distance_to(global_position) > 0.01:
		look_at(look_target, Vector3.UP)

	attack_timer -= delta
	if attack_timer <= 0.0:
		_perform_attack()
		attack_timer = attack_cooldown

func _perform_attack() -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(attack_damage)

# ===================== GERAK =====================
func _move_towards_navigation(speed: float) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var next_position: Vector3 = navigation_agent.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(next_position)
	direction.y = 0.0

	velocity = direction * speed

	if direction.length() > 0.1:
		look_at(global_position + direction, Vector3.UP)

	move_and_slide()
