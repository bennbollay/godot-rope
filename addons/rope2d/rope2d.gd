extends Node2D

class_name Rope2D
## A class to manage and create Rope2D chains.

enum RopeType {
	## Each [RopePiece] uses a [RigidBody2D]+[CollisionShape2D] with the joint dynamics managed
	## by a [PinJoint2D].  The default shape of the [CollisionShape2D] is a [CapsuleShape2D],
	## which can be changed via [member rope_piece_parameteers].[br]
	## [br]
	## Use a [constant Rope2D.ROPE_TYPE_PINJOINT] when the length of the [Rope2D]
	## is allowed to flex (approximately 1 piece length per 20 pieces) in response
	## to certain physics stressors. Less likely than
	## [constant Rope2D.ROPE_TYPE_GROOVEPIN] to suffer catastrophic physics failure
	## in most situations.
	ROPE_TYPE_PINJOINT,
	## Not currently supported; does nothing.
	ROPE_TYPE_GROOVEPIN,
}

enum ReadyAction {
	## Do not create a rope when this node is added to the tree.
	NOTHING,
	
	## Create a new rope to the position in [end_position] or the position
	## of the node specified in [end_node].
	CREATE_TO_POSITION,
	
	## Create a new rope to a [RopeAnchor] created under [member ending_anchor_mount_point].
	CREATE_TO_MOUNT,
}

## Default length for a [RopePiece].  Overwritten by 
## [annotation RopePieceParameters.piece_length] on the [RopeAnchor] in the
## scene.
const DEFAULT_PIECE_LENGTH := 20.0

## Default value for how close a [RopePiece] has to get to a target [RopeAnchor]
## or location to be considered as having arrived.
const DEFAULT_LOCATION_TOLERANCE := 4.0

## Choose the type of the joing for this rope; currently only [constant Rope2D.ROPE_TYPE_PINJOINT]
## fully supported.
@export_custom(PROPERTY_HINT_ENUM, "Pin Joint,Groove Pin") var rope_type: RopeType = RopeType.ROPE_TYPE_PINJOINT

## A set of parameters that are applied to the [RopeAnchor] at the start of the Rope2D.
@export var rope_starting_anchor_parameters: RopePieceParameters
## A set of parameters that are applied to the [RopeAnchor] at the start of the Rope2D.
@export var rope_ending_anchor_parameters: RopePieceParameters

## A set of parameters that are applied to each created [RopePiece], to allow for controlling
## various physics properties.
@export var rope_piece_parameters: RopePieceParameters
## Default value for how close a [RopePiece] has to get to a target [RopeAnchor]
## or location to be considered as having arrived.
@export var close_tolerance: float = DEFAULT_LOCATION_TOLERANCE

## When [method _ready] and either [member end_position] or [member ending_anchor_mount_point]
## are set, create the Rope2D.
@export var ready_action: ReadyAction = ReadyAction.NOTHING

@export_group("Rope Targets (Optional, Pick One)")
## Specify the target end position for the [Rope2D], used when [method create]
## is called or on [method _ready] if [member ready_action] is set to
## [constant Rope2D.CREATE_TO_POSITION].
@export var end_position_vector: Vector2
## Specify the target end position for the [Rope2D], used when [method create]
## is called or on [method _ready] if [member ready_action] is set to
## [constant Rope2D.CREATE_TO_POSITION], and [member end_position_vector] is not set.[br]
## [br]
## Only [member Node2D.global_position] is used. Use [member ending_anchor_mount_point]
## to control where the ending [RopeAnchor] is mounted in the tree.
@export var end_position_node: Node2D


@export_group("Mount Points (Optional)")
## Specifies the node on the tree to mount newly created [RopePiece]
## under, including [RopeAnchor] if neither [member starting_anchor_mount_point]
## or [member ending_anchor_mount_point] are specified.[br]
## [br]
## Defaults to a newly created [Node] mounted under the [Rope2D].
@export var rope_piece_mount_point: Node

## Specifies the node on the tree to mount the starting [RopeAnchor]
## under.[br]
## [br]
## Defaults to this [Rope2D] node.
@export var starting_anchor_mount_point: Node

## Specify the node to mount the end-of-rope anchor under for the
## [Rope2D], used when [create()] is called or on [_ready] if
## [ready_action] is set to [ReadyAction.CREATE_TO_MOUNT].[br]
## [br]
## Defaults to the resulting value of [member rope_piece_mount_point].
@export var ending_anchor_mount_point: Node

## Fired when a new [RopePiece] is created to allow for additional customization
## at runtime.
signal on_new_rope_piece(piece: RopePiece)
## Fired when a new [RopeAnchor] (passed as a [RopePiece]) is created to allow for additional customization
## at runtime.
signal on_new_rope_anchor(anchor: RopePiece)

# XXX:
#  Rebuild test_rope using the new API
#  Support negative values for spool and extend to withdraw elements smoothly.
#  Set up a "launcher" test.
#    * Fire a projectile and then extend the line out after it?
#    -- This is actually a pretty good idea, doing the same "extend" that
#       is used to follow the mouse.  Just make sure that the points returned
#       also include the "chased" point.
#  Add a demo for following a Line2D.
#    -- Maybe even trimming the Line2D's visibility as it goes along, if feasible.
#  Set up a save/load test.

