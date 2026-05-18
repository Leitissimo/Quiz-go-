extends Node

@export var spawn_points: Array[Marker2D]
var Enemy: PackedScene = preload("res://Cenas/enemy.tscn")
var wave: int = 1
var inimigos_vivos: int = 0 
@onready var player = get_tree().get_first_node_in_group("player")

var spawners_ativos: int = 0

func _ready() -> void:
	spawn_enemies()

func spawn_enemies():
	
	if inimigos_vivos >= 15:
		return
		
	spawners_ativos += 1
	$"../timerNextWave".start()
	

	var quantidade = wave 
	
	for i in range(quantidade):

		if inimigos_vivos >= 15 or GameManager.quiz_aberto:
			break
			
		var enemy = Enemy.instantiate()
		var ponto_aleatorio = spawn_points.pick_random()
		enemy.position = ponto_aleatorio.position
		
		enemy.tree_exited.connect(_ao_inimigo_morrer)
		get_parent().add_child.call_deferred(enemy)
		inimigos_vivos += 1
		
		$"../powerUpsSpawnPoints/timerSpawnGap".start()
		await $"../powerUpsSpawnPoints/timerSpawnGap".timeout

	spawners_ativos -= 1

func _ao_inimigo_morrer():
	
	if not is_inside_tree(): return
	
	inimigos_vivos -= 1
	GameManager.enemies_killed += 1
	

	if inimigos_vivos <= 0 and spawners_ativos == 0:
		wave += 1
		GameManager.waves = wave
		player.setWave()
		spawn_enemies()

	elif inimigos_vivos < 15 and spawners_ativos == 0:

		if $"../timerNextWave".is_stopped() and not GameManager.quiz_aberto:
			spawn_enemies()

func _on_timer_next_wave_timeout() -> void:
	if GameManager.quiz_aberto:
		return
		
	$"../powerUpsSpawnPoints/timerSpawnGap".stop()
	wave += 1
	GameManager.waves = wave
	player.setWave()
	spawn_enemies()

func _on_player_stop_enemies() -> void:
	$"../timerNextWave".stop()
	$"../powerUpsSpawnPoints/timerSpawnGap".stop()
	GameManager.waves = wave
