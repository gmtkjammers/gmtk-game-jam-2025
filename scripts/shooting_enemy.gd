extends "res://scripts/Enemy.gd"

@export var bullet_scene = preload("res://scenes/bullet.tscn")
@export var shoot_cooldown: float = 2

var bulletSpawn: Node3D
var shoot_timer: Timer

func _ready() -> void:
	super._ready()

	bulletSpawn = $BulletSpawn
	shoot_timer = $ShootTimer

	player_entered_range.connect(_on_player_enter_range)
	player_left_range.connect(_on_player_leave_range)

	shoot_timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if player_is_in_range:
		var look_pos = Vector3(player_body.position.x, position.y, player_body.position.z)
		look_at(look_pos, Vector3.UP, true)


func _shoot_and_reset_timer() -> void:
	var bullet = bullet_scene.instantiate() as Node3D
	get_tree().root.add_child(bullet)
	bullet.global_position = bulletSpawn.global_position
	bullet.global_rotation = bulletSpawn.global_rotation

	shoot_timer.start(shoot_cooldown)


func _on_player_enter_range() -> void:
	look_at(player.position, Vector3.UP, true)

	shoot_timer.start(shoot_cooldown / 2)


func _on_player_leave_range() -> void:
	shoot_timer.stop()

func _on_timer_timeout() -> void:
	_shoot_and_reset_timer()