var _rope_start: RopePiece
var _rope_last_piece: RopePiece
var _owned_rope_end: bool = false


var _pending_spool_pieces: int = 0

## Returns the [annotation RopePieceParameters.piece_length] value specified
## in the [method _init].start [RopeAnchor] used to create this [Rope2D].
var piece_length: float:
	get():
		return rope_piece_parameters.piece_length


## Pass in a RopeAnchor-contract conforming RopePiece as the first parameter.[br]
func _init() -> void:
	# Popualte the starting mount points
	if not rope_piece_mount_point:
		rope_piece_mount_point = Node.new()
		rope_piece_mount_point.name = "Pieces"
		add_child(rope_piece_mount_point)
	if not starting_anchor_mount_point:
		starting_anchor_mount_point = self
	if not ending_anchor_mount_point:
		ending_anchor_mount_point = rope_piece_mount_point
	
	# Populate the default parameters
	if not rope_piece_parameters:
		rope_piece_parameters = RopePieceParameters.new()
	if not rope_starting_anchor_parameters:
		rope_starting_anchor_parameters = RopePieceParameters.new()
	if not rope_ending_anchor_parameters:
		rope_ending_anchor_parameters = RopePieceParameters.new()


func _ready():
	await _guarantee_ready(starting_anchor_mount_point)
	_rope_start = _new_anchor(starting_anchor_mount_point, rope_starting_anchor_parameters)
	
	if ready_action == ReadyAction.NOTHING:
		return
	if ready_action == ReadyAction.CREATE_TO_POSITION:
		if not validate_create_to_mount_configuration():
			return
		if end_position_vector:
			_rope_start.set_piece_rotation(_get_spawn_angle(_rope_start, end_position_vector))
			create_rope(end_position_vector)
		elif end_position_node:
			_rope_start.set_piece_rotation(_get_spawn_angle(_rope_start, end_position_node.global_position))
			create_rope(end_position_node.global_position)
	elif ready_action == ReadyAction.CREATE_TO_MOUNT:
		if not validate_create_to_mount_configuration():
			return
		_rope_start.set_piece_rotation(_get_spawn_angle(_rope_start, ending_anchor_mount_point.global_position))
		await _guarantee_ready(ending_anchor_mount_point)
		create_rope(_new_anchor(ending_anchor_mount_point, rope_ending_anchor_parameters))

func _guarantee_ready(n: Node):
	if not n.is_node_ready():
		await n.ready
	
## Without a valid position, or a Node2D whose global_position can be used,
## the CREATE_TO_POSITION setting isn't able to create the desired Rope2D.
func validate_create_to_position_configuration() -> bool:
	if not end_position_vector and (not end_position_node or not end_position_node is Node2D):
		push_warning("Create To Position missing end_position_vector or end_position_node.")
		return false
	return true

func validate_create_to_mount_configuration() -> bool:
	if ready_action == ReadyAction.CREATE_TO_MOUNT and not ending_anchor_mount_point is Node2D:
		# Without a Node2D ending_anchor_mount_point, the Rope2D defaults to (0,0), which
		# is almost certainly not the desired behavior.
		push_warning("Create To Mount missing a Node2D ending_anchor_mount_point")
		return false
	return true
	


func _new_piece() -> RopePiece:
	var piece: RopePiece
	if rope_type == RopeType.ROPE_TYPE_PINJOINT:
		piece = RopePiecePinJoint.create_piece(rope_piece_mount_point, rope_piece_parameters)
	#elif rope_type == RopeType.ROPE_TYPE_GROOVEPIN:
	#	piece = RopePieceGroovePin.create(self, rope_piece_parameters)
	else:
		return null
	
	on_new_rope_piece.emit(piece)
	return piece

func _new_anchor(mount: Node, params: RopePieceParameters) -> RopePiece:
	var anchor: RopePiece
	if rope_type == RopeType.ROPE_TYPE_PINJOINT:
		anchor = RopeAnchorPinJoint.create_anchor(mount, params)
	#elif rope_type == RopeType.ROPE_TYPE_GROOVEPIN:
	#	anchor = RopeAnchorGroovePin.create_anchor(self, rope_anchor_parameters)
	else:
		return null
	
	on_new_rope_anchor.emit(anchor)
	return anchor

