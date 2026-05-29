extends Node

class_name Rope2D
## A class to manage and create Rope2D chains.

# XXX:
#  Add documentation for each endpoint and add the documentation to the 
#  readme.
#  Bring over the new pin_groove implementation.
#  Set up a "launcher" test.
#    * Fire a projectile and then extend the line out after it?
#    -- This is actually a pretty good idea, doing the same "extend" that
#       is used to follow the mouse.  Just make sure that the points returned
#       also include the "chased" point.
#  Add a demo for following a Line2D.
#    -- Maybe even trimming the Line2D's visibility as it goes along, if feasible.
#  Set up a save/load test.

## Default length for a [RopePiece].  Overwritten by 
## [annotation RopePieceParameters.piece_length] on the [RopeAnchor] in the
## scene.
const DEFAULT_PIECE_LENGTH := 20.0

## Default value for how close a [RopePiece] has to get to a target [RopeAnchor]
## or location to be considered as having arrived.
const DEFAULT_LOCATION_TOLERANCE := 4.0

var _rope_start: RopePiece
var _rope_last_piece: RopePiece
var _owned_rope_end: bool = false

var _close_tolerance: float

var _pending_spool_pieces: int = 0

## Returns the [annotation RopePieceParameters.piece_length] value specified
## in the [param _init.start] [RopeAnchor] used to create this [Rope2D].
var piece_length: float:
	get():
		return _rope_start.piece_parameters.piece_length



func _create_piece() -> RopePiece:
	return _rope_start.create_piece(self)


## Pass in a RopeAnchor-contract conforming RopePiece as the first parameter.[br]
## [br]
## * [param start] - a scene instantiation of a [RopeAnchor], for
## example a [RopeAnchorPinJoint].tscn or a [RopeAnchorGroovePin].tscn.[br]
## [br]
## * [param close_tolerance] - used when connecting a [RopePiece] with
##   a specified anchor or location to specify "close enough". [i](Default: [constant CLOSE_TOLERANCE])[/i][br]
func _init(
		start: RopePiece,
		close_tolerance: float = DEFAULT_LOCATION_TOLERANCE,
) -> void:
	_rope_start = start
	_close_tolerance = close_tolerance

## Create [RopePiece] elements between the [member _rope_start] and [param end_or_vec2],
## which can either be a [RopeAnchor] conforming instantiated scene like
## [RopeAnchorPinJoint] or [RopeAnchorGroovePin], or a [Vector2] [annotation Node2D.global_position]
## that indicates a target location for the [Rope2D] to finish within
## [member _close_tolerance].
## [br]
## * [param end_or_vec2] - a [RopeAnchor] instantiated in the scene or a [Vector2]
##   specifying the target location for the [Rope2D] to finish.[br]
## [br]
## * [param max_segments] - the maximum number of segments, or [code]-1[/code] if no maximum,
##   to use when extending towards [param end_or_vec2].  Useful when specifying
##   a [Rope2D] of fixed length.[br]
## [br]
## * [param start_piece] - extend the current rope from this [RopePiece], largely
##   used internally from [method extend].
func create_rope(end_or_vec2: Variant, max_segments: int = -1, start_piece: RopePiece = _rope_start) -> RopePiece:
	var end_pos: Vector2

	if end_or_vec2 is Vector2i:
		end_or_vec2 = Vector2(end_or_vec2.x, end_or_vec2.y)

	if end_or_vec2 is Vector2:
		end_pos = end_or_vec2
	else:
		end_pos = (end_or_vec2 as RopePiece).get_start_position()

	var start_pos: Vector2 = start_piece.get_start_position()
	var distance := start_pos.distance_to(end_pos)
	var num_segments: int = round(distance / piece_length)
	var actual_angle := start_pos.angle_to_point(end_pos)
	var spawn_angle: float = actual_angle - PI / 2
	var floating_end: bool = false

	if max_segments != -1 and num_segments > max_segments:
		floating_end = true
		num_segments = max_segments

	_rope_last_piece = _create_rope_segments(start_piece, num_segments, spawn_angle, end_pos)

	var rope_end: RopePiece

	if end_or_vec2 is Vector2 or floating_end:
		rope_end = _rope_start.clone(self)
		rope_end.global_position = (_rope_last_piece.get_start_position() +
			Vector2.from_angle(actual_angle).normalized() * piece_length )

		_owned_rope_end = true
	else:
		rope_end = end_or_vec2

	# Connect the last_piece to the end of the chain.
	_rope_last_piece.set_next_piece(rope_end)

	return rope_end

