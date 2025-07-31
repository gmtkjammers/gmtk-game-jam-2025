extends RigidBody3D


const ROTATION_SPEED = 10
const THROW_SPEED = 10
enum Lasso_State {OVERHEAD, THROWING, RETURNING}
var state = Lasso_State.OVERHEAD
var throw_angle = 0

func _physics_process(delta: float) -> void:
	if state == Lasso_State.OVERHEAD:
		# Just rotate around
		rotation.y += ROTATION_SPEED*delta
		pass
	
	if not get_colliding_bodies().is_empty():
		print(get_colliding_bodies()[0])
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 1.0
		timer.one_shot = true
		timer.start()
		timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
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
