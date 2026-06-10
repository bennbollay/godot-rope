@icon("res://addons/rope2d/icon/plenticons-chain-yellow.svg")
extends Node2D

class_name Rope2D
## A class to manage and create Rope2D chains. Allows for mounting the start and endpoint of the
## Rope2D on specific Node's in the tree, letting the rope connect two moving nodes or otherwise
## attach to the scene.

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

	## Create a new rope to the position in [member end_position_vector] or the position
	## of the node specified in [member end_position_node].[br]
	## [br]
	## [b]Note:[/b] Does not mount the ending anchor under [member end_position_node]. Set
	## [member ending_anchor_mount_point] if that's desired, or use [constant Rope2D.CREATE_TO_MOUNT].
	CREATE_TO_POSITION,

	## Create a new rope to an anchor created under [member ending_anchor_mount_point].
	CREATE_TO_MOUNT,
}

## Default length for a [RopePiece].  Overwritten by [member rope_piece_parameters.piece_length].
const DEFAULT_PIECE_LENGTH := 20.0

## Default value for how close a [RopePiece] has to get to a target anchor
## or location to be considered as having arrived.
const DEFAULT_LOCATION_TOLERANCE := 4.0

## Choose the type of the joint for this rope; currently only [constant Rope2D.ROPE_TYPE_PINJOINT]
## is fully supported.
@export_custom(PROPERTY_HINT_ENUM, "Pin Joint,Groove Pin") var rope_type: RopeType = RopeType.ROPE_TYPE_PINJOINT

## A set of parameters that are applied to the anchor at the start of the Rope2D.
@export var rope_starting_anchor_parameters: RopePieceParameters
## A set of parameters that are applied to the anchor at the end of the Rope2D.
@export var rope_ending_anchor_parameters: RopePieceParameters
## A set of parameters that are applied to each created [RopePiece], to allow for controlling
## various physics properties.
@export var rope_piece_parameters: RopePieceParameters

## Default value for how close a [RopePiece] has to get to a target anchor
## or location to be considered as having arrived.
@export var close_tolerance: float = DEFAULT_LOCATION_TOLERANCE

## When [method _ready] and [member end_position_vector], [member end_position_node], or [member ending_anchor_mount_point]
## are set, do the following:
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
## to control where the ending anchor is mounted in the tree.
@export var end_position_node: Node2D

@export_group("Mount Points (Optional)")
## Specifies the node on the tree to mount newly created [RopePiece]
## under, including anchors if neither [member starting_anchor_mount_point]
## or [member ending_anchor_mount_point] are specified.[br]
## [br]
## Defaults to a newly created [Node] mounted under the [Rope2D].
@export var rope_piece_mount_point: Node

## Specifies the node on the tree to mount the starting anchor
## under.[br]
## [br]
## Defaults to this [Rope2D] node.
@export var starting_anchor_mount_point: Node

## Specify the node to mount the end-of-rope anchor under for the
## [Rope2D], used when [method create_rope] is called or on [method _ready] if
## [member ready_action] is set to [constant Rope2D.CREATE_TO_MOUNT].[br]
## [br]
## Defaults to the resulting value of [member rope_piece_mount_point].
@export var ending_anchor_mount_point: Node

## Emits when a new [RopePiece] is created to allow for additional customization
## at runtime.
signal on_new_rope_piece(piece: RopePiece)
## Emits when a new anchor (passed as a [RopePiece]) is created to allow for additional customization
## at runtime.
signal on_new_rope_anchor(anchor: RopePiece)
## Emits when the rope is initially created via the [method create_rope] call or in [method _ready]
## if [member ready_action] is set to [constant Rope2D.CREATE_TO_POSITION] or
## [constant Rope2D.CREATE_TO_MOUNT].
signal on_rope_create(rope: Rope2D)

var _rope_start: RopePiece
var _rope_end: RopePiece
var _rope_last_piece: RopePiece

var _pending_spool_pieces: int = 0
var _rope_spooling_anchor_parameters: RopePieceParameters = RopePieceParameters.new()
var _spool_lock: float = 0
signal _on_spool_release()

## Returns the [annotation RopePieceParameters.piece_length] value.
var piece_length: float:
	get():
		return rope_piece_parameters.piece_length


## Initialize the various parameters to sensible defaults.  The [member rope_piece_mount_point],
## [member starting_anchor_mount_point], [member ending_anchor_mount_point],
## [member rope_piece_parameters], [member rope_starting_anchor_parameters], and
## [member rope_ending_anchor_parameters] can all be overwritten after the creation
## of the Rope2D object.
func _init() -> void:
	# Populate the starting mount points
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


