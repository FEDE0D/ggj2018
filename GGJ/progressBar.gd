extends CanvasLayer

var completition

func update(count):
	get_node("Control/TextureProgress").set_value(count)
	get_node("Control/TextureProgress/AnimationPlayer").play("glow")


func _ready():
	set_process(true)

func _process(delta):
	completition = get_node("Control/TextureProgress").get_value()
	completition -= delta
	completition = clamp(completition,0,100)
	