func _get_spawn_angle(start_piece: RopePiece = _rope_start, end_pos: Vector2 = _rope_last_piece.global_position):
	var start_pos: Vector2 = start_piece.get_next_position()
	var actual_angle := start_pos.angle_to_point(end_pos)
	var spawn_angle: float = actual_angle - PI / 2
	
	return spawn_angle


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
		end_pos = (end_or_vec2 as RopePiece).get_prev_position()

	var start_pos: Vector2 = start_piece.get_next_position()
	var distance := start_pos.distance_to(end_pos)
	var num_segments: int = ceil(distance / piece_length)
	var spawn_angle: float = _get_spawn_angle(start_piece, end_pos)
	var floating_end: bool = false

	#print("XXX reducing num_segments by one")
	#num_segments -= 1
	#print(start_pos, "->", end_pos, "=", distance, " with ", num_segments, " * ", piece_length)
	if max_segments != -1 and num_segments > max_segments:
		floating_end = true
		num_segments = max_segments

	# Rotate the first piece
	#start_piece.set_piece_rotation(spawn_angle)
	_rope_last_piece = _create_rope_segments(start_piece, num_segments, spawn_angle, end_pos)

	var rope_end: RopePiece

	if end_or_vec2 is Vector2 or floating_end:
		rope_end = _create_ending_anchor(ending_anchor_mount_point, _rope_last_piece, -1, spawn_angle)
		#rope_end.set_piece_position((_rope_last_piece.get_start_position() +
		#	Vector2.from_angle(actual_angle).normalized() * piece_length ))

		_owned_rope_end = true
	else:
		rope_end = end_or_vec2
		#rope_end.set_piece_position(_rope_last_piece.get_start_position())
		#rope_end.set_piece_rotation(spawn_angle)


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
		piece = _create_piece(piece, i, spawn_angle)
		var joint_pos := piece.get_next_position()
		if end_pos and joint_pos.distance_to(end_pos) < close_tolerance:
			break

	return piece


func _create_piece(prev_piece: RopePiece, _id: int, spawn_angle: float) -> RopePiece:
	var piece := _new_piece()

	piece.set_piece_position(prev_piece.get_next_position())
	piece.set_piece_rotation(spawn_angle)

	prev_piece.set_next_piece(piece)

	return piece

func _create_ending_anchor(mount: Node, prev_piece: RopePiece, _id: int, spawn_angle: float) -> RopePiece:
	var piece := _new_anchor(mount, rope_ending_anchor_parameters)
	
	piece.set_piece_position(prev_piece.get_next_position())
	piece.set_piece_rotation(spawn_angle)

	prev_piece.set_next_piece(piece)

	return piece


func _spool_next_piece():
	var old_first_piece := _rope_start.next_piece

	# Determine the direction of the first piece in the rope
	# XXX Why double-next here?
	var start_angle := _rope_start.next_piece.next_piece.get_angle_to_next()
	var back_angle_vec := Vector2.from_angle(start_angle - PI / 2)

	# Find the position behind the current starting position
	var start_position := _rope_start.get_prev_position()
	var new_position := start_position + back_angle_vec * piece_length

	# print("spool from angle: ", start_angle, "(", rad_to_deg(start_angle), ") to angle: ", back_angle, "(", rad_to_deg(back_angle), ") shifting from: ", start.global_position, " to: ", new_position, " on vector: ", back_angle_vec)

	# Create a new End Piece to act as a temporary anchor during physics
	var new_start: RopePiece = _new_anchor(starting_anchor_mount_point, rope_starting_anchor_parameters)
	
	# XXX this is a capsul here but a circle elsewhere.
	new_start.set_piece_position(new_position)
	print(new_start, "Starting new position from ", _rope_start.global_position, "@", rad_to_deg(start_angle - PI / 2), " for ", piece_length, " = ", new_position)


	# Create the new piece to insert into the rope
	var new_piece := _create_piece(new_start, 99, start_angle)

	# Connect the old first piece after the new piece
	new_piece.set_next_piece(old_first_piece)

	_rope_start.clear_next()
	# Decouple _rope_start's joint but keep next_piece valid
	_rope_start.next_piece = new_piece
	_rope_start.set_piece_visible(false)

	# Now set up the force to unspool it:
	# await new_start.relocate_to(start_position)
	await new_start.relocate_to(piece_length, start_angle, _rope_start)

	# Reattach the old start and free the new start when the new start arrives
	_rope_start.set_next_piece(new_piece)
	
	new_start.queue_free()
	_rope_start.set_piece_visible(true)


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

## Freeze all of the physics in the Rope
func freeze_rope():
	freeze_nodes(self)
	freeze_nodes(_rope_start)
	freeze_nodes(_rope_last_piece)
	if _rope_last_piece.next_piece:
		freeze_nodes(_rope_last_piece.next_piece)
	
func freeze_nodes(v: Variant):
	if "freeze" in v:
		v.freeze = true
	if "get_children" in v:
		for n in v.get_children():
			freeze_nodes(n)
	


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
		"close_tolerance": close_tolerance,
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
	# XXX Broken
	return Rope2D.new()

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
	rope_end_piece.set_piece_position(Utility.string_to_vector2(saved_rope.end_global_position))
	_owned_rope_end = true

	# Connect the last_piece to the end of the chain.
	_rope_last_piece.set_next_piece(rope_end_piece)

	return rope_end_piece


func _set_points(points: Array) -> RopePiece:
	var piece: RopePiece = _rope_start

	# Ignore the last entry which is the rope_end_piece
	for i in range(0, points.size() - 1):
		piece = _create_piece(piece, i, points[i])

	return piece
