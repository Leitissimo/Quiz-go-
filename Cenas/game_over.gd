extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/GridContainer/Label2.text = str(GameManager.waves)
	$VBoxContainer/GridContainer/Label4.text = str(GameManager.coins)
	$VBoxContainer/GridContainer/Label6.text = str(GameManager.enemies_killed)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	GameManager.restart()
	get_tree().change_scene_to_file("res://Cenas/main.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/shop.tscn")
