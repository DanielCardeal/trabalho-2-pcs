extends VBoxContainer

var _creditos := []
var _terminou := false
var _tela = 0
var _tempo = 0
var _tempo_por_tela := 4.5

func _ready():
	var file = File.new()
	file.open("res://creditos.json", file.READ)
	var json = file.get_as_text()
	_creditos = JSON.parse(json).result
	file.close()

func _process(delta):
	if (_tela <= len(_creditos) - 1):
		_tempo = _tempo + delta
		#print(_tempo, delta)
		if (_tempo > _tempo_por_tela):
			_reseta_tela()
			_proxima_tela()
			_tela += 1
			_tempo = 0
	else:
		if !(_terminou):
			_reseta_tela()
			_add_botao_retorno()
			_terminou = true
			
func _reseta_tela():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
		
func _proxima_tela():
	var linha_vazia = _devolve_linha(" ")
	var linha = _devolve_linha(_creditos[_tela]["Titulo"])
	self.add_child(linha)
	self.add_child(linha_vazia)
	for i in range(len(_creditos[_tela]["Nomes"])):
		linha = _devolve_linha(_creditos[_tela]["Nomes"][i])
		self.add_child(linha)
			
func _devolve_linha(texto):
	var linha = Label.new()
	linha.text = texto
	linha.align = Label.ALIGN_CENTER
	linha.valign = Label.VALIGN_CENTER
	return linha

func _add_botao_retorno():
	var botao = Button.new()
	botao.text = "τελα ινιχιαλ"
	botao.rect_size = Vector2(200, 30)
	botao.connect("pressed", self, "_volta_tela_inicial")
	self.add_child(botao)
	
func _volta_tela_inicial():
	get_tree().change_scene("res://cenas/jogo/tela_inicial/tela_inicial.tscn")
