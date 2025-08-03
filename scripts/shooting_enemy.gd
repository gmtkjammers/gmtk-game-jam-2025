extends "res://scripts/Enemy.gd"

var bullet_scene = preload("res://scenes/mobs/bullet.tscn")
@export var shoot_cooldown: float = 2
@export var shooting_range: float = 10
var player_is_in_shooting_range
@export var bulletSpawn: Node3D
var cooldown = false

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	_check_if_player_in_shooting_range()
	if player_is_in_shooting_range:
		look_at(player_body.global_position)
		shoot_gun()
	super._physics_process(delta)


func _check_if_player_in_shooting_range() -> void:
	var distance = global_position.distance_to(player_body.global_position)

	if distance <= shooting_range:
		player_is_in_shooting_range = true
	
	elif distance > shooting_range :
		player_is_in_shooting_range = false


func shoot_gun():
	if cooldown: return
	print("bang!")
	cooldown = true
	var shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	add_child(shoot_timer)
	shoot_timer.timeout.connect(reset_cooldown)
	shoot_timer.start(2)
	var bullet = bullet_scene.instantiate()
	print(bullet)
	get_tree().get_root().add_child(bullet)
	bullet.global_position = bulletSpawn.global_position
	bullet.direction_to_move = (player_body.global_position - bulletSpawn.global_position).normalized()

func reset_cooldown():
	print("cooldown over!")
	cooldown = false