## After the [member starting_anchor_mount_point] and [member ending_anchor_mount_point]
## are ready, and [member ready_action] specifies an action, create the appropriate
## pieces between the specified locations.[br]
## [br]
## [b]Note:[/b] If [member ready_action] is [constant Rope2D.NOTHING] then no action is taken.
func _ready():
	await _guarantee_ready(starting_anchor_mount_point)
	_rope_start = _new_anchor(starting_anchor_mount_point, rope_starting_anchor_parameters)

	if ready_action == ReadyAction.NOTHING:
		return

	if ready_action == ReadyAction.CREATE_TO_POSITION:
		if not _validate_create_to_mount_configuration():
			return

		await _guarantee_ready(ending_anchor_mount_point)

		if end_position_vector:
			_rope_start.set_piece_rotation(_get_spawn_angle(_rope_start, end_position_vector))
			create_rope(end_position_vector)
		elif end_position_node:
			_rope_start.set_piece_rotation(_get_spawn_angle(_rope_start, end_position_node.global_position))
			create_rope(end_position_node.global_position)

	elif ready_action == ReadyAction.CREATE_TO_MOUNT:
		if not _validate_create_to_mount_configuration():
			return
		await _guarantee_ready(ending_anchor_mount_point)

		_rope_start.set_piece_rotation(_get_spawn_angle(_rope_start, ending_anchor_mount_point.global_position))
		create_rope(ending_anchor_mount_point.global_position)


func _guarantee_ready(n: Node):
	if not n.is_node_ready():
		await n.ready


# Without a valid position, or a [Node2D] whose global_position can be used,
# the [constant Rope2D.CREATE_TO_POSITION] setting isn't able to create the desired Rope2D.
func _validate_create_to_position_configuration() -> bool:
	if not end_position_vector and (not end_position_node or not end_position_node is Node2D):
		push_warning("Create To Position missing end_position_vector or end_position_node.")
		return false
	return true


# Without a Node2D ending_anchor_mount_point, the Rope2D defaults to (0,0), which
# is almost certainly not the desired behavior.
func _validate_create_to_mount_configuration() -> bool:
	if ready_action == ReadyAction.CREATE_TO_MOUNT and not ending_anchor_mount_point is Node2D:
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
	#	anchor = RopeAnchorGroovePin.create_anchor(mount, params)
	else:
		return null

	on_new_rope_anchor.emit(anchor)
	return anchor


func _get_spawn_angle(start_piece: RopePiece = _rope_start, end_pos: Vector2 = _rope_last_piece.global_position):
	var start_pos: Vector2 = start_piece.get_next_position()
	var actual_angle := start_pos.angle_to_point(end_pos)
	var spawn_angle: float = actual_angle - PI / 2

	return spawn_angle


func _max_length_to_max_segments(max_length: float = -1) -> int:
	if max_length == -1:
		return -1
	return _length_to_segments(max_length)


func _length_to_segments(max_length: float = -1) -> int:
	return sign(max_length) * ceil(abs(max_length / piece_length))


## Create [RopePiece] elements between the Rope2D and [param target].[br]
## [br]
## [b]Parameters:[/b][br][br]
## * [param target] - a [Vector2]
##   specifying the target location for the [Rope2D] to finish.[br]
## [br]
## * [param max_segments] - the maximum number of segments, or [code]-1[/code] if no maximum,
##   to use when extending towards [param target].  Useful when specifying
##   a [Rope2D] of fixed length.[br]
## [br]
## * [param start_piece] - extend the current rope from this [RopePiece], largely
##   used internally from [method extend].
func create_rope(target: Vector2, max_length: float = -1, start_piece: RopePiece = _rope_start) -> RopePiece:
	var max_segments = _max_length_to_max_segments(max_length)
	var start_pos: Vector2 = start_piece.get_next_position()
	var distance := start_pos.distance_to(target)

	if distance < close_tolerance:
		return _rope_end

	var num_segments: int = _length_to_segments(distance)
	var spawn_angle: float = _get_spawn_angle(start_piece, target)

	if max_segments != -1 and num_segments > max_segments:
		num_segments = max_segments

	_rope_last_piece = _create_rope_segments(start_piece, num_segments, spawn_angle, target)
	_rope_end = _create_ending_anchor(ending_anchor_mount_point, _rope_last_piece, -1, spawn_angle)

	# Connect the last_piece to the end of the chain.
	_rope_last_piece.set_next_piece(_rope_end)

	on_rope_create.emit(self)

	return _rope_end


