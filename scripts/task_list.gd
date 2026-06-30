extends VBoxContainer
class_name TaskList

var arrTask = []

func _ready():
	for task in get_children():
		if task.name != "Label":
			arrTask.append(task)

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			for task in arrTask:
				task.visible = not task.visible
				
func are_all_tasks_completed() -> bool:
	for task in arrTask:
		# Misalkan setiap child node task memiliki variabel 'is_done' atau sejenisnya
		if not task.is_done: 
			return false # Jika ada 1 saja yang belum selesai, return false
	return true # Jika semua lolos pengecekan, berarti semua selesai
