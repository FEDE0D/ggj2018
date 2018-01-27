extends KinematicBody2D

var speed = 4
var converted = false
var separationDist = 500
var followSlowRadius = 100
var anim
var health = 1

func _ready():
	set_process(true)
	anim = get_node("AnimationPlayer")
	
func _process(delta):
	if !converted:
		setHealth(min(1, health + 0.1 * delta))
	else:
		var separation = get_separation() * speed
		var follow = get_follow() * speed * 0.7
		var position = get_global_pos()
		position += separation
		position += follow
		
		var distToTarget = get_global_pos() - position
		if distToTarget.length() < 150:
			var lerpValue = 1 - (distToTarget.length() / 150)
			position = get_global_pos().linear_interpolate(position, lerpValue)
		
		if distToTarget.length() > 0.5:
			if !anim.is_playing():
				anim.play("bounce")
		else:
			anim.stop()
			get_node("body").set_rot(0)
		
		var direction = position.x - get_pos().x
		if (direction < 0):
			get_node("body").get_node("Sprite").set_flip_h(true)
			get_node("body").get_node("shadow").set_flip_h(true)
		else:
			get_node("body").get_node("Sprite").set_flip_h(false)
			get_node("body").get_node("shadow").set_flip_h(false)

		set_pos(position)
		
func get_separation():
	var npcs = get_tree().get_nodes_in_group("npcs")
	var separation = Vector2()
	var neightborCount = 0
	for npc in npcs:
		var dist = npc.get_global_pos() - get_global_pos()
		if dist.length() < separationDist:
			var lerpValue = 1 - (dist.length() / separationDist)
			separation += dist.normalized() * -lerpValue
			neightborCount += 1
	
	return (separation / neightborCount)

func get_follow():
	var player = Globals.get("player")
	var dist = get_global_pos() - player.get_global_pos()
	var lerpValue = 1
	
	if dist.length() < followSlowRadius:
		lerpValue = dist.length() / followSlowRadius
	
	return dist.normalized() * -lerpValue

func conversion(p):
	if !converted:
		setHealth(max(0, health - 0.5))
		if health == 0:
			converted = true
			add_to_group("converted")
			get_node("body/Particles2D").set_emitting(true)
			print("convert")

func start_hit():
	var timeout = 0.5
	var dist = get_global_pos() - Globals.get("player").get_global_pos()
	if dist.length() < 800:
		timeout = dist.length() / 800 * 0.5
	get_node("HitTimer").set_wait_time(timeout)
	get_node("HitTimer").start()

func do_hit():
	for b in get_node("Area2D").get_overlapping_bodies():
		if b.is_in_group("npcs") and b != self:
				b.conversion(Globals.get("player"))
				Globals.get("player").newFollower(self)

func _on_Timer_timeout():
	get_node("AnimationPlayer").play("hit")

func setHealth(health):
	self.health = health
	get_node("ProgressBar").set_value(health)
	if self.health == 0 or converted:
		get_node("ProgressBar").hide()
	elif self.health < 1:
		get_node("ProgressBar").show()