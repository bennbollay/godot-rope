extends Area2D

class_name WindArea2D

enum PulseMode {
	NONE,
	SIN,
	RAND
}

@export var pulse_mode: PulseMode = PulseMode.NONE
@export var speed: Vector2 = Vector2.UP * 2:
	set(new_speed):
		update_speed(new_speed)
		speed = new_speed


var bodies: Array[Node2D] = []
var current_speed: Vector2

func _ready() -> void:
	body_entered.connect(_object_entered)
	body_exited.connect(_object_exited)
	
	if pulse_mode == PulseMode.NONE:
		return
	if pulse_mode == PulseMode.SIN:
		var tween = create_tween()
		tween.tween_property(self, "speed", speed.rotated(PI), 3)
		tween.tween_property(self, "speed", speed, 3)
		tween.set_loops()


func is_windable(object: Node2D):
	return "wind_velocity" in object


func update_speed(new_speed: Vector2):
	print("Speed to ", new_speed, " for ", bodies.size(), " entities")
	for body: RopePiece in bodies:
		body.wind_velocity -= current_speed
		if new_speed.y < 0.0:
			body.linear_velocity.y = new_speed.y
		body.wind_velocity += new_speed
	current_speed = new_speed

func _object_entered(object: Node2D):
	if not is_windable(object):
		return
	bodies.append(object)
	if current_speed.y < 0.0:
		object.linear_velocity.y = current_speed.y
	object.wind_velocity += current_speed


func _object_exited(object: Node2D):
	if not is_windable(object):
		return
	var n := bodies.find(object)
	bodies.remove_at(n)
	object.wind_velocity -= current_speed
