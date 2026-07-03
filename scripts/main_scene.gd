extends Node

@export var invoice_list_container: VBoxContainer
@export var item_label_scene: PackedScene
@export var debug_list_menu: Control

@export var hp_progress_bar: Range
@export var stamina_progress_bar: Range

@onready var modal_nota_is_open = $CanvasLayer/LabelList/ModalNotaIsOpen
@onready var modal_nota_is_close = $CanvasLayer/LabelList/ModalNotaIsClose
@onready var nota_list_label = $CanvasLayer/LabelList/NotaListLabel
@onready var nota_list = $CanvasLayer/NotaList
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var game_over_menu = $CanvasLayer/GameOverMenu

@onready var labelToInteract: Label = $CanvasLayer/LabelToInteract
@onready var money_label: Label = $CanvasLayer/ContainerMoney/Label

@onready var day_label: Label = $CanvasLayer/DayLabel
@onready var timer_label: Label = $CanvasLayer/TimerLabel
@onready var day_timer: Timer = $CanvasLayer/DayTimer

var player: CharacterBody3D
var current_counted_items: Dictionary = {}

@onready var audioPlayer = $AudioStreamPlayer
var music_santai = preload("res://assets/music/Pas Santai.mp3.mpeg.ogg")
var music_tegang = preload("res://assets/music/pas Tegang.mp3.mpeg.ogg")
var is_tense_music_playing: bool = false

@onready var sfx_player = $SfxStreamPlayer
var sfx_click = preload("res://assets/sfx/button_click.wav")
var sfx_game_over = preload("res://assets/sfx/game_over.wav")
var sfx_wrong_move = preload("res://assets/sfx/wrong_move.wav")
var sfx_nota_fulfilled = preload("res://assets/sfx/nota_fullfilled.wav")

var was_quota_fulfilled: bool = false

func play_click_sfx() -> void:
	if sfx_player:
		sfx_player.stream = sfx_click
		sfx_player.play()

func _ready() -> void:
	if LevelData.current_day == 0:
		LevelData.start_day()
		
	if audioPlayer:
		audioPlayer.stream = music_santai
		audioPlayer.play()
		
	update_invoice_list_ui()
	setup_character_ui_connections()
	setup_day_and_timer()
	
	if pause_menu:
		pause_menu.visible = false
		
	if game_over_menu:
		game_over_menu.visible = false
	
	if modal_nota_is_open and modal_nota_is_close and nota_list_label and nota_list:
		modal_nota_is_open.visible = true
		modal_nota_is_close.visible = false
		nota_list_label.visible = true
		nota_list.visible = true
		nota_list_label.modulate.a = 1.0
		nota_list.modulate.a = 1.0

func _process(_delta: float) -> void:
	setup_money_ui()
	update_timer_ui()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			play_click_sfx()
			if game_over_menu and game_over_menu.visible:
				LevelData.reset_to_default()
				get_tree().change_scene_to_file("res://scenes/User Interface/main_menu.tscn")
			elif pause_menu and pause_menu.visible:
				_on_resume_button_pressed()
			else:
				_on_menu_button_pressed()
		elif event.keycode == KEY_Q:
			play_click_sfx()
			if not (game_over_menu and game_over_menu.visible) and (not pause_menu or not pause_menu.visible):
				if modal_nota_is_open.visible:
					_on_sidebar_open_button_pressed()
				else:
					_on_sidebar_close_button_pressed()

func setup_day_and_timer() -> void:
	if day_label:
		day_label.text = "- Day %d -" % LevelData.current_day
		
	if day_timer:
		day_timer.wait_time = 150
		if not day_timer.timeout.is_connected(_on_day_timer_timeout):
			day_timer.timeout.connect(_on_day_timer_timeout)
		day_timer.start()

func update_timer_ui() -> void:
	if day_timer and timer_label and not day_timer.is_stopped():
		var time_left = int(day_timer.time_left)
		var minutes = time_left / 60
		var seconds = time_left % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]
		
		if time_left <= 120 and not is_tense_music_playing:
			is_tense_music_playing = true
			if audioPlayer:
				audioPlayer.stream = music_tegang
				audioPlayer.play()

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
	if not invoice_list_container or not item_label_scene:
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

func update_nota_status(counted_items: Dictionary) -> void:
	if not invoice_list_container:
		return
		
	current_counted_items = counted_items
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
				
	var is_fulfilled = check_quota_fulfilled()
	if is_fulfilled and not was_quota_fulfilled:
		if sfx_player:
			sfx_player.stream = sfx_nota_fulfilled
			sfx_player.play()
	was_quota_fulfilled = is_fulfilled

func check_quota_fulfilled() -> bool:
	var required_items = LevelData.nota_list
	for nota in required_items:
		var item_name = nota.get("objectName", "")
		var required_amount = nota.get("amount", 0)
		if not current_counted_items.has(item_name) or current_counted_items[item_name] < required_amount:
			return false
	return true

func _on_day_timer_timeout() -> void:
	if check_quota_fulfilled():
		LevelData.location = "shop"
		get_tree().change_scene_to_file("res://scenes/electronicStore.tscn")
	else:
		LevelData.failed_day()
		if game_over_menu:
			game_over_menu.visible = true
		if player:
			player.is_paused = true
			player.release_mouse()

func _on_sidebar_open_button_pressed() -> void:
	play_click_sfx()
	if not (modal_nota_is_open and modal_nota_is_close and nota_list_label and nota_list):
		return
		
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(nota_list_label, "modulate:a", 0.0, 0.2)
	tween.tween_property(nota_list, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(func():
		nota_list_label.visible = false
		nota_list.visible = false
		modal_nota_is_open.visible = false
		modal_nota_is_close.visible = true
	)

func _on_sidebar_close_button_pressed() -> void:
	play_click_sfx()
	if not (modal_nota_is_open and modal_nota_is_close and nota_list_label and nota_list):
		return
		
	modal_nota_is_open.visible = true
	modal_nota_is_close.visible = false
	nota_list_label.visible = true
	nota_list.visible = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(nota_list_label, "modulate:a", 1.0, 0.2)
	tween.tween_property(nota_list, "modulate:a", 1.0, 0.2)

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

func _on_day_ended(van_items: Array) -> void:
	var is_success: bool = LevelData.check_van_items(van_items)
	
	if not is_success:
		if sfx_player:
			sfx_player.stream = sfx_wrong_move
			sfx_player.play()
			await get_tree().create_timer(1.0).timeout
			sfx_player.stream = sfx_game_over
			sfx_player.play()
			
		LevelData.failed_day()
		if game_over_menu:
			game_over_menu.visible = true
		if player:
			player.is_paused = true
			player.release_mouse()

func _on_open_debug_menu_pressed() -> void:
	if debug_list_menu:
		debug_list_menu.visible = not debug_list_menu.visible

func _on_debug_next_day_pressed() -> void:
	LevelData.start_day()
	get_tree().reload_current_scene()

func _on_debug_closed_day_pressed() -> void:
	_on_day_ended([])

func _on_debug_reset_day_pressed() -> void:
	LevelData.reset_to_default()
	get_tree().reload_current_scene()
