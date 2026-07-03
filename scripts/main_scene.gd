extends Node

@export var invoice_list_container: VBoxContainer
@export var item_label_scene: PackedScene
@export var debug_list_menu: Control

@export var hp_progress_bar: Range
@export var stamina_progress_bar: Range
@onready var labelToInteract: Label = $CanvasLayer/LabelToInteract
@onready var money_label: Label = $CanvasLayer/ContainerMoney/Label

var player: CharacterBody3D

func _ready() -> void:
	LevelData.start_day()
	update_invoice_list_ui()
	setup_character_ui_connections()

func _process(_delta: float) -> void:
	setup_money_ui()

func setup_money_ui() -> void:
	if money_label:
		money_label.text = str(LevelData.money)

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

func update_invoice_list_ui() -> void:
	if not invoice_list_container:
		push_error("InvoiceList Node (VBoxContainer) is not assigned in the Inspector!")
		return
		
	if not item_label_scene:
		push_error("Label Scene is not assigned to the item_label_scene variable in the Inspector!")
		return
		
	for child in invoice_list_container.get_children():
		child.queue_free()
		
	var current_invoice: Array = LevelData.nota_list
	
	for i in range(current_invoice.size()):
		var item: Dictionary = current_invoice[i] as Dictionary
		var item_name: String = item.get("objectName", "Unknown")
		var item_amount: int = item.get("amount", 0)
		
		var display_text: String = ""
		if item_amount > 1:
			display_text = "%s x%d" % [item_name, item_amount]
		else:
			display_text = item_name
			
		var label_instance: Label = item_label_scene.instantiate() as Label
		if label_instance:
			label_instance.text = display_text
			invoice_list_container.add_child(label_instance)
			
func _on_day_ended(van_items: Array) -> void:
	var is_success: bool = LevelData.check_van_items(van_items)
	
	if not is_success:
		LevelData.failed_day()
		get_tree().reload_current_scene()

func _on_open_debug_menu_pressed() -> void:
	if debug_list_menu:
		debug_list_menu.visible = not debug_list_menu.visible

func _on_debug_next_day_pressed() -> void:
	get_tree().reload_current_scene()

func _on_debug_closed_day_pressed() -> void:
	_on_day_ended([])

func _on_debug_reset_day_pressed() -> void:
	LevelData.reset_to_default()
	get_tree().reload_current_scene()
	
func update_nota_status(counted_items: Dictionary) -> void:
	if not invoice_list_container:
		return
		
	var current_invoice: Array = LevelData.nota_list
	var labels_list = invoice_list_container.get_children()
	
	for i in range(current_invoice.size()):
		if i < labels_list.size():
			var label: Label = labels_list[i]
			var item: Dictionary = current_invoice[i]
			
			var target_name: String = item.get("objectName", "")
			var target_amount: int = item.get("amount", 0)
			var current_amount: int = counted_items.get(target_name, 0)
			
			if current_amount >= target_amount:
				label.add_theme_color_override("font_outline_color", Color(0, 1, 0))
				label.add_theme_constant_override("outline_size", 4)
			else:
				label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
				label.add_theme_constant_override("outline_size", 4)
