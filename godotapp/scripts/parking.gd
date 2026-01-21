extends Node3D

@onready var car1: Node3D = $car1
@onready var car2: Node3D = $car2
@onready var car3: Node3D = $car3
@onready var car4: Node3D = $car4

var ws := WebSocketPeer.new()
var url := "ws://192.168.4.1/ws"
var is_connected := false
var reconnect_timer := 2.0  # seconds between reconnect attempts
var time_since_disconnect := 0.0

func _ready():
	print("Connecting to ESP32 WebSocket...")
	_connect_ws()

func _process(delta):
	ws.poll()  # required for WebSocketPeer to update state

	match ws.get_ready_state():
		WebSocketPeer.STATE_OPEN:
			time_since_disconnect = 0.0
			if not is_connected:
				is_connected = true
				print("Connected to ESP32 WebSocket!")

			# handle all available messages
			while ws.get_available_packet_count() > 0:
				var msg = ws.get_packet().get_string_from_utf8()
				_handle_message(msg)

		WebSocketPeer.STATE_CLOSING:
			print("WebSocket closing...")

		WebSocketPeer.STATE_CLOSED:
			if is_connected:
				is_connected = false
				print("WebSocket disconnected")
				_hide_all_cars()

			# Auto-reconnect logic
			time_since_disconnect += delta
			if time_since_disconnect >= reconnect_timer:
				time_since_disconnect = 0.0
				print("Attempting to reconnect to WebSocket...")
				_connect_ws()

func _connect_ws():
	var err = ws.connect_to_url(url)
	if err != OK:
		print("Connection attempt failed: ", err)
	else:
		print("Connecting...")

func _handle_message(msg: String) -> void:
	print("Received JSON: ", msg)
	var data = JSON.parse_string(msg)
	if typeof(data) == TYPE_DICTIONARY:
		handle_sensor(data.get("sensor1", {}), car1)
		handle_sensor(data.get("sensor2", {}), car2)
		handle_sensor(data.get("sensor3", {}), car3)
		handle_sensor(data.get("sensor4", {}), car4)
	else:
		print("Invalid JSON")
		_hide_all_cars()

func handle_sensor(sensor_data: Dictionary, car: Node3D) -> void:
	var distance = sensor_data.get("distance", -1)
	var detected = sensor_data.get("detected", false)

	if detected and distance >= 1 and distance <= 14:
		car.show()
	else:
		car.hide()

func _hide_all_cars() -> void:
	car1.hide()
	car2.hide()
	car3.hide()
	car4.hide()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
