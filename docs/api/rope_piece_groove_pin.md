# RopePieceGroovePin

**Inherits**: [RopePiece](./rope_piece.md)



---
## Properties
#### • `pin_body` <a id='pin_body'></a>


#### • `groove_body` <a id='groove_body'></a>


#### • `pin_joint` <a id='pin_joint'></a>


#### • `groove_joint` <a id='groove_joint'></a>


#### • `collision_shape` <a id='collision_shape'></a>




---


## Method Descriptions
### • `static` [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`, ` `params:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='create'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_prev_position(` `)`  <a id='get_prev_position'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_next_position(` `)`  <a id='get_next_position'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_groove_position(` `)`  <a id='get_groove_position'></a>

***
### • `void`&nbsp;&nbsp;`set_piece_position(` `pos:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='set_piece_position'></a>

***
### • `void`&nbsp;&nbsp;`set_piece_rotation(` `rot:`&nbsp;&nbsp;`float` `)`  <a id='set_piece_rotation'></a>

***
### • `void`&nbsp;&nbsp;`set_piece_visible(` `vis:`&nbsp;&nbsp;`bool` `)`  <a id='set_piece_visible'></a>

***
### • `float`&nbsp;&nbsp;`get_angle_to_next(` `)`  <a id='get_angle_to_next'></a>

***
### • `float`&nbsp;&nbsp;`get_angle_to_next_piece(` `)`  <a id='get_angle_to_next_piece'></a>

***
### • `void`&nbsp;&nbsp;`set_next_piece(` `next:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='set_next_piece'></a>

***
### • `void`&nbsp;&nbsp;`clear_next(` `)`  <a id='clear_next'></a>

***
### • `void`&nbsp;&nbsp;`apply_piece_parameters(` `p:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='apply_piece_parameters'></a>

***
### • `void`&nbsp;&nbsp;`apply_anchor_parameters(` `p:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='apply_anchor_parameters'></a>

***
### • `void`&nbsp;&nbsp;`set_joint_parameters(` `bias:`&nbsp;&nbsp;`float` `, ` `_softness:`&nbsp;&nbsp;`float` `)`  <a id='set_joint_parameters'></a>

***
### • `void`&nbsp;&nbsp;`set_shape(` `shape:`&nbsp;&nbsp;[Shape2D](https://docs.godotengine.org/en/stable/classes/class_shape2d.html)`, ` `piece_length:`&nbsp;&nbsp;`float` `)`  <a id='set_shape'></a>

***
### • `String`&nbsp;&nbsp;`get_relocation_path(` `)`  <a id='get_relocation_path'></a>

***
### • `void`&nbsp;&nbsp;`add_relocation_force(` `force:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='add_relocation_force'></a>

***
### • `void`&nbsp;&nbsp;`set_velocities(` `_linear:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`, ` `_angular:`&nbsp;&nbsp;`float` `)`  <a id='set_velocities'></a>

***
### • `float`&nbsp;&nbsp;`get_rotation(` `)`  <a id='get_rotation'></a>

***
### • [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)&nbsp;&nbsp;`get_velocities(` `)`  <a id='get_velocities'></a>

***
