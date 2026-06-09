extends Label

@onready var rope: Rope2D = $Rope2D
@onready var ball: RigidBody2D = $Ball

var following: bool = false
var gate := NoFasterThan.new()


func _process(delta: float) -> void:
	gate.try(
		delta,
		func():
			if Input.is_key_pressed(KEY_B) and not following:
				# Launch the ball through the scene
				ball.gravity_scale = 1.0
				ball.apply_impulse(Vector2(2.5, -1) * 500)
				following = true
	)

	if following:
		var anchor: RopePiece = rope.get_end_anchor()

		rope.extend(ball.global_position)

		# Stop the ball when convienent
		if ball.global_position.y > rope.global_position.y:
			following = false
			$Ball.freeze = true
			$Ball.gravity_scale = 0.0
