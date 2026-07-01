#extends Area3D
#class_name NotaCountingArea
#
#@export var van : Van # Assign Van di inspector
#
#func _process_item(item: InteractableObject) -> void:
	#var item_data := item.item_data
	#var grid_needed := int(item_data.gridSize.x * item_data.gridSize.y * item_data.gridSize.z)
	#
	## Cukup panggil fungsi Van. try_store_item akan mengurus update task_list
	#if van.try_store_item(item, grid_needed):
		#item.freeze = true
		#item.visible = false
	#else:
		#print("Tidak muat di Van")
