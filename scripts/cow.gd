extends "res://scripts/Enemy.gd"

@export var size_bonus = 5;

func catch_effect():
	return Catch_Logic.increase_size(size_bonus)
