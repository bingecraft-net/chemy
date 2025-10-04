extends TileMapLayer

const size = 16
const tile_width = 32
const z = Vector2i(-1, -1)
const a = Vector2i(0, 0)
const b = Vector2i(1, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fnl = FastNoiseLite.new()
	fnl.frequency = 1.

	for x in range(size):
		for y in range(size):
			var xy = Vector2i(x, y)
			if fnl.get_noise_2d(xy.x, xy.y) > -0.25:
				set_cell(xy, 0, a)


var offset = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left mouse button"):
		var xy = get_viewport().get_mouse_position() / tile_width / scale
		set_cell(xy, 0, b)
	
	offset += 1
	
	for x in range(offset % 2, size, 2):
		@warning_ignore("integer_division")
		for y in range(offset / 2 % 2, size, 2):
			var ul = Vector2i(x, y)
			var ur = ul + Vector2i.RIGHT
			var bl = ul + Vector2i.DOWN
				
			if get_cell_atlas_coords(ul) == a and get_cell_atlas_coords(ur) == b \
			or get_cell_atlas_coords(ul) == b and get_cell_atlas_coords(ur) == a:
				set_cell(ul, -1, z, -1)
				set_cell(ur, -1, z, -1)
				spawn_boid(tile_width * (1. * ul + Vector2(1, 0.5)))
				
			if get_cell_atlas_coords(ul) == a and get_cell_atlas_coords(bl) == b \
			or get_cell_atlas_coords(ul) == b and get_cell_atlas_coords(bl) == a:
				set_cell(ul, -1, z, -1)
				set_cell(bl, -1, z, -1)
				spawn_boid(tile_width * (1. * ul + Vector2(0.5, 1)))
				
				
func spawn_boid(pos: Vector2):
	var proto = load("res://boid.tscn")
	var instance: RigidBody2D = proto.instantiate()
	instance.position = pos
	add_child(instance)
