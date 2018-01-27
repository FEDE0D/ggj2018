extends CanvasLayer

var scene_path

func transition_to(scene_path):
	self.scene_path = scene_path
	get_node("AnimationPlayer").play("transition")

func transition():
	if (scene_path):
		get_tree().change_scene_to(load(scene_path))
