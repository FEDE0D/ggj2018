extends KinematicBody2D

var speed = 4
var converted = false
var separationDist = 500
var followSlowRadius = 100
var health = 1
var score
var character
export(int) var velocidad = 8

var salvado = false
var salvadoSpeed = 100
var salvadoAccel = 15

var waitAnimTime
var waitFlipTime

func _ready():
	score = get_node("/root/Score")
	set_process(true)
	salvadoAccel = rand_range(15, 30)
	waitAnimTime = rand_range(0, 1)
	waitFlipTime = rand_range(1, 6)
	character = get_random_character();
	get_node("body/Sprite").set_texture(load("res://assets/npcs/normal/" + str(character)))
	get_node("body/shadow").set_texture(load("res://assets/npcs/normal/" + str(character)))

func _process(delta):
	waitAnimTime -= delta
	waitFlipTime -= delta
	if waitAnimTime < 0:
		get_node("AnimationTreePlayer").set_active(true)
	if waitFlipTime < 0 and !converted:
		get_node("body").set_scale(get_node("body").get_scale() * Vector2(-1, 1))
		waitFlipTime = rand_range(1, 6)
	
	if salvado:
		set_global_pos(get_global_pos() + Vector2(0, -salvadoSpeed) * delta)
		salvadoSpeed += salvadoAccel
	
	if !converted:
		setHealth(min(1, health + 0.1 * delta))
	else:
		var separation = get_separation() * speed
		var follow = get_follow() * speed * (1 + Globals.get("player").getExtraSpeedRatio())
		var position = get_global_pos()
		position += separation
		position += follow
		
		for a in get_node("Area2D").get_overlapping_areas():
			if a.get_name() == "RescuePoint" && converted:
				a.activate()
		
		
		var distToTarget = get_global_pos() - position
		if distToTarget.length() < 150:
			var lerpValue = 1 - (distToTarget.length() / 150)
			position = get_global_pos().linear_interpolate(position, lerpValue)
		
		if distToTarget.length() > 0.5:
			get_node("AnimationTreePlayer").transition_node_set_current("transition", 2)
		else:
			get_node("AnimationTreePlayer").transition_node_set_current("transition", 1)
			get_node("body").set_rot(0)
		
		var direction = position.x - get_pos().x
		if (direction < 0):
			get_node("body").set_scale(Vector2(-1, 1))
		else:
			get_node("body").set_scale(Vector2(1, 1))
		set_pos(position)
		
		# if converted & far away from player
		if isAwayFromPlayer():
			setHealth(health + 0.25 * delta)
			if health + delta >= 1:
				converted = false
				remove_from_group("converted")
				get_node("AnimationTreePlayer").transition_node_set_current("transition", 1)
				get_node("/root/Score").decrement(1)
				get_node("body/Sprite").set_texture(load("res://assets/npcs/normal/" + str(character)))
				get_node("body/shadow").set_texture(load("res://assets/npcs/normal/" + str(character)))
		else:
			setHealth(0)
			
func isAwayFromPlayer():
	var distToPlayer = Globals.get("player").get_global_pos() - get_global_pos()
	return distToPlayer.length() > 500

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
		setHealth(max(0, health - 0.25))
		if health == 0:
			converted = true
			get_node("body/Sprite").set_frame(1)
			score.increment(1)
			score.increment_health(5);
			add_to_group("converted")
			get_node("body/Particles2D").set_emitting(true)
			get_node("Particles2D").set_emitting(true)
			get_node("body/Sprite").set_texture(load("res://assets/npcs/purified/" + str(character)))
			get_node("body/shadow").set_texture(load("res://assets/npcs/purified/" + str(character)))
			print("res://assets/npcs/purified/" + str(character));
			get_node("AnimationPlayer").seek(rand_range(0,1))

func start_hit():
	var timeout = 0.5
	var dist = get_global_pos() - Globals.get("player").get_global_pos()
	if dist.length() < 800:
		timeout = dist.length() / 800 * 0.5
	get_node("HitTimer").set_wait_time(timeout)
	get_node("HitTimer").start()
	#get_node("AnimationTreePlayer").transition_node_set_current("transition", 0)

func do_hit():
	for b in get_node("Area2D").get_overlapping_bodies():
		if b.is_in_group("npcs") and b != self:
				b.conversion(Globals.get("player"))
				Globals.get("player").newFollower(self)

func _on_Timer_timeout():
	get_node("AnimationTreePlayer").oneshot_node_start("oneshot")

func setHealth(health):
	self.health = health
	get_node("ProgressBar").set_value(health)
	if !converted:
		if self.health == 0:
			get_node("ProgressBar").hide()
		elif self.health < 1:
			get_node("ProgressBar").show()
		elif self.health >= 1:
			get_node("ProgressBar").hide()
	else:
		if isAwayFromPlayer():
			get_node("ProgressBar").show()
		else:
			get_node("ProgressBar").hide()

func salvado():
	salvado = true
	set_z(10)
	get_node("shadow").hide()
	get_node("AnimationTreePlayer").transition_node_set_current("transition", 0)
	Globals.get("player").salvados += 1

func get_random_character():
	var files = []
	var dir = Directory.new()
	dir.open("res://assets/npcs/normal")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files[randi()%files.size()+0]
