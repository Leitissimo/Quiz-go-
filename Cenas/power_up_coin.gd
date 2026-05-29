extends Area2D

var is_ima_on: bool = false

const SPEED: float = 600.0
var acceleration: float = 1.0

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_ima_on:
		var direction: Vector2 = (player.position - self.position).normalized()
		
		position += direction * delta * SPEED * acceleration
		
		acceleration += delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AudioStreamPlayer2D.play()
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		GameManager.coins += 1
		GameManager.coins_total += 1
		body.setCoins()
		await $AudioStreamPlayer2D.finished
		call_deferred("queue_free")
		

func set_ima_on():
	is_ima_on = true
