extends Node

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label =$quiz/Control/Panel/VBoxContainer/Label2
@onready var grid = $quiz/Control/Panel/VBoxContainer/GridContainer
var resposta_correta = ""
var cont: int = 5
var segundos: float

var banco_de_perguntas : Dictionary = {
	"Quanto é: 35 + 42 ?": 77,
	"Uma dúzia de ovos mais meia dúzia dá quanto?": 18,
	"Se um triângulo tem 3 lados, quantos lados têm 4 triângulos?": 12,
	"Quanto é o dobro de 25?": 50,
	"Quanto é 20 + 20 + 20 + 7": 67,
	"Em uma caixa há 12 dúzias de ovos. Quantos ovos há no total?": 144,
	"Quanto é: 1/2 + 1/4": 0.75
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
	
	cont = 5
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
