extends "res://scripts/shooting_enemy.gd"

@export var size_bonus = 0.1;

func catch_effect():
	return Catch_Logic.lasso_size(size_bonus)