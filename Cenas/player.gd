extends CharacterBody2D

signal stop_enemies

var player_shoot_scene = preload("res://Cenas/player_shoot.tscn")

var speed: float = 500.0
var can_move: bool = true
var invuneravel: bool = false
var hp: int = GameManager.hp
var piscando: bool = false
var piscando_tween: Tween
var dano: int = GameManager.dano

func _ready() -> void:
	hp = GameManager.hp
	dano = GameManager.dano
	$CanvasLayer/HBoxContainer/Label.text = "HEALTH: "+str(hp)

func _physics_process(delta: float) -> void:
	if can_move:
		var direction: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
		
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not invuneravel:
		can_move = false
		emit_signal("stop_enemies")
		invuneravel = true
		

func getClosestEnemy(indice_alvo: int = 0):
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty() or indice_alvo >= enemies.size():
		return null
	enemies.sort_custom(func(a, b):
		var dist_a = global_position.distance_to(a.global_position)
		var dist_b = global_position.distance_to(b.global_position)
		return dist_a < dist_b
	)
	return enemies[indice_alvo]

func shoot():
	for i in range(GameManager.qtd_tiro):
		var target = getClosestEnemy(i)
		if target != null:
			if (target.global_position - global_position).length() < 1000:
				var player_shoot = player_shoot_scene.instantiate()
				player_shoot.setDamage(dano)
				player_shoot.setDirection((target.global_position - global_position).normalized())
				player_shoot.position = self.position
				get_parent().add_child(player_shoot)


func _on_timer_shoot_timeout() -> void:
	if can_move:
		shoot()

func setMove():
	can_move = true
	invuneravel = true
	set_collision_mask_value(3, false)
	$timerInvencivel.start()
	await $timerInvencivel.timeout
	invuneravel = false
	set_collision_mask_value(3, true)
	parar_piscar()
	
func hit():
	hp -= 1
	if hp > 0:
		$CanvasLayer/HBoxContainer/Label.text = "HEALTH: " + str(hp)
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Cenas/gameOver.tscn")

func piscar():
	if piscando_tween and piscando_tween.is_valid():
		piscando_tween.kill()
	piscando_tween = create_tween().set_loops(0)
	piscando_tween.tween_property($AnimatedSprite2D, "modulate:a", 0.2, 0.1)
	piscando_tween.tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.1)
	
func parar_piscar():
	
	if piscando_tween and piscando_tween.is_valid():
		piscando_tween.kill()
	
	
	$AnimatedSprite2D.modulate.a = 1.0

func setWave():
	$CanvasLayer/HBoxContainer/Label2.text = "WAVE: "+str(GameManager.waves)

func setCoins():
	$CanvasLayer/HBoxContainer/Label3.text = "COINS: "+str(GameManager.coins)
