extends Node

var SAVE_PATH: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/QuizGo_Save.cfg"

var coins: int = 0
var waves: int = 0
var enemies_killed: int = 0
var skips: int = 0
var coins_total = 0
var hp: int = 3
var dano: int = 1
var qtd_tiro: int = 1
var quiz_aberto: bool = false


func _ready() -> void:
	load_game()


func _process(delta: float) -> void:
	pass


func restart():
	waves = 0
	enemies_killed = 0
	skips = 0
	coins = 0


func save_game() -> void:
	var config = ConfigFile.new()
	
	config.set_value("Player", "hp", hp)
	config.set_value("Player", "dano", dano)
	config.set_value("Player", "qtd_tiro", qtd_tiro)
	config.set_value("Stats", "coins_total", coins_total)
	
	config.save(SAVE_PATH)


func load_game() -> void:
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		print("arquivo n existe")
		return
		
	hp = config.get_value("Player", "hp", 3)
	dano = config.get_value("Player", "dano", 1)
	qtd_tiro = config.get_value("Player", "qtd_tiro", 2)
	coins_total = config.get_value("Stats", "coins_total", 0)


func _notification(what: int) -> void:
	
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game() 
		get_tree().quit() 
