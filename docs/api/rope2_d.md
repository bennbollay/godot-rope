# Rope2D

**Inherits**: [Node2D](https://docs.godotengine.org/en/stable/classes/class_node2d.html)

A class to manage and create Rope2D chains. Allows for mounting the start and endpoint of the Rope2D on specific Node's in the tree, letting the rope connect two moving nodes or otherwise attach to the scene.

---
## Constants
#### • `ROPE_TYPE_PINJOINT`: `0` <a id='ROPE_TYPE_PINJOINT'></a>

Each [RopePiece](./rope_piece.md) uses a [RigidBody2D](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html)+[CollisionShape2D](https://docs.godotengine.org/en/stable/classes/class_collisionshape2d.html) with the joint dynamics managed by a [PinJoint2D](https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html).  The default shape of the [CollisionShape2D](https://docs.godotengine.org/en/stable/classes/class_collisionshape2d.html) is a [CapsuleShape2D](https://docs.godotengine.org/en/stable/classes/class_capsuleshape2d.html), which can be changed via [rope_piece_parameteers](#rope_piece_parameteers).

Use a [Rope2D.ROPE_TYPE_PINJOINT](./rope2_d.md#ROPE_TYPE_PINJOINT) when the length of the [Rope2D](./rope2_d.md) is allowed to flex (approximately 1 piece length per 20 pieces) in response to certain physics stressors. Less likely than [Rope2D.ROPE_TYPE_GROOVEPIN](./rope2_d.md#ROPE_TYPE_GROOVEPIN) to suffer catastrophic physics failure in most situations.
#### • `ROPE_TYPE_GROOVEPIN`: `1` <a id='ROPE_TYPE_GROOVEPIN'></a>

Not currently supported; does nothing.
#### • `NOTHING`: `0` <a id='NOTHING'></a>

Do not create a rope when this node is added to the tree.
#### • `CREATE_TO_POSITION`: `1` <a id='CREATE_TO_POSITION'></a>

Create a new rope to the position in [end_position_vector](#end_position_vector) or the position of the node specified in [end_position_node](#end_position_node).

**Note:** Does not mount the ending anchor under [end_position_node](#end_position_node). Set [ending_anchor_mount_point](#ending_anchor_mount_point) if that's desired, or use [Rope2D.CREATE_TO_MOUNT](./rope2_d.md#CREATE_TO_MOUNT).
#### • `CREATE_TO_MOUNT`: `2` <a id='CREATE_TO_MOUNT'></a>

Create a new rope to an anchor created under [ending_anchor_mount_point](#ending_anchor_mount_point).
#### • `DEFAULT_PIECE_LENGTH`: `20.0` <a id='DEFAULT_PIECE_LENGTH'></a>

Default length for a [RopePiece](./rope_piece.md).  Overwritten by [rope_piece_parameters.piece_length](https://docs.godotengine.org/en/stable/classes/class_rope_piece_parameters.html#class-rope_piece_parameters-property-piece_length).
#### • `DEFAULT_LOCATION_TOLERANCE`: `4.0` <a id='DEFAULT_LOCATION_TOLERANCE'></a>

Default value for how close a [RopePiece](./rope_piece.md) has to get to a target anchor or location to be considered as having arrived.


---


## Properties
#### • `rope_type` <a id='rope_type'></a>

Choose the type of the joint for this rope; currently only [Rope2D.ROPE_TYPE_PINJOINT](./rope2_d.md#ROPE_TYPE_PINJOINT) is fully supported.
#### • `rope_starting_anchor_parameters` <a id='rope_starting_anchor_parameters'></a>

A set of parameters that are applied to the anchor at the start of the Rope2D.
#### • `rope_ending_anchor_parameters` <a id='rope_ending_anchor_parameters'></a>

A set of parameters that are applied to the anchor at the end of the Rope2D.
#### • `rope_piece_parameters` <a id='rope_piece_parameters'></a>

A set of parameters that are applied to each created [RopePiece](./rope_piece.md), to allow for controlling various physics properties.
#### • `close_tolerance` <a id='close_tolerance'></a>

Default value for how close a [RopePiece](./rope_piece.md) has to get to a target anchor or location to be considered as having arrived.
#### • `ready_action` <a id='ready_action'></a>

When [_ready](#_ready) and [end_position_vector](#end_position_vector), [end_position_node](#end_position_node), or [ending_anchor_mount_point](#ending_anchor_mount_point) are set, do the following:
#### • `end_position_vector` <a id='end_position_vector'></a>

Specify the target end position for the [Rope2D](./rope2_d.md), used when [create](#create) is called or on [_ready](#_ready) if [ready_action](#ready_action) is set to [Rope2D.CREATE_TO_POSITION](./rope2_d.md#CREATE_TO_POSITION).
#### • `end_position_node` <a id='end_position_node'></a>

Specify the target end position for the [Rope2D](./rope2_d.md), used when [create](#create) is called or on [_ready](#_ready) if [ready_action](#ready_action) is set to [Rope2D.CREATE_TO_POSITION](./rope2_d.md#CREATE_TO_POSITION), and [end_position_vector](#end_position_vector) is not set.

Only [Node2D.global_position](https://docs.godotengine.org/en/stable/classes/class_node2d.html#class-node2d-property-global_position) is used. Use [ending_anchor_mount_point](#ending_anchor_mount_point) to control where the ending anchor is mounted in the tree.
#### • `rope_piece_mount_point` <a id='rope_piece_mount_point'></a>

Specifies the node on the tree to mount newly created [RopePiece](./rope_piece.md) under, including anchors if neither [starting_anchor_mount_point](#starting_anchor_mount_point) or [ending_anchor_mount_point](#ending_anchor_mount_point) are specified.

Defaults to a newly created [Node](https://docs.godotengine.org/en/stable/classes/class_node.html) mounted under the [Rope2D](./rope2_d.md).
#### • `starting_anchor_mount_point` <a id='starting_anchor_mount_point'></a>

Specifies the node on the tree to mount the starting anchor under.

Defaults to this [Rope2D](./rope2_d.md) node.
#### • `ending_anchor_mount_point` <a id='ending_anchor_mount_point'></a>

Specify the node to mount the end-of-rope anchor under for the [Rope2D](./rope2_d.md), used when [create_rope](#create_rope) is called or on [_ready](#_ready) if [ready_action](#ready_action) is set to [Rope2D.CREATE_TO_MOUNT](./rope2_d.md#CREATE_TO_MOUNT).

Defaults to the resulting value of [rope_piece_mount_point](#rope_piece_mount_point).
#### • `piece_length` <a id='piece_length'></a>

Returns the [RopePieceParameters.piece_length](./rope_piece_parameters.md#piece_length) value.


---


## Method Descriptions
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create_rope(` `target:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`, ` `max_length:`&nbsp;&nbsp;`float` `, ` `start_piece:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='create_rope'></a>

#### Description:
Create [RopePiece](./rope_piece.md) elements between the Rope2D and `target`.

#### Parameters:


* `target` - a [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html) specifying the target location for the [Rope2D](./rope2_d.md) to finish.

* `max_segments` - the maximum number of segments, or `-1` if no maximum, to use when extending towards `target`.  Useful when specifying a [Rope2D](./rope2_d.md) of fixed length.

* `start_piece` - extend the current rope from this [RopePiece](./rope_piece.md), largely used internally from [extend](#extend).
***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`extend(` `target:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`, ` `max_length:`&nbsp;&nbsp;`int` `)`  <a id='extend'></a>

#### Description:
Extend the length of an already [create_rope](#create_rope)ed [Rope2D](./rope2_d.md) in the direction of `target` for a maximum `max_segments`, `-1` means until the last [RopePiece](./rope_piece.md) is within [_close_tolerance](#_close_tolerance) of `target`.

**Note:** [extend](#extend) extends the [Rope2D](./rope2_d.md) from the *end* of the rope, while [spool](#spool) extends the [Rope2D](./rope2_d.md) from the *start* of the rope.  Use [extend](#extend) when there is a destination to reach, and use [spool](#spool) when there's physics in effect on the rope pulling new [RopePiece](./rope_piece.md)s out of the spool.   
#### Parameters:


* `target` - a [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html) specifying the target location for the [Rope2D](./rope2_d.md) to finish.

* `max_length` - the maximum length of rope, or `-1` if no maximum, to use when extending towards `target`.  Useful when specifying a [Rope2D](./rope2_d.md) of fixed length.  

***
### • `void`&nbsp;&nbsp;`contract(` `length:`&nbsp;&nbsp;`float` `)`  <a id='contract'></a>

#### Description:
Reduce the length of the rope by `length` by trimming pieces from the end of the rope. Adds a new anchor at the end.

#### Parameters:


* `length` - the amount to remove from the end.
***
### • `void`&nbsp;&nbsp;`spool(` `spool_length:`&nbsp;&nbsp;`float` `, ` `lock:`&nbsp;&nbsp;`Variant` `)`  <a id='spool'></a>

#### Description:
Add (or remove, if negative) `spool_length` of [RopePiece](./rope_piece.md) elements to a logical "spool" located at [_rope_start](#_rope_start).  As the [Rope2D](./rope2_d.md) is pulled via physics, new pieces will be spooled out until `spool_length` has been added to the rope.  Each [RopePiece](./rope_piece.md) will be [piece_length](#piece_length) in size.

If `spool_length` is negative, then pieces are pulled back into the spool using the force value specified in [RopePieceParameters.push_rope_force](./rope_piece_parameters.md#push_rope_force).

If `spool_length` is positive, then pieces are extruded at a rate commensurate with the force being exerted on the [Rope2D](./rope2_d.md), as from a [WindArea2D](./wind_area2_d.md) or gravity. Additionally, if [RopePieceParmaeters.push_rope](https://docs.godotengine.org/en/stable/classes/class_ropepieceparmaeters.html#class-ropepieceparmaeters-annotation-push_rope) is set to true, then [RopePieceParameters.push_rope_force](./rope_piece_parameters.md#push_rope_force) will be added to whatever other forces are applied against the rope.

**Warning:** Spool is not a particularly fast implementation, so alternative approaches may be necessary if a large number of pieces need to be spooled out rapidly.

**Note:** [extend](#extend) extends the [Rope2D](./rope2_d.md) from the *end* of the rope, while [spool](#spool) extends the [Rope2D](./rope2_d.md) from the *start* of the rope.  Use [extend](#extend) when there is a destination to reach, and use [spool](#spool) when there's physics in effect on the rope pulling new [RopePiece](./rope_piece.md)s out of the spool.

**Note:** Invoking `await spool()` will wait until all pending [spool](#spool) invocations have completed, including the current one. #### Parameters:


- `spool_length` - the length of rope to add.  

***
### • `void`&nbsp;&nbsp;`delete(` `)`  <a id='delete'></a>

#### Description:
Delete all of the created nodes in the rope and remove itself.

This is especially relevant if [rope_piece_mount_point](#rope_piece_mount_point), [starting_anchor_mount_point](#starting_anchor_mount_point), or [ending_anchor_mount_point](#ending_anchor_mount_point) are located outside of the [Rope2D](./rope2_d.md) tree.  

***
### • `float`&nbsp;&nbsp;`calculate_rope_length(` `from:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`, ` `to:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='calculate_rope_length'></a>

#### Description:
Returns the length of the [RopePiece](./rope_piece.md)s between `from` and `to`, or the entire [Rope2D](./rope2_d.md) if unspecified.

#### Parameters:


* `from` - The [RopePiece](./rope_piece.md) to start counting at.

* `to` - The [RopePiece](./rope_piece.md) to finish counting at.
***
### • [Vector2[]](https://docs.godotengine.org/en/stable/classes/class_vector2[].html)&nbsp;&nbsp;`get_points(` `local:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='get_points'></a>

#### Description:
Returns an [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)[[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html) of the [Node2D.global_position](https://docs.godotengine.org/en/stable/classes/class_node2d.html#class-node2d-annotation-global_position)'s for each [RopePiece](./rope_piece.md), with `local` removed from each one.

Used when drawing a [Line2D](https://docs.godotengine.org/en/stable/classes/class_line2d.html) or other visual effect that follows the [Rope2D](./rope2_d.md).   
#### Parameters:


* `local` - A coordinate translation to transpose the points into a common coordinate space, such as [Node2D.global_position](https://docs.godotengine.org/en/stable/classes/class_node2d.html#class-node2d-property-global_position)
***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`get_end_anchor(` `)`  <a id='get_end_anchor'></a>

#### Description:
Returns the trailing anchor of the rope.
***
### • `void`&nbsp;&nbsp;`freeze_rope(` `)`  <a id='freeze_rope'></a>

#### Description:
Freeze all of the physics in the Rope, extremely useful when debugging. An `unfreeze_rope()` is left as an exercise for the reader.
***
### • [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)&nbsp;&nbsp;`to_json(` `preserve_velocity:`&nbsp;&nbsp;`bool` `)`  <a id='to_json'></a>

#### Description:
Returns a serializable [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) that represents the [Rope2D](./rope2_d.md) as a sequence of [RigidBody2D.rotation](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-rotation) of [piece_length](#piece_length) size. Optionally preserve the [RigidBody2D.linear_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-property-linear_velocity) and [RigidBody2D.angular_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-property-angular_velocity) if `preserve_velocity` is `TRUE`

Must be restored to a [Rope2D](./rope2_d.md) with matching [RopePieceParameters.piece_length](./rope_piece_parameters.md#piece_length), but other parameters and mount points are not persisted.

#### Parameters:


* `preserve_velocity` - Record the [RigidBody2D.linear_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-linear_velocity) and [RigidBody2D.angular_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-angular_velocity) of the [RopePiece](./rope_piece.md)
***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`from_json(` `saved_rope:`&nbsp;&nbsp;`Variant` `)`  <a id='from_json'></a>

***
