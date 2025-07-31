extends CharacterBody3D

@export var speed = 14


func _physics_process(_delta: float) -> void:
	var direction = Vector3.ZERO
	var targetVelocity = Vector3.ZERO
	
	if (Input.is_action_pressed("move_backward")):
		direction.z += 1
	if (Input.is_action_pressed("move_forward")):
		direction.z -= 1
	if (Input.is_action_pressed("move_left")):
		direction.x -= 1
	if (Input.is_action_pressed("move_right")):
		direction.x += 1
	
	targetVelocity.x = speed * direction.normalized().x
	targetVelocity.z = speed * direction.normalized().z
	
	velocity = targetVelocity
	
	# var mouse_pos: Vector3 = _get_mouse_position()
	# print("mouse position: ",mouse_pos)
	
	
	# $Pivot.look_at(mouse_pos, Vector3.UP, true)
	# $Pivot.rotation_degrees.x = 0
	
	move_and_slide()

# func _get_mouse_position() -> Vector3:
# 	var mouse_position = get_viewport().get_mouse_position()
# 	var camera: Camera3D = get_node("../CameraPivot/Camera3D")
	
# 	var ray_origin = camera.project_ray_origin(mouse_position)
# 	var ray_target = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	
# 	var space_state = get_world_3d().direct_space_state
# 	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_target,1))
	
# 	if not intersection.is_empty():
# 		var pos = intersection.position
# 		return pos
	
# 	return Vector3.ZERO
