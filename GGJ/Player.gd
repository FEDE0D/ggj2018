extends Node2D

var speed = Vector2(0,0)
var move_speed = 200
var deceleration = 40
var direction = Vector2(0,0)
var animationtree
var animation_pos = 0
var score
const MAX_SPEED = Vector2(20,20)

var followers_count = 0
var npcs_count = 0
var transmission_emiting = false
var reload = 0

signal new_follower(health, score)

func _ready():
	set_process(true)
	set_process_input(true)
	animationtree = get_node("AnimationTreePlayer")
	Globals.set("player", self)
	score = get_node("/root/Score")
	emit_signal("new_follower", score.get_health(), score.get_score())
	
	var ticker = null
	ticker = Timer.new()
	add_child(ticker)
	
	ticker.connect("timeout", self, "tick_health")
	ticker.set_wait_time(1.0)
	ticker.set_one_shot(false)
	ticker.start()


func tick_health():
	var health_tick = score.get_health() / 50 + 0.5
	score.set_health(score.get_health() - health_tick)
	emit_signal("new_follower", score.get_health(), score.get_score())
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
	set_pos(get_pos() + speed + (speed * getExtraSpeedRatio()))

func getExtraSpeedRatio():
	return float(get_followers_count()) / get_npcs_count()

func get_followers_count():
	return get_tree().get_nodes_in_group("converted").size()
	
func get_npcs_count():
	return get_tree().get_nodes_in_group("npcs").size()

func _input(event):
	if event.is_action_pressed("hit"):
		get_node("AnimationTreePlayer").oneshot_node_start("HitNode")
		# trigger hit on converted
		for converted in get_tree().get_nodes_in_group("converted"):
			converted.start_hit()
		# convert new ones
		for b in get_node("Area2D").get_overlapping_bodies():
			if b.is_in_group("npcs"):
				b.conversion(self)
				emit_signal("new_follower", score.get_health(), score.get_score())
		for a in get_node("Area2D").get_overlapping_areas():
			if a.is_in_group("rescue"):
				a.activate()

func newFollower(node):
	print("new follower")
	pass