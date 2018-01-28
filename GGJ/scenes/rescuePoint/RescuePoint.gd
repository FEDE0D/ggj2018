extends Node2D

func _ready():
	pass

func activate():
	for f in get_overlapping_bodies():
		if f.is_in_group("npcs"):
			f.salvado()