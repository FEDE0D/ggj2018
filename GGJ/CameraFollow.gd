extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player

func _ready():
	player = Globals.get("player")
	set_process(true)

func _process(delta):
	set_pos(get_pos().linear_interpolate(player.get_pos(),delta))
	var zoom =  Vector2()
	var camera_value = 1 + (get_tree().get_nodes_in_group("converted").size()) *0.02
	zoom =Vector2(1,1) * camera_value
	zoom = get_zoom().linear_interpolate(zoom,delta*2)
	set_zoom(zoom)
	pass