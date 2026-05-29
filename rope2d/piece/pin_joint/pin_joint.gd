extends RopePiece

class_name RopePiecePinJoint

var log_on = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var joint: PinJoint2D = $PinJoint2D


static func create(mount: Node, params: RopePieceParameters) -> RopePiece:
	var piece: RopePiece = load("uid://b11br86kuy6ke").instantiate()
	mount.add_child(piece)
	params.apply(piece)
	return piece


func _ready() -> void:
	joint.node_a = get_path()


func get_angle_to_next() -> float:
	var node_b := get_node(joint.node_b) as Node2D
	return global_position.angle_to_point(node_b.global_position) - PI / 2


func set_shape(shape: CapsuleShape2D, piece_length: float):
	collision_shape.shape = shape
	collision_shape.position.y = piece_length / 2
	joint.position.y = piece_length


func set_joint_parameters(bias: float, softness: float):
	joint.bias = bias
	joint.softness = softness


func get_start_position() -> Vector2:
	return joint.global_position


func set_next_piece(next: RopePiece):
	super(next)
	joint.node_a = get_path()
	joint.node_b = next.get_path()


func clear_next():
	super()
	joint.node_b = ""


func get_relocation_path() -> String:
	return get_path()


func add_relocation_force(force: Vector2):
	add_constant_force(force)


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
