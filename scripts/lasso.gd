extends RigidBody3D


const ROTATION_SPEED = 5
const THROW_SPEED = 5
enum Lasso_State {OVERHEAD, THROWING, RETURNING}
var state = Lasso_State.OVERHEAD
var throw_angle = 0
var catch_target = null
var catch_offset = null
var lasso_charge : float = 0
@export var player: CharacterBody3D
@export var GRAVITY = 2
@export var lasso_scale = 1.0

func _ready() -> void:
	gravity_scale = 0
	_reset_lasso()


func _physics_process(delta: float) -> void:

	if state == Lasso_State.OVERHEAD:
		# Just rotate around
		position.x = player.position.x
		position.z = player.position.z
		rotation.y += ROTATION_SPEED*delta*(lasso_charge + 1)

		#check if mouse is being held down
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			lasso_charge += delta
	
	if state == Lasso_State.THROWING and not get_colliding_bodies().is_empty():
		checkCatches(get_colliding_bodies())
		reel_in()

	if state == Lasso_State.RETURNING:
		#move self towards player
		var direction = (player.global_position - global_position).normalized()
		linear_velocity = direction*10

		#drag caught thing
		if(catch_target):
			catch_target.position = position + catch_offset

		#check if back at the player
		
		if player in get_colliding_bodies():
			_resolve_catch(catch_target)
			_reset_lasso()
		elif position.distance_to(player.position) < 1:
			_resolve_catch(catch_target)
			_reset_lasso()

func checkCatches(collisions: Array[Node3D]):
	for body in collisions:
		if body.is_in_group("catchable"):
			print("caught!", body)
			catch_target = body
			catch_offset = body.position - position

func reel_in():
	print("reeling in!")
	state = Lasso_State.RETURNING
	#move body and lasso towards player
	gravity_scale = 0
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	add_constant_central_force(direction*10)

func _resolve_catch(_catch_target : Node3D):
	#run catch logic from the caught object
	if not _catch_target or not catch_target.catch_effect:
		return
	if "hat" in _catch_target and _catch_target.hat:
		player.add_hat()
	if "horse" in _catch_target and _catch_target.horse:
		player.add_horse()
	_catch_target.catch_effect().call(player)
	_catch_target.queue_free()
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and state == Lasso_State.OVERHEAD and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		throw(lasso_charge)


func _reset_lasso() -> void:
	catch_target = null
	catch_offset = null
	state = Lasso_State.OVERHEAD
	constant_force = Vector3(0, 0, 0)
	position = player.position + Vector3(0,2,0)
	rotation = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	gravity_scale = 0
	lasso_charge = 0
	state = Lasso_State.OVERHEAD


func throw(power: float):
	var direction = (player.get_child(1).global_transform.basis * Vector3(0, 0.5, 1)).normalized()
	state = Lasso_State.THROWING
	var impulse = direction * THROW_SPEED * power + direction * THROW_SPEED
	gravity_scale = GRAVITY
	apply_central_impulse(impulse)
