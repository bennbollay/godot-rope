# RopePieceParameters

**Inherits**: [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html)

A collection of parameters used to configure newly created [RopePiece](./rope_piece.md) elements.

---
## Properties
#### • `gravity_scale` <a id='gravity_scale'></a>

Overloads the [RigidBody2D.gravity_scale](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-gravity_scale).
#### • `mass` <a id='mass'></a>

Overloads the [RigidBody2D.mass](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-mass).
#### • `push_rope` <a id='push_rope'></a>

Specifies if the [RopePiece](./rope_piece.md) should be pushed out of the [Rope2D.spool](./rope2_d.md#spool) versus letting it be unspooled as normal physics pull on the rope.
#### • `pin_joint_softness` <a id='pin_joint_softness'></a>

Overloads the [PinJoint2D.softness](https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html#class-pinjoint2d-annotation-softness).
#### • `pin_joint_bias` <a id='pin_joint_bias'></a>

Overloads the [PinJoint2D.bias](https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html#class-pinjoint2d-annotation-bias).
#### • `shape` <a id='shape'></a>

Specifies the shape of the [CollisionShape2D](https://docs.godotengine.org/en/stable/classes/class_collisionshape2d.html) used in the [RopePiece](./rope_piece.md).  
*(Default: [CapsuleShape2D](https://docs.godotengine.org/en/stable/classes/class_capsuleshape2d.html))*
#### • `piece_length` <a id='piece_length'></a>

Specifies the length of the [RopePiece](./rope_piece.md).


---


## Method Descriptions
### • [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)&nbsp;&nbsp;`to_json(` `)`  <a id='to_json'></a>

***
### • `void`&nbsp;&nbsp;`apply(` `piece:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='apply'></a>

***
### • `static` [RopePieceParameters](./rope_piece_parameters.md)&nbsp;&nbsp;`from_json(` `p:`&nbsp;&nbsp;[Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)`)`  <a id='from_json'></a>

***
