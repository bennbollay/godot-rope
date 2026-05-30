# RopePiece

**Inherits**: [RigidBody2D](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html)

The abstract base class that various different types of [RopePiece](./rope_piece.md) are derived from.

---
## Properties
#### • `wind_velocity` <a id='wind_velocity'></a>

Force added from a [WindArea2D](./wind_area2_d.md) on this [RopePiece](./rope_piece.md).
#### • `follow_mouse` <a id='follow_mouse'></a>

Push this piece towards the current [CanvasItem.get_global_mouse_position](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#class-canvasitem-annotation-get_global_mouse_position).
#### • `next_piece` <a id='next_piece'></a>

The next [RopePiece](./rope_piece.md) in the [Rope2D](./rope2_d.md).
#### • `piece_parameters` <a id='piece_parameters'></a>

Used in [RopeAnchor](./rope_anchor.md)-conforming types like [RopeAnchorPinJoint](./rope_anchor_pin_joint.md) and [RopeAnchorGroovePin](./rope_anchor_groove_pin.md).
#### • `anchor_parameters` <a id='anchor_parameters'></a>

Used in [RopeAnchor](./rope_anchor.md)-conforming types like [RopeAnchorPinJoint](./rope_anchor_pin_joint.md) and [RopeAnchorGroovePin](./rope_anchor_groove_pin.md).


---


## Method Descriptions
### • `abstract` [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_start_position(` `)`  <a id='get_start_position'></a>

***
### • `abstract` `float`&nbsp;&nbsp;`get_angle_to_next(` `)`  <a id='get_angle_to_next'></a>

***
### • `abstract` `void`&nbsp;&nbsp;`set_shape(` `shape:`&nbsp;&nbsp;[CapsuleShape2D](https://docs.godotengine.org/en/stable/classes/class_capsuleshape2d.html)`, ` `piece_length:`&nbsp;&nbsp;`float` `)`  <a id='set_shape'></a>

***
### • `abstract` `void`&nbsp;&nbsp;`set_joint_parameters(` `bias:`&nbsp;&nbsp;`float` `, ` `softness:`&nbsp;&nbsp;`float` `)`  <a id='set_joint_parameters'></a>

***
### • `abstract` `String`&nbsp;&nbsp;`get_relocation_path(` `)`  <a id='get_relocation_path'></a>

***
### • `abstract` `void`&nbsp;&nbsp;`add_relocation_force(` `force:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='add_relocation_force'></a>

***
### • `void`&nbsp;&nbsp;`relocate_to(` `length:`&nbsp;&nbsp;`float` `, ` `angle:`&nbsp;&nbsp;`float` `, ` `target_anchor:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`, ` `force:`&nbsp;&nbsp;`float` `)`  <a id='relocate_to'></a>

***
### • `void`&nbsp;&nbsp;`set_next_piece(` `next:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='set_next_piece'></a>

***
### • `void`&nbsp;&nbsp;`clear_next(` `)`  <a id='clear_next'></a>

***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create_piece(` `_mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`)`  <a id='create_piece'></a>

#### Description:
Not implemented by default; not used by RopePieces, only Anchors
***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`clone(` `_mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`)`  <a id='clone'></a>

#### Description:
Not implemented by default
***
