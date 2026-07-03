extends Node2D

@onready var cart = $CanvasLayer/Cart
@onready var loading_text = $"CanvasLayer/Loading Text"
@onready var progress_bar = $CanvasLayer/TextureProgressBar

var next_scene_path: String = "res://scenes/levelScene.tscn"
var progress: Array = []

func _ready() -> void:
	cart.scale = Vector2(0.709, 0.709)
	progress_bar.value = 0
	progress_bar.max_value = 100
	progress_bar.step = 0.1
	
	var tween_cart = create_tween().set_loops()
	tween_cart.tween_property(cart, "scale", Vector2(0.75, 0.75), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_cart.tween_property(cart, "scale", Vector2(0.709, 0.709), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var tween_text = create_tween().set_loops()
	tween_text.tween_property(loading_text, "modulate:a", 0.3, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_text.tween_property(loading_text, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	
	match load_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100.0
		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = 100.0
			var new_scene = ResourceLoader.load_threaded_get(next_scene_path)
			get_tree().change_scene_to_packed(new_scene)
			set_process(false)
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			set_process(false)
