extends Line2D

class_name RopeDrawSimpleLine

var rope: Rope2D


func _init(draw_rope: Rope2D):
	rope = draw_rope
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	joint_mode = Line2D.LINE_JOINT_ROUND
	width = 2


func use_gradient():
	var c := PackedColorArray()
	c.resize(5)
	c.fill(Color.RED)
	c[0].a = 0.0
	c[1].a = 0.6
	c[2].a = 1.0
	c[3].a = 0.6
	c[4].a = 0.0

	texture = GradientTexture2D.new()
	texture.gradient = Gradient.new()
	texture.gradient.colors = c
	texture.gradient.offsets = PackedFloat32Array([0.0, 0.2, 0.5, 0.8, 1.0])
	texture.width = 1
	texture.height = 64
	texture_mode = Line2D.LINE_TEXTURE_TILE
	texture.fill_from = Vector2(1, 0.86752135)
	texture.fill_to = Vector2(1, 0.12820514)

	begin_cap_mode = Line2D.LINE_CAP_NONE
	width = 10


func is_gradient() -> bool:
	return not not texture


func set_color(color: Color):
	var grad_texture: GradientTexture2D = texture
	if not is_gradient():
		default_color = color
		return

	var colors: PackedColorArray = grad_texture.gradient.colors

	for i in range(0, colors.size()):
		colors[i].r = color.r
		colors[i].g = color.g
		colors[i].b = color.b

	grad_texture.gradient.colors = colors


func set_rope(draw_rope: Rope2D):
	rope = draw_rope


func _process(_delta: float) -> void:
	if not rope:
		return

	points = rope.get_points(global_position)
