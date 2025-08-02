extends "res://scripts/Enemy.gd"

@export var bullet_scene = preload("res://scenes/mobs/bullet.tscn")
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

	var nav_pos_direction: Vector3 = (next_nav_pos - position).normalized()

	# Probably should be done in a better way than this
	if next_nav_pos != position and not player_is_in_range:
		rotation.y = lerpf(rotation.y, atan2(nav_pos_direction.x, nav_pos_direction.z), turn_speed * delta)

	velocity = nav_pos_direction * speed
	move_and_slide()

	if player_is_in_range:
		var look_pos = Vector3(player_body.position.x, position.y, player_body.position.z)
		var player_direction = (look_pos - position).normalized()
		rotation.y = lerpf(rotation.y, atan2(player_direction.x, player_direction.z), turn_speed * delta)


func _shoot_and_reset_timer() -> void:
	var bullet = bullet_scene.instantiate() as Node3D
	get_tree().root.add_child(bullet)
	bullet.global_position = bulletSpawn.global_position
	bullet.global_rotation = bulletSpawn.global_rotation

	print("-------------")
	print(name, " shooting")
	var direction = (player_body.position - bulletSpawn.global_position).normalized()

	bullet.shoot(direction)
	shoot_timer.start(shoot_cooldown)


func _on_player_enter_range() -> void:
	look_at(player.position, Vector3.UP, true)

	shoot_timer.start(shoot_cooldown / 2)


func _on_player_leave_range() -> void:
	shoot_timer.stop()

func _on_timer_timeout() -> void:
	_shoot_and_reset_timer()
