extends RopePiecePinJoint
class_name RopeAnchorPinJoint

@export 	var rope_piece_parameters: RopePieceParameters = RopePieceParameters.new()
@export 	var rope_anchor_parameters: RopeAnchorParameters = RopeAnchorParameters.new()

func _init() -> void:
	piece_parameters = rope_piece_parameters
	anchor_parameters = rope_anchor_parameters

func create_piece(mount: Node) -> RopePiecePinJoint:
	return RopePiecePinJoint.create(mount, piece_parameters)
	
func clone(mount: Node) -> RopePiece:
	var anchor: RopePiece = load("res://rope2d/piece/pin_joint_anchor.tscn").instantiate()
	mount.add_child(anchor)
	anchor_parameters.apply(anchor)
	return anchor
