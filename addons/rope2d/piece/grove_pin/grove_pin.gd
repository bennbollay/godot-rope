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
	
func get_start_position() -> Vector2:
	return $Pin/PinJoint2D.global_position
	
func get_angle_to_next() -> float:
	return pin_joint.global_position.angle_to_point(groove_joint.global_position) - PI / 2

func set_next_piece(next: RopePiece):
	super(next)
	var n := next as RopePieceGroovePin
	
	groove_joint.node_b = n.pin_body.get_path()


func clear_next():
	next_piece = null
	groove_joint.node_b = ""

func set_shape(shape: CapsuleShape2D, piece_length: float):
	collision_shape.shape = shape
	collision_shape.position.y = piece_length / 2
	groove_joint.length = piece_length
	groove_joint.initial_offset = piece_length


func set_joint_parameters(bias: float, _softness: float):
	groove_joint.bias = bias
	# joint.softness = softness

func get_relocation_path() -> String:
	return pin_body.get_path()


func add_relocation_force(force: Vector2):
	pin_body.add_constant_force(force)
