extends "res://scripts/Enemy.gd"

@export var bullet_scene = preload("res://scenes/bullet.tscn")

var bulletSpawn: Node3D

func _ready() -> void:
	super._ready()

	bulletSpawn = $BulletSpawn

	player_entered_range.connect(_on_player_enter_range)
	player_left_range.connect(_on_player_leave_range)


func _on_player_enter_range() -> void:
	print("player entered range")

	look_at(player.position, Vector3.UP, true)

	var bullet = bullet_scene.instantiate() as Node3D
	get_tree().root.add_child(bullet)
	bullet.global_position = bulletSpawn.global_position
	bullet.global_rotation = bulletSpawn.global_rotation


func _on_player_leave_range() -> void:
	print("player left range")
