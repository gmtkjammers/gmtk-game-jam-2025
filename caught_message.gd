extends Node3D
var rng = RandomNumberGenerator.new()
@export var timer : Timer
var camera : Camera3D
var randoffset
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(fade)
	timer.start()
	randoffset = rng.randf_range(-15.0, 15.0)

func fade():
	$fade_out.stop()
	queue_free()

func set_camera(new_camera):
	self.camera = new_camera

func display(msg_text):
	$panel/label.text = msg_text

var count = 0
var throwheight = 10

func _process(delta):
	$panel.position = Vector2(count*randoffset-10,(count-throwheight)**2-throwheight**2)
	count+=0.4
