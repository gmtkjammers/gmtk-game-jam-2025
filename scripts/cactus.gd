extends CharacterBody3D

const NAME = "cactus"
func catch_effect():
	return Catch_Logic.take_damage()
