extends CharacterBody3D

@export var speed = 3
@export var turn_speed : float = 5
@export var max_move_offset = 5
@export var player_detection_range = 5

var navigation: NavigationAgent3D
@export var hat = false
@export var horse = false
## Number to describe ground offset on the y axis for navigation, should be negative
@export var horse_height_offset: float

signal player_entered_range
signal player_left_range
var hat_scene = preload("res://scenes/cosmetics/hat.tscn")
var horse_scene = preload("res://scenes/cosmetics/horse.tscn")

var player_is_in_range: bool = false
var player_body: CharacterBody3D

var next_nav_pos: Vector3 = Vector3.ZERO

func _ready() -> void:

	player_body = get_tree().current_scene.find_child("Player").find_child("PlayerBody") as CharacterBody3D
	if (player_body == null): 
		print(name, " got null player_body")

	navigation = $NavigationAgent3D
	navigation.target_position = _get_random_position()
	navigation.navigation_finished.connect(_on_navigation_finished)

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
		navigation.path_height_offset = horse_height_offset

func _physics_process(_delta: float) -> void:
	if navigation == null:
		return

	if (navigation.is_navigation_finished()):
		print("nav finished")
		return

	next_nav_pos = navigation.get_next_path_position()

	_check_if_player_in_range()

# Doing this since Area3D signals completely fall apart when the 2 areas are moving
func _check_if_player_in_range() -> void:
	var distance = position.distance_to(player_body.position)

	if distance <= player_detection_range and not player_is_in_range:
		player_entered_range.emit()
		player_is_in_range = true
	
	elif distance > player_detection_range and player_is_in_range:
		player_left_range.emit()
		player_is_in_range = false

func _get_random_position() -> Vector3:
	var randomX = randf_range(-max_move_offset, max_move_offset)
	var randomZ = randf_range(-max_move_offset, max_move_offset)

	var offset_x = position.x + randomX
	var offset_z = position.z + randomZ

	return Vector3(offset_x, position.y, offset_z)

var counter = 0
func _update_target_position(pos: Vector3) -> void:
	navigation.target_position = pos
	
	if not navigation.is_target_reachable():
		print("invalid pos, getting random")
		if counter > 100:
			counter = 0
			return
		counter += 1
		_update_target_position(_get_random_position())
	else:
		counter = 0

func _on_navigation_finished() -> void:
	_update_target_position(_get_random_position())
