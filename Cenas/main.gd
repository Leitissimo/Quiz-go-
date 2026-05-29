extends Node

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label =$quiz/Control/Panel/VBoxContainer/Label2
@onready var grid = $quiz/Control/Panel/VBoxContainer/GridContainer
var resposta_correta = ""
var cont: int = 5
var segundos: float

var banco_de_perguntas : Dictionary = {
	"Quanto é: 35 + 42 ?": 77,
	"Quanto é o dobro de 25?": 50,
	"Quanto é 20 + 20 + 20 + 7": 67,
	"Em uma caixa há 12 dúzias de ovos. Quantos ovos há no total?": 144,
	"Quanto é √16": 4,
	"Quanto é 40-15":25,
	"Quanto é 20% de 100":20,
	"Qual a area de um quadrado com lado 6":36,
	"Qual o divisor comum de 6 e 8":2,
	"Quanto é a 100+80":180,
	"Quanto é 10*10":100,
	"Quantos lados tem um pentagono":5,
	"Quanto é o raio de uma circunferência com diametro 10":5,
	"Quantos dias tem um ano bissexto":366,
	"Quanto é 15/5":3,
	"Quantas horas tem um dia":24,
	"Quantos minutos tem uma hora":60,
	"Quanto é 2+2x3":8,
	"Quanto é 14-5":9,
	"Quantos meses tem em um ano":12,
	"Quanto é 6x6":36,
	"Quanto é √49":7,
	"Quanto é 5 + 5 x 4":25,
	"Quanto é: 53 + 29":82,
	"Quanto é 14+13":27,
	"Quanto é 5x3+4":19,
	"Quanto é 5+5+6":16,
	"Quantos segundos tem 1 minuto":60,
	"Quantas letras tem a palavra QUARTO":6,
	"Quantos lados tem um dado":6,
	"Quantos dias tem uma semana":7,
	"Quanto é 9x2":18,
	"Quanto é 30+20":50,
	"Quanto é 9x0":0,
	"Quanto é √169":13,
	"Quanto é √4":2,
	"Qunto é 6x10+7":67,
	"Quantas letras tem um alfabeto":26,
	"Quantos gramas tem um quilograma":1000,
	"Quantas horas tem dois dias":48
}

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_stop_enemies() -> void:
	segundos = $music.get_playback_position()
	print(segundos)
	$music.stop()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.can_move = false
	gerar_pergunta()
	spawn_quizUI()
	$powerUpsSpawnPoints/timerSpawnGap.stop()
	$powerUpsSpawnPoints/timerNextSpawnPowerUp.stop()
	GameManager.quiz_aberto = true

func spawn_quizUI():
	$quiz/Control.show()
	if GameManager.skips > 0:
		$quiz/Control/Panel/VBoxContainer/skip_question.text = "Skips restantes: "+str(GameManager.skips)
		$quiz/Control/Panel/VBoxContainer/skip_question.show()
	else :
		$quiz/Control/Panel/VBoxContainer/skip_question.hide()

func gerar_pergunta():
	if banco_de_perguntas.is_empty():
		print("Todas as perguntas foram respondidas!")
		get_tree().call_deferred("change_scene_to_file", "res://Cenas/gameOver.tscn")
		return
	
	cont = 10
	$quiz/Control/Panel/VBoxContainer/Label.text = "Tempo: "+str(cont)
	$quiz/Control/timerQuiz.start()
	var chaves = banco_de_perguntas.keys() 
	var texto_pergunta = chaves.pick_random() 
	var resultado = banco_de_perguntas[texto_pergunta] 
	print(banco_de_perguntas[texto_pergunta])
	
	
	label.text = texto_pergunta
	resposta_correta = str(resultado)
	banco_de_perguntas.erase(texto_pergunta)
	
	var opcoes = [resposta_correta]
	while opcoes.size() < 4:
		var erro = str(resultado + randi_range(-3, 3))
		if not opcoes.has(erro):
			opcoes.append(erro)
	opcoes.shuffle()
	
	var botoes = grid.get_children()
	for i in range(botoes.size()):
		var btn = botoes[i]
		btn.text =  opcoes[i]
		if btn.pressed.is_connected(_ao_responder):
			btn.pressed.disconnect(_ao_responder)
		
		btn.pressed.connect(_ao_responder.bind(btn.text))


func _ao_responder(valor_clicado):
	if valor_clicado == resposta_correta:
		$acertou.play()
		
		continuar_jogo()
	else:
		$errou.play()
		player.hit()
		continuar_jogo()
	
func continuar_jogo():
	$music.play(segundos)
	$quiz/Control/timerQuiz.stop()
	var player = get_tree().get_first_node_in_group("player")
	player.setMove()
	player.piscar()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.can_move = true
	$quiz/Control.hide()
	$timerNextWave.start()
	$powerUpsSpawnPoints/timerNextSpawnPowerUp.start()
	$powerUpsSpawnPoints/timerSpawnGap.start()
	GameManager.quiz_aberto = false


func _on_timer_quiz_timeout() -> void:
	
	if cont > 0:
		cont -= 1
		$quiz/Control/Panel/VBoxContainer/Label.text = "Tempo: "+str(cont)
	else:
		$quiz/Control/timerQuiz.stop()
		player.hit()
		continuar_jogo()


func _on_skip_question_pressed() -> void:
	GameManager.skips -= 1
	continuar_jogo()
	$quiz/Control/timerQuiz.stop()
