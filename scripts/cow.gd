extends "res://scripts/passive_enemy.gd"

@export var size_bonus = 5;
const NAME = "cow"
func catch_effect():
	return Catch_Logic.increase_size(size_bonus)
