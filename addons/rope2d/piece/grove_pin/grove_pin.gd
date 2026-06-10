extends RopePiece

class_name RopePieceGroovePin

@onready var pin_body: RigidBody2D = $Pin
@onready var groove_body: RigidBody2D = $Groove
@onready var pin_joint: PinJoint2D = $Pin/PinJoint2D
@onready var groove_joint: GrooveJoint2D = $Groove/GrooveJoint2D

@onready var collision_shape: CollisionShape2D = $Groove/CollisionShape2D


static func create(mount: Node, params: RopePieceParameters) -> RopePiece:
	var piece: RopePiece = load("uid://cxyeku3an2g13").instantiate()
	mount.add_child(piece)
	params.apply(piece)
	return piece


func _ready() -> void:
	pin_joint.node_a = pin_body.get_path()
	pin_joint.node_b = groove_body.get_path()
	groove_joint.node_a = groove_body.get_path()


func get_prev_position() -> Vector2:
	return pin_body.global_position


func get_next_position() -> Vector2:
	var pos: Vector2 = Vector2.DOWN
	pos = get_groove_position()
	return pos


func get_groove_position() -> Vector2:
	if groove_joint.node_b:
		return get_node(groove_joint.node_b).global_position
	return groove_body.global_position + Vector2.DOWN.rotated(pin_body.rotation) * groove_joint.initial_offset


func set_piece_position(pos: Vector2):
	pin_body.global_position = pos
	groove_body.global_position = pos


func set_piece_rotation(rot: float):
	pin_body.rotation = rot
	groove_body.rotation = rot


func set_piece_visible(vis: bool):
	pin_body.visible = vis
	groove_body.visible = vis


func get_angle_to_next() -> float:
	return pin_body.global_position.angle_to_point(groove_body.global_position) - PI / 2


func get_angle_to_next_piece() -> float:
	return pin_body.global_position.angle_to_point(next_piece.pin_body.global_position) - PI / 2


func set_next_piece(next: RopePiece):
	super(next)
	var n := next as RopePieceGroovePin

	groove_joint.initial_offset = groove_body.global_position.distance_to(n.pin_body.global_position)
	groove_joint.length = groove_joint.initial_offset

	# Setting the node_b causes the physics system to Do Things, which
	# means that setting the initial_offset or the length after the path
	# is set does The Wrong Thing.
	#
	# The Wrong Thing usually looks like the next entry moving too far
	# away, as the length and offset don't get adjusted based on the
	# actual distance that the node is from the groove.
	groove_joint.node_b = n.pin_body.get_path()


func clear_next():
	next_piece = null
	groove_joint.node_b = ""


func apply_piece_parameters(p: RopePieceParameters):
	pin_body.gravity_scale = p.gravity_scale
	pin_body.mass = p.mass
	pin_body.linear_damp_mode = p.linear_damp_mode
	pin_body.linear_damp = p.linear_damp
	pin_body.angular_damp_mode = p.angular_damp_mode
	pin_body.angular_damp = p.angular_damp
	pin_body.collision_layer = p.collision_layer
	pin_body.collision_mask = p.collision_mask

	push_rope = p.push_rope
	set_joint_parameters(p.pin_joint_bias, p.pin_joint_softness)
	set_shape(p.shape, p.piece_length)


func apply_anchor_parameters(p: RopePieceParameters):
	pin_body.gravity_scale = p.gravity_scale
	pin_body.mass = p.mass
	groove_body.gravity_scale = p.gravity_scale
	groove_body.mass = p.mass


func set_joint_parameters(bias: float, _softness: float):
	groove_joint.bias = bias
	# joint.softness = softness


func set_shape(shape: Shape2D, piece_length: float):
	# collision_shape.shape = shape
	# If it's capsule it needs this, but not circle
	# collision_shape.position.y = piece_length / 2
	groove_joint.length = piece_length
	groove_joint.initial_offset = piece_length


func get_relocation_path() -> String:
	return pin_body.get_path()


func add_relocation_force(force: Vector2):
	pin_body.add_constant_force(force)


func set_velocities(_linear: Vector2, _angular: float):
	pass


func get_rotation() -> float:
	return 0.0


func get_velocities() -> Dictionary:
	return { }
