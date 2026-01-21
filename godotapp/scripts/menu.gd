extends Control
@onready var updatewhatsaid: Label = $MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/Panel2/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label
var messages = ["Landmark", "Destination", "Hotel", "Mall", "Hospital"]
const PARKING = preload("res://scenes/format.tscn")
var index := 0
var loaded_scene: PackedScene = null

func loop_texts() -> void:
	while true:
		await get_tree().create_timer(0.7).timeout
		index = (index + 1) % messages.size()  # move to next, wrap around
		updatewhatsaid.text = messages[index]
#
#
#var ws := WebSocketPeer.new()
#var url := "ws://192.168.4.1/ws"
#var is_connected := false

func _ready():
	updatewhatsaid.text = messages[index]  # start from first one
	loop_texts()
	#print("Connecting to ESP32 WebSocket...")
	#var err = ws.connect_to_url(url)
	#if err != OK:
		#print("Connection failed: ", err)
	#else:
		#print("Connecting...")
#
#func _process(delta):
	#ws.poll()
#
	#match ws.get_ready_state():
		#WebSocketPeer.STATE_OPEN:
			#if not is_connected:
				#is_connected = true
				#print("Connected to ESP32 WebSocket!")
#
			#while ws.get_available_packet_count() > 0:
				#var msg = ws.get_packet().get_string_from_utf8()
				#print("Received JSON: ", msg)
				#var data = JSON.parse_string(msg)
				#if data:
					#print(data)
				#else:
					#print("Invalid JSON received")
#
		#WebSocketPeer.STATE_CLOSING:
			#print("WebSocket closing...")
#
		#WebSocketPeer.STATE_CLOSED:
			#if is_connected:
				#is_connected = false
				#print("WebSocket disconnected")


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(PARKING)
