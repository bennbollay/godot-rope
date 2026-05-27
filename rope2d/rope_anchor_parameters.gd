extends Resource
class_name RopeAnchorParameters

@export var gravity_scale: float

func _init(gravity_scale_: float = 0.0) -> void:
	gravity_scale = gravity_scale_

func apply(anchor: RopePiece):
	anchor.gravity_scale = gravity_scale
