extends Area2D

## Used as an example to create an [Area2D] of force that applies to all
## [RopePiece] elements within it.
class_name WindArea2D

## Changes the pattern of the force applied.
enum PulseMode {
	NONE,
	SIN,
	RAND,
}

@export var pulse_mode: PulseMode = PulseMode.NONE

## How much, and in what direction, force to apply to the
## [RopePiece].
@export var speed: Vector2 = Vector2.ZERO:
	set(new_speed):
		update_speed(new_speed)
		speed = new_speed

var _bodies: Array[Node2D] = []
var _current_speed: Vector2


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
	for body: RopePiece in _bodies:
		body.wind_velocity -= _current_speed
		if new_speed.y < 0.0:
			body.linear_velocity.y = new_speed.y
		body.wind_velocity += new_speed
	_current_speed = new_speed


func _object_entered(object: Node2D):
	if not is_windable(object):
		return
	_bodies.append(object)
	if _current_speed.y < 0.0:
		object.linear_velocity.y = _current_speed.y
	object.wind_velocity += _current_speed


func _object_exited(object: Node2D):
	if not is_windable(object):
		return
	var n := _bodies.find(object)
	_bodies.remove_at(n)
	object.wind_velocity -= _current_speed
