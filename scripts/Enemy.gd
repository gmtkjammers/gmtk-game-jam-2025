extends CharacterBody3D

@export var speed = 5
@export var max_move_offset = 5

var navigation: NavigationAgent3D

var targetPosition = Vector3.ZERO

func _ready() -> void:
	navigation = $NavigationAgent3D
	navigation.target_position = _get_random_position()
	print(navigation.target_position)


func _physics_process(_delta: float) -> void:
	if (navigation.is_navigation_finished()):
		print("nav finished")
		return

	var nextPos = navigation.get_next_path_position()

	# if (nextPos == position):
	# 	nextPos = _get_random_position()
	# 	navigation.target_position = nextPos

	var direction = (nextPos - position).normalized()

	print("currentPos: ", position)
	print("nexPos: ", nextPos)
	print("direction: ", direction)

	velocity = direction * speed

	move_and_slide()

func _get_random_position() -> Vector3:
	var rng = RandomNumberGenerator.new()

	var randomX = randf_range(-max_move_offset, max_move_offset)
	var randomZ = randf_range(-max_move_offset, max_move_offset)

	var offset_x = position.x + randomX
	var offset_z = position.z + randomZ

	return Vector3(offset_x, position.y, offset_z)

func _update_target_position() -> void:
	var random_pos = _get_random_position()
	navigation.target_position = random_pos
	
	if not navigation.is_target_reachable():
		_update_target_position()


func _on_navigation_agent_3d_navigation_finished() -> void:
	_update_target_position()
