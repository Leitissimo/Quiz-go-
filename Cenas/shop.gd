extends Node

@onready var alerta = $alerta

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "COINS: "+str(GameManager.coins_total)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	GameManager.save_game()
	get_tree().change_scene_to_file("res://Cenas/main.tscn")
	

func _on_hp_1_pressed() -> void:
	
	$AudioStreamPlayer2D.play()
	if GameManager.coins_total >= 10:
		GameManager.coins_total -= 10
		GameManager.hp += 1
		$Label.text = "COINS: "+str(GameManager.coins_total)
	else :
		alert()
		
	GameManager.save_game()


func _on_dano_1_pressed() -> void:
	
	$AudioStreamPlayer2D.play()
	if GameManager.coins_total >= 10:
		GameManager.coins_total -= 10
		GameManager.dano += 1
		$Label.text = "COINS: "+str(GameManager.coins_total)
	else :
		alert()
	
	GameManager.save_game()


func _on_tiro_1_pressed() -> void:
	
	$AudioStreamPlayer2D.play()
	if GameManager.coins_total >= 30:
		GameManager.coins_total -= 30
		GameManager.qtd_tiro += 1
		$Label.text = "COINS: "+str(GameManager.coins_total)
	else:
		alert()
	
	GameManager.save_game()


func _on_quit_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()


func alert():
	$GridContainer.hide()
	alerta.popup_centered()


func _on_alerta_confirmed() -> void:
	$GridContainer.show()


func _on_alerta_canceled() -> void:
	$GridContainer.show()


func _on_velocity_pressed() -> void:
	
	$AudioStreamPlayer2D.play()
	if GameManager.coins_total >= 30:
		GameManager.coins_total -= 30
		GameManager.speed += 50
		$Label.text = "COINS: "+str(GameManager.coins_total)
	else:
		alert()
