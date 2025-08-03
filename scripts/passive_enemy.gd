extends "res://scripts/Enemy.gd"

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	var nav_pos_direction: Vector3 = (next_nav_pos - position).normalized()

	# Probably should be done in a better way than this
	if next_nav_pos != position:
		rotation.y = lerpf(rotation.y, atan2(nav_pos_direction.x, nav_pos_direction.z), turn_speed * delta)

	velocity = nav_pos_direction * speed
	move_and_slide()

func _get_position_away_from_player() -> Vector3:
	var dir_away_from_player = position.direction_to(player_body.position) * -1

	var offset_angle = randf_range(-90, 90)

	dir_away_from_player.rotated(Vector3.UP, offset_angle)
	dir_away_from_player.y = 0

	var new_pos = position + (dir_away_from_player * max_move_offset)
	return new_pos

func _on_navigation_finished() -> void:
	if player_is_in_range:
		_update_target_position(_get_position_away_from_player())
		return
	
	super._on_navigation_finished()