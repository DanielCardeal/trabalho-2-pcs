extends HBoxContainer

signal fim_jogo

export var _pergunta : String
export var _solucao : String
export var _letras : String

onready var _label_pergunta := $VBoxContainer/Pergunta
onready var _label_resposta := $VBoxContainer/Resposta
onready var _vbox_botoes := $VBoxContainer/Botoes
onready var _hbox_tentativas := $Tentativas

var _tentativa_cena := load("res://cenas/jogo/puzzle/Tentativa.tscn")
var _tentativa : String = ""

func _ready():
	cria_botoes()
	_label_pergunta.text = _pergunta

func cria_botoes():
	var botoes = _vbox_botoes.get_children()
	for i in range(len(_letras)):
		var botao = botoes[i]
		var letra = _letras[i]
		botao.set_letra(letra)
		botao.connect('adiciona_letra', self, '_on_adiciona_letra')

# Adiciona *letra* à resposta
func _on_adiciona_letra(letra):
	_tentativa += letra
	_label_resposta.text = _tentativa
	if len(_tentativa) >= len(_solucao):
		testa_solucao()

func testa_solucao():
	var resultado = conta_preto_branco()
	if resultado["branco"] == 4:
		pass
	else:
		adiciona_tentativa(resultado)
		reseta_tentativa()

# Conta o número de acertos completo (brancos) e parciais (pretos) para uma dada
# tentativa
func conta_preto_branco():
	var n = len(_solucao)
	if len(_tentativa) != n:
		return {"preto": 0, "branco": 0}
	var branco = 0
	var preto = 0
	# Conta brancas
	for i in range(n):
		if _tentativa[i] == _solucao[i]:
			branco += 1
	# Conta pretas
	for c in _solucao:
		if _tentativa.find(c) != -1:
			preto += 1
	preto -= branco
	return {"preto": preto, "branco": branco}


func reseta_tentativa():
	_tentativa = ""
	_label_resposta.text = _tentativa
	for botao in _vbox_botoes.get_children():
		botao.disabled = false

# Adiciona tentativa ao histórico de jogadas
func adiciona_tentativa(resultado):
	var instancia_tentativa = _tentativa_cena.instance()
	_hbox_tentativas.add_child(instancia_tentativa)
	instancia_tentativa.set_resultado(_tentativa, resultado)
