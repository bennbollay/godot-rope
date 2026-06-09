# RopePiecePinJoint

**Inherits**: [RopePiece](./rope_piece.md)



---
## Properties
#### • `log_on` <a id='log_on'></a>


#### • `collision_shape` <a id='collision_shape'></a>


#### • `joint` <a id='joint'></a>




---


## Method Descriptions
### • `static` [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create_piece(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`, ` `params:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='create_piece'></a>

***
### • `static` [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create_anchor(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`, ` `params:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='create_anchor'></a>

***
### • `void`&nbsp;&nbsp;`rename(` `n:`&nbsp;&nbsp;`String` `)`  <a id='rename'></a>

***
### • `float`&nbsp;&nbsp;`get_angle_to_next(` `)`  <a id='get_angle_to_next'></a>

***
### • `void`&nbsp;&nbsp;`set_shape(` `shape:`&nbsp;&nbsp;[Shape2D](https://docs.godotengine.org/en/stable/classes/class_shape2d.html)`, ` `piece_length:`&nbsp;&nbsp;`float` `)`  <a id='set_shape'></a>

***
### • `void`&nbsp;&nbsp;`set_joint_parameters(` `bias:`&nbsp;&nbsp;`float` `, ` `softness:`&nbsp;&nbsp;`float` `)`  <a id='set_joint_parameters'></a>

***
### • `void`&nbsp;&nbsp;`set_next_piece(` `next:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='set_next_piece'></a>

***
### • `void`&nbsp;&nbsp;`clear_next(` `)`  <a id='clear_next'></a>

***
### • `String`&nbsp;&nbsp;`get_relocation_path(` `)`  <a id='get_relocation_path'></a>

***
### • [RigidBody2D](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html)&nbsp;&nbsp;`as_rigidbody(` `)`  <a id='as_rigidbody'></a>

***
### • `void`&nbsp;&nbsp;`add_relocation_force(` `force:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='add_relocation_force'></a>

***
### • `void`&nbsp;&nbsp;`apply_piece_parameters(` `p:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='apply_piece_parameters'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_prev_position(` `)`  <a id='get_prev_position'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_next_position(` `)`  <a id='get_next_position'></a>

***
### • `float`&nbsp;&nbsp;`get_rotation(` `)`  <a id='get_rotation'></a>

***
### • `void`&nbsp;&nbsp;`set_velocities(` `linear:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`, ` `angular:`&nbsp;&nbsp;`float` `)`  <a id='set_velocities'></a>

***
### • [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)&nbsp;&nbsp;`get_velocities(` `)`  <a id='get_velocities'></a>

***
### • `bool`&nbsp;&nbsp;`update_relocation(` `)`  <a id='update_relocation'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_mouse_vector(` `)`  <a id='get_mouse_vector'></a>

***
