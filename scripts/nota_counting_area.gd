extends Area3D

var items_in_area: Dictionary = {}

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body is InteractableObject and body.item_data is ShoppingItem:
		var item_name = body.item_data.objectName
		
		if items_in_area.has(item_name):
			items_in_area[item_name] += 1
		else:
			items_in_area[item_name] = 1
			
		_notify_main_scene()

func _on_body_exited(body: Node3D) -> void:
	if body is InteractableObject and body.item_data is ShoppingItem:
		var item_name = body.item_data.objectName
		
		if items_in_area.has(item_name):
			items_in_area[item_name] -= 1
			if items_in_area[item_name] <= 0:
				items_in_area.erase(item_name)
				
		_notify_main_scene()

func _notify_main_scene() -> void:
	var main_node = get_tree().current_scene
	if main_node.has_method("update_nota_status"):
		main_node.update_nota_status(items_in_area)
