extends Node
class_name MapHolder

enum TileType {
	AIR = -1,
	WALL = 0,
	CONVEYOR = 1,
	RESET = 2,
	EXIT = 3,
}

enum Direction {
	UP = 1,
	DOWN = 2,
	LEFT = 4,
	RIGHT = 8,
}

static func direction_to_offset(direction: int) -> Vector2:
	match direction:
		Direction.UP:
			return Vector2(0, -1)
		Direction.DOWN:
			return Vector2(0, 1)
		Direction.LEFT:
			return Vector2(-1, 0)
		Direction.RIGHT:
			return Vector2(1, 0)
		_:
			return Vector2.ZERO

const CONVEYOR_ATLAS_POS_TO_DIRECTION: Dictionary = {
	Vector2(0, 0): Direction.RIGHT,
	Vector2(1, 0): Direction.DOWN,
	Vector2(0, 1): Direction.UP,
	Vector2(1, 1): Direction.LEFT,

	Vector2(2, 0): Direction.DOWN,
	Vector2(3, 0): Direction.LEFT,
	Vector2(2, 1): Direction.RIGHT,
	Vector2(3, 1): Direction.UP,

	Vector2(0, 2): Direction.UP,
	Vector2(1, 2): Direction.DOWN,

	Vector2(2, 2): Direction.RIGHT,
	Vector2(3, 2): Direction.LEFT,
}

const RESET_ATLAS_POS_TO_DIRECTIONS: Dictionary = {
	Vector2(0, 0): Direction.UP | Direction.DOWN | Direction.LEFT | Direction.RIGHT,
	
	Vector2(1, 0): Direction.UP,
	Vector2(2, 0): Direction.RIGHT,
	Vector2(0, 1): Direction.DOWN,
	Vector2(1, 1): Direction.LEFT,
	
	Vector2(2, 1): Direction.UP | Direction.RIGHT,
	Vector2(0, 2): Direction.UP | Direction.LEFT,
	Vector2(1, 2): Direction.DOWN | Direction.RIGHT,
	Vector2(2, 2): Direction.DOWN | Direction.LEFT,
	
	Vector2(0, 3): Direction.LEFT | Direction.RIGHT,
	Vector2(1, 3): Direction.UP | Direction.DOWN,
	
	Vector2(2, 3): Direction.LEFT | Direction.DOWN | Direction.RIGHT,
	Vector2(0, 4): Direction.UP | Direction.DOWN | Direction.LEFT,
	Vector2(1, 4): Direction.LEFT | Direction.UP | Direction.RIGHT,
	Vector2(2, 4): Direction.UP | Direction.DOWN | Direction.RIGHT,
}

var map: TileMap = null
var bounds: Rect2 = Rect2()

func _enter_tree():
	load_level(Levels.current_level)

func _recalculate_bounds() -> void:
	bounds = map.get_used_rect()
	bounds.position *= Globals.CELL_SIZE
	bounds.size *= Globals.CELL_SIZE

func load_level(name: String) -> void:
	for child in get_children():
		remove_child(child)
	
	map = load('res://gameplay/levels/%s.tscn' % name).instance()
	
	assert(map.scale == Globals.TILEMAP_SCALE)
	assert(map.cell_size == Globals.CELL_SIZE_V)
	
	add_child(map)
	_recalculate_bounds()

func get_tilev_world(world_pos: Vector2) -> int:
	var tile_pos = map.world_to_map(world_pos)
	return map.get_cellv(tile_pos)

func get_tile_world(world_x: float, world_y: float) -> int:
	return get_tilev_world(Vector2(world_x, world_y))

func get_tilev(tile_pos: Vector2) -> int:
	return map.get_cellv(tile_pos)

func get_tile(tile_x: float, tile_y: float) -> int:
	return get_tilev(Vector2(tile_x, tile_y))

func world_to_map(world_pos: Vector2) -> Vector2:
	return map.world_to_map(world_pos)

func get_conveyor_movement(tile_pos: Vector2) -> Vector2:
	assert(map.get_cellv(tile_pos) == TileType.CONVEYOR)

	var atlas_pos: Vector2 = map.get_cell_autotile_coord(tile_pos.x, tile_pos.y)
	var direction: int = CONVEYOR_ATLAS_POS_TO_DIRECTION[atlas_pos]
	return direction_to_offset(direction)

func get_reset_flags(tile_pos: Vector2) -> int:
	assert(map.get_cellv(tile_pos) == TileType.RESET)

	var atlas_pos: Vector2 = map.get_cell_autotile_coord(tile_pos.x, tile_pos.y)
	return RESET_ATLAS_POS_TO_DIRECTIONS[atlas_pos]
