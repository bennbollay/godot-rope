@abstract
extends RopePiece
## An abstract interface class that specifies the two methods required to
## implement a [RopeAnchor], derived from a [RopePiece].  Because different
## [RopeAnchor]s have different base classes (for example [RopePiecePinJoint]
## or [RopePieceGroovePin]), no [RopeAnchor] will directly derive from this class.[br]
## [br]
## Extended by [RopeAnchorPinJoint] and [RopeAnchorGroovePin].
class_name RopeAnchor

# Expected:
# @export 	var piece_parameters: RopePieceParameters = RopePieceParameters.new()

## Returns a [RopePiece] based on the current type of this [RopeAnchor].
@abstract func create_piece(mount: Node) -> RopePiece

## Returns a [RopeAnchor] that shares the configuration of this [RopeAnchor].
@abstract func clone(mount: Node) -> RopeAnchor
