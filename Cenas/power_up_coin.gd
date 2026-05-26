extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
		
