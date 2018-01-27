extends Node2D

var speed = Vector2(0,0)
var move_speed = 150
var deceleration = 40
var direction = Vector2(0,0)
var animationtree
var animation_pos = 0
const MAX_SPEED = Vector2(20,20)


func _ready():
	set_process(true)
	animationtree = get_node("AnimationTreePlayer")
	Globals.set("player", self)
	
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	else:
		direction.y = 0
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		get_node("body").get_node("Sprite").set_flip_h(false)
		
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		get_node("body").get_node("Sprite").set_flip_h(true)
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
		animationtree.transition_node_set_current("transition", 1)
	else:
		animationtree.transition_node_set_current("transition", 0)
	
	
	set_pos(get_pos() + speed)
	
func collision( area ):
	print("collision")
	if area.is_in_group("npcs"):
		area.conversion(self)