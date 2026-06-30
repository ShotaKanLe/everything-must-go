extends StaticBody3D
class_name EndDayButton3D

@export var van : Van
@export var task_list : TaskList

var player_in_range : bool = false
var is_active : bool = false

signal end_day_pressed

@onready var csg_box : CSGBox3D = $CSGBox3D
@onready var interaction_area : Area3D = $InteractionArea
@onready var label_3d : Label3D = $Label3D

# Material dibuat di code agar bisa ganti warna secara dinamis
var button_material : StandardMaterial3D

func _ready() -> void:
	# Setup material
	button_material = StandardMaterial3D.new()
	csg_box.material = button_material

	# Connect signals
	if task_list:
		task_list.all_tasks_completed.connect(_on_all_tasks_completed)
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

	_refresh_state()

func _input(event: InputEvent) -> void:
	if not player_in_range:
		return
	if not is_active:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			end_day_pressed.emit()
			print("[VAN] End Day dipicu! Lanjut ke break scene.")

func _refresh_state() -> void:
	if task_list:
		is_active = task_list.are_all_tasks_completed()
	else:
		is_active = false
	_update_visual()

func _update_visual() -> void:
	if is_active:
		button_material.albedo_color = Color(0.0, 0.8, 0.2)  # hijau
		label_3d.text = "[E] End Day"
	else:
		button_material.albedo_color = Color(0.8, 0.1, 0.1)  # merah
		label_3d.text = "Nota Belum\nSelesai"

func _on_all_tasks_completed() -> void:
	_refresh_state()

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_in_range = true
		label_3d.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_in_range = false
		label_3d.visible = false
