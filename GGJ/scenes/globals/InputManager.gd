extends Node

var pressed = false

func _ready():
	set_process_input(true)

func _input(event):
	if Input.is_action_pressed("fullscreen") && !pressed:
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
		pressed = true
	elif !Input.is_action_pressed("fullscreen"):
		pressed = false