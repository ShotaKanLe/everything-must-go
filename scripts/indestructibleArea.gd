extends Area3D

var original_thresholds : Dictionary = {}

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is InteractableObject:
		if body.item_data and body.item_data.isFragile:
			original_thresholds[body.get_instance_id()] = body.break_velocity_threshold
			body.break_velocity_threshold = INF

func _on_body_exited(body: Node) -> void:
	if body is InteractableObject:
		var body_id := body.get_instance_id()
		if original_thresholds.has(body_id):
			body.break_velocity_threshold = original_thresholds[body_id]
			original_thresholds.erase(body_id)
