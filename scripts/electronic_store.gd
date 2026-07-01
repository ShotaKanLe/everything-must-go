extends Node3D

var baseballBatScene = preload("res://scenes/tools/baseball_bat.tscn")
var feather = preload("res://scenes/tools/feather.tscn")
var jetpack = preload("res://scenes/tools/jetpack.tscn")
var portableCardBox = preload("res://scenes/tools/portable_cardbox.tscn")
var stealthCardBox = preload("res://scenes/tools/stealth_cardbox.tscn")

@onready var tools_spawn_point: Node3D = $ToolsSpawnPoint

# Node UI yang disesuaikan dari main_scene / mainCharacter
@export var debug_list_menu: Control
@export var hp_progress_bar: Range
@export var stamina_progress_bar: Range

# Referensi ke player untuk menghubungkan UI Bar jika player diinstansiasi secara dinamis
# (Jika player sudah ada di dalam editor, Anda bisa menggunakan @onready var player = $Player)
var player: CharacterBody3D

func _ready() -> void:
	# Jika scene ini dijalankan langsung untuk testing dan current_day masih 0,
	# jalankan start_day() agar current_day menjadi 1
	if LevelData.current_day == 0:
		LevelData.start_day()
		
	print("--- Memulai Proses Spawn Tools ---")
	spawn_tools()
	setup_character_ui_connections()

func setup_character_ui_connections() -> void:
	# Mencari node player di dalam scene
	for child in get_children():
		if child.name.to_lower().contains("player") or child is CharacterBody3D:
			player = child
			break
			
	if player:
		# Hubungkan progress bar ke properti milik mainCharacter
		if hp_progress_bar:
			player.hp_progress_bar = hp_progress_bar
			hp_progress_bar.max_value = player.max_hp
			hp_progress_bar.value = player.current_hp
			
		if stamina_progress_bar:
			player.stamina_progress_bar = stamina_progress_bar
			stamina_progress_bar.max_value = player.max_stamina
			stamina_progress_bar.value = player.current_stamina
	else:
		push_warning("Player tidak ditemukan di root ElectronicStore. Pastikan bar HP/Stamina terhubung manual.")

func spawn_tools() -> void:
	if not tools_spawn_point:
		print("[DEBUG ERROR] Node ToolsSpawnPoint tidak ditemukan!")
		return
		
	var spawn_nodes := tools_spawn_point.get_children()
	var total_spawn_points := spawn_nodes.size()
	print("[DEBUG] Total titik spawn yang ditemukan di dalam node: ", total_spawn_points)
	
	if total_spawn_points == 0:
		print("[DEBUG WARNING] Proses berhenti karena tidak ada child node di ToolsSpawnPoint.")
		return
		
	var current_day: int = LevelData.current_day
	var price_multiplier := 1.0 + (current_day - 1) * 0.4
	print("[DEBUG] Current Day: ", current_day, " | Price Multiplier: ", price_multiplier)
	
	var tool_data_script = ToolItemArrayList.new()
	var all_tools: Array = tool_data_script.toolItemArrayList
	var available_tools := []
	
	for tool in all_tools:
		if current_day >= tool.get("availableFromDay", 1):
			available_tools.append(tool)
			
	print("[DEBUG] Jumlah tool yang tersedia untuk hari ini: ", available_tools.size())
	
	if available_tools.is_empty():
		print("[DEBUG WARNING] Proses berhenti karena tidak ada tool yang tersedia untuk hari ini.")
		return
		
	var spawn_count := randi_range(3, min(9, total_spawn_points))
	print("[DEBUG] Target jumlah item yang akan di-spawn acak: ", spawn_count)
	
	spawn_nodes.shuffle()
	
	var success_count := 0
	for i in range(spawn_count):
		var spawn_node = spawn_nodes[i]
		var random_tool: Dictionary = available_tools.pick_random()
		
		var tool_scene: PackedScene = get_scene_by_name(random_tool.objectName)
		if not tool_scene:
			print("[DEBUG WARNING] Scene untuk ", random_tool.objectName, " tidak ditemukan/belum di-preload. Melewati...")
			continue
			
		var tool_instance = tool_scene.instantiate()
		
		if "item_data" in tool_instance and tool_instance.item_data:
			var min_price: float = random_tool.get("minimumPrice", 0) * price_multiplier
			var max_price: float = random_tool.get("maximumPrice", 0) * price_multiplier
			tool_instance.item_data.minimumPrice = min_price
			tool_instance.item_data.maximumPrice = max_price
			
			# PENTING: Panggil get_random_price() SETELAH minimumPrice & maximumPrice di-update
			tool_instance.current_price = tool_instance.item_data.get_random_price()
			
		if tool_instance.has_method("get_random_price"):
			tool_instance.current_price = tool_instance.item_data.get_random_price()
		elif "current_price" in tool_instance and "item_data" in tool_instance and tool_instance.item_data:
			tool_instance.current_price = randf_range(tool_instance.item_data.minimumPrice, tool_instance.item_data.maximumPrice)
			
		spawn_node.add_child(tool_instance)
		if tool_instance is Node3D:
			tool_instance.global_position = spawn_node.global_position
			tool_instance.global_rotation = spawn_node.global_rotation
			
		print("[DEBUG SUCCESS] Berhasil memunculkan ", random_tool.objectName, " di node: ", spawn_node.name)
		success_count += 1

	print("[DEBUG] Selesai! Total tool yang berhasil muncul di map: ", success_count)

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
		_:
			return null

# ==================== DEBUG MENU FUNCTIONS ====================

func _on_open_debug_menu_pressed() -> void:
	if debug_list_menu:
		debug_list_menu.visible = not debug_list_menu.visible

func _on_debug_next_day_pressed() -> void:
	# Fungsi menaikkan hari dari sistem menu debug utama Anda
	LevelData.start_day()
	get_tree().reload_current_scene()

func _on_debug_reset_day_pressed() -> void:
	LevelData.reset_to_default()
	get_tree().reload_current_scene()
