extends Node2D

@onready var logo = $CanvasLayer/EverythingMustGoLogo

@onready var btn_start = $CanvasLayer/ListButton/ButtonStart
@onready var sprite_start = $CanvasLayer/ListButton/ButtonStartSprite

@onready var btn_tutorial = $CanvasLayer/ListButton/TutorialButton
@onready var sprite_tutorial = $CanvasLayer/ListButton/TutorialButtonSprite

@onready var btn_exit = $CanvasLayer/ListButton/ExitButton
@onready var sprite_exit = $CanvasLayer/ListButton/ExitButtonSprite

@onready var btn_credit = $CanvasLayer/ListButton/CreditButton
@onready var sprite_credit = $CanvasLayer/ListButton/CreditButtonSprite

func _ready() -> void:
	logo.position = Vector2(299.0, 318.0)
	logo.scale = Vector2(0.555, 0.555)

	var tween_logo = create_tween().set_loops()
	tween_logo.tween_property(logo, "scale", Vector2(0.58, 0.58), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_logo.tween_property(logo, "scale", Vector2(0.555, 0.555), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	btn_start.mouse_entered.connect(_on_hover_entered.bind(sprite_start))
	btn_start.mouse_exited.connect(_on_hover_exited.bind(sprite_start))
	
	btn_tutorial.mouse_entered.connect(_on_hover_entered.bind(sprite_tutorial))
	btn_tutorial.mouse_exited.connect(_on_hover_exited.bind(sprite_tutorial))
	
	btn_exit.mouse_entered.connect(_on_hover_entered.bind(sprite_exit))
	btn_exit.mouse_exited.connect(_on_hover_exited.bind(sprite_exit))
	
	btn_credit.mouse_entered.connect(_on_hover_entered.bind(sprite_credit))
	btn_credit.mouse_exited.connect(_on_hover_exited.bind(sprite_credit))

func _on_hover_entered(sprite: Node) -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.68, 0.68), 0.1)

func _on_hover_exited(sprite: Node) -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.645, 0.645), 0.1)

func animate_button(sprite: Node) -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.58, 0.58), 0.1)
	tween.tween_property(sprite, "scale", Vector2(0.645, 0.645), 0.1)

func _on_button_start_pressed() -> void:
	animate_button(sprite_start)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/loadingScreen.tscn")

func _on_tutorial_button_pressed() -> void:
	animate_button(sprite_tutorial)

func _on_exit_button_pressed() -> void:
	animate_button(sprite_exit)
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_credit_button_pressed() -> void:
	animate_button(sprite_credit)
