extends RopePiece

class_name RopePiecePinJoint

var log_on = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var joint: PinJoint2D = $PinJoint2D

static func create(mount: Node, params: RopePieceParameters) -> RopePiece:
	var piece: RopePiece = load("res://rope2d/piece/pin_joint.tscn").instantiate()
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
	
func relocate_to(length: float, angle: float, target_anchor: RopePiece, force: float = 50):
	var groove := GrooveJoint2D.new()
	add_child(groove)
	groove.global_position = global_position
	groove.initial_offset = 0
	groove.length = length
	groove.rotate(angle)
	groove.node_a = target_anchor.get_path()
	groove.node_b = get_path()

	location_target = target_anchor.global_position

	if push_rope:
		add_constant_force((location_target - global_position) * force)
	await on_relocation_done


func update_relocation() -> bool:
	if location_target == Vector2.INF:
		return false

	if global_position.distance_to(location_target) < LOCATION_TOLERANCE:
		location_target = Vector2.INF
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
