extends Control

@export var max_slots : int = 5
@export var current_slots_count : int = 3

@onready var slot_container: HBoxContainer = $SlotContainer

var inventory_data : Array = []
var active_slot_index : int = 0

func _ready() -> void:
	setup_slots()
	select_slot(0)

func setup_slots() -> void:
	for child in slot_container.get_children():
		child.queue_free()
	
	inventory_data.clear()
	
	for i in range(current_slots_count):
		inventory_data.append(null)
		
		var slot_panel = PanelContainer.new()
		slot_panel.custom_minimum_size = Vector2(60, 60)
		slot_panel.name = "Slot" + str(i + 1)
		
		var label = Label.new()
		label.text = str(i + 1)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		slot_panel.add_child(label)
		
		slot_container.add_child(slot_panel)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_1 and current_slots_count >= 1:
			select_slot(0)
		elif event.keycode == KEY_2 and current_slots_count >= 2:
			select_slot(1)
		elif event.keycode == KEY_3 and current_slots_count >= 3:
			select_slot(2)
		elif event.keycode == KEY_4 and current_slots_count >= 4:
			select_slot(3)
		elif event.keycode == KEY_5 and current_slots_count >= 5:
			select_slot(4)

func select_slot(index: int) -> void:
	active_slot_index = index
	
	for i in range(slot_container.get_child_count()):
		var slot = slot_container.get_child(i) as PanelContainer
		if i == index:
			slot.modulate = Color(1, 1, 0)
		else:
			slot.modulate = Color(1, 1, 1)

func add_slot() -> void:
	if current_slots_count < max_slots:
		current_slots_count += 1
		setup_slots()
		select_slot(clamp(active_slot_index, 0, current_slots_count - 1))

func remove_slot() -> void:
	if current_slots_count > 1:
		current_slots_count -= 1
		setup_slots()
		select_slot(clamp(active_slot_index, 0, current_slots_count - 1))

func add_item_to_active_slot(item_data: ShoppingItem) -> void:
	inventory_data[active_slot_index] = item_data
	var slot = slot_container.get_child(active_slot_index)
	
	var item_label = slot.get_node_or_null("ItemLabel")
	if not item_label:
		item_label = Label.new()
		item_label.name = "ItemLabel"
		item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot.add_child(item_label)
	
	if item_data:
		item_label.text = item_data.objectName
	else:
		item_label.text = ""
