extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func update(count):
	get_node("Control/ProgressBar").set_value(count)