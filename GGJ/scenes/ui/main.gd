extends Control

var cloudSprites1
var cloudSprites2

func _ready():
	cloudSprites1 = get_node("cloud1").get_children()
	cloudSprites2 = get_node("cloud2").get_children()
	set_process(true)
	set_process_input(true)

func _on_Button_pressed():
	SceneTransition.transition_to("Main.tscn")

func _process(delta):
	for c in cloudSprites1:
		c.rotate(-delta)
	for c in cloudSprites2:
		c.rotate(-delta)

func _on_Button1_toggled( pressed ):
	OS.set_window_fullscreen(pressed)

func _input(event):
	if Input.is_action_pressed("hit"):
		_on_Button_pressed()
