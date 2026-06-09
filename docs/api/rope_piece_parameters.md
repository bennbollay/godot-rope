# RopePieceParameters

**Inherits**: [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html)

A collection of parameters used to configure newly created [RopePiece](./rope_piece.md) elements.

---
## Properties
#### • `piece_length` <a id='piece_length'></a>

Specifies the length of the [RopePiece](./rope_piece.md).
#### • `push_rope` <a id='push_rope'></a>

Specifies if the [RopePiece](./rope_piece.md) should be pushed out of the [Rope2D.spool](./rope2_d.md#spool) versus letting it be unspooled as normal physics pull on the rope.
#### • `push_rope_force` <a id='push_rope_force'></a>

Force to use when adding (if [push_rope](#push_rope) is set to `TRUE`) or removing [RopePiece](./rope_piece.md) via [Rope2D.spool](./rope2_d.md#spool).
#### • `gravity_scale` <a id='gravity_scale'></a>

Overloads [RigidBody2D.gravity_scale](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-gravity-scale).
#### • `mass` <a id='mass'></a>

Overloads [RigidBody2D.mass](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-mass).
#### • `freeze` <a id='freeze'></a>

Overloads [RigidBody2D.freeze](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-freeze).
#### • `linear_damp_mode` <a id='linear_damp_mode'></a>

Overloads [RigidBody2D.linear_damp_mode](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-linear-damp-mode).
#### • `linear_damp` <a id='linear_damp'></a>

Overloads [RigidBody2D.linear_damp](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-linear-damp).
#### • `angular_damp_mode` <a id='angular_damp_mode'></a>

Overloads [RigidBody2D.angular_damp_mode](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-angular-damp-mode).
#### • `angular_damp` <a id='angular_damp'></a>

Overloads [RigidBody2D.angular_damp](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-angular-damp).
#### • `collision_layer` <a id='collision_layer'></a>

Overloads [CollisionObject2D.collision_layer](https://docs.godotengine.org/en/stable/classes/class_collisionobject2d.html#class-collisionobject2d-annotation-collision-layer).

**Note:** Do not have the [collision_layer](#collision_layer) and [collision_mask](#collision_mask) overlap.
#### • `collision_mask` <a id='collision_mask'></a>

Overloads [CollisionObject2D.collision_mask](https://docs.godotengine.org/en/stable/classes/class_collisionobject2d.html#class-collisionobject2d-annotation-collision-mask).

**Note:** Do not have the [collision_layer](#collision_layer) and [collision_mask](#collision_mask) overlap.
#### • `pin_joint_softness` <a id='pin_joint_softness'></a>

Overloads [PinJoint2D.softness](https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html#class-pinjoint2d-annotation-softness).
#### • `pin_joint_bias` <a id='pin_joint_bias'></a>

Overloads [PinJoint2D.bias](https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html#class-pinjoint2d-annotation-bias).
#### • `shape` <a id='shape'></a>

Specifies the shape of the [CollisionShape2D](https://docs.godotengine.org/en/stable/classes/class_collisionshape2d.html) used in the [RopePiece](./rope_piece.md).  
*(Default: [CapsuleShape2D](https://docs.godotengine.org/en/stable/classes/class_capsuleshape2d.html))*


---


## Method Descriptions
### • [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)&nbsp;&nbsp;`to_json(` `)`  <a id='to_json'></a>

***
### • `void`&nbsp;&nbsp;`validate(` `)`  <a id='validate'></a>

***
### • `void`&nbsp;&nbsp;`apply(` `piece:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='apply'></a>

***
### • `static` [RopePieceParameters](./rope_piece_parameters.md)&nbsp;&nbsp;`from_json(` `p:`&nbsp;&nbsp;[Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html)`)`  <a id='from_json'></a>

***
