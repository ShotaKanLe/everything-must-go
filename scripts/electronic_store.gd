extends Node3D

var baseballBatScene = preload("res://scenes/tools/baseball_bat.tscn")
var feather = preload("res://scenes/tools/feather.tscn")
var jetpack = preload("res://scenes/tools/jetpack.tscn")
var portableCardBox = preload("res://scenes/tools/portable_cardbox.tscn")
var stealthCardBox = preload("res://scenes/tools/stealth_cardbox.tscn")

var staminaUpgradeScene = preload("res://scenes/objects/Upgrades/stamina_upgrade.tscn")
var healthUpgradeScene = preload("res://scenes/objects/Upgrades/health_upgrade.tscn")
var strenghtUpgradeScene = preload("res://scenes/objects/Upgrades/strenght_upgrade.tscn")
var doubleJumpUpgradeScene = preload("res://scenes/objects/Upgrades/double_jump_upgrade.tscn")
var rangeUpgradeScene = preload("res://scenes/objects/Upgrades/range_upgrade.tscn")
var speedUpgradeScene = preload("res://scenes/objects/Upgrades/speed_upgrade.tscn")
var staminaRegenUpgradeScene = preload("res://scenes/objects/Upgrades/stamina_regen_upgrade.tscn")

@onready var tools_spawn_point: Node3D = $ToolsSpawnPoint
@onready var upgrades_spawn_point: Node3D = $UpgradeSpawnPoint

@export var debug_list_menu: Control
@export var hp_progress_bar: Range
@export var stamina_progress_bar: Range

@onready var labelToInteract: Label = $CanvasLayer/LabelToInteract
@onready var money_label: Label = $CanvasLayer/ContainerMoney/Label
@onready var day_label: Label = $CanvasLayer/DayLabel
@onready var pause_menu: Control = $CanvasLayer/PauseMenu

@onready var sfx_player = $SfxStreamPlayer
var sfx_click = preload("res://assets/sfx/button_click.wav")

var player: CharacterBody3D

func play_click_sfx() -> void:
	if sfx_player:
		sfx_player.stream = sfx_click
		sfx_player.play()

func _ready() -> void:
	if LevelData.current_day == 0:
		LevelData.start_day()
		
	spawn_tools()
	spawn_upgrades()
	setup_character_ui_connections()
	setupMoneyUI()
	setup_day_ui()
	
	if pause_menu:
		pause_menu.visible = false

func _process(_delta: float) -> void:
	setupMoneyUI()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			play_click_sfx()
			if pause_menu and pause_menu.visible:
				_on_resume_button_pressed()
			else:
				_on_menu_button_pressed()

func setup_day_ui() -> void:
	if day_label:
		day_label.text = "- Day %d -" % LevelData.current_day

func setup_character_ui_connections() -> void:
	var found_player = find_child("Player", true, false)
	if found_player and found_player is CharacterBody3D:
		player = found_player
	else:
		for child in get_children():
			if child is CharacterBody3D or child.name.to_lower().contains("player"):
				player = child
				break
				
	if player:
		if hp_progress_bar:
			player.hp_progress_bar = hp_progress_bar
			hp_progress_bar.max_value = player.max_hp
			hp_progress_bar.value = player.current_hp
			
		if stamina_progress_bar:
			player.stamina_progress_bar = stamina_progress_bar
			stamina_progress_bar.max_value = player.max_stamina
			stamina_progress_bar.value = player.current_stamina
			
		if labelToInteract:
			player.label_to_interact = labelToInteract
			labelToInteract.visible = false
	else:
		push_warning("Player tidak ditemukan di root ElectronicStore. Pastikan bar HP/Stamina terhubung manual.")

func spawn_tools() -> void:
	if not tools_spawn_point:
		return
		
	var spawn_nodes := tools_spawn_point.get_children()
	var total_spawn_points := spawn_nodes.size()
	
	if total_spawn_points == 0:
		return
		
	var current_day: int = LevelData.current_day
	var price_multiplier := 1.0 + (current_day - 1) * 0.4
	
	var tool_data_script = ToolItemArrayList.new()
	var all_tools: Array = tool_data_script.toolItemArrayList
	var available_tools := []
	
	for tool in all_tools:
		if current_day >= tool.get("availableFromDay", 1):
			available_tools.append(tool)
			
	if available_tools.is_empty():
		return
		
	var spawn_count := randi_range(3, min(9, total_spawn_points))
	spawn_nodes.shuffle()
	
	for i in range(spawn_count):
		var spawn_node = spawn_nodes[i]
		var random_tool: Dictionary = available_tools.pick_random()
		var tool_scene: PackedScene = get_scene_by_name(random_tool.objectName)
		
		if not tool_scene:
			continue
			
		var tool_instance = tool_scene.instantiate()
		
		if "item_data" in tool_instance and tool_instance.item_data:
			var min_price: float = random_tool.get("minimumPrice", 0) * price_multiplier
			var max_price: float = random_tool.get("maximumPrice", 0) * price_multiplier
			tool_instance.item_data.minimumPrice = min_price
			tool_instance.item_data.maximumPrice = max_price
			tool_instance.current_price = tool_instance.item_data.get_random_price()
			
		if tool_instance.has_method("get_random_price"):
			tool_instance.current_price = tool_instance.item_data.get_random_price()
		elif "current_price" in tool_instance and "item_data" in tool_instance and tool_instance.item_data:
			tool_instance.current_price = randf_range(tool_instance.item_data.minimumPrice, tool_instance.item_data.maximumPrice)
			
		spawn_node.add_child(tool_instance)
		if tool_instance is Node3D:
			tool_instance.global_position = spawn_node.global_position
			tool_instance.global_rotation = spawn_node.global_rotation

