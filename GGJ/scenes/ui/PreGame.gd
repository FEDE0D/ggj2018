extends Control

func _ready():
	set_process_input(true)

func _on_Button_pressed():
	SceneTransition.transition_to("Main.tscn")

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		_on_Button_pressed()