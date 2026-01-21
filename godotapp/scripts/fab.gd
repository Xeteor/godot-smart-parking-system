extends VBoxContainer

@onready var main_button: Button = $Button5
@onready var menu_buttons := [$Button, $Button2, $Button3, $Button4]

var is_open = false
var tween: Tween

func _ready():
	# hide all menu buttons initially
	for b in menu_buttons:
		b.visible = false
	
	main_button.pressed.connect(_on_main_pressed)

func _on_main_pressed():
	if tween and tween.is_running():
		return
	
	tween = create_tween()
	
	if is_open:
		# Hide buttons
		for b in menu_buttons:
			tween.tween_property(b, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			b.visible = false
		is_open = false
	else:
		# Show buttons
		for b in menu_buttons:
			b.visible = true
			b.modulate.a = 0.0
			tween.tween_property(b, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		is_open = true
