extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAM_SENSITIVITY = 0.01

# func _ready() -> void:
# 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Pivot.rotate_y(-event.relative.x * CAM_SENSITIVITY)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var direction = ($Pivot.global_transform.basis * Vector3(0, 0, 1)).normalized()
		$Lasso.throw(direction)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
	# var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = ($Pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir != Vector2.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