## Extend the length of the [Rope2D] in the direction of [param end_or_vec2]
## for a maximum [param max_segments], [code]-1[/code] means until the last [RopePiece]
## is within [member _close_tolerance] of [param end_or_vec2].[br]
## [br]
## * [param end_or_vec2] - a [RopeAnchor] instantiated in the scene or a [Vector2]
##   specifying the target location for the [Rope2D] to finish.[br]
## [br]
## * [param max_segments] - the maximum number of segments, or [code]-1[/code] if no maximum,
##   to use when extending towards [param end_or_vec2].  Useful when specifying
##   a [Rope2D] of fixed length.[br]
## [br]
## [b]Note:[/b] [method extend] extends the [Rope2D] from the [i]end[/i] of the rope, while
## [method spool] extends the [Rope2D] from the [i]start[/i] of the rope.  Use
## [method extend] when there is a destination to reach, and use [method spool]
## when there's physics in effect on the rope pulling new [RopePiece]s out of
## the spool.[br]
func extend(end_or_vec2: Variant, max_segments: int = -1) -> RopePiece:
	if _owned_rope_end:
		var rope_end: RopePiece = _rope_last_piece.next_piece
		remove_child(rope_end)
		_rope_last_piece.clear_next()
	return create_rope(end_or_vec2, max_segments, _rope_last_piece)

## Add new [RopePiece] elements to a logical "spool" located at
## [member _rope_start].  As the [Rope2D] is pulled via physics, new
## pieces will be spooled out until [param spool_pieces] have been added
## to the rope.  Each [RopePiece] will be [member piece_length] in size.[br]
## [br]
## * [param spool_pieces] - the number of new [RopePiece] to add to the
##   [Rope2D].[br]
## [br]
## [b]Note:[/b] [method extend] extends the [Rope2D] from the [i]end[/i] of the rope, while
## [method spool] extends the [Rope2D] from the [i]start[/i] of the rope.  Use
## [method extend] when there is a destination to reach, and use [method spool]
## when there's physics in effect on the rope pulling new [RopePiece]s out of
## the spool.[br]
func spool(spool_pieces: int = 1):
	_pending_spool_pieces += spool_pieces

	# Already spooling in progress
	if _pending_spool_pieces != spool_pieces:
		return

	while _pending_spool_pieces > 0:
		await _spool_next_piece()
		_pending_spool_pieces -= 1



func _create_rope_segments(start: RopePiece, num_segments: int, spawn_angle: float, end_pos: Variant) -> RopePiece:
	var piece: RopePiece = start
	for i in num_segments:
		piece = _add_piece(piece, i, spawn_angle)
		var joint_pos := piece.get_start_position()
		if end_pos and joint_pos.distance_to(end_pos) < _close_tolerance:
			break

	return piece


func _add_piece(prev_piece: RopePiece, id: int, spawn_angle: float) -> RopePiece:
	var piece := _create_piece()
	piece.global_position = prev_piece.get_start_position()
	piece.rotation = spawn_angle
	piece.set_name("rope_piece_" + str(id))

	prev_piece.set_next_piece(piece)

	return piece


