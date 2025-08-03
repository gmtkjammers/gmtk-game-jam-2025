extends Area3D

@export var speed = 3
var direction_to_move: Vector3

func _ready() -> void:
	var kill_bullet = Timer.new()
	add_child(kill_bullet)
	kill_bullet.start(3)
	kill_bullet.timeout.connect(_on_timer_timeout)

func _physics_process(delta: float) -> void:
	position += direction_to_move * speed * delta
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body is CharacterBody3D:
				body.take_damage()
				queue_free()

func _on_timer_timeout() -> void:
	queue_free()
