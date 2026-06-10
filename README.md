# Godot 4 2D Rope Implementation

This project creates a Rope class a variety of different ways to support physics-enabled 2D ropes in Godot 4.

# Video Example

<https://github.com/user-attachments/assets/30e491fb-57b7-4230-9f8f-edf31166ab1e>

# Usage

Open the [addons/rope2d/test/test_rope.tscn](https://github.com/bennbollay/godot-rope/tree/main/addons/rope2d/test) scene or look at the various example files in that
directory for common examples.

Many of the examples are also documented below.

# Documentation

Inline documentation in Godot is available.

Additionally, you can read the documentation [here](https://github.com/bennbollay/godot-rope/tree/main/docs/api/rope2_d.md).

# Examples

All of these examples are present in the `addons/rope2d/test/test_rope.tscn` scene.

## Common Parameters

`Rope2D` supports three different [RopePieceParameters](https://github.com/bennbollay/godot-rope/tree/main/docs/api/rope_piece_parameters.md) that can be used to
customize various `RigidBody2D` and `Joint2D` attributes on the rope elements, as they are created.

This is an easy way to set options like `RigidBody2D.freeze` or to change the `RigidBody2D.gravity_scale` for anchors to
make them freeze in space, for example.

#### rope_starting_anchor_parameters

These parameters are applied to the starting anchor in a rope, when it is
created as part of the rope creation process.

#### rope_ending_anchor_parameters

These parameters are applied to the ending anchor in a rope, when it is
created as part of the rope creation process, or when it's updated as
the rope changes length via `extend()` or `contract()`.

#### rope_piece_parameters

Each piece that's created on the rope has these parameters applied to it.

## Creating a New Rope

### Fixed on Both Ends

_Usecases:_ Suitable for attaching two objects together, or a vine hanging from parts of the level.

_Instructions:_

**_Via Editor_**
Create a new `Rope2D` object under the `Node2D` that the rope should start, specify the `Ending Anchor` node as the target node in the `Rope2D` (`Rope2D.ending_anchor_mount_point`), and tell the rope to auto create itself by setting the `Ready Action` to `Create To Mount`.

**_Via API_**

```swift
var starting_anchor: Node2D
var ending_anchor: Node2D
# ...
var rope: Rope2D = Rope2D.new()
rope.ending_anchor_mount_point = ending_anchor
rope.ready_action = Rope2D.CREATE_TO_MOUNT
starting_anchor.add_child(rope)
```

### Fixed on only the start

_Usecases:_ Suitable for dangling a rope in the air that a player could climb.

_Instructions:_

**_Via Editor_**
Create a new `Rope2D` object under the `Node2D` that the rope should start,
pick a positiong (`End Position Vector`) or a target node
(`End Position Node`), and tell the rope to auto create itself by setting the
`Ready Action` to `Create To Positiong`.

**_Via API_**

```swift
# Extend the rope to the location of this node, but don't attach
var target_node: Node2D = ...
# Or use a specific location
var target_position: Vector2 = ...

# ...

var rope: Rope2D = Rope2D.new()
rope.ready_action = Rope2D.CREATE_TO_POSITION
rope.end_position_node = target_node
# OR
rope.end_position_vector = target_position

starting_anchor.add_child(rope)
```

### Create a Fixed Length Rope

_Usecases:_ If the rope needs to be a specific length immediately, but not
reach all the way to a target node.

_Instructions:_

**_Via Editor_**
Use the `End Position Vector` to choose the distance for the rope to be created,
of the correct length

**_Via API_**

```swift
var rope: Rope2D = Rope2D.new()
starting_anchor.add_child(rope)

# Extends to $Target.global_position no more than 100 units.
rope.create_rope($Target.global_position, 100)
```

## Changing the Length of a Rope

There are two ways of changing the length of a rope. The first is using
`spool()`, which extends the rope from the source, using physics to add
(or remove) pieces from the start.

The second is by using `extend()` or `contract()` which adds new pieces
to the end of the rope.

Both are controlled via API.

### Spooling from the Source

**Note:** `Rope2D.spool()` is an `async` function and will complete when
the spooling is complete, including any operations added while
in the `await` state.

```swift
$Rope2D.spool(100)
```

Spool out the rope 100 units. This requires a force to pull on the rope
to pull the new pieces off of the spool.

Alternatively, `push_rope` can be specified to generate an extractive or
contracting force on the rope, which will pool up the pieces next to
the spool.

```swift
$Rope2D.spool(-50)
```

Unspool the rope by 50 units. This uses the `RopePieceParameters.push_rope_force`
to control how much force to "pull" on the rope with to retract those pieces.

### Extending from the End

**Note:** Extending (and contracting) are immediate operations and do not require
any force, like `spool()` does, to perform their actions.

```swift
$Rope2D.extend($Target.global_position, 100)
```

Extend the rope towards `$Target.global_position` by 100 units.

```swift
$Rope2D.contract(100)
```

Contract the length of the rope by removing 100 units of length from the end.

## Deleting a Rope

Because a rope attaches it's nodes to a variety of specified mount points, removing it is not as simple as simply
removing the `Rope2D` object from the scene tree. A custom method is provided to clean up, however any pending `await
spool()` operations will have unknown behaviors.

```swift
$Rope2D.delete()
```

Delete the rope, and remove it from the scene tree.

## Drawing the Rope

The `Rope2D`, by default, does not include any visual component. Instead, it is a construct built in the physics
engine. However, a simple utility class to draw a line following the rope is provided: `RopeDrawSimpleLine`.

```swift
var drawer := RopeDrawSimpleLine.new(rope)
rope.add_child(drawer)
```

Add a simple line drawing to the rope object so that it's visible on the screen.

The drawer is surprisingly simple - it derives from `Line2D` and simply updates the list of `points`
in the `_process()` method.

```swift
func _process(_delta: float) -> void:
 points = rope.get_points(global_position)
```

This can be extended or your own implementation can be provided to draw the rope however you like.

## Saving and Loading

The `Rope2D` object also supports serializing itself to a JSON compatible dictionary, which can be used
to persist both the rope points as well as any velocities on them, as long as the `Rope2D.from_json()`
method is invoked on a `Rope2D` that's configured with a similar `piece_length` value.

### Saving a Rope to a Dictionary

```swift
var saved_rope := rope.to_json(preserve_velocity)
```

Save the rope as a `Dictionary`, including the `linear_velocity` and `angular_velocity` of the individual pieces if
`preserve_velocity` is set to `true`.

### Restoring a Rope from a Dictionary

After creating the rope via `Rope2D.new()` or otherwise having it placed in the scene tree, the rope can be restored
from a previously saved `Dictionary` object.

```swift
rope.from_json(saved_rope)
```

The rope will be recreated with all of the pieces at the prior locations, as well as any velocities that might have been
saved if `preserve_velocity` was passed in as `true`.

# Notes

- It's worth emphasizing that the length of the rope is approximate, only. Whether due to physics deformation or the
  chunking determined by `RopePieceParameters.piece_length`, the exact length of a rope should not be considered
  fixed.
