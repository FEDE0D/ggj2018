extends CanvasLayer

var completition
var flag = false

func update(count, score):
	get_node("Control/TextureProgress").set_value(count)
	get_node("Control/TextureProgress/AnimationPlayer").play("glow")
	get_node("Control/Score").set_text(str(score))
	get_node("Control/ScoreShadow").set_text(str(score))
	print(score)
	print(count)


func _ready():
	Globals.set("UI", self)
	get_node("Control/Score").set_text(str(0))
	get_node("Control/ScoreShadow").set_text(str(0))
	set_process(true)
	var timer = null
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self, "hide_tutorial")
	timer.set_wait_time(10.0)
	timer.start()
	
	get_node("Control/Tutorial/W").set_frame(0)
	get_node("Control/Tutorial/A").set_frame(0)
	get_node("Control/Tutorial/S").set_frame(0)
	get_node("Control/Tutorial/D").set_frame(0)

func _process(delta):
	completition = get_node("Control/TextureProgress").get_value()
	completition -= delta
	completition = clamp(completition,0,100)
	
func hide_tutorial():
	get_node("Control/Tutorial").hide()
	pass

func showLlevalosLuz():
	if !flag:
		get_node("Control/LlevalosLabel").show()
		get_node("Timer").start()
		flag = true

func _on_Timer_timeout():
	get_node("Control/LlevalosLabel").hide()
