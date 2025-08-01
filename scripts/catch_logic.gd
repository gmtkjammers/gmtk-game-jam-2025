class_name Catch_Logic

static func increase_size(amt: float):
	print("executed increase size with amt ", amt)
	return func(target: CharacterBody3D):
		print("executed next level with target ", target)
		target.scale *= amt
	
