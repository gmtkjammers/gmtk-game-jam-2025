extends Area3D

@export var speed = 5

var will_move: bool = false
var direction_to_move: Vector3

func _physics_process(delta: float) -> void:
	if not will_move:
		return

	position += direction_to_move * speed * delta

	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body is CharacterBody3D:
				body.take_damage()

func shoot(direction: Vector3):
	will_move = true
	direction_to_move = direction


func _on_timer_timeout() -> void:
	queue_free()
