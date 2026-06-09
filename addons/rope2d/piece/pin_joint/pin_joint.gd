extends RopePiece

class_name RopePiecePinJoint

var log_on = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var joint: PinJoint2D = $PinJoint2D


static func create_piece(mount: Node, params: RopePieceParameters) -> RopePiece:
	var piece: RopePiece = load("uid://b11br86kuy6ke").instantiate()
	mount.add_child(piece)
	params.apply(piece)
	return piece


static func create_anchor(mount: Node, params: RopePieceParameters) -> RopePiece:
	var anchor: RopePiece = load("uid://bhof88x0fym2i").instantiate()
	mount.add_child(anchor)
	params.apply(anchor)
	return anchor


func _ready() -> void:
	joint.node_a = get_path()


func rename(n: String):
	name = n
	joint.node_a = get_path()


func get_angle_to_next() -> float:
	var node_b := get_node(joint.node_b) as Node2D
	return global_position.angle_to_point(node_b.global_position) - PI / 2


func set_shape(shape: Shape2D, piece_length: float):
	collision_shape.shape = shape
	if shape is CapsuleShape2D:
		collision_shape.position.y = piece_length / 2
		joint.position.y = piece_length


func set_joint_parameters(bias: float, softness: float):
	joint.bias = bias
	joint.softness = softness


func set_next_piece(next: RopePiece):
	super(next)
	joint.node_b = next.get_path()


func clear_next():
	super()
	joint.node_b = ""


func get_relocation_path() -> String:
	return get_path()


func as_rigidbody() -> RigidBody2D:
	return (self as Variant as RigidBody2D)


func add_relocation_force(force: Vector2):
	as_rigidbody().add_constant_force(force)


func apply_piece_parameters(p: RopePieceParameters):
	var r: RigidBody2D = as_rigidbody()
	r.gravity_scale = p.gravity_scale
	r.mass = p.mass
	r.freeze = p.freeze
	r.linear_damp_mode = p.linear_damp_mode
	r.linear_damp = p.linear_damp
	r.angular_damp_mode = p.angular_damp_mode
	r.angular_damp = p.angular_damp
	r.collision_layer = p.collision_layer
	r.collision_mask = p.collision_mask

	push_rope = p.push_rope
	push_rope_force = p.push_rope_force

	set_joint_parameters(p.pin_joint_bias, p.pin_joint_softness)
	set_shape(p.shape, p.piece_length)


func get_prev_position() -> Vector2:
	return as_rigidbody().global_position


func get_next_position() -> Vector2:
	return joint.global_position


func get_rotation() -> float:
	return as_rigidbody().rotation


func set_velocities(linear: Vector2, angular: float):
	var r: RigidBody2D = as_rigidbody()
	r.linear_velocity = linear
	r.angular_velocity = angular


func get_velocities() -> Dictionary:
	var r: RigidBody2D = as_rigidbody()

	return {
		"linear_velocity": str(r.linear_velocity),
		"angular_velocity": r.angular_velocity,
	}


func update_relocation() -> bool:
	if _location_target == Vector2.INF:
		return false

	if global_position.distance_to(_location_target) < Rope2D.DEFAULT_LOCATION_TOLERANCE:
		_location_target = Vector2.INF
		on_relocation_done.emit.call_deferred()
		return false

	return true


func get_mouse_vector() -> Vector2:
	if not follow_mouse:
		return Vector2.ZERO

	return (get_global_mouse_position() - position).normalized()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	update_relocation()
	state.apply_force(wind_velocity * 80)
	state.apply_force(get_mouse_vector() * 5000)
