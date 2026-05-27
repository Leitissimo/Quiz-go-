extends Node

@export var spawn_points: Array[Marker2D] 
var power_up_coin_scene = preload("res://Cenas/power_up_coin.tscn")
var nuke_scene = preload("res://Cenas/nuke.tscn")
var skip_star_scene = preload("res://Cenas/skip_star.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_next_spawn_power_up_timeout() -> void:
	
	var itens = {
		"nuke": 4,    
		"star": 1  
		  
	}
	
	var peso_total = 0
	for peso in itens.values():
		peso_total += peso
		
	var sorteio = randi() % peso_total
	var soma_atual = 0
	
	for item in itens:
		soma_atual += itens[item]
		if sorteio < soma_atual:
			
			match item:
				"nuke": spawn_nuke()
				"star": spawn_star()
				
			break 
func spawn_coin():
	var ponto = spawn_points.pick_random() 
	
	if ponto.get_child_count() == 0:
		var coin = power_up_coin_scene.instantiate()
		
		ponto.add_child(coin) 

func spawn_nuke():
	var ponto = spawn_points.pick_random()
	
	if ponto.get_child_count() == 0:
		var nuke = nuke_scene.instantiate()
		ponto.add_child(nuke)

func spawn_star():
	var ponto = spawn_points.pick_random()
	
	if ponto.get_child_count() == 0:
		var star = skip_star_scene.instantiate()
		ponto.add_child(star)
