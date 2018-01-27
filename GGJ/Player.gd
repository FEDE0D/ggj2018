extends Node2D

var speed = Vector2(0,0)
var move_speed = 150
var deceleration = 40
var direction = Vector2(0,0)
var animationtree
var animation_pos = 0
const MAX_SPEED = Vector2(20,20)
var followers_count = 0
var npcs_count = 0

signal new_follower

func _ready():
	set_process(true)
	set_process_input(true)
	animationtree = get_node("AnimationTreePlayer")
	Globals.set("player", self)
	self.npcs_count = get_tree().get_nodes_in_group("npcs").size()
	
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	else:
		direction.y = 0
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		#fixme refactor to move body instead of both sprites
		get_node("body").get_node("Sprite").set_flip_h(false)
		get_node("body").get_node("Shadow").set_flip_h(false)
		
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		#fixme refactor to move body instead of both sprites
		get_node("body").get_node("Sprite").set_flip_h(true)
		get_node("body").get_node("Shadow").set_flip_h(true)
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
	

func _input(event):
	if event.is_action_pressed("hit"):
		get_node("AnimationTreePlayer").oneshot_node_start("HitNode")
		for b in get_node("Area2D").get_overlapping_bodies():
			if b.is_in_group("npcs"):
				b.conversion(self)
				var health = (float(followers_count) / npcs_count)
				emit_signal("new_follower", health)