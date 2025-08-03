class_name Catch_Logic

static func increase_size(amt: float):
	print("executed increase size with amt ", amt)
	return func(target: CharacterBody3D):
		print("executed next level with target ", target)
		target.size += amt
		# Prob should be doing this somewhere else
		if target.has_signal("increased_size"):
			target.increased_size.emit()
	
static func take_damage():
	print("executed take damage")
	return func(target: CharacterBody3D):
		target.take_damage()

static func lasso_size(amt: float):
	print("executed lasso size with amt ", amt)
	return func(target: CharacterBody3D):
		print("executed lasso size with target ", target)
		target.lasso.lasso_size += amt
		# Prob should be doing this somewhere else
		if target.has_signal("increased_lasso"):
			target.increased_lasso.emit()