func _spool_next_piece():
	var old_first_piece := _rope_start.next_piece

	# Determine the direction of the first piece in the rope
	# XXX Why double-next here?
	var start_angle := _rope_start.next_piece.next_piece.get_angle_to_next()
	var back_angle_vec := Vector2.from_angle(start_angle - PI / 2)

	# Find the position behind the current starting position
	var start_position := _rope_start.global_position
	var new_position := start_position + back_angle_vec * piece_length

	# print("spool from angle: ", start_angle, "(", rad_to_deg(start_angle), ") to angle: ", back_angle, "(", rad_to_deg(back_angle), ") shifting from: ", start.global_position, " to: ", new_position, " on vector: ", back_angle_vec)

	# Create a new End Piece to act as a temporary anchor during physics
	var new_start: RopePiece = _rope_start.clone(self)
	new_start.gravity_scale = 0.0
	new_start.global_position = new_position

	# Create the new piece to insert into the rope
	var new_piece := _add_piece(new_start, 99, start_angle)
	new_piece.next_piece = old_first_piece

	# Connect the old first piece after the new piece
	new_piece.set_next_piece(old_first_piece)

	# Decouple _rope_start's joint but keep next_piece valid
	_rope_start.clear_next()
	_rope_start.next_piece = new_piece
	_rope_start.visible = false

	# Now set up the force to unspool it:
	# await new_start.relocate_to(start_position)
	await new_start.relocate_to(piece_length, start_angle, _rope_start)

	# Reattach the old start and free the new start when the new start arrives
	_rope_start.set_next_piece(new_piece)
	# get_joint(_rope_start).node_b = get_joint(new_start).node_b
	# _rope_start.next_piece = new_piece
	new_start.queue_free()
	_rope_start.visible = true


## Returns the length of the [RopePiece]s between [param from] and [param to], or
## the entire [Rope2D] if unspecified.
func calculate_rope_length(from: RopePiece = _rope_start, to: RopePiece = _rope_last_piece) -> float:
	var walker: RopePiece = from
	var dist: float = 0.0

	while walker and walker != to:
		if not walker.next_piece:
			break

		dist += walker.get_start_position().distance_to(walker.next_piece.get_start_position())
		walker = walker.next_piece

	return dist

## Returns an [Array][lb][Vector2[rb] of the [annotation Node2D.global_position]'s for
## each [RopePiece].[br]
## [br]
## Used when drawing a [Line2D] or other visual effect that follows the [Rope2D].
func get_points() -> Array[Vector2]:
	var points: Array[Vector2] = []
	var walker: RopePiece = _rope_start.next_piece
	while walker:
		points.append(walker.global_position)
		walker = walker.next_piece
	return points


## Returns a serializable [Dictionary] that represents the [Rope2D] in the [annotation Node2D.global_position]
## coordinate space.
func to_json() -> Dictionary:
	var rope = []
	var walker: RopePiece = _rope_start.next_piece
	var last_piece: RopePiece = _rope_start
	while walker:
		rope.append(walker.rotation)
		last_piece = walker
		walker = walker.next_piece

	return {
		"close_tolerance": _close_tolerance,
		"rope": rope,
		"end_global_position": str(last_piece.global_position),
	}


## Returns a [Rope2D] that's ready for a [method from_json] call.  The
## [param start] should have the same values for the
## [annotation RopeAnchor.rope_piece_parameters] and [annotation RopeAnchor.rope_anchor_parameters]
## as when the [method to_json] was invoked.[br]
## [br]
## * [param start] - the [RopePiece] that was originally passed to [method create_rope].[br]
## [br]
## * [param saved_rope] - the [Dictionary] returned from [method to_json].
static func create_saved_rope(start: RopePiece, saved_rope: Variant) -> Rope2D:
	return Rope2D.new(
		start,
		saved_rope.close_tolerance
	)

## Returns the last [RopePiece] created.[br]
## [br]
## Instantiates the [RopePiece]s from the [param saved_rope], and adds them
## to the [Rope2D].[br]
## [br]
## * [param saved_rope] - the [Dictionary] returned from [method to_json].
func from_json(saved_rope: Variant) -> RopePiece:
	if not "rope" in saved_rope:
		return

	_rope_last_piece = _set_points(saved_rope.rope)

	# Assumes free-floating endpoint.
	var rope_end_piece: RopePiece
	rope_end_piece = _rope_start.clone(self)
	rope_end_piece.global_position = Utility.string_to_vector2(saved_rope.end_global_position)
	_owned_rope_end = true

	# Connect the last_piece to the end of the chain.
	_rope_last_piece.set_next_piece(rope_end_piece)

	return rope_end_piece


func _set_points(points: Array) -> RopePiece:
	var piece: RopePiece = _rope_start

	# Ignore the last entry which is the rope_end_piece
	for i in range(0, points.size() - 1):
		piece = _add_piece(piece, i, points[i])

	return piece
