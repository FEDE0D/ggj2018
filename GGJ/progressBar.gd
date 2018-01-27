extends CanvasLayer

var completition

func update(count, score):
	get_node("Control/TextureProgress").set_value(count)
	get_node("Control/TextureProgress/AnimationPlayer").play("glow")
	get_node("Control/Score").set_text(str(score))
	print(score)


func _ready():
	get_node("Control/Score").set_text(str(0))
	set_process(true)

func _process(delta):
	completition = get_node("Control/TextureProgress").get_value()
	completition -= delta
	completition = clamp(completition,0,100)
	