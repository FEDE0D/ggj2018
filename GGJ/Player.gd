extends Node2D

var speed = Vector2(0,0)
var move_speed = 150
var deceleration = 40
var direction = Vector2(0,0)
var player
const MAX_SPEED = Vector2(20,20)


func _ready():
	set_process(true)
	player = get_node("AnimationPlayer")
	
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	else:
		direction.y = 0
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	else:
		direction.x = 0
	
	speed = direction * move_speed * delta
	if (!direction.x) && (speed.x > 0):
		speed.x -= deceleration
	if (!direction.y) && (speed.y > 0):
		speed.y -=deceleration
	clamp(speed.y,0,MAX_SPEED.y)
	clamp(speed.x,0,MAX_SPEED.x)
		
	if (direction.x || direction.y):
		print("moving")
		if (!player.is_playing()):
			player.play("bounce")
	else:
		player.stop_all()
	set_pos(get_pos() + speed)
	
func collision( area ):
	print("collision")
	if area.is_in_group("npcs"):
		area.conversion(self)