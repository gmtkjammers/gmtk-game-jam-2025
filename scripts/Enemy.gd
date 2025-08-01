extends CharacterBody3D

@export var speed = 5
@export var turn_speed : float = 5
@export var max_move_offset = 5
@export var player_detection_range = 5

var navigation: NavigationAgent3D
@export var player: Node3D
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

func _ready() -> void:
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

	for node in player.get_children():
		if node is CharacterBody3D:
			player_body = node

func _physics_process(delta: float) -> void:
	if navigation == null:
		return

	if (navigation.is_navigation_finished()):
		print("nav finished")
		return

	var nextPos = navigation.get_next_path_position()
	var direction: Vector3 = (nextPos - position).normalized()

	velocity = direction * speed

	# Probably should be done in a better way than this
	if nextPos != position and not player_is_in_range:
		rotation.y = lerpf(rotation.y, atan2(direction.x, direction.z), turn_speed * delta)
	move_and_slide()

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
func _update_target_position() -> void:
	var random_pos = _get_random_position()
	navigation.target_position = random_pos
	
	if not navigation.is_target_reachable():
		if counter > 100:
			counter = 0
			return
		counter += 1
		_update_target_position()
	else:
		counter = 0

func _on_navigation_finished() -> void:
	_update_target_position()
