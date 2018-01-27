extends Node2D


var speed = Vector2(0,0)
var move_speed = 2
var separation_speed = 3
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
		var separation = get_separation() * separation_speed
		var follow = get_follow() * move_speed
		var position = get_global_pos()
		position += separation
		position += follow
		
		var distToTarget = get_global_pos() - position
		if distToTarget.length() < 150:
			var lerpValue = 1 - (distToTarget.length() / 150)
			position = get_global_pos().linear_interpolate(position, lerpValue)
		
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
		if abs(dist.length()) < 100:
			separation += dist * -1
			neightborCount += 1
	
	return (separation / neightborCount).normalized()

func get_follow():
	var player = Globals.get("player")
	var dist = get_global_pos() - player.get_global_pos()
	return dist.normalized() * -1

func conversion(p):
	if !converted:
		player = p
		converted = true
		print("convert")
		