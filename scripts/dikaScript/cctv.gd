extends Node3D

@onready var rotation_steps_deg: Array[float] = [90.0, -90.0, -90.0, 90.0]
@onready var rotation_duration: float = 3
var security_guard: CharacterBody3D

var current_step_index: int = 0
var _tween: Tween
@onready var cctv_area: Area3D = $CctvArea

func _ready() -> void:
	security_guard = get_tree().get_first_node_in_group("guards")
	_do_next_rotation()

func _do_next_rotation() -> void:
	var angle_deg: float = rotation_steps_deg[current_step_index]
	var angle_rad: float = deg_to_rad(angle_deg)
	var target_y: float = cctv_area.rotation.y + angle_rad

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(cctv_area, "rotation:y", target_y, rotation_duration)
	_tween.tween_callback(_on_rotation_finished)

func _on_rotation_finished() -> void:
	current_step_index = (current_step_index + 1) % rotation_steps_deg.size()
	_do_next_rotation()

func _on_cctv_area_body_entered(body):
	if body.name == "MainCharacter":
		if body.get("grabbed_object") != null:
			var grabbed_object = body.get("grabbed_object") as InteractableObject
			if grabbed_object.item_data.isIllegalToSteal:
				security_guard.state = security_guard.State.CHASE
		
		
