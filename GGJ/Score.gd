extends Node

var score = 0;

func _ready():
	set_process (true)
	pass

func _process(delta):
	pass
	
func increment(amount):
	score += amount
	pass
	
func decrement(amount):
	score += amount
	pass
	
func get_score():
	return score
	pass
