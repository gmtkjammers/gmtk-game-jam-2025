extends CharacterBody3D
@export var Lasso : Node3D

const JUMP_VELOCITY = 4.5
const CAM_SENSITIVITY = 0.01
@export var starting_speed = 5.0
@export var speed_adjust = 1.0
var head_point : Node3D
var seat_point : Node3D
@export var head_pin : Node3D
@export var seat_pin : Node3D
var hats : Array[Node3D]
var horses: Array[Node3D]
var hat_scene = preload("res://scenes/cosmetics/hat.tscn")
var horse_scene = preload("res://scenes/cosmetics/horse.tscn")
var speed = starting_speed*speed_adjust
func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head_point = head_pin
	seat_point = seat_pin

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * CAM_SENSITIVITY)


func increase_size(amt:float):
	$Pivot.scale += Vector3(amt, amt, amt)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#add_horse()

	var input_dir := Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
	# var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir != Vector2.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func add_hat():
	head_point = add_cosmetic(hat_scene, head_point, hats).get_node("head_pin")
	# print("adding hat, ", head_point.position)
	# var new_hat : Node3D = hat_scene.instantiate()
	# $Pivot.add_child(new_hat)
	# new_hat.global_position = head_point.global_position
	# new_hat.global_rotation = head_point.global_rotation
	# hats.append(new_hat)
	# head_point = new_hat.get_node("head_pin")

func add_horse():
	print("adding horse, ", head_point.position)
	var new_horse : Node3D = horse_scene.instantiate()
	var new_collider = new_horse.get_node("horse_collider")
	print("new collider", new_collider)
	new_collider.reparent(self)
	new_collider.global_position = seat_point.global_position - Vector3(0, new_horse.scale.y, 0)
	print("new horse", new_horse)
	$Pivot.add_child(new_horse)
	new_horse.global_position = seat_point.global_position - Vector3(0, new_horse.scale.y, 0)
	position += Vector3(0, new_horse.scale.y, 0)
	seat_point = new_horse.get_node("seat_pin")
	horses.append(new_horse)
	speed += 5


func add_cosmetic(scene , point, list):
	print("adding cosmetic", scene, point)
	var new_cosmetic: Node3D = scene.instantiate()
	$Pivot.add_child(new_cosmetic)
	new_cosmetic.global_position = point.global_position
	new_cosmetic.global_rotation = point.global_rotation
	list.append(new_cosmetic)
	return(new_cosmetic)

func remove_hat():
	if hats.size() > 0:
		hats.pop_back().queue_free()
		head_point = hats[-1].get_node("head_pin")
