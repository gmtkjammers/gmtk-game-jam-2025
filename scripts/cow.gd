extends StaticBody3D
@export var size_bonus = 1.2;

func catch_effect():
	return Catch_Logic.increase_size(size_bonus)
