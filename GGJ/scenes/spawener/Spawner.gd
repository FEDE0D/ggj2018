extends Position2D

export(PackedScene) var packedScene
export(int) var maxCant = 5
export(int) var maxDistance = 300

func _ready():
	get_node("Sprite").hide()

func spawn(parent):
	for i in range(1, randi() % maxCant + 1):
		var position = get_global_pos() + Vector2(0, randf() * maxDistance).rotated(randf() * 2 * PI)
		var instance = packedScene.instance()
		instance.set_global_pos(position)
		parent.add_child(instance)
		pass
