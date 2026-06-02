extends Node

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.x > 1300:
		player.position.x = -200
	
	elif player.position.x < -300:
		
		player.position.x = 1200
		
	if player.position.y < -200:
		player.position.y = 700
	
	elif player.position.y > 800:
		player.position.y = -100


func _on_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Cenas/main.tscn")


func _on_button_2_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Cenas/shop.tscn")


func _on_button_3_pressed() -> void:
	$VBoxContainer.hide()
	$VBoxContainer2.show()


func _on_return_to_menu_pressed() -> void:
	$VBoxContainer.show()
	$VBoxContainer2.hide()


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		GameManager.full_screen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		GameManager.full_screen = false


func _on_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
