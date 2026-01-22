extends Node

class_name Rope

var RopePieceScene := preload("res://rope/rope_piece.tscn")
var RopeEndPieceScene = preload("res://rope/rope_end_piece.tscn")

const DEFAULT_PIECE_LENGTH := 20.0
const LOCATION_TOLERANCE := 4.0

var piece_length: float
var rope_start: RopePiece
var close_tolerance: float

var pending_spool_pieces: int = 0


func get_joint(n: Node2D) -> PinJoint2D:
	return n.get_node("PinJoint2D")


func get_shape(n: Node2D) -> CollisionShape2D:
	return n.get_node("CollisionShape2D")


func get_joint_a(j: PinJoint2D) -> PhysicsBody2D:
	return j.get_node(j.node_a)


func get_joint_b(j: PinJoint2D) -> PhysicsBody2D:
	return j.get_node(j.node_b)


func get_next(piece: RigidBody2D) -> RopePiece:
	return get_joint_b(get_joint(piece))


func get_angle(pivot: PinJoint2D) -> float:
	var node_a := get_node(pivot.node_a) as Node2D
	var node_b := get_node(pivot.node_b) as Node2D
	return node_a.global_position.angle_to_point(node_b.global_position) - PI / 2


func get_length(piece: RigidBody2D) -> float:
	return (get_shape(piece).shape as CapsuleShape2D).height


func _init(start: RopePiece, length: float = DEFAULT_PIECE_LENGTH, close_tol: float = LOCATION_TOLERANCE) -> void:
	piece_length = length
	rope_start = start
	close_tolerance = close_tol


func create_rope(end_or_vec2: Variant, max_segments: int = -1):
	var end_pos: Vector2

	if end_or_vec2 is Vector2:
		end_pos = end_or_vec2
	else:
		end_pos = get_joint(end_or_vec2).global_position

	var start_pos: Vector2 = get_joint(rope_start).global_position
	var distance := start_pos.distance_to(end_pos)
	var num_segments: int = round(distance / piece_length)
	var spawn_angle := start_pos.angle_to_point(end_pos) - PI / 2
	var floating_end: bool = false
	
	if max_segments != -1 and num_segments > max_segments:
		floating_end = true
		num_segments = max_segments
		
	var shape: CapsuleShape2D = CapsuleShape2D.new()
	shape.height = piece_length
	shape.radius = 1.0

	var last_piece := create_rope_segments(num_segments, shape, spawn_angle, end_pos)

	var rope_end_piece: RopePiece

	if end_or_vec2 is Vector2 or floating_end:
		rope_end_piece = RopeEndPieceScene.instantiate()
		rope_end_piece.global_position = last_piece.global_position
		rope_end_piece.gravity_scale = 0.0
		add_child(rope_end_piece)
	else:
		rope_end_piece = end_or_vec2


	# Connect the last_piece to the end of the chain.
	var last_joint = get_joint(last_piece)
	last_joint.node_a = last_piece.get_path()
	last_joint.node_b = rope_end_piece.get_path()
	last_piece.next_piece = rope_end_piece


func create_rope_segments(num_segments: int, shape: CapsuleShape2D, spawn_angle: float, end_pos: Variant) -> RopePiece:
	var piece: RopePiece = rope_start
	for i in num_segments:
		piece = add_piece(piece, i, shape, spawn_angle)
		var joint_pos = get_joint(piece).global_position
		if end_pos and joint_pos.distance_to(end_pos) < close_tolerance:
			break

	return piece


# In the joint, node_a always points to yourself, and node_b always points to the next node
# in the chain.  When allocating a new piece, set the prev_piece's node_b to the newly
# allocated piece.
func add_piece(prev_piece: RopePiece, id: int, shape: CapsuleShape2D, spawn_angle: float) -> RopePiece:
	var prev_joint: PinJoint2D = get_joint(prev_piece)

	var piece := RopePieceScene.instantiate() as RopePiece
	get_shape(piece).shape = shape
	get_shape(piece).position.y = piece_length / 2
	get_joint(piece).position.y = piece_length
	piece.global_position = prev_joint.global_position
	piece.rotation = spawn_angle
	piece.gravity_scale = 0.0
	piece.set_name("rope_piece_" + str(id))
	prev_piece.next_piece = piece

	add_child(piece)

	# Set the prev_piece.joint.node_b to point at the new piece.
	prev_joint.node_a = prev_piece.get_path()
	prev_joint.node_b = piece.get_path()

	# Defensively set the new piece node_a
	get_joint(piece).node_a = piece.get_path()

	return piece


func spool(spool_pieces: int = 1):
	pending_spool_pieces += spool_pieces

	# Already spooling in progress
	if pending_spool_pieces != spool_pieces:
		return

	while pending_spool_pieces > 0:
		await spool_next_piece()
		pending_spool_pieces -= 1


func spool_next_piece():
	var old_first_piece := get_next(rope_start)
	var common_shape := get_shape(old_first_piece).shape

	# Determine the direction of the first piece in the rope
	var start_angle := get_angle(get_joint(get_next(get_next(rope_start))))
	var back_angle_vec := Vector2.from_angle(start_angle - PI / 2)

	# Find the position behind the current starting position
	var start_position := rope_start.global_position
	var new_position := start_position + back_angle_vec * piece_length

	# print("spool from angle: ", start_angle, "(", rad_to_deg(start_angle), ") to angle: ", back_angle, "(", rad_to_deg(back_angle), ") shifting from: ", start.global_position, " to: ", new_position, " on vector: ", back_angle_vec)

	# Create a new End Piece to act as a temporary anchor during physics
	var new_start: RopePiece = RopeEndPieceScene.instantiate()
	new_start.gravity_scale = 0.0
	new_start.global_position = new_position
	add_child(new_start)

	# Create the new piece to insert into the rope
	var new_piece := add_piece(new_start, 99, common_shape, start_angle)
	new_piece.next_piece = old_first_piece

	# Connect the old first piece after the new piece
	get_joint(new_piece).node_b = old_first_piece.get_path()

	# Decouple the old start anchor
	get_joint(rope_start).node_b = ""
	rope_start.visible = false

	# Now set up the force to unspool it:
	# await new_start.relocate_to(start_position)
	await new_start.relocate_to(piece_length, start_angle, rope_start)

	# Reattach the old start and free the new start when the new start arrives
	get_joint(rope_start).node_b = get_joint(new_start).node_b
	rope_start.next_piece = new_piece
	new_start.queue_free()
	rope_start.visible = true


func calculate_rope_length(from: RopePiece, to: Variant) -> float:
	var walker: RigidBody2D = from
	var dist: float = 0.0

	while walker and walker != to:
		var joint := get_joint(walker)
		var node_b := get_joint_b(joint)
		if not node_b:
			break
		dist += walker.global_position.distance_to(node_b.global_position)
		walker = node_b

	return dist


func get_points() -> Array[Vector2]:
	var points: Array[Vector2] = []
	var walker: RopePiece = rope_start
	while walker:
		points.append(walker.global_position)
		walker = walker.next_piece
	return points
