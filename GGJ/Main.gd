extends Node

func _ready():
	Globals.set("map", self)
	for spawner in get_node("map/spawners").get_children():
		spawner.spawn(get_node("characters"))
	Globals.get("contador").update()

func end_game():
	SceneTransition.transition_to("scenes/ui/main.tscn")
