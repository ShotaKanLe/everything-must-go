extends Node3D

var current_item_instance: Node3D = null

func _ready():
	Inventory.slot_selected.connect(_update_held_item)

func clear_item():
	if current_item_instance:
		current_item_instance.queue_free()
		current_item_instance = null
		
func show_item(item_data: ItemData):
	clear_item()
	if item_data and item_data.mesh_scene:
		current_item_instance = item_data.mesh_scene.instantiate()
		if item_data.item_name == "Shopping Cart":
			current_item_instance.position = Vector3(0, 0, -1)
		else:
			current_item_instance.position = Vector3.ZERO
			
		if item_data.item_name == "Baseball Bat":
			current_item_instance.rotation_degrees = Vector3(0, 0, -90)
		else:
			current_item_instance.rotation = Vector3.ZERO
		add_child(current_item_instance)

func _update_held_item(slot_index: int):
	var item = Inventory.hotbar[slot_index]
	show_item(item)
