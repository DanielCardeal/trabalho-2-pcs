extends HBoxContainer

# Sinal que indica o fim do jogo. O status indica se o jogador ganhou ou perdeu.
signal fim_jogo(status)

enum STATUS {GANHOU, PERDEU}

export var _pergunta : String
export var _solucao : String
export var _letras : String
export(PackedScene) var _cena_letra
export(PackedScene) var _cena_tentativa

onready var _label_pergunta := $PerguntaResposta/Pergunta
onready var _label_resposta := $PerguntaResposta/Resposta
onready var _vbox_botoes := $PerguntaResposta/Botoes
onready var _hbox_tentativas := $Tentativas
onready var _botao_confirma := $PerguntaResposta/HBoxContainer/Confirmar

var _tentativa : String = ""
var _num_tentativas := 0

func _ready():
	cria_botoes()
	_label_pergunta.text = _pergunta

func cria_botoes():
	for i in range(len(_letras)):
		var botao = _cena_letra.instance()
		var letra = _letras[i]
		botao.set_letra(letra)
		botao.connect('adiciona_letra', self, '_on_adiciona_letra')
		_vbox_botoes.add_child(botao)

# Adiciona *letra* à resposta
func _on_adiciona_letra(letra):
	if (len(_tentativa) + 1) == len(_solucao):
		_botao_confirma.disabled = false
		var botoes = _vbox_botoes.get_children()
		for i in range(len(_letras)):
			botoes[i].disabled = true
	_tentativa += letra
	_label_resposta.text = _tentativa

func testa_solucao():
	var resultado = conta_preto_branco()
	if resultado["branco"] == len(_solucao):
		emit_signal('fim_jogo', STATUS.GANHOU)
	elif _num_tentativas >= 10:
		emit_signal('fim_jogo', STATUS.PERDEU)
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
	_botao_confirma.disabled = true
	for botao in _vbox_botoes.get_children():
		botao.disabled = false

# Adiciona tentativa ao histórico de jogadas
func adiciona_tentativa(resultado):
	var instancia_tentativa = _cena_tentativa.instance()
	_hbox_tentativas.add_child(instancia_tentativa)
	instancia_tentativa.set_resultado(_tentativa, resultado)
	_num_tentativas += 1
	if _num_tentativas >= 10:
		emit_signal('fim_jogo', STATUS.PERDEU)

func _on_Refazer_pressed():
	reseta_tentativa()

func _on_Confirmar_pressed():
	testa_solucao()
