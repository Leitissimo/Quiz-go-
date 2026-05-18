extends CharacterBody2D

var speed: float = 300.0;
var can_move = true;
var hp: int = 2
const KNOCK_BACK_STRENGTH: int = 1200

@onready var player = get_tree().get_first_node_in_group("player")

var coin = preload("res://Cenas/power_up_coin.tscn")

func _physics_process(delta: float) -> void:
	if can_move and player != null:
		var direction: Vector2 = (player.position - self.position).normalized()
	
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
func hit(damage: int):
	hp -= damage
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(2, 0.5, 0.5, 1), 0.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
	
	
	if hp <= 0:
		var coins = coin.instantiate()
		coins.global_position = self.global_position
		get_parent().add_child.call_deferred(coins)
		call_deferred("queue_free")

func aplly_knockback(direction: Vector2):
	velocity = direction * KNOCK_BACK_STRENGTH
	can_move = false
	move_and_slide()
	$stunTimer.start()
	await $stunTimer.timeout
	can_move = true
