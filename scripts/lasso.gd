extends RigidBody3D


const ROTATION_SPEED = 10
const THROW_SPEED = 10
enum Lasso_State {OVERHEAD, THROWING, RETURNING}
var state = Lasso_State.OVERHEAD
var throw_angle = 0
var catch_target = null
var catch_offset = null
@export var player: CharacterBody3D

func _ready() -> void:
	print(get_tree().get_nodes_in_group("catchable"))
	gravity_scale = 0


func _physics_process(delta: float) -> void:
	if state == Lasso_State.OVERHEAD:
		# Just rotate around
		rotation.y += ROTATION_SPEED*delta
		pass
	
	if state == Lasso_State.THROWING and not get_colliding_bodies().is_empty():
		checkCatches(get_colliding_bodies())
		reel_in()

	if state == Lasso_State.RETURNING:
		#drag caught thing
		if(catch_target):
			catch_target.position = position + catch_offset

		#check if back at the player
		if position.distance_to(player.position) < 2:
			_reset_lasso()
		if player in get_colliding_bodies():
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


	
func _reset_lasso() -> void:
	catch_target = null
	catch_offset = null
	state = Lasso_State.OVERHEAD
	constant_force = Vector3(0, 0, 0)
	position = Vector3(0, 3, 0)
	rotation = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	gravity_scale = 0
	state = Lasso_State.OVERHEAD


func throw(direction: Vector3):
	#on click, throw lasso
	state = Lasso_State.THROWING
	var impulse = direction * THROW_SPEED
	gravity_scale = 1
	apply_central_impulse(impulse)
