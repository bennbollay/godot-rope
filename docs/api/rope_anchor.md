# RopeAnchor

**Inherits**: [RopePiece](./rope_piece.md)

An abstract interface class that specifies the two methods required to implement a [RopeAnchor](./rope_anchor.md), derived from a [RopePiece](./rope_piece.md).  Because different [RopeAnchor](./rope_anchor.md)s have different base classes (for example [RopePiecePinJoint](./rope_piece_pin_joint.md) or [RopePieceGroovePin](./rope_piece_groove_pin.md)), no [RopeAnchor](./rope_anchor.md) will directly derive from this class.

Extended by [RopeAnchorPinJoint](./rope_anchor_pin_joint.md) and [RopeAnchorGroovePin](./rope_anchor_groove_pin.md).

---
## Method Descriptions
### • `abstract` [RopePiece](./rope_piece.md)&nbsp;&nbsp;`create_piece(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`)`  <a id='create_piece'></a>

#### Description:
Returns a [RopePiece](./rope_piece.md) based on the current type of this [RopeAnchor](./rope_anchor.md).
***
### • `abstract` [RopeAnchor](./rope_anchor.md)&nbsp;&nbsp;`clone(` `mount:`&nbsp;&nbsp;[Node](https://docs.godotengine.org/en/stable/classes/class_node.html)`)`  <a id='clone'></a>

#### Description:
Returns a [RopeAnchor](./rope_anchor.md) that shares the configuration of this [RopeAnchor](./rope_anchor.md).
***
