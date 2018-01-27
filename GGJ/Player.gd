extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var speed = Vector2(0,0)
var move_speed = 300
var deceleration = 40
var direction = Vector2(0,0)
const MAX_SPEED = Vector2(20,20)


func _ready():
	set_process(true)
	pass
	
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
	
	
	set_pos(get_pos() + speed)