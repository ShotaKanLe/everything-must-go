extends Node3D
class_name Van

@export var task_list : TaskList
@export var total_grid_capacity : int = 100

var current_grid_used : int = 0
var stored_items : Array[Node3D] = []

func try_store_item(item: Node3D, grid_needed: int) -> bool:
	if (current_grid_used + grid_needed) > total_grid_capacity:
		return false
	current_grid_used += grid_needed
	stored_items.append(item)
	
	# Beritahu TaskList untuk update progress jika ada
	if task_list:
		task_list.update_task_progress(item.item_data.objectName, 1)
	return true

func are_all_tasks_done() -> bool:
	return task_list.are_all_tasks_completed() if task_list else false
