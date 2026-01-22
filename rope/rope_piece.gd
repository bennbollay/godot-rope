extends RigidBody2D

class_name RopePiece

var wind_velocity: Vector2 = Vector2(0, 0)
var location_target: Vector2 = Vector2.INF
var push_rope: bool = false

var log_on = false

const LOCATION_TOLERANCE := 4.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var joint: PinJoint2D = $PinJoint2D

var next_piece: RopePiece

signal on_relocation_done()


func relocate_to(length: float, angle: float, target_anchor: RopePiece, force: float = 50):
	var groove := GrooveJoint2D.new()
	add_child(groove)
	groove.global_position = global_position
	groove.initial_offset = 0
	groove.length = length
	groove.rotate(angle)
	groove.node_a = target_anchor.get_path()
	groove.node_b = get_path()

	location_target = target_anchor.global_position
	
	if push_rope:
		add_constant_force((location_target - global_position) * force)
	await on_relocation_done


func update_relocation() -> bool:
	if location_target == Vector2.INF:
		return false

	if global_position.distance_to(location_target) < LOCATION_TOLERANCE:
		location_target = Vector2.INF
		on_relocation_done.emit.call_deferred()
		return false

	return true


func get_mouse_vector() -> Vector2:
	if not Input.is_action_pressed("ui_up"):
		return Vector2.ZERO

	return (get_global_mouse_position() - position).normalized()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	update_relocation()
	state.apply_force(wind_velocity * 80)
	state.apply_force(get_mouse_vector() * 5000)
