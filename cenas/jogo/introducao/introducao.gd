extends Node

func _ready():
	var diag_intro = Dialogic.start('convocacao')
	add_child(diag_intro)
