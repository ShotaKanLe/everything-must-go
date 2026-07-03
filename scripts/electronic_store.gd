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
@onready var labelToInteract: Label = $CanvasLayer/LabelToInteract
@onready var upgrades_spawn_point: Node3D = $UpgradeSpawnPoint # Tambahkan baris ini

# Node UI yang disesuaikan dari main_scene / mainCharacter
@export var debug_list_menu: Control
@export var hp_progress_bar: Range
@export var stamina_progress_bar: Range

# Referensi ke player untuk menghubungkan UI Bar jika player diinstansiasi secara dinamis
# (Jika player sudah ada di dalam editor, Anda bisa menggunakan @onready var player = $Player)
var player: CharacterBody3D

func _ready() -> void:
	if LevelData.current_day == 0:
		LevelData.start_day()
		
	print("--- Memulai Proses Spawn Tools & Upgrades ---")
	spawn_tools()
	spawn_upgrades() # Tambahkan baris ini
	setup_character_ui_connections()
	setupMoneyUI()

func setup_character_ui_connections() -> void:
	for child in get_children():
		if child.name.to_lower().contains("player") or child is CharacterBody3D:
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

func _process(delta: float) -> void:
	setupMoneyUI()

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
		# Tools
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
			
		# Upgrades
		"Health Upgrade":
			return healthUpgradeScene
		"Stamina Upgrade":
			return staminaUpgradeScene
		"Strength Upgrade":
			return strenghtUpgradeScene # Typo 'strenght' mengikuti nama variabel preload Anda
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
	var money = LevelData.money
	$CanvasLayer/ContainerMoney/Label.text = str(LevelData.money)

func spawn_upgrades() -> void:
	if not upgrades_spawn_point:
		print("[DEBUG ERROR] Node UpgradeSpawnPoint tidak ditemukan!")
		return
		
	var spawn_nodes := upgrades_spawn_point.get_children()
	var total_spawn_points := spawn_nodes.size()
	print("[DEBUG] Total titik spawn upgrade yang ditemukan: ", total_spawn_points)
	
	if total_spawn_points == 0:
		return
		
	var current_day: int = LevelData.current_day
	var price_multiplier := 1.0 + (current_day - 1) * 0.4
	
	var upgrade_data_script = UpgradeItemArrayList.new()
	var all_upgrades: Array = upgrade_data_script.upgradeItemArrayList
	
	# Dictionary untuk mencatat berapa banyak tipe upgrade yang sudah di-spawn di toko hari ini
	var spawned_counts := {}
	var success_count := 0
	
	for spawn_node in spawn_nodes:
		var available_upgrades := []
		
		# 1. Filter upgrade yang tersedia berdasarkan limit dari LevelData dan yang sudah di-spawn
		for upgrade in all_upgrades:
			var type = upgrade.upgradeType
			var current_lvl = 0
			var max_lvl = -1 # -1 berarti tidak ada batas maksimal
			
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
			
			# Jika tidak ada limit (-1) ATAU (level saat ini + yang sudah muncul di toko) masih di bawah max limit
			if max_lvl == -1 or (current_lvl + spawned_already) < max_lvl:
				available_upgrades.append(upgrade)
		
		# Jika ternyata semua upgrade sudah mencapai limit, hentikan proses spawn sisa titiknya
		if available_upgrades.is_empty():
			print("[DEBUG] Sisa titik spawn diabaikan karena semua upgrade sudah menyentuh batas maksimal.")
			break
			
		# 2. Ambil acak dari list yang sudah difilter
		var random_upgrade: Dictionary = available_upgrades.pick_random()
		var upgrade_scene: PackedScene = get_scene_by_name(random_upgrade.objectName)
		
		if not upgrade_scene:
			print("[DEBUG WARNING] Scene untuk ", random_upgrade.objectName, " tidak ditemukan. Melewati...")
			continue
			
		var upgrade_instance = upgrade_scene.instantiate()
		
		# 3. PENYELESAIAN MASALAH "DOUBLE JUMP UPGRADE": Putuskan Resource dan Timpa Nilainya
		if "item_data" in upgrade_instance and upgrade_instance.item_data:
			# duplicate() membuat resource menjadi independen, tidak mengubah file aslinya
			upgrade_instance.item_data = upgrade_instance.item_data.duplicate(true) 
			
			# Timpa nama dan tipe berdasarkan array list
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
			
		# 4. Tambahkan hitungan spawn untuk mencegah duplikat melebihi batas di iterasi berikutnya
		var u_type = random_upgrade.upgradeType
		if spawned_counts.has(u_type):
			spawned_counts[u_type] += 1
		else:
			spawned_counts[u_type] = 1
			
		print("[DEBUG SUCCESS] Muncul: ", random_upgrade.objectName, " di node: ", spawn_node.name)
		success_count += 1

	print("[DEBUG] Selesai! Total upgrade yang berhasil muncul: ", success_count)

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
