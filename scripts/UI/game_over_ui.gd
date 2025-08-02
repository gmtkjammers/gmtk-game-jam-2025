extends Control

@export var retry_button: Button
@export var player: Node3D

func _ready() -> void:
	$CanvasLayer.visible = false

	retry_button.pressed.connect(_on_retry_pressed)

	player.player_died.connect(_on_player_died)

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_player_died() -> void:
	$CanvasLayer.visible = true
