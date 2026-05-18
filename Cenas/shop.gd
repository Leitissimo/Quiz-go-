extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "COINS: "+str(GameManager.coins_total)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/main.tscn")


func _on_hp_1_pressed() -> void:
	if GameManager.coins_total >= 10:
		GameManager.coins_total -= 10
		GameManager.hp += 1
		$Label.text = "COINS: "+str(GameManager.coins_total)
	else :
		print("saldo insuficiente")


func _on_dano_1_pressed() -> void:
	if GameManager.coins_total >= 10:
		GameManager.coins_total -= 10
		GameManager.dano += 1
		$Label.text = "COINS: "+str(GameManager.coins_total)
	else :
		print("saldo insuficiente")


func _on_tiro_1_pressed() -> void:
	pass # Replace with function body.
