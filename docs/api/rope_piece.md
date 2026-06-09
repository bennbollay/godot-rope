# RopePiece

**Inherits**: [Node2D](https://docs.godotengine.org/en/stable/classes/class_node2d.html)

The abstract base class that various different types of [RopePiece](./rope_piece.md), such as [PinJointRopePiece](https://docs.godotengine.org/en/stable/classes/class_pinjointropepiece.html), are derived from.

---
## Properties
#### • `wind_velocity` <a id='wind_velocity'></a>

Force added from a [WindArea2D](./wind_area2_d.md) on this [RopePiece](./rope_piece.md).
#### • `push_rope` <a id='push_rope'></a>

Forcefully push this piece onto the rope when unspooling.
#### • `push_rope_force` <a id='push_rope_force'></a>


#### • `follow_mouse` <a id='follow_mouse'></a>

Push this piece towards the current [CanvasItem.get_global_mouse_position](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#class-canvasitem-annotation-get_global_mouse_position).
#### • `next_piece` <a id='next_piece'></a>

The next [RopePiece](./rope_piece.md) in the [Rope2D](./rope2_d.md).
#### • `piece_parameters` <a id='piece_parameters'></a>

Defaults used to configure the underlying nodes and joints.
#### • `debug` <a id='debug'></a>

Diagnostic flag to add more logging messages.


---


## Method Descriptions
### • `abstract` `float`&nbsp;&nbsp;`get_angle_to_next(` `)`  <a id='get_angle_to_next'></a>

#### Description:
Get the angle to the next piece.
***
### • `abstract` `void`&nbsp;&nbsp;`set_shape(` `shape:`&nbsp;&nbsp;[Shape2D](https://docs.godotengine.org/en/stable/classes/class_shape2d.html)`, ` `piece_length:`&nbsp;&nbsp;`float` `)`  <a id='set_shape'></a>

#### Description:
Set the shape of the collision shape, as well as the length.
***
### • `abstract` `void`&nbsp;&nbsp;`set_joint_parameters(` `bias:`&nbsp;&nbsp;`float` `, ` `softness:`&nbsp;&nbsp;`float` `)`  <a id='set_joint_parameters'></a>

#### Description:
Update the joint's bias and softness parameters.
***
### • `abstract` `void`&nbsp;&nbsp;`set_velocities(` `linear:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`, ` `angular:`&nbsp;&nbsp;`float` `)`  <a id='set_velocities'></a>

#### Description:
Set the [RigidBody2D.linear_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-linear_velocity) and [RigidBody2D.angular_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-angular_velocity) on the [RopePiece](./rope_piece.md).
***
### • `abstract` `String`&nbsp;&nbsp;`get_relocation_path(` `)`  <a id='get_relocation_path'></a>

#### Description:
Used during spooling to control which part of the [RopePiece](./rope_piece.md) the [GrooveJoint2D](https://docs.godotengine.org/en/stable/classes/class_groovejoint2d.html) attaches to.
***
### • `abstract` `void`&nbsp;&nbsp;`add_relocation_force(` `force:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='add_relocation_force'></a>

#### Description:
Force added to accelerate the unspooling of this piece.
***
### • `abstract` `void`&nbsp;&nbsp;`apply_piece_parameters(` `parameters:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='apply_piece_parameters'></a>

#### Description:
On creation, apply the parameters specified in [Rope2D.rope_piece_parameters](./rope2_d.md#rope_piece_parameters) or related anchor specializations.
***
### • `abstract` [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_prev_position(` `)`  <a id='get_prev_position'></a>

#### Description:
The global_position the previous RopePiece attaches to.
***
### • `abstract` [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_next_position(` `)`  <a id='get_next_position'></a>

#### Description:
The global_position the next RopePiece starts at.
***
### • `abstract` `float`&nbsp;&nbsp;`get_rotation(` `)`  <a id='get_rotation'></a>

#### Description:
Returns the rotation, in radians, of the [RopePiece](./rope_piece.md).
***
### • `abstract` [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)&nbsp;&nbsp;`get_velocities(` `)`  <a id='get_velocities'></a>

#### Description:
Return a [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) of the [RigidBody2D.linear_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-linear_velocity) and [RigidBody2D.angular_velocity](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-angular_velocity).
***
### • `void`&nbsp;&nbsp;`relocate_to(` `length:`&nbsp;&nbsp;`float` `, ` `angle:`&nbsp;&nbsp;`float` `, ` `target_anchor:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`, ` `force:`&nbsp;&nbsp;`float` `, ` `new_position:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='relocate_to'></a>

#### Description:
Used by [method Rope2D.spool] to relocate a given piece to the current start position.
***
### • `void`&nbsp;&nbsp;`set_next_piece(` `next:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='set_next_piece'></a>

#### Description:
Updates the [RopePiece](./rope_piece.md) to point at the next one in the rope.
***
### • `void`&nbsp;&nbsp;`clear_next(` `)`  <a id='clear_next'></a>

#### Description:
Remove the references to the next [RopePiece](./rope_piece.md) from this one.
***
### • `void`&nbsp;&nbsp;`set_piece_position(` `pos:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='set_piece_position'></a>

#### Description:
Update the global position, which may require customization of sub-elements.
***
### • `void`&nbsp;&nbsp;`set_piece_rotation(` `rot:`&nbsp;&nbsp;`float` `)`  <a id='set_piece_rotation'></a>

#### Description:
Rotate the piece so that it's aligned with the rest of the rope on creation.
***
### • `void`&nbsp;&nbsp;`set_piece_visible(` `vis:`&nbsp;&nbsp;`bool` `)`  <a id='set_piece_visible'></a>

#### Description:
Hide the current piece if it's not part of the active rope.
***
### • `bool`&nbsp;&nbsp;`is_anchor(` `)`  <a id='is_anchor'></a>

#### Description:
Returns `TRUE` if the [RopePiece](./rope_piece.md) is an anchor element.
***
