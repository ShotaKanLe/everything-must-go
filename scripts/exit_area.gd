extends Area3D

@export var nota_counting_area: Area3D
@export var loading_screen_scene: PackedScene = preload("res://scenes/User Interface/loadingScreen.tscn")

var player_in_area: bool = false
var space_pressed_count: int = 0
var player_ref: CharacterBody3D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.name.to_lower().contains("player") or body is CharacterBody3D:
		player_in_area = true
		player_ref = body
		space_pressed_count = 0
		update_interaction_label()

func _on_body_exited(body: Node3D) -> void:
	if body == player_ref:
		player_in_area = false
		space_pressed_count = 0
		if player_ref and player_ref.label_to_interact:
			player_ref.label_to_interact.visible = false
		player_ref = null

func _input(event: InputEvent) -> void:
	if player_in_area and event.is_action_pressed("ui_accept"):
		space_pressed_count += 1
		
		if space_pressed_count >= 3:
			process_exit()
		else:
			update_interaction_label()

func update_interaction_label() -> void:
	if not player_ref or not player_ref.label_to_interact:
		return
		
	var remaining = 3 - space_pressed_count
	player_ref.label_to_interact.visible = true
	
	if space_pressed_count == 0:
		player_ref.label_to_interact.text = "Space 3 times for exit"
	else:
		player_ref.label_to_interact.text = "Space %d time(s) more for exit" % remaining

func process_exit() -> void:
	if LevelData.location == "mall":
		if check_nota_fulfilled():
			LevelData.location = "shop"
			change_scene_with_loading("res://scenes/electronicStore.tscn")
		else:
			space_pressed_count = 0
			if player_ref and player_ref.label_to_interact:
				player_ref.label_to_interact.text = "Fulfill your quota first before exited"
				
	elif LevelData.location == "shop":
		LevelData.start_day()
		change_scene_with_loading("res://scenes/levelScene.tscn")

func check_nota_fulfilled() -> bool:
	if not nota_counting_area:
		return false
		
	var current_items = nota_counting_area.items_in_area
	var required_items = LevelData.nota_list
	
	for nota in required_items:
		var item_name = nota.get("objectName", "")
		var required_amount = nota.get("amount", 0)
		
		if not current_items.has(item_name) or current_items[item_name] < required_amount:
			return false
			
	return true

func change_scene_with_loading(target_path: String) -> void:
	var loading_instance = loading_screen_scene.instantiate()
	loading_instance.next_scene_path = target_path
	
	var root = get_tree().root
	var current_scene = get_tree().current_scene
	
	root.add_child(loading_instance)
	get_tree().current_scene = loading_instance
	current_scene.queue_free()
