extends Node

var score = 0;
var health = 50;

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
	
func set_health(new_health):
	health = new_health
	pass
	
func get_health():
	return health
	pass
	
func increment_health(amount):
	health += amount
	pass