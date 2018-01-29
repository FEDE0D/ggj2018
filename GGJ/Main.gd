extends Node

var animator 

func _ready():
	Globals.set("map", self)
	for spawner in get_node("map/spawners").get_children():
		spawner.spawn(get_node("characters"))
	Globals.get("contador").update()
	Globals.set("music",get_node("StreamPlayer"))
	animator = get_node("characters/AnimationPlayer")

func end_game():
	SceneTransition.transition_to("scenes/ui/main.tscn")
