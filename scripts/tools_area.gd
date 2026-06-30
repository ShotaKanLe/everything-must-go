## tools_area.gd — attach ke Node3D "ToolsArea"
extends Node3D

## Isi dengan ItemData .tres di Inspector
@export var item_data_list: Array[ItemData] = []

## Scene box visual (box_spot.tscn)
@export var box_spot_scene: PackedScene

## Jarak antar box (sumbu X)
@export var box_spacing: float = 2.5

## Tinggi item di atas permukaan box
@export var spawn_height: float = 1.2

## Detik sebelum item respawn setelah di-pick
@export var spawn_delay: float = 5.0

var _slots: Array[Dictionary] = []

func _ready() -> void:
	if item_data_list.is_empty() or box_spot_scene == null:
		push_warning("ToolsArea: item_data_list atau box_spot_scene kosong!")
		return
	_generate_all_slots()

func _generate_all_slots() -> void:
	var count = item_data_list.size()
	var start_x = -(count - 1) * box_spacing / 2.0

	for i in count:
		var box = box_spot_scene.instantiate()
		add_child(box)
		box.position = Vector3(start_x + i * box_spacing, 0, 0)

		var slot = {"box": box, "item": null,
					"pending": false, "index": i}
		_slots.append(slot)
		_spawn_item_for_slot(slot, item_data_list[i])
		
func _spawn_item_for_slot(slot: Dictionary, data: ItemData) -> void:
	var inst = data.interactable_scene.instantiate()
	inst.item_data = data
	get_parent().add_child.call_deferred(inst)

	var pos = slot["box"].global_position
	pos.y += spawn_height
	inst.global_position = pos

	#inst.tree_exiting.connect(_on_item_removed.bind(slot))
	#slot["item"] = inst
	#slot["pending"] = false
#
##func _on_item_removed(slot: Dictionary) -> void:
	##if slot["pending"]: return
	##slot["item"] = null
	##slot["pending"] = true
	##await get_tree().create_timer(spawn_delay).timeout
	##slot["pending"] = false
	##_spawn_item_for_slot(slot, item_data_list[slot["index"]])
