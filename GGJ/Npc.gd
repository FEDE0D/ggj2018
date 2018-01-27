extends Node2D

var speed = 4
var converted = false
var separationDist = 500
var followSlowRadius = 100

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	if converted:
		var separation = get_separation() * speed
		var follow = get_follow() * speed * 0.7
		var position = get_global_pos()
		position += separation
		position += follow
		
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
		converted = true