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

	var expected_strength := current_day - 1
	if current_day >= 4:
		expected_strength = 99

	var pool_items := []
	var item_absurd_status := {}
	
	for group in item_list_data.shoppingItemArrayList:
		var is_absurd : bool = group.get("isAbsurd", false)
		
		if is_absurd and current_day < 2:
			continue
			
		for cat_data in group["list"]:
			for item in cat_data["listItem"]:
				var item_strength : int = item.get("strenghtLevelToLift", 0)
				
				if item.get("availableFromDay", 0) <= current_day and item_strength <= expected_strength:
					pool_items.append(item)
					item_absurd_status[item["objectName"]] = is_absurd

	if pool_items.is_empty():
		push_error("Pool item kosong! Periksa data ketersediaan item.")
		return

	pool_items.shuffle()
	var selected_count: int = min(max_unique_items, pool_items.size())
	
	for i in range(selected_count):
		var target_item = pool_items[i]
		var item_name: String = target_item["objectName"]
		var is_absurd: bool = item_absurd_status[item_name]
		var item_strength: int = target_item.get("strenghtLevelToLift", 0)
		
		var amount := 1
		
		if is_absurd:
			if current_day >= 9:
				amount = randi_range(1, 3)
			elif current_day >= 5:
				amount = randi_range(1, 2)
			else:
				amount = 1
		else:
			var max_amount := 1
			if current_day >= 7:
				max_amount = 3
			elif current_day >= 4:
				max_amount = 2
				
			if item_strength >= 5:
				max_amount = 1
			elif item_strength >= 2:
				max_amount = min(max_amount, 2)
				
			amount = randi_range(1, max_amount)
			
		nota_list.append({
			"objectName": item_name,
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
