extends Node

var coins: int = 0
var waves: int = 0
var enemies_killed: int = 0
var skips: int = 0
var coins_total = 0
var hp: int = 3
var dano:int = 1
var qtd_tiro:int = 2
var quiz_aberto: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restart():
	waves = 0
	enemies_killed = 0
	skips = 0
	coins = 0
