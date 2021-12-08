extends Node

func _on_Button_pressed():
	get_tree().change_scene("res://cenas/jogo/introducao/introducao.tscn")

func _on_Crditos_pressed():
	get_tree().change_scene("res://cenas/jogo/creditos/creditos.tscn")
