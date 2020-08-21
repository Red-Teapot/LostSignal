extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("gameplay_left"):
		position.x -= 100 * delta
	if Input.is_action_pressed("gameplay_right"):
		position.x += 100 * delta
	if Input.is_action_pressed("gameplay_up"):
		position.y -= 100 * delta
	if Input.is_action_pressed("gameplay_down"):
		position.y += 100 * delta