## Extend the length of an already [method create_rope]ed [Rope2D] in the direction of [param target]
## for a maximum [param max_segments], [code]-1[/code] means until the last [RopePiece]
## is within [member _close_tolerance] of [param target].[br]
## [br]
## [b]Note:[/b] [method extend] extends the [Rope2D] from the [i]end[/i] of the rope, while
## [method spool] extends the [Rope2D] from the [i]start[/i] of the rope.  Use
## [method extend] when there is a destination to reach, and use [method spool]
## when there's physics in effect on the rope pulling new [RopePiece]s out of
## the spool.
## [br]
## [b]Parameters:[/b][br][br]
## * [param target] - a [Vector2]
##   specifying the target location for the [Rope2D] to finish.[br]
## [br]
## * [param max_length] - the maximum length of rope, or [code]-1[/code] if no maximum,
##   to use when extending towards [param target].  Useful when specifying
##   a [Rope2D] of fixed length.[br]
func extend(target: Vector2, max_length: int = -1) -> RopePiece:
	assert(max_length >= -1)
	if _rope_end:
		_rope_end.queue_free()
	if _rope_last_piece:
		_rope_last_piece.clear_next()
		return create_rope(target, max_length, _rope_last_piece)
	return create_rope(target, max_length)


## Reduce the length of the rope by [param length] by trimming pieces from the
## end of the rope. Adds a new anchor at the end.[br]
## [br]
## [b]Parameters:[/b][br][br]
## * [param length] - the amount to remove from the end.
func contract(length: float):
	var segments := _length_to_segments(length)

	if segments <= 0:
		return

	# Find the new last piece by walking the rope with a second
	# walker a 'segments' pieces behind, ignoring anchors.
	var new_last_piece: RopePiece
	var walker: RopePiece = _rope_start.next_piece
	while walker:
		if segments > 0:
			if not walker.is_anchor():
				segments -= 1
				if segments == 0:
					new_last_piece = _rope_start
		elif not walker.is_anchor():
			new_last_piece = new_last_piece.next_piece
		walker = walker.next_piece

	if not new_last_piece or new_last_piece.is_anchor():
		# Rope is already too short; just remove the whole rope already.
		return

	# Create the new anchor for the rope.
	var dead_piece := new_last_piece.next_piece
	_rope_last_piece = new_last_piece
	_rope_end = _create_ending_anchor(ending_anchor_mount_point, _rope_last_piece, -1, new_last_piece.rotation)
	_rope_last_piece.set_next_piece(_rope_end)

	# Delete all of the now unnecessary pieces, including the old trailing anchor.
	while dead_piece:
		dead_piece.queue_free()
		dead_piece = dead_piece.next_piece


