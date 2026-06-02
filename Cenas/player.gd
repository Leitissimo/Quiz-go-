extends CharacterBody2D

signal stop_enemies

var player_shoot_scene = preload("res://Cenas/player_shoot.tscn")

@export var isCameraOn:bool

@export var up: String = "up"
@export var down: String = "down"
@export var left: String = "left"
@export var right: String = "right"

var speed: float = 500.0
var can_move: bool = true
var invuneravel: bool = false
var hp: int = GameManager.hp
var piscando: bool = false
var piscando_tween: Tween
var dano: int = GameManager.dano
var direction: Vector2
var dead: bool = false

@onready var player_animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if not isCameraOn:
		$Camera2D.queue_free()
		$TimerShoot.stop()
	hp = GameManager.hp
	dano = GameManager.dano
	speed = GameManager.speed
	$CanvasLayer/HBoxContainer/Label.text = "HEALTH: "+str(hp)
	GameManager.coins = 0

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("full screen") and DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		GameManager.full_screen = !GameManager.full_screen
		
		if get_tree().current_scene.name == "main-menu":
			$"../VBoxContainer2/Button".button_pressed = GameManager.full_screen
		
	elif Input.is_action_just_pressed("full screen") and DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		GameManager.full_screen = !GameManager.full_screen
		if get_tree().current_scene.name == "main-menu":
			$"../VBoxContainer2/Button".button_pressed = GameManager.full_screen
	
	if not dead:
		if can_move:
			direction = Input.get_vector(left, right, up, down).normalized()
			
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		
		player_animation.update_animation(velocity)
		
		move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not invuneravel and  isCameraOn:
		can_move = false
		emit_signal("stop_enemies")
		invuneravel = true
		


func get_closest_enemies(qtd_alvos: int) -> Array:
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	var living_enemies: Array = []
	
	for enemy in all_enemies:
		
		if not enemy.getDead():
			living_enemies.append(enemy)
			
	if living_enemies.is_empty():
		return []
		
	living_enemies.sort_custom(func(a, b):
		var dist_a = global_position.distance_to(a.global_position)
		var dist_b = global_position.distance_to(b.global_position)
		return dist_a < dist_b
	)
	
	return living_enemies.slice(0, qtd_alvos)

func shoot():
	
	var targets = get_closest_enemies(GameManager.qtd_tiro)
	
	if targets.is_empty():
		return

	for target in targets:
		
		if (target.global_position - global_position).length() < 1000:
			var player_shoot = player_shoot_scene.instantiate()
			player_shoot.setDamage(dano)
			
			var direction_to_target = (target.global_position - global_position).normalized()
			player_shoot.setDirection(direction_to_target)
			
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
		dead = true
		player_animation.death()

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


func _on_animated_sprite_2d_animation_finished() -> void:
	if player_animation.animation == "death":
		get_tree().call_deferred("change_scene_to_file", "res://Cenas/gameOver.tscn")
