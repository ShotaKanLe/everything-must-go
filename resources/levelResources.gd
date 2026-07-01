extends Node

var current_day: int = 0

var stamina_level: int = 0
var health_level: int = 0
var strength_level: int = 0
var double_jump_upgrade: bool = false
var range_level: int = 0
var speed_level: int = 0
var stamina_regen_level: int = 0
var slot_tools_level: int = 0

var nota_list: Array = []
var current_day_budget: float = 0.0
var location: String = "shop"
var money: float = 0.0
var owned_tools_list: Array = []

var item_list_data: ShoppingItemArrayList = ShoppingItemArrayList.new()

func get_max_stamina() -> float:
	return 100.0 + (stamina_level * 10.0)

func get_max_hp() -> float:
	return 100.0 + (health_level * 10.0)

func get_max_grab_distance() -> float:
	return 4.0 + (range_level * 0.5)

func get_base_speed() -> float:
	return 7.0 + (speed_level * 0.5)

func get_stamina_regen() -> float:
	return 5.0 + (stamina_regen_level * 0.5)

func get_max_slots() -> int:
	return 3 + slot_tools_level

func generate_nota_list() -> void:
	nota_list.clear()
	
	var max_unique_items := 3
	if current_day > 3 and randf() > 0.5:
		max_unique_items = randi_range(3, 5)
	else:
		max_unique_items = 3

	var pool_items := []
	for group in item_list_data.shoppingItemArrayList:
		if group["isAbsurd"] and current_day <= 3:
			continue
			
		for cat_data in group["list"]:
			for item in cat_data["listItem"]:
				if item["availableFromDay"] <= current_day:
					pool_items.append(item)

	if pool_items.is_empty():
		push_error("Pool item kosong! Periksa data ketersediaan item.")
		return

	pool_items.shuffle()
	var selected_count: int = min(max_unique_items, pool_items.size())
	
	for i in range(selected_count):
		var target_item = pool_items[i]
		
		var amount := 1
		if current_day > 3:
			amount = randi_range(1, 3)
			
		nota_list.append({
			"objectName": target_item["objectName"],
			"amount": amount,
			"maximumPrice": target_item["maximumPrice"]
		})

func generate_day_budget() -> void:
	var standard_budget := 0.0
	for nota in nota_list:
		standard_budget += nota["maximumPrice"] * nota["amount"]
		
	if current_day > 3 and randf() > 0.5:
		current_day_budget = randf_range(0.0, standard_budget)
	else:
		current_day_budget = standard_budget
		
	current_day_budget = snapped(current_day_budget, 0.01)

func start_day() -> void:
	current_day += 1
	location = "mall"
	generate_nota_list()
	generate_day_budget()
	money += current_day_budget

func check_van_items(van_shopping_item_list: Array) -> bool:
	var nota_checklist := {}
	for nota in nota_list:
		nota_checklist[nota["objectName"]] = nota["amount"]
		
	var van_counts := {}
	for item in van_shopping_item_list:
		var item_name : String = ""
		if "objectName" in item:
			item_name = item.objectName
		elif "item_data" in item and item.item_data and "objectName" in item.item_data:
			item_name = item.item_data.objectName
		else:
			continue
			
		if van_counts.has(item_name):
			van_counts[item_name] += 1
		else:
			van_counts[item_name] = 1

	if van_counts.size() != nota_checklist.size():
		return false
		
	for item_name in nota_checklist:
		if not van_counts.has(item_name) or van_counts[item_name] != nota_checklist[item_name]:
			return false
			
	return true

func failed_day() -> void:
	reset_to_default()

func reset_to_default() -> void:
	current_day = 0
	stamina_level = 0
	health_level = 0
	strength_level = 0
	double_jump_upgrade = false
	range_level = 0
	speed_level = 0
	stamina_regen_level = 0
	slot_tools_level = 0
	nota_list.clear()
	current_day_budget = 0.0
	location = "shop"
	money = 0.0
	owned_tools_list.clear()
