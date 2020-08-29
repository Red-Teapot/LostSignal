extends Node2D

const SPEED: float = 96.0
const OFFSET = Globals.CELL_SIZE_V / 2

var map_holder: MapHolder = null

var target: Vector2 = Vector2.ZERO
var old_tile_pos: Vector2 = Vector2.INF

var controls_offset: Vector2 = Vector2.ZERO
var active_tile_offset: Vector2 = Vector2.ZERO
var walls_offset: Vector2 = Vector2.ZERO

var movement_flags: int = 0

func _enter_tree() -> void:
	map_holder = $'/root/Gameplay/MapHolder' as MapHolder

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gameplay_up"):
		movement_flags |= MapHolder.Direction.UP
	if event.is_action_pressed("gameplay_down"):
		movement_flags |= MapHolder.Direction.DOWN
	if event.is_action_pressed("gameplay_left"):
		movement_flags |= MapHolder.Direction.LEFT
	if event.is_action_pressed("gameplay_right"):
		movement_flags |= MapHolder.Direction.RIGHT

func _check_controls() -> void:
	controls_offset = Vector2.ZERO
	if movement_flags & MapHolder.Direction.LEFT != 0:
		controls_offset.x -= 1
	if movement_flags & MapHolder.Direction.RIGHT != 0:
		controls_offset.x += 1
	if movement_flags & MapHolder.Direction.UP != 0:
		controls_offset.y -= 1
	if movement_flags & MapHolder.Direction.DOWN != 0:
		controls_offset.y += 1

func _check_active_tiles(tile_pos: Vector2) -> void:
	if tile_pos == old_tile_pos:
		return
	
	active_tile_offset = Vector2.ZERO
	match map_holder.get_tilev(tile_pos):
		MapHolder.TileType.CONVEYOR:
			active_tile_offset = map_holder.get_conveyor_movement(tile_pos)
		MapHolder.TileType.RESET:
			var reset_flags = map_holder.get_reset_flags(tile_pos)
			movement_flags &= (~reset_flags)
		MapHolder.TileType.EXIT:
			print('EXIT')

func _check_walls(tile_pos: Vector2, offset: Vector2) -> Vector2:
	var dx = Vector2(offset.x, 0)

	if map_holder.get_tilev(tile_pos + dx) == MapHolder.TileType.WALL:
		offset.x = 0
	
	var dy = Vector2(0, offset.y)
	if map_holder.get_tilev(tile_pos + dy) == MapHolder.TileType.WALL:
		offset.y = 0
	
	if offset.x != 0 and offset.y != 0 and map_holder.get_tilev(tile_pos + offset) == MapHolder.TileType.WALL:
		offset.x = 0

	return offset

func _update_target(tile_pos: Vector2) -> void:
	# Active tiles might change controls (e.g. reset tiles)
	_check_active_tiles(tile_pos)
	_check_controls()

	var offset = active_tile_offset

	# Do not apply controls if standing on a conveyor
	if offset == Vector2.ZERO:
		offset = controls_offset
	
	target = tile_pos + _check_walls(tile_pos, offset)

func _physics_process(delta: float) -> void:
	var target_pos_world: Vector2 = target * Globals.CELL_SIZE + OFFSET
	var distance = position.distance_to(target_pos_world)
	var offset: Vector2 = position.direction_to(target_pos_world)
	position += offset * min(SPEED * delta, distance)

	# Arrived at target, update it to continue movement
	if position.distance_squared_to(target_pos_world) <= 1:
		var tile_pos: Vector2 = map_holder.world_to_map(position)
		_update_target(tile_pos)
		old_tile_pos = tile_pos
