extends Resource
## A collection of parameters that are used to configure new [RopeAnchor] when they
## are created, for example when a [Rope2D] has a free-floating endpoint that is
## not attached to a specific [RopeAnchor] in the scene.
class_name RopeAnchorParameters

## Overloads the [annotation RigidBody2D.gravity_scale].
@export var gravity_scale: float
## Overloads the [annotation RigidBody2D.mass].
@export var mass: float = 1.0

## Parameters to apply to the piece after cloning
@export var rope_piece_parameters: RopePieceParameters = RopePieceParameters.new()

func _init() -> void:
	pass

## Apply the included overloads to the new [RopeAnchor].  Invoked during the
## [annotation Rope2D.spool] or [annotation Rope2D.extend] process.
func apply(anchor: RopePiece):
	anchor.apply_piece_parameters(rope_piece_parameters)
	anchor.apply_anchor_parameters(self)
