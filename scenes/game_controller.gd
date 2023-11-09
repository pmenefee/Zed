extends Node

@onready var previous_window = DisplayServer.window_get_mode()
@onready var current_window = DisplayServer.window_get_mode()


func _ready():
	print("string here")

func _input(event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		current_window = DisplayServer.window_get_mode()
		if current_window != 4:
			previous_window = current_window
			DisplayServer.window_set_mode(4)
			print("Toggle: fullscreen on")
		else:
			if previous_window == 4:
				previous_window = 2
			DisplayServer.window_set_mode(previous_window)
			print("Toggle: fullscreen off")
