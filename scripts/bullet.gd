extends Area3D

@export var speed = 5

var will_move: bool = false

func _ready() -> void:
	shoot()


func shoot():
	will_move = true

func _physics_process(delta: float) -> void:
	if not will_move:
		return

	position += basis.z * speed * delta

func _on_timer_timeout() -> void:
	print("taimou")
	queue_free()
