# RopePiecePinJoint

**Inherits**: [RopePiece](./rope_piece.md)



---
## Properties
#### • `log_on` <a id='log_on'></a>


#### • `collision_shape` <a id='collision_shape'></a>


#### • `joint` <a id='joint'></a>




---


## Method Descriptions
### • `static` [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`, ` `params:`&nbsp;&nbsp;[RopePieceParameters](./rope_piece_parameters.md)`)`  <a id='create'></a>

***
### • `float`&nbsp;&nbsp;`get_angle_to_next(` `)`  <a id='get_angle_to_next'></a>

***
### • `void`&nbsp;&nbsp;`set_shape(` `shape:`&nbsp;&nbsp;[CapsuleShape2D](https://docs.godotengine.org/en/stable/classes/class_capsuleshape2d.html)`, ` `piece_length:`&nbsp;&nbsp;`float` `)`  <a id='set_shape'></a>

***
### • `void`&nbsp;&nbsp;`set_joint_parameters(` `bias:`&nbsp;&nbsp;`float` `, ` `softness:`&nbsp;&nbsp;`float` `)`  <a id='set_joint_parameters'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_start_position(` `)`  <a id='get_start_position'></a>

***
### • `void`&nbsp;&nbsp;`set_next_piece(` `next:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='set_next_piece'></a>

***
### • `void`&nbsp;&nbsp;`clear_next(` `)`  <a id='clear_next'></a>

***
### • `String`&nbsp;&nbsp;`get_relocation_path(` `)`  <a id='get_relocation_path'></a>

***
### • `void`&nbsp;&nbsp;`add_relocation_force(` `force:`&nbsp;&nbsp;[Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)`)`  <a id='add_relocation_force'></a>

***
### • `bool`&nbsp;&nbsp;`update_relocation(` `)`  <a id='update_relocation'></a>

***
### • [Vector2](https://docs.godotengine.org/en/stable/classes/class_vector2.html)&nbsp;&nbsp;`get_mouse_vector(` `)`  <a id='get_mouse_vector'></a>

***
