# RopeAnchorPinJoint

**Inherits**: [RopePiecePinJoint](./rope_piece_pin_joint.md)

An anchor for a [PinJoint2D](https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html)-based [RopePiece](./rope_piece.md).  These are suitable for most simple rope usage like vines, mostly static cables, and other instances where the physics interactions are limited and tolereance around length changes and movement are high.

**Note:** Recommended to increase [PhysicsServer2D.SPACE-PARAM-SOLVER-ITERATIONS](https://docs.godotengine.org/en/stable/classes/class_physicsserver2d.html#class-physicsserver2d-constant-space-param-solver-iterations) or [member ProjectSettings.physics/2d/solver/solver_iterations], especially during periods of high physics, to avoid degenerate results.  Target solver iteration values must be experimentally derived.

However, even with increased iterations, the [RopePiecePinJoint](./rope_piece_pin_joint.md) is not as constrained as the [RopePieceGroovePin](./rope_piece_groove_pin.md) implementation.

---
## Method Descriptions
### • `bool`&nbsp;&nbsp;`is_anchor(` `)`  <a id='is_anchor'></a>

#### Description:
Returns `TRUE` if the [RopePiece](./rope_piece.md) is an anchor element.
***
### • `void`&nbsp;&nbsp;`set_shape(` `shape:`&nbsp;&nbsp;[Shape2D](https://docs.godotengine.org/en/stable/classes/class_shape2d.html)`, ` `piece_length:`&nbsp;&nbsp;`float` `)`  <a id='set_shape'></a>

#### Description:
Prevent changing the shape of the anchor to the default CapsuleShape2D.
***
