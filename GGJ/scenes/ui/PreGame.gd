extends Control

func _ready():
	pass

func _on_Button_pressed():
	SceneTransition.transition_to("Main.tscn")
