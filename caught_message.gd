extends Node3D
var rng = RandomNumberGenerator.new()
@export var timer : Timer
var camera : Camera3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(fade)
	timer.start()

func fade():
	$fade_out.stop()
	queue_free()

func set_camera(new_camera):
	self.camera = new_camera

func display(msg_text):
	$panel/label.text = msg_text
