class_name Utility

static func string_to_vector2(s: String) -> Vector2:
	if not s or s.length() == 0:
		return Vector2.ZERO

	var new_s: String = s

	new_s = new_s.erase(0, 1)
	new_s = new_s.erase(new_s.length() - 1, 1)
	var parts: Array = new_s.split(", ")
	#print("string_to_vector2: ", new_s, " into ", parts)

	return Vector2(float(parts[0]), float(parts[1]))
