extends CanvasLayer

func update(count):
	get_node("Control/TextureProgress").set_value(count)