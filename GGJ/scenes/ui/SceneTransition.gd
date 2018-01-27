extends CanvasLayer

var scene

func transition_to(scene_path):
	scene = load(scene_path)
	get_node("AnimationPlayer").play("transition")

func transition():
	if (scene):
		get_tree().change_scene_to(scene)