## Add (or remove, if negative) [param spool_length] of [RopePiece] elements to
## a logical "spool" located at [member _rope_start].  As the [Rope2D] is
## pulled via physics, new pieces will be spooled out until
## [param spool_length] has been added to the rope.  Each [RopePiece] will be
## [member piece_length] in size.[br]
## [br]
## If [param spool_length] is negative, then pieces are pulled back into the spool
## using the force value specified in
## [annotation RopePieceParameters.push_rope_force].[br]
## [br]
## If [param spool_length] is positive, then pieces are extruded at a rate commensurate
## with the force being exerted on the [Rope2D], as from a [WindArea2D] or gravity.
## Additionally, if [annotation RopePieceParmaeters.push_rope] is set to true, then
## [annotation RopePieceParameters.push_rope_force] will be added to whatever other
## forces are applied against the rope.[br]
## [br]
## [b]Warning:[/b] Spool is not a particularly fast implementation, so alternative
## approaches may be necessary if a large number of pieces need to be spooled out
## rapidly.[br]
## [br]
## [b]Note:[/b] [method extend] extends the [Rope2D] from the [i]end[/i] of the rope, while
## [method spool] extends the [Rope2D] from the [i]start[/i] of the rope.  Use
## [method extend] when there is a destination to reach, and use [method spool]
## when there's physics in effect on the rope pulling new [RopePiece]s out of
## the spool.[br]
## [br]
## [b]Note:[/b] Invoking [code]await spool()[/code] will wait until all pending [method spool]
## invocations have completed, including the current one.
## [b]Parameters:[/b][br][br]
## - [param spool_length] - the length of rope to add.[br]
func spool(spool_length: float = 1, lock = randf()):
	var spool_pieces: int = _length_to_segments(spool_length)
	_pending_spool_pieces += spool_pieces

	if _spool_lock == 0:
		# Lock spooling to this invocation
		_spool_lock = lock
	else:
		# Spooling already in progress
		await _on_spool_release
		return

	while _pending_spool_pieces != 0:
		if _pending_spool_pieces > 0:
			await _spool_next_piece()
			_pending_spool_pieces -= 1
		if _pending_spool_pieces < 0:
			await _unspool_next_piece()
			_pending_spool_pieces += 1

	# Release the lock
	_spool_lock = 0
	_on_spool_release.emit()


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
	# XXX Why double-next here? Add check for minimum length if this is
	#     actually required.
	var start_angle := _rope_start.next_piece.next_piece.get_angle_to_next()
	var back_angle_vec := Vector2.from_angle(start_angle - PI / 2)

	# Find the position behind the current starting position
	var start_position := _rope_start.get_prev_position()
	var new_position := start_position + back_angle_vec * piece_length

	# Create a new End Piece to act as a temporary anchor during physics
	var new_start: RopePiece = _new_anchor(starting_anchor_mount_point, _rope_spooling_anchor_parameters)
	new_start.rename("SpoolAnchor")
	new_start.set_piece_position(new_position)
	#print(new_start, "Starting new position from ", _rope_start.global_position, "@", rad_to_deg(start_angle - PI / 2), " for ", piece_length, " = ", new_position)

	# Create the new piece to insert into the rope
	var new_piece := _create_piece(new_start, 99, start_angle)

	# Connect the old first piece after the new piece
	new_piece.set_next_piece(old_first_piece)

	_rope_start.clear_next()
	# Decouple _rope_start's joint but keep next_piece valid, used for collecting points.
	_rope_start.next_piece = new_piece
	_rope_start.set_piece_visible(false)

	# Now set up the force to unspool it:
	# await new_start.relocate_to(start_position)
	await new_start.relocate_to(piece_length, start_angle, _rope_start)

	# Reattach the old start and free the new start when the new start arrives
	_rope_start.set_next_piece(new_piece)

	new_start.queue_free()
	_rope_start.set_piece_visible(true)


func _unspool_next_piece():
	var old_first_piece := _rope_start.next_piece

	# Determine the direction of the first piece in the rope
	# XXX Why double-next here? Add check for minimum length if this is
	#     actually required.
	var start_angle := _rope_start.next_piece.next_piece.get_angle_to_next()
	var back_angle_vec := Vector2.from_angle(start_angle - PI / 2)

	# Find the position behind the current starting position
	var start_position := _rope_start.get_prev_position()
	var new_position := start_position + back_angle_vec * piece_length

	# Create a new End Piece to act as a temporary anchor during physics
	var new_start: RopePiece = _new_anchor(starting_anchor_mount_point, _rope_spooling_anchor_parameters)
	new_start.rename("SpoolAnchor")
	new_start.set_piece_position(_rope_start.get_prev_position())
	#print(new_start, "Starting new position from ", _rope_start.global_position, "@", rad_to_deg(start_angle - PI / 2), " for ", piece_length, " = ", new_position)

	# Connect the old first piece after the new piece
	new_start.set_next_piece(old_first_piece)

	_rope_start.clear_next()
	# Decouple _rope_start's joint but keep next_piece valid, used for collecting points.
	_rope_start.next_piece = old_first_piece
	_rope_start.set_piece_visible(false)

	# Now set up the force to unspool it:
	# await new_start.relocate_to(start_position)
	await new_start.relocate_to(-piece_length, start_angle, _rope_start, rope_piece_parameters.push_rope_force, new_position)
	_rope_start.set_next_piece(old_first_piece.next_piece)
	old_first_piece.clear_next()

	new_start.queue_free()
	old_first_piece.queue_free()
	_rope_start.set_piece_visible(true)


## Delete all of the created nodes in the rope and remove itself.[br]
## [br]
## This is especially relevant if [member rope_piece_mount_point],
## [member starting_anchor_mount_point], or [member ending_anchor_mount_point]
## are located outside of the [Rope2D] tree.[br]
func delete():
	var walker: RopePiece = _rope_start
	while walker:
		walker.queue_free()
		walker = walker.next_piece
	queue_free()


## Returns the length of the [RopePiece]s between [param from] and [param to], or
## the entire [Rope2D] if unspecified.[br]
## [br]
## [b]Parameters:[/b][br][br]
## * [param from] - The [RopePiece] to start counting at.[br][br]
## * [param to] - The [RopePiece] to finish counting at.
func calculate_rope_length(from: RopePiece = _rope_start, to: RopePiece = _rope_last_piece) -> float:
	var walker: RopePiece = from
	var dist: float = 0.0

	while walker and walker != to:
		if not walker.next_piece:
			break

		dist += walker.get_prev_position().distance_to(walker.next_piece.get_prev_position())
		walker = walker.next_piece

	return dist


