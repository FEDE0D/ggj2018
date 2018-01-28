extends Node2D

var audio

func _ready():
	audio = get_node("SamplePlayer2D")

func activate():
	for f in get_overlapping_bodies():
		if f.is_in_group("npcs"):
			if !f.salvado:
				f.salvado()
				audio.play("asencionPosta",0)

func changeColor():
	get_node("AnimationPlayer").play("loop")

func changeBack():
	get_node("AnimationPlayer").play("loop_complete")
	
