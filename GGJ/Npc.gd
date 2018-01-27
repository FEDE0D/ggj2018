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
		var separation = get_separation() * 1
		var follow = get_follow() * 1
		set_pos(get_pos() + separation + follow)
		
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
		