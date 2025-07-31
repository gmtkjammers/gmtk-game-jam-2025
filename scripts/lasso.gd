extends RigidBody3D


const ROTATION_SPEED = 10
const THROW_SPEED = 20
enum Lasso_State {OVERHEAD, THROWING, RETURNING}
var state = Lasso_State.OVERHEAD
var throw_angle = 0

func _physics_process(delta: float) -> void:
	if state == Lasso_State.OVERHEAD:
		# Just rotate around
		rotation.y += ROTATION_SPEED*delta
		pass
	
	if not get_colliding_bodies().is_empty():
		position = Vector3(0, 3, 0)
		rotation = Vector3.ZERO
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		gravity_scale = 0
		inertia = Vector3.ZERO
		constant_force = Vector3.ZERO
		state = Lasso_State.OVERHEAD

func throw(direction: Vector3):
	#on click, throw lasso
	state = Lasso_State.THROWING
	var impulse = direction * THROW_SPEED
	gravity_scale = 1
	apply_central_impulse(impulse)
