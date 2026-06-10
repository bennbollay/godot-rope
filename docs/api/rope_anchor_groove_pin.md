# RopeAnchorGroovePin

**Inherits**: [RopePieceGroovePin](./rope_piece_groove_pin.md)

An anchor for a [GroveJoint2D](https://docs.godotengine.org/en/stable/classes/class_grovejoint2d.html)-based [RopePiece](./rope_piece.md).  This alternative design is suitable for environments where higher physics accuracy and a more constrained length is desired.

**Note:** Recommended to increase [PhysicsServer2D.SPACE_PARAM_SOLVER_ITERATIONS](https://docs.godotengine.org/en/stable/classes/class_physicsserver2d.html#class-physicsserver2d-constant-space-param-solver-iterations) or [member ProjectSettings.physics/2d/solver/solver_iterations], especially during periods of high physics, to avoid degenerate results.  Target solver iteration values must be experimentally derived.

---
## Properties
#### • `mass` <a id='mass'></a>


#### • `gravity_scale` <a id='gravity_scale'></a>


#### • `freeze` <a id='freeze'></a>




---


## Method Descriptions
### • [RopePieceGroovePin](./rope_piece_groove_pin.md)&nbsp;&nbsp;`create_piece(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`)`  <a id='create_piece'></a>

***
### • [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create_anchor(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`)`  <a id='create_anchor'></a>

***
