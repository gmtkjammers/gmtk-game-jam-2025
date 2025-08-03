extends "res://scripts/passive_enemy.gd"
const NAME = "snake"
@export var size_bonus = 1.5;

func catch_effect():
	return Catch_Logic.lasso_size(size_bonus)