func get_scene_by_name(object_name: String) -> PackedScene:
	match object_name:
		"Baseball Bat":
			return baseballBatScene
		"Feather":
			return feather
		"Jetpack":
			return jetpack
		"Portable Cardbox":
			return portableCardBox
		"Stealth Cardbox":
			return stealthCardBox
		"Health Upgrade":
			return healthUpgradeScene
		"Stamina Upgrade":
			return staminaUpgradeScene
		"Strength Upgrade":
			return strenghtUpgradeScene
		"Double Jump Upgrade":
			return doubleJumpUpgradeScene
		"Range Upgrade":
			return rangeUpgradeScene
		"Speed Upgrade":
			return speedUpgradeScene
		"Stamina Regen Upgrade":
			return staminaRegenUpgradeScene
		_:
			return null

func setupMoneyUI():
	if money_label:
		money_label.text = str(LevelData.money)

func spawn_upgrades() -> void:
	if not upgrades_spawn_point:
		return
		
	var spawn_nodes := upgrades_spawn_point.get_children()
	var total_spawn_points := spawn_nodes.size()
	
	if total_spawn_points == 0:
		return
		
	var current_day: int = LevelData.current_day
	var price_multiplier := 1.0 + (current_day - 1) * 0.4
	
	var upgrade_data_script = UpgradeItemArrayList.new()
	var all_upgrades: Array = upgrade_data_script.upgradeItemArrayList
	
	var spawned_counts := {}
	
	for spawn_node in spawn_nodes:
		var available_upgrades := []
		
		for upgrade in all_upgrades:
			var type = upgrade.upgradeType
			var current_lvl = 0
			var max_lvl = -1
			
			match type:
				UpgradeItemArrayList.HEALTH: 
					max_lvl = -1
				UpgradeItemArrayList.STAMINA: 
					max_lvl = -1
				UpgradeItemArrayList.STRENGTH:
					current_lvl = LevelData.strength_level
					max_lvl = 12
				UpgradeItemArrayList.DOUBLE_JUMP:
					current_lvl = 1 if LevelData.double_jump_upgrade else 0
					max_lvl = 1
				UpgradeItemArrayList.RANGE:
					current_lvl = LevelData.range_level
					max_lvl = 8
				UpgradeItemArrayList.SPEED:
					current_lvl = LevelData.speed_level
					max_lvl = 10
				UpgradeItemArrayList.STAMINA_REGEN:
					current_lvl = LevelData.stamina_regen_level
					max_lvl = 10
			
			var spawned_already = spawned_counts.get(type, 0)
			
			if max_lvl == -1 or (current_lvl + spawned_already) < max_lvl:
				available_upgrades.append(upgrade)
		
		if available_upgrades.is_empty():
			break
			
		var random_upgrade: Dictionary = available_upgrades.pick_random()
		var upgrade_scene: PackedScene = get_scene_by_name(random_upgrade.objectName)
		
		if not upgrade_scene:
			continue
			
		var upgrade_instance = upgrade_scene.instantiate()
		
		if "item_data" in upgrade_instance and upgrade_instance.item_data:
			upgrade_instance.item_data = upgrade_instance.item_data.duplicate(true) 
			upgrade_instance.item_data.objectName = random_upgrade.objectName
			upgrade_instance.item_data.upgrade_type = random_upgrade.upgradeType
			
			var min_price: float = random_upgrade.get("minimumPrice", 0) * price_multiplier
			var max_price: float = random_upgrade.get("maximumPrice", 0) * price_multiplier
			upgrade_instance.item_data.minimumPrice = min_price
			upgrade_instance.item_data.maximumPrice = max_price
			
		if upgrade_instance.has_method("get_random_price"):
			upgrade_instance.current_price = upgrade_instance.item_data.get_random_price()
		elif "current_price" in upgrade_instance and "item_data" in upgrade_instance and upgrade_instance.item_data:
			upgrade_instance.current_price = randf_range(upgrade_instance.item_data.minimumPrice, upgrade_instance.item_data.maximumPrice)
			
		spawn_node.add_child(upgrade_instance)
		if upgrade_instance is Node3D:
			upgrade_instance.global_position = spawn_node.global_position
			upgrade_instance.global_rotation = spawn_node.global_rotation
			
		var u_type = random_upgrade.upgradeType
		if spawned_counts.has(u_type):
			spawned_counts[u_type] += 1
		else:
			spawned_counts[u_type] = 1

func _on_menu_button_pressed() -> void:
	play_click_sfx()
	if pause_menu:
		pause_menu.visible = true
	if player:
		player.is_paused = true
		player.release_mouse()

func _on_resume_button_pressed() -> void:
	play_click_sfx()
	if pause_menu:
		pause_menu.visible = false
	if player:
		player.is_paused = false
		player.capture_mouse()

func _on_exit_button_pressed() -> void:
	play_click_sfx()
	get_tree().change_scene_to_file("res://scenes/User Interface/main_menu.tscn")

func _on_open_debug_menu_pressed() -> void:
	play_click_sfx()
	if debug_list_menu:
		debug_list_menu.visible = not debug_list_menu.visible

func _on_debug_next_day_pressed() -> void:
	play_click_sfx()
	LevelData.start_day()
	get_tree().reload_current_scene()

func _on_debug_reset_day_pressed() -> void:
	play_click_sfx()
	LevelData.reset_to_default()
	get_tree().reload_current_scene()
