extends Node

var score = 0;

func _ready():
	print("instancing")
	set_process (true)
	pass

func _process(delta):
	_increment(1)
	pass
	
func _increment(amount):
	score += amount
	pass
	
func get_score(amount):
	score += amount
	pass
