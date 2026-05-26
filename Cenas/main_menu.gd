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
