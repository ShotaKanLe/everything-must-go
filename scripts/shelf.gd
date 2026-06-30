extends Node3D
class_name Shelf

## Kategori shelf ini — harus sama dengan CategoryArea parent-nya
@export var category_name : String = "Produce"

## Scene item yang bisa muncul di shelf ini
@export var possible_item_scenes : Array[PackedScene] = []

## Maksimal item di shelf (dibatasi juga oleh jumlah slot)
@export_range(1, 6) var max_items : int = 4

## Node parent yang berisi Marker3D sebagai slot posisi item
@export var item_slots_parent : Node3D

var items_on_shelf : Array[Node3D] = []

# ─── SPAWN ─────────────────────────────────────────────────────────────────────

## Dipanggil oleh CategoryArea setelah shelf di-instantiate
func spawn_items() -> void:
	clear_items()

	if possible_item_scenes.is_empty():
		return

	var slots := _get_item_slots()
	if slots.is_empty():
		push_warning("Shelf [%s]: Tidak ada item slots!" % category_name)
		return

	slots.shuffle()
	var count : int = min(max_items, slots.size())
	
	var guaranteed := possible_item_scenes.duplicate()
	guaranteed.shuffle()
	
	var final_scenes : Array[PackedScene] = []

	for scene in guaranteed:
		final_scenes.append(scene)
	
	while final_scenes.size() < count:
		var random_scene := possible_item_scenes[randi() % possible_item_scenes.size()]
		final_scenes.append(random_scene)
	
	for i in range(count):
		var item : Node3D = final_scenes[i].instantiate()
		add_child(item)
		item.global_position = slots[i].global_position
		item.scale = Vector3(0.1, 0.1, 0.1)
		items_on_shelf.append(item)

func clear_items() -> void:
	for item in items_on_shelf:
		if is_instance_valid(item):
			item.queue_free()
	items_on_shelf.clear()

func _get_item_slots() -> Array[Marker3D]:
	var result : Array[Marker3D] = []
	if not item_slots_parent:
		return result
	for child in item_slots_parent.get_children():
		if child is Marker3D:
			result.append(child)
	return result

func get_item_count() -> int:
	return items_on_shelf.size()
