extends RigidBody3D


const ROTATION_SPEED = 3
const THROW_SPEED = 20
const MAX_POWER = 1.5
const LASSO_VERTICAL_OFFSET = 2
enum Lasso_State {OVERHEAD, THROWING, RETURNING}
var state = Lasso_State.OVERHEAD
var throw_angle = 0
var catch_target = null
var catch_offset = null
var lasso_charge : float = 0
var lasso_size : float = 1
@export var player: CharacterBody3D
@export var GRAVITY = 6
@export var lasso_scale = 1.0
func _ready() -> void:
	_reset_lasso()


func _physics_process(delta: float) -> void:

	# Just rotate around
	position.x = player.position.x
	position.z = player.position.z
	position.y = player.position.y + LASSO_VERTICAL_OFFSET
	rotation.y += ROTATION_SPEED*delta*(lasso_charge + 1)

	#check if mouse is being held down
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		lasso_charge += delta



func _reset_lasso() -> void:
	catch_target = null
	catch_offset = null
	state = Lasso_State.OVERHEAD
	constant_force = Vector3(0, 0, 0)
	rotation = Vector3(0.1,0,0)
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	gravity_scale = 0
	lasso_charge = 0
	state = Lasso_State.OVERHEAD
	set_collision_layer_value(3, false)
