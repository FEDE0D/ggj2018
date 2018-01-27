extends CanvasLayer

func update(count, score):
	get_node("Control/TextureProgress").set_value(count)
	get_node("Control/TextureProgress/AnimationPlayer").play("glow")
	get_node("Control/Score").set_text("Score: " + str(score))
	print(score)
	