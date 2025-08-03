extends "res://scripts/shooting_enemy.gd"
@export var size_bonus = 1.2;
const NAME = "monkey"
func catch_effect():
	got_caught.emit()
	return Catch_Logic.increase_size(size_bonus)

func _ready():
	player_body = get_tree().current_scene.find_child("Player").find_child("PlayerBody") as CharacterBody3D


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
