extends Button

signal adiciona_letra(letra)

var _letra : String

# Escolhe a letra para mostrar no botão
func set_letra(letra):
	text = letra
	_letra = letra

func _on_pressed():
	disabled = true
	emit_signal('adiciona_letra', _letra)
