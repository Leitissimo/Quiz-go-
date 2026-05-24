extends AnimatedSprite2D


func update_animation(velocity: Vector2):
	
	if velocity.x > 0:
		flip_h = false
	elif velocity.x < 0:
		flip_h = true
		
	if velocity.length() > 0:
		play("walk")
	else:
		play("idle")
	
	
func death():
	play("death")
