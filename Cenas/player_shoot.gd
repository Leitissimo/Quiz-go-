extends Area2D

var speed: float = 900.0
var direction: Vector2 
var damage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * delta * direction

func setDirection(direction):
	self.direction = direction
	rotation = direction.angle()

func setDamage(damage):
	self.damage = damage

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		
		body.hit(damage)
		body.aplly_knockback(direction)
		
		queue_free()
	elif body.is_in_group("wall"):
		call_deferred("queue_free")
