@abstract
extends RopePiece

class_name RopeAnchor

# Expected:
# @export 	var piece_parameters: RopePieceParameters = RopePieceParameters.new()

@abstract func create_piece(mount: Node) -> RopePiece


@abstract func clone(mount: Node) -> RopeAnchor
