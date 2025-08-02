extends "res://scripts/Enemy.gd"

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	var nav_pos_direction: Vector3 = (next_nav_pos - position).normalized()

	# Probably should be done in a better way than this
	if next_nav_pos != position:
		rotation.y = lerpf(rotation.y, atan2(nav_pos_direction.x, nav_pos_direction.z), turn_speed * delta)

	velocity = nav_pos_direction * speed
	move_and_slide()