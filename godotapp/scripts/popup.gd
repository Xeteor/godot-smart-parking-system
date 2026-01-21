extends Control

const MENU = preload("uid://bag16md25rfl3")

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = 2.0  # wait 2 seconds (you can change this)
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(MENU)
