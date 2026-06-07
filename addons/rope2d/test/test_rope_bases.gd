extends Node2D

var r: bool = false
func _ready() -> void:
	if  not r:
		var pj_rope := Rope2D.new($PinJointAnchorStart)
		add_child(pj_rope)
		pj_rope.create_rope($PinJointAnchorEnd)
		# pj_rope.freeze_rope()

	if not r:
		$GroovePinAnchorStart.apply_parameters($GroovePinAnchorStart.piece_parameters)
		$GroovePinAnchorEnd.apply_parameters($GroovePinAnchorStart.piece_parameters)
		
		var gp_rope := Rope2D.new($GroovePinAnchorStart)
		add_child(gp_rope)
		gp_rope.create_rope($GroovePinAnchorStart.global_position + Vector2(0, 20 * 100))
		# gp_rope.freeze_rope()

func _process(_delta: float) -> void:
	%Mouse.global_position = get_global_mouse_position()