## Returns an [Array][lb][Vector2[rb] of the [annotation Node2D.global_position]'s for
## each [RopePiece], with [param local] removed from each one.[br]
## [br]
## Used when drawing a [Line2D] or other visual effect that follows the [Rope2D].
## [br]
## [b]Parameters:[/b][br][br]
## * [param local] - A coordinate translation to transpose the points into a common
##   coordinate space, such as [member Node2D.global_position]
func get_points(local: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	var walker: RopePiece = _rope_start.next_piece
	if _pending_spool_pieces != 0:
		# Skip the first piece which is still being unspooled.
		walker = walker.next_piece
	var points: Array[Vector2] = [_rope_start.global_position - local]
	while walker:
		points.append(walker.global_position - local)
		walker = walker.next_piece
	return points


## Returns the trailing anchor of the rope.
func get_end_anchor() -> RopePiece:
	return _rope_end


## Freeze all of the physics in the Rope, extremely useful when debugging. An
## [code]unfreeze_rope()[/code] is left as an exercise for the reader.
func freeze_rope():
	_freeze_nodes(self)
	_freeze_nodes(_rope_start)
	_freeze_nodes(_rope_last_piece)
	_freeze_nodes(starting_anchor_mount_point)
	_freeze_nodes(ending_anchor_mount_point)
	_freeze_nodes(rope_piece_mount_point)
	if _rope_last_piece.next_piece:
		_freeze_nodes(_rope_last_piece.next_piece)


func _freeze_nodes(v: Variant):
	if "freeze" in v:
		v.freeze = true
	if "get_children" in v:
		for n in v.get_children():
			_freeze_nodes(n)


## Returns a serializable [Dictionary] that represents the [Rope2D] as a sequence
## of [annotation RigidBody2D.rotation] of [member piece_length] size. Optionally
## preserve the [member RigidBody2D.linear_velocity] and
## [member RigidBody2D.angular_velocity] if [param preserve_velocity] is
## [code]TRUE[/code][br]
## [br]
## Must be restored to a [Rope2D] with matching [annotation RopePieceParameters.piece_length], but
## other parameters and mount points are not persisted.[br]
## [br]
## [b]Parameters:[/b][br][br]
## * [param preserve_velocity] - Record the [annotation RigidBody2D.linear_velocity] and
## [annotation RigidBody2D.angular_velocity] of the [RopePiece]
func to_json(preserve_velocity: bool = false) -> Dictionary:
	var rope: Array[float] = []
	var forces = []
	var walker: RopePiece = _rope_start.next_piece
	var last_piece: RopePiece = _rope_start
	while walker:
		rope.append(walker.get_rotation())
		if preserve_velocity:
			forces.push_back(walker.get_velocities())

		last_piece = walker
		walker = walker.next_piece

	if rope.size() > 0:
		assert(last_piece == _rope_end)

	return {
		"piece_length": piece_length,
		"rope": rope,
		"forces": forces,
		"end_global_position": str(last_piece.global_position),
		"end_rotation": last_piece.rotation,
	}


func from_json(saved_rope: Variant) -> RopePiece:
	if not "rope" in saved_rope:
		return

	assert(saved_rope.piece_length == piece_length, "Different piece lengths unsupported")

	# Delete the existing pieces
	var walker: RopePiece = _rope_start.next_piece
	_rope_start.clear_next()
	while walker:
		walker.queue_free()
		walker = walker.next_piece

	_rope_last_piece = _set_points(saved_rope.rope, saved_rope.forces)

	# Assumes free-floating endpoint.
	_rope_end = _create_ending_anchor(
		ending_anchor_mount_point,
		_rope_last_piece,
		-1,
		saved_rope.end_rotation,
	)
	_rope_end.set_piece_position(
		Utility.string_to_vector2(saved_rope.end_global_position),
	)

	return _rope_last_piece


func _set_points(rotations: Array, forces: Array) -> RopePiece:
	var piece: RopePiece = _rope_start

	# Ignore the last entry which is the rope_end_piece
	for i in range(0, rotations.size() - 1):
		piece = _create_piece(piece, i, rotations[i])
		if forces.size() > i:
			piece.set_velocities(Utility.string_to_vector2(forces[i].linear_velocity), forces[i].angular_velocity)

	return piece
