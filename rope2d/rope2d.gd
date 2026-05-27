extends Node

class_name Rope2D

var RopeEndPieceScene = preload("res://rope2d/piece/pin_joint_anchor.tscn")

const DEFAULT_PIECE_LENGTH := 20.0
const LOCATION_TOLERANCE := 4.0

var rope_start: RopePiece
var rope_last_piece: RopePiece
var owned_rope_end: bool = false

var close_tolerance: float

var pending_spool_pieces: int = 0

var piece_default_gravity_scale: float = 0.0
var endpoint_default_gravity_scale: float = 0.0

var rope_piece_parameters: RopePieceParameters = RopePieceParameters.new()

func create_piece() -> RopePiece:
	return RopePiecePinJoint.create(self, rope_piece_parameters)

#func get_joint(n: Node2D) -> PinJoint2D:
	#return n.get_node("PinJoint2D")
#
#
#func get_shape(n: Node2D) -> CollisionShape2D:
	#return n.get_node("CollisionShape2D")
#
#
#func get_joint_a(j: PinJoint2D) -> PhysicsBody2D:
	#return j.get_node(j.node_a)
#
#
#func get_joint_b(j: PinJoint2D) -> PhysicsBody2D:
	#if j.node_b.is_empty():
		#return null
	#return j.get_node(j.node_b)
#
#
#func get_next(piece: RigidBody2D) -> RopePiece:
	#return get_joint_b(get_joint(piece))
#
#
#func get_angle(pivot: PinJoint2D) -> float:
	#var node_a := get_node(pivot.node_a) as Node2D
	#var node_b := get_node(pivot.node_b) as Node2D
	#return node_a.global_position.angle_to_point(node_b.global_position) - PI / 2
#
#
#func get_length(piece: RigidBody2D) -> float:
	#return (get_shape(piece).shape as CapsuleShape2D).height


func _init(
		start: RopePiece,
		piece_parameters: RopePieceParameters = RopePieceParameters.new(),
		piece_default_gravity: float = 0.0,
		end_default_gravity: float = 0.0,
		close_tol: float = LOCATION_TOLERANCE,
) -> void:
	rope_start = start
	rope_piece_parameters = piece_parameters
	close_tolerance = close_tol
	piece_default_gravity_scale = piece_default_gravity
	endpoint_default_gravity_scale = end_default_gravity


func create_rope(end_or_vec2: Variant, max_segments: int = -1, start_piece: RopePiece = rope_start) -> RopePiece:
	var end_pos: Vector2

	if end_or_vec2 is Vector2i:
		end_or_vec2 = Vector2(end_or_vec2.x, end_or_vec2.y)

	if end_or_vec2 is Vector2:
		end_pos = end_or_vec2
	else:
		end_pos = (end_or_vec2 as RopePiece).get_start_position()

	var start_pos: Vector2 = start_piece.get_start_position()
	var distance := start_pos.distance_to(end_pos)
	var num_segments: int = round(distance / rope_piece_parameters.piece_length)
	var actual_angle = start_pos.angle_to_point(end_pos)
	var spawn_angle: float = actual_angle - PI / 2
	var floating_end: bool = false

	if max_segments != -1 and num_segments > max_segments:
		floating_end = true
		num_segments = max_segments

	rope_last_piece = _create_rope_segments(start_piece, num_segments, spawn_angle, end_pos)

	var rope_end: RopePiece

	if end_or_vec2 is Vector2 or floating_end:
		rope_end = RopeEndPieceScene.instantiate()
		rope_end.global_position = rope_last_piece.global_position + Vector2.from_angle(actual_angle).normalized() * rope_piece_parameters.piece_length
		rope_end.gravity_scale = endpoint_default_gravity_scale
		add_child(rope_end)

		owned_rope_end = true
	else:
		rope_end = end_or_vec2

	# Connect the last_piece to the end of the chain.
	rope_last_piece.set_next_piece(rope_end)

	return rope_end


func extend(end_or_vec2: Variant, max_segments: int = -1) -> RopePiece:
	if owned_rope_end:
		var rope_end: RopePiece = rope_last_piece.next_piece
		remove_child(rope_end)
		rope_last_piece.clear_next()
	return create_rope(end_or_vec2, max_segments, rope_last_piece)


func _create_rope_segments(start: RopePiece, num_segments: int, spawn_angle: float, end_pos: Variant) -> RopePiece:
	var piece: RopePiece = start
	for i in num_segments:
		piece = add_piece(piece, i, spawn_angle)
		var joint_pos := piece.get_start_position()
		if end_pos and joint_pos.distance_to(end_pos) < close_tolerance:
			break

	return piece


