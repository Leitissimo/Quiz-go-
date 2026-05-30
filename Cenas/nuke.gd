extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void :
	if body.is_in_group("player"):
		$AudioStreamPlayer2D.play()
		executar_nuke_circulo()
		explodir()

func explodir():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.call_deferred("queue_free")

func executar_nuke_circulo():
	var layer = CanvasLayer.new()
	add_child(layer)
	
	var nuke_visual = ColorRect.new()
	
	var material = ShaderMaterial.new()
	var shader = Shader.new()
	shader.code = """
		shader_type canvas_item;
		void fragment() {
			float dist = distance(UV, vec2(0.5));
			if (dist > 0.5) {
				discard;
			}
		}
	"""
	material.shader = shader
	nuke_visual.material = material
	
	nuke_visual.color = Color.RED
	nuke_visual.modulate.a = 0.5
	
	
	nuke_visual.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	nuke_visual.size = Vector2(200, 200) 
	nuke_visual.pivot_offset = nuke_visual.size / 2
	nuke_visual.scale = Vector2.ZERO
	
	layer.add_child(nuke_visual)
	
	var tween = create_tween()
	
	
	tween.tween_property(nuke_visual, "scale", Vector2(80, 80), 4.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(nuke_visual, "modulate:a", 0.0, 2.5)\
		.set_delay(0.5)
	
	tween.tween_callback(layer.queue_free)
	set_collision_mask_value(2, false)
	hide()
	await tween.finished
	call_deferred("queue_free")
