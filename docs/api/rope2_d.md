# Rope2D

**Inherits**: [Node](https://docs.godotengine.org/en/stable/classes/class_node.html)

A class to manage and create Rope2D chains.

---
## Constants
#### • `DEFAULT_PIECE_LENGTH`: `20.0` <a id='DEFAULT_PIECE_LENGTH'></a>

Default length for a [RopePiece](./rope_piece.md).  Overwritten by [RopePieceParameters.piece_length](./rope_piece_parameters.md#piece_length) on the [RopeAnchor](./rope_anchor.md) in the scene.
#### • `DEFAULT_LOCATION_TOLERANCE`: `4.0` <a id='DEFAULT_LOCATION_TOLERANCE'></a>

Default value for how close a [RopePiece](./rope_piece.md) has to get to a target [RopeAnchor](./rope_anchor.md) or location to be considered as having arrived.


---


## Properties
#### • `piece_length` <a id='piece_length'></a>

Returns the [RopePieceParameters.piece_length](./rope_piece_parameters.md#piece_length) value specified in the [_init](#_init).start [RopeAnchor](./rope_anchor.md) used to create this [Rope2D](./rope2_d.md).


---


## Method Descriptions
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create_rope(` `end_or_vec2:`&nbsp;&nbsp;`Variant` `, ` `max_segments:`&nbsp;&nbsp;`int` `, ` `start_piece:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='create_rope'></a>

#### Description:
Create [RopePiece](./rope_piece.md) elements between the [_rope_start](https://docs.godotengine.org/en/stable/classes/class__rope_start.html) and `end_or_vec2`, which can either be a [RopeAnchor](./rope_anchor.md) conforming instantiated scene like [RopeAnchorPinJoint](./rope_anchor_pin_joint.md) or [RopeAnchorGroovePin](./rope_anchor_groove_pin.md), or a [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html) [Node2D.global_position](https://docs.godotengine.org/en/stable/classes/class_node2d.html#class-node2d-annotation-global_position) that indicates a target location for the [Rope2D](./rope2_d.md) to finish within [_close_tolerance](https://docs.godotengine.org/en/stable/classes/class__close_tolerance.html).   
* `end_or_vec2` - a [RopeAnchor](./rope_anchor.md) instantiated in the scene or a [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html) specifying the target location for the [Rope2D](./rope2_d.md) to finish.

* `max_segments` - the maximum number of segments, or `-1` if no maximum, to use when extending towards `end_or_vec2`.  Useful when specifying a [Rope2D](./rope2_d.md) of fixed length.

* `start_piece` - extend the current rope from this [RopePiece](./rope_piece.md), largely used internally from [extend](#extend).
***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`extend(` `end_or_vec2:`&nbsp;&nbsp;`Variant` `, ` `max_segments:`&nbsp;&nbsp;`int` `)`  <a id='extend'></a>

#### Description:
Extend the length of the [Rope2D](./rope2_d.md) in the direction of `end_or_vec2` for a maximum `max_segments`, `-1` means until the last [RopePiece](./rope_piece.md) is within [_close_tolerance](https://docs.godotengine.org/en/stable/classes/class__close_tolerance.html) of `end_or_vec2`.

* `end_or_vec2` - a [RopeAnchor](./rope_anchor.md) instantiated in the scene or a [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html) specifying the target location for the [Rope2D](./rope2_d.md) to finish.

* `max_segments` - the maximum number of segments, or `-1` if no maximum, to use when extending towards `end_or_vec2`.  Useful when specifying a [Rope2D](./rope2_d.md) of fixed length.

**Note:** [extend](#extend) extends the [Rope2D](./rope2_d.md) from the *end* of the rope, while [spool](#spool) extends the [Rope2D](./rope2_d.md) from the *start* of the rope.  Use [extend](#extend) when there is a destination to reach, and use [spool](#spool) when there's physics in effect on the rope pulling new [RopePiece](./rope_piece.md)s out of the spool.  

***
### • `void`&nbsp;&nbsp;`spool(` `spool_pieces:`&nbsp;&nbsp;`int` `)`  <a id='spool'></a>

#### Description:
Add new [RopePiece](./rope_piece.md) elements to a logical "spool" located at [_rope_start](https://docs.godotengine.org/en/stable/classes/class__rope_start.html).  As the [Rope2D](./rope2_d.md) is pulled via physics, new pieces will be spooled out until `spool_pieces` have been added to the rope.  Each [RopePiece](./rope_piece.md) will be [piece_length](https://docs.godotengine.org/en/stable/classes/class_piece_length.html) in size.

* `spool_pieces` - the number of new [RopePiece](./rope_piece.md) to add to the [Rope2D](./rope2_d.md).

**Note:** [extend](#extend) extends the [Rope2D](./rope2_d.md) from the *end* of the rope, while [spool](#spool) extends the [Rope2D](./rope2_d.md) from the *start* of the rope.  Use [extend](#extend) when there is a destination to reach, and use [spool](#spool) when there's physics in effect on the rope pulling new [RopePiece](./rope_piece.md)s out of the spool.  

***
### • `float`&nbsp;&nbsp;`calculate_rope_length(` `from:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`, ` `to:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='calculate_rope_length'></a>

#### Description:
Returns the length of the [RopePiece](./rope_piece.md)s between `from` and `to`, or the entire [Rope2D](./rope2_d.md) if unspecified.
***
### • [Vector2[]](https://docs.godotengine.org/en/stable/classes/class_vector2[].html)&nbsp;&nbsp;`get_points(` `)`  <a id='get_points'></a>

#### Description:
Returns an [Array](https://docs.godotengine.org/en/stable/classes/class_array.html)[[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html) of the [Node2D.global_position](https://docs.godotengine.org/en/stable/classes/class_node2d.html#class-node2d-annotation-global_position)'s for each [RopePiece](./rope_piece.md).

Used when drawing a [Line2D](https://docs.godotengine.org/en/stable/classes/class_line2d.html) or other visual effect that follows the [Rope2D](./rope2_d.md).
***
### • [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)&nbsp;&nbsp;`to_json(` `)`  <a id='to_json'></a>

#### Description:
Returns a serializable [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) that represents the [Rope2D](./rope2_d.md) in the [Node2D.global_position](https://docs.godotengine.org/en/stable/classes/class_node2d.html#class-node2d-annotation-global_position) coordinate space.
***
### • `static` [Rope2D](./rope2_d.md)&nbsp;&nbsp;`create_saved_rope(` `start:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`, ` `saved_rope:`&nbsp;&nbsp;`Variant` `)`  <a id='create_saved_rope'></a>

#### Description:
Returns a [Rope2D](./rope2_d.md) that's ready for a [from_json](#from_json) call.  The `start` should have the same values for the [RopeAnchor.rope_piece_parameters](./rope_anchor.md#rope_piece_parameters) and [RopeAnchor.rope_anchor_parameters](./rope_anchor.md#rope_anchor_parameters) as when the [to_json](#to_json) was invoked.

* `start` - the [RopePiece](./rope_piece.md) that was originally passed to [create_rope](#create_rope).

* `saved_rope` - the [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) returned from [to_json](#to_json).
***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`from_json(` `saved_rope:`&nbsp;&nbsp;`Variant` `)`  <a id='from_json'></a>

#### Description:
Returns the last [RopePiece](./rope_piece.md) created.

Instantiates the [RopePiece](./rope_piece.md)s from the `saved_rope`, and adds them to the [Rope2D](./rope2_d.md).

* `saved_rope` - the [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) returned from [to_json](#to_json).
***
