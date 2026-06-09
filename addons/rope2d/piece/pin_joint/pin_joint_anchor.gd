@icon("res://addons/rope2d/icon/logout-svgrepo-com.svg")
extends RopePiecePinJoint

## An anchor for a [PinJoint2D]-based [RopePiece].  These are suitable for
## most simple rope usage like vines, mostly static cables, and other
## instances where the physics interactions are limited and tolereance around
## length changes and movement are high.[br]
## [br]
## [b]Note:[/b] Recommended to increase
## [constant PhysicsServer2D.SPACE_PARAM_SOLVER_ITERATIONS] or
## [member ProjectSettings.physics/2d/solver/solver_iterations], especially during
## periods of high physics, to avoid degenerate results.  Target solver iteration values
## must be experimentally derived.[br]
## [br]
## However, even with increased iterations, the [RopePiecePinJoint] is not as
## constrained as the [RopePieceGroovePin] implementation.
class_name RopeAnchorPinJoint

## Returns [code]TRUE[/code] if the [RopePiece] is an anchor element.
func is_anchor() -> bool:
	return true


## Prevent changing the shape of the anchor to the default CapsuleShape2D.
func set_shape(shape: Shape2D, piece_length: float):
	if shape is CapsuleShape2D:
		return
	super(shape, piece_length)
