extends Control

onready var _texto = $HBoxContainer/Texto
onready var _num_brancos = $HBoxContainer/NumBrancos
onready var _num_pretos = $HBoxContainer/NumPretos

func set_resultado(tentativa, resultado):
	_texto.text = tentativa
	_num_brancos.text = str(resultado["branco"])
	_num_pretos.text = str(resultado["preto"])
