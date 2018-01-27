extends Node2D


var speed = Vector2(0,0)
var move_speed = 300
var deceleration = 40
var direction = Vector2(0,0)
const MAX_SPEED = Vector2(20,20)
var player

var converted = false

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	if converted:
		set_pos(Vector2(lerp(get_pos().x, player.get_pos().x ,delta),
		lerp(get_pos().y, player.get_pos().y ,delta)))
		
		

func conversion(p):
	if !converted:
		player = p
		converted = true
		print("convert")
		