# Godot 4 2D Rope Implementation

This project creates a Rope class a variety of different ways to support physics-enabled 2D ropes in Godot 4.

# Example

![rope_demo_video](https://github.com/user-attachments/assets/6ec2ab26-b500-47e9-a682-a7b096e3d919)

# Usage

See [test/test_rope.gd](test/test_rope.gd) for the example usage represented here:

## Fixed on both ends

Using the `RopeEndPiece` node as starting and/or end points, create a `Rope` that extends from that starting node to a specified ending node.

```swift
rope = Rope.new($RopeStartPiece)
add_child(rope)
rope.create_rope($RopeEndPiece) # rope_end_piece.global_position)
```

## Customize the length of each line segment

```swift
# Create a rope where each segment is 5 px long
rope = Rope.new($RopeStartPiece, 5)
```

## Towards a particular point

```swift
rope.create_rope($RopeEndPiece2.global_position)
```

## Towards a specific end piece, but only a certain length

```swift
# Create a rope that's 10 segments long that will connect to
# the $RopeEndPiece2 if it reaches it, but will otherwise float
rope.create_rope($RopeEndPiece2, 10)
```

## Grow the rope by five segments

```swift
rope.spool(5)
```

## Draw a line over the rope

```swift
rope_drawer = RopeDrawSimpleLine.new(grope)
add_child(rope_drawer)
```

## Stop drawing the line

```swift
rope_drawer.queue_free()
```
