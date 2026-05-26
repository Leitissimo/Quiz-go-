extends CharacterBody2D

var speed: float = 300.0;
var can_move = true;
var hp: int = int(2 + GameManager.waves/10)
const KNOCK_BACK_STRENGTH: int = 1200
@onready var animation_player = $AnimatedSprite2D

@onready var player = get_tree().get_first_node_in_group("player")

var coin = preload("res://Cenas/power_up_coin.tscn")

var isAttacking: bool = false
var dead: bool = false

func _physics_process(delta: float) -> void:
	print(hp)
	if not dead:
		if can_move and player != null:
			var direction: Vector2 = (player.position - self.position).normalized()
		
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		
		trigger_animation()
		move_and_slide()
	
func hit(damage: int):
	hp -= damage
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(2, 0.5, 0.5, 1), 0.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
	
	
	if hp <= 0:
		death()

func aplly_knockback(direction: Vector2):
	velocity = direction * KNOCK_BACK_STRENGTH
	can_move = false
	move_and_slide()
	$stunTimer.start()
	await $stunTimer.timeout
	can_move = true

func trigger_animation():
	
	if velocity.x > 0:
		animation_player.flip_h = false
	elif velocity.x < 0:
		animation_player.flip_h = true
	
	if (player.global_position - global_position).length() < 200 and can_move:
		animation_player.play("attack")
		isAttacking = true
	
	if not isAttacking:
		if velocity.length() > 0:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	

	
func death():
	$CollisionShape2D.set_deferred("disabled", true)
	dead = true
	animation_player.play("death")
	
func getDead() -> bool:
	return self.dead

func _on_animated_sprite_2d_animation_finished() -> void:
	
	if animation_player.animation == "death":
		if randi()%3:
			var coins = coin.instantiate()
			coins.global_position = self.global_position
			get_parent().add_child.call_deferred(coins)
		call_deferred("queue_free")
	
	if animation_player.animation == "attack":
		isAttacking = false
