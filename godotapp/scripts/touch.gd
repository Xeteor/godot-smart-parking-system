extends Control

@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
const MENU = preload("uid://bag16md25rfl3")
var touches := {}
var start_distance := 0.0
var initial_fov := 0.0
var last_drag_pos: Vector2 = Vector2.ZERO
var _changing_scene := false



# Camera movement limits (relative to initial camera position)
var move_limit_x = 10.0
var move_limit_y = 20.0

var initial_camera_pos: Vector3

func _ready():
	# Store initial camera position
	initial_camera_pos = camera_3d.position

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = event.position
		else:
			touches.erase(event.index)
		queue_redraw()

	elif event is InputEventScreenDrag:
		touches[event.index] = event.position
		
		# Single touch → drag camera
		if touches.size() == 1:
			if last_drag_pos == Vector2.ZERO:
				last_drag_pos = event.position
			else:
				var delta = event.position - last_drag_pos
				move_camera(delta)
				last_drag_pos = event.position

		queue_redraw()
		
	# Reset drag tracking if necessary
	if touches.size() != 1:
		last_drag_pos = Vector2.ZERO

	check_pinch_zoom()

func _draw() -> void:
	for pos in touches.values():
		draw_circle(pos, 100.0, Color.GREEN, false, 5.0)

func check_pinch_zoom():
	if touches.size() == 2:
		var points = touches.values()
		var p1 = points[0]
		var p2 = points[1]

		var current_dist = p1.distance_to(p2)
		calc_zoom(current_dist)
	else:
		start_distance = 0.0

func calc_zoom(curr_dist: float) -> void:
	if start_distance == 0.0:
		start_distance = curr_dist
		initial_fov = camera_3d.fov
	else:
		var scale_factor = curr_dist / start_distance
		var new_fov = initial_fov / scale_factor
		camera_3d.fov = clamp(new_fov, 30.0, 90.0)

func move_camera(delta: Vector2) -> void:
	var sensitivity = 0.04  # slow drag
	var new_pos = camera_3d.position
	new_pos.x -= delta.x * sensitivity
	new_pos.y += delta.y * sensitivity

	# Clamp relative to initial camera position
	new_pos.x = clamp(new_pos.x, initial_camera_pos.x - move_limit_x, initial_camera_pos.x + move_limit_x)
	new_pos.y = clamp(new_pos.y, initial_camera_pos.y - move_limit_y, initial_camera_pos.y + move_limit_y)

	camera_3d.position = new_pos
