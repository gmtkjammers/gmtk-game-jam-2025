extends CharacterBody3D
@export var Lasso : Node3D

const JUMP_VELOCITY = 4.5
const CAM_SENSITIVITY = 0.01
@export var starting_speed = 5.0
@export var speed_adjust = 1.0
var head_point : Node3D
@export var head_pin : Node3D
var hats : Array[Node3D]
var hat_scene = preload("res://scenes/cosmetics/hat.tscn")

var speed = starting_speed*speed_adjust
func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head_point = head_pin
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Pivot.rotate_y(-event.relative.x * CAM_SENSITIVITY)


func increase_size(amt:float):
	$Pivot.scale += Vector3(amt, amt, amt)

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
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func add_hat():
	print("adding hat, ", head_point.position)
	var new_hat : Node3D = hat_scene.instantiate()
	$Pivot.add_child(new_hat)
	new_hat.global_position = head_point.global_position
	new_hat.global_rotation = head_point.global_rotation
	hats.append(new_hat)
	head_point = new_hat.get_node("head_pin")

func remove_hat():
	if hats.size() > 0:
		hats.pop_back().queue_free()
		head_point = hats[-1].get_node("head_pin")