# In the joint, node_a always points to yourself, and node_b always points to the next node
# in the chain.  When allocating a new piece, set the prev_piece's node_b to the newly
# allocated piece.
func add_piece(prev_piece: RopePiece, id: int, spawn_angle: float) -> RopePiece:
	var piece := create_piece()
	piece.global_position = prev_piece.get_start_position()
	piece.rotation = spawn_angle
	piece.gravity_scale = piece_default_gravity_scale
	piece.set_name("rope_piece_" + str(id))
	
	prev_piece.set_next_piece(piece)

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
	var old_first_piece := rope_start.next_piece

	# Determine the direction of the first piece in the rope
	var start_angle := rope_start.next_piece.next_piece.get_angle_to_next()
	var back_angle_vec := Vector2.from_angle(start_angle - PI / 2)

	# Find the position behind the current starting position
	var start_position := rope_start.global_position
	var new_position := start_position + back_angle_vec * rope_piece_parameters.piece_length

	# print("spool from angle: ", start_angle, "(", rad_to_deg(start_angle), ") to angle: ", back_angle, "(", rad_to_deg(back_angle), ") shifting from: ", start.global_position, " to: ", new_position, " on vector: ", back_angle_vec)

	# Create a new End Piece to act as a temporary anchor during physics
	var new_start: RopePiece = RopeEndPieceScene.instantiate()
	new_start.gravity_scale = 0.0
	new_start.global_position = new_position
	add_child(new_start)

	# Create the new piece to insert into the rope
	var new_piece := add_piece(new_start, 99, start_angle)
	new_piece.next_piece = old_first_piece

	# Connect the old first piece after the new piece
	new_piece.set_next_piece(old_first_piece)

	# Decouple the old start anchor
	rope_start.clear_next()
	rope_start.visible = false

	# Now set up the force to unspool it:
	# await new_start.relocate_to(start_position)
	await new_start.relocate_to(rope_piece_parameters.piece_length, start_angle, rope_start)

	# Reattach the old start and free the new start when the new start arrives
	rope_start.set_next_piece(new_piece)
	# get_joint(rope_start).node_b = get_joint(new_start).node_b
	# rope_start.next_piece = new_piece
	new_start.queue_free()
	rope_start.visible = true


func calculate_rope_length(from: RopePiece, to: RopePiece) -> float:
	var walker: RopePiece = from
	var dist: float = 0.0

	while walker and walker != to:
		if not walker.next_piece:
			break
		
		dist += walker.get_start_position().distance_to(walker.next_piece.get_start_position())
		walker = walker.next_piece

	return dist


func get_points() -> Array[Vector2]:
	var points: Array[Vector2] = []
	var walker: RopePiece = rope_start.next_piece
	while walker:
		points.append(walker.global_position)
		walker = walker.next_piece
	return points


func to_json() -> Dictionary:
	var rope = []
	var walker: RopePiece = rope_start.next_piece
	var last_piece: RopePiece = rope_start
	while walker:
		rope.append(walker.rotation)
		last_piece = walker
		walker = walker.next_piece

	return {
		"rope_piece_parameters": rope_piece_parameters.to_json(),
		"close_tolerance": close_tolerance,
		"piece_default_gravity_scale": piece_default_gravity_scale,
		"endpoint_default_gravity_scale": endpoint_default_gravity_scale,
		"rope": rope,
		"end_global_position": str(last_piece.global_position),
	}


static func create_saved_rope(start: RopePiece, saved_rope: Variant) -> Rope2D:
	return Rope2D.new(
		start,
		RopePieceParameters.from_json(saved_rope.rope_piece_parameters),
		saved_rope.piece_default_gravity_scale,
		saved_rope.endpoint_default_gravity_scale,
	)


func from_json(saved_rope: Variant) -> RopePiece:
	if not "rope" in saved_rope:
		return

	rope_last_piece = _set_points(saved_rope.rope)

	# Assumes free-floating endpoint.
	var rope_end_piece: RopePiece
	rope_end_piece = RopeEndPieceScene.instantiate()
	rope_end_piece.global_position = Utility.string_to_vector2(saved_rope.end_global_position)
	rope_end_piece.gravity_scale = endpoint_default_gravity_scale
	owned_rope_end = true
	add_child(rope_end_piece)

	# Connect the last_piece to the end of the chain.
	rope_last_piece.set_next_piece(rope_end_piece)

	return rope_end_piece


func _set_points(points: Array) -> RopePiece:
	var piece: RopePiece = rope_start

	# Ignore the last entry which is the rope_end_piece
	for i in range(0, points.size() - 1):
		piece = add_piece(piece, i, points[i])

	return piece
