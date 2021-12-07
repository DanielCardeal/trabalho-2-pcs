extends Node

var _puzzles := [
	load('res://cenas/jogo/puzzle/Puzzle1.tscn'),
	load('res://cenas/jogo/puzzle/Puzzle2.tscn'),
	load('res://cenas/jogo/puzzle/Puzzle3.tscn'),
	]

var _timelines := [
	'convocacao',
	'conversa_duende',
	]

func _ready():
	_on_puzzle_fim_jogo()

# No fim de um diálogo, começa um puzzle
func _on_dialogic_timeline_end(_dialogo):
	if len(_puzzles) == 0:
		return
	var prox_cena = _puzzles.pop_front().instance()
	prox_cena.connect('fim_jogo', self, '_on_puzzle_fim_jogo')
	add_child(prox_cena)

# No fim de um puzzle, passa para o próximo diálogo
func _on_puzzle_fim_jogo():
	if len(_timelines) == 0:
		return

	var timeline = _timelines.pop_front()
	var dialogo = Dialogic.start(timeline)
	dialogo.connect('timeline_end', self, '_on_dialogic_timeline_end')
	add_child(dialogo)
