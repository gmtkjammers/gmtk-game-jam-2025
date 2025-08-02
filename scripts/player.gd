extends CharacterBody3D
@export var Lasso : Node3D
@export var size : float = 10
const INITIAL_SIZE : float = 20
const JUMP_VELOCITY = 0.5
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
@export var cursor: Node3D
@export var camera : Camera3D
var camera_offset : Vector3 = Vector3(0, 0, 0)
var camera_initial_offset : Vector3 = Vector3(0, 0, 0)
var zoom_level : float = -4
var max_zoom : int = 12
var min_zoom : int = -7

@export var hit_timer : Timer
@export var hit_invul_time: float = 2

var can_take_damage = true
var can_move = true

signal player_died

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head_point = head_pin
	seat_point = seat_pin
	add_hat()
	add_hat()
	hit_timer.timeout.connect(on_hit_invul_timeout)
	camera_initial_offset = camera.global_position
	camera_offset = camera_initial_offset
	zoom_mouse(0)
	camera.global_position = global_position + camera_offset 

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func look_at_cursor():
	var player_pos = global_transform.origin
	var dropPlane = Plane(Vector3(0,1,0), player_pos.y)
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from, to)
	if cursor_pos:
		cursor.global_transform.origin = cursor_pos + Vector3(0,1,0)
		look_at(cursor_pos, Vector3.UP, true)

func _input(event: InputEvent) -> void:
	if not can_move:
		return
	look_at_cursor()
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_mouse(-1)
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_mouse(1)
func _physics_process(delta: float) -> void:
	#update scale
	scale = Vector3(1,1,1) * (size / INITIAL_SIZE)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta

	if not can_move:
		return

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * size
		#add_horse()

	var input_dir := Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir != Vector2.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	camera.global_position = global_position + camera_offset 

func add_hat():
	head_point = add_cosmetic(hat_scene, head_point, hats).get_node("head_pin")
	

func add_horse():
	print("adding horse, ", head_point.position)
	var new_horse : Node3D = horse_scene.instantiate()
	var new_collider = new_horse.get_node("horse_collider")
	print("new collider", new_collider)
	new_collider.reparent(self)
	new_collider.global_position = seat_point.global_position - Vector3(0, new_horse.scale.y, 0)
	new_collider.rotation = Vector3.ZERO
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
	if hats.size() == 1:
		hats.pop_back().queue_free()
		head_point = head_pin
		return

	if hats.size() > 1:
		hats.pop_back().queue_free()
		head_point = hats[-1].get_node("head_pin")

func take_damage():
	if not can_take_damage:
		print("bullet hit but player is invul")
		return

	if hats.size() == 0:
		player_died.emit()
		can_take_damage = false
		can_move = false

	if hats.size() > 0:
		remove_hat()

	hit_timer.start(hit_invul_time)
	can_take_damage = false

func on_hit_invul_timeout() -> void:
	can_take_damage = true

func zoom_mouse(num: int):
	zoom_level = clamp(zoom_level + num, min_zoom, max_zoom)
	print(zoom_level)
	camera_offset = camera_initial_offset + Vector3(0,zoom_level,0).rotated(Vector3(1,0,0), camera.rotation.x)
