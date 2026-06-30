extends Area3D
class_name CategoryArea

## Nama kategori area ini (contoh: "Produce", "Meat", "Dairy")
## Security menggunakan ini untuk cek apakah item wajar dibawa player
@export var category_name : String = "Produce"

## Scene item yang bisa spawn di area ini
@export var possible_item_scenes : Array[PackedScene] = []

## Scene shelf yang digunakan jika use_shelves = true
@export var shelf_scene : PackedScene

## Jika true, spawn 1-4 shelf. Jika false, spawn item langsung di spawn points
@export var use_shelves : bool = true

## Jumlah shelf yang di-spawn (1-4, hanya berlaku jika use_shelves = true)
@export_range(1, 4) var shelf_count : int = 4

## Node parent yang berisi Marker3D sebagai titik spawn
@export var spawn_points_parent : Node3D

var spawned_shelves : Array[Node3D] = []
var spawned_items : Array[Node3D] = []

## Item yang sedang berada di dalam area ini (untuk security check)
var items_currently_inside : Array[Node3D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# ─── SPAWN ─────────────────────────────────────────────────────────────────────

## Dipanggil oleh DayManager saat day dimulai
func spawn_contents() -> void:
	clear_contents()

	if possible_item_scenes.is_empty():
		push_warning("CategoryArea [%s]: possible_item_scenes kosong!" % category_name)
		return

	if use_shelves and shelf_scene:
		_spawn_shelves()
	else:
		_spawn_items_directly()

func _spawn_shelves() -> void:
	var points := _get_spawn_points()
	if points.is_empty():
		push_warning("CategoryArea [%s]: Tidak ada spawn points!" % category_name)
		return

	var count : int = clamp(shelf_count, 1, min(4, points.size()))
	points.shuffle()

	for i in range(count):
		var shelf : Shelf = shelf_scene.instantiate()
		add_child(shelf)
		shelf.global_position = points[i].global_position
		shelf.category_name = category_name
		shelf.possible_item_scenes = possible_item_scenes
		shelf.spawn_items()
		spawned_shelves.append(shelf)

func _spawn_items_directly() -> void:
	var points := _get_spawn_points()
	if points.is_empty():
		push_warning("CategoryArea [%s]: Tidak ada spawn points!" % category_name)
		return

	points.shuffle()
	var count : int = min(points.size(), possible_item_scenes.size())

	for i in range(count):
		var scene := possible_item_scenes[randi() % possible_item_scenes.size()]
		var item : Node3D = scene.instantiate()
		add_child(item)
		item.global_position = points[i].global_position
		spawned_items.append(item)

func _get_spawn_points() -> Array[Marker3D]:
	var result : Array[Marker3D] = []
	if not spawn_points_parent:
		return result
	for child in spawn_points_parent.get_children():
		if child is Marker3D:
			result.append(child)
	return result

## Reset semua isi area (saat day reset atau fail)
func clear_contents() -> void:
	for shelf in spawned_shelves:
		if is_instance_valid(shelf):
			shelf.queue_free()
	spawned_shelves.clear()

	for item in spawned_items:
		if is_instance_valid(item):
			item.queue_free()
	spawned_items.clear()

	items_currently_inside.clear()

# ─── SECURITY CHECK ────────────────────────────────────────────────────────────

## Dipanggil oleh security system: apakah item ini "wajar" berada di area ini?
func is_item_legal_here(item: Node3D) -> bool:
	if not item is InteractableObject:
		return false
	var interactable := item as InteractableObject
	if not interactable.item_data:
		return false
	# Item legal jika kategorinya sama dengan area ini
	return interactable.item_data.objectCategory == category_name

## Cek apakah item saat ini sedang berada di dalam area
func is_item_inside(item: Node3D) -> bool:
	return item in items_currently_inside

# ─── AREA DETECTION ────────────────────────────────────────────────────────────

func _on_body_entered(body: Node3D) -> void:
	if body is InteractableObject:
		if not body in items_currently_inside:
			items_currently_inside.append(body)

func _on_body_exited(body: Node3D) -> void:
	if body in items_currently_inside:
		items_currently_inside.erase(body)
