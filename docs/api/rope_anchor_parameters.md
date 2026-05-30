# RopeAnchorParameters

**Inherits**: [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html)

A collection of parameters that are used to configure new [RopeAnchor](./rope_anchor.md) when they are created, for example when a [Rope2D](./rope2_d.md) has a free-floating endpoint that is not attached to a specific [RopeAnchor](./rope_anchor.md) in the scene.

---
## Properties
#### • `gravity_scale` <a id='gravity_scale'></a>

Overloads the [RigidBody2D.gravity_scale](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-gravity_scale).
#### • `mass` <a id='mass'></a>

Overloads the [RigidBody2D.mass](https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html#class-rigidbody2d-annotation-mass).


---


## Method Descriptions
### • `void`&nbsp;&nbsp;`apply(` `anchor:`&nbsp;&nbsp;[RopePiece](./rope_piece.md)`)`  <a id='apply'></a>

#### Description:
Apply the included overloads to the new [RopeAnchor](./rope_anchor.md).  Invoked during the [Rope2D.spool](./rope2_d.md#spool) or [Rope2D.extend](./rope2_d.md#extend) process.
***
