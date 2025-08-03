extends CharacterBody3D

@export var speed = 3
@export var turn_speed : float = 5
@export var max_move_offset = 5
@export var player_detection_range = 15
@export var hat = false
@export var horse = false
## Number to describe ground offset on the y axis for navigation, should be negative
@export var horse_height_offset: float
var hat_scene = preload("res://scenes/cosmetics/hat.tscn")
var horse_scene = preload("res://scenes/cosmetics/horse.tscn")

var player_is_in_range: bool = false
var player_body: CharacterBody3D

var next_nav_pos: Vector3 = Vector3.ZERO

func _ready() -> void:

	player_body = get_tree().current_scene.find_child("Player").find_child("PlayerBody") as CharacterBody3D
	if (player_body == null): 
		print(name, " got null player_body")

	if hat:
		var new_hat : Node3D = hat_scene.instantiate()
		#new_hat.global_position = $Pivot/head_pin.global_position
		add_child(new_hat)
		new_hat.global_position = $Pivot/head_pin.global_position

	if horse:
		position += Vector3(0, 1, 0)
		var new_horse : Node3D = horse_scene.instantiate()
		new_horse.position = $Pivot/seat_pin.position
		#new_horse.rotation = $Pivot/seat_pin.rotation
		add_child(new_horse)

func _physics_process(_delta: float) -> void:

	_check_if_player_in_range()

	if player_is_in_range:
		_run_away()
	else:
		velocity = Vector3.ZERO
	rotation.y += _delta
	move_and_slide()

func _run_away():
	#move away from player
	var direction = (global_position- player_body.global_position).normalized()
	look_at(direction)
	velocity = direction * speed
	velocity.y = 0

func _check_if_player_in_range() -> void:
	var distance = global_position.distance_to(player_body.global_position)

	if distance <= player_detection_range:
		player_is_in_range = true
	
	elif distance > player_detection_range :
		player_is_in_range = false
