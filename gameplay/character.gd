extends Node2D

const SPEED: float = 96.0
const OFFSET = Globals.CELL_SIZE_V / 2

# Visuals
var map_holder: MapHolder = null
var arrow_u: Sprite = null
var arrow_d: Sprite = null
var arrow_l: Sprite = null
var arrow_r: Sprite = null
var stuck_hint: StuckHint = null

# Audio players
var movement_loop: AudioStreamPlayer = null
var direction_activate: AudioStreamPlayer = null
var direction_reset: AudioStreamPlayer = null

var target: Vector2 = Vector2.ZERO
var old_tile_pos: Vector2 = Vector2.INF

var controls_offset: Vector2 = Vector2.ZERO
var active_tile_offset: Vector2 = Vector2.ZERO
var walls_offset: Vector2 = Vector2.ZERO

var movement_flags: int = 0
var movement_flags_old: int = 0

func _enter_tree() -> void:
	map_holder = $'/root/Gameplay/MapHolder' as MapHolder
	arrow_u = $'ArrowU' as Sprite
	arrow_d = $'ArrowD' as Sprite
	arrow_l = $'ArrowL' as Sprite
	arrow_r = $'ArrowR' as Sprite
	stuck_hint = $'/root/Gameplay/HUD/StuckHint' as StuckHint

	movement_loop = $'/root/Gameplay/MovementLoop' as AudioStreamPlayer
	direction_activate = $'/root/Gameplay/DirectionActivate' as AudioStreamPlayer
	direction_reset = $'/root/Gameplay/DirectionReset' as AudioStreamPlayer

func _update_arrows() -> void:
	arrow_u.visible = (movement_flags & MapHolder.Direction.UP) != 0
	arrow_d.visible = (movement_flags & MapHolder.Direction.DOWN) != 0
	arrow_l.visible = (movement_flags & MapHolder.Direction.LEFT) != 0
	arrow_r.visible = (movement_flags & MapHolder.Direction.RIGHT) != 0

	movement_flags_old = movement_flags

func _input(event: InputEvent) -> void:
	var arrows_need_update: bool = false
	if event.is_action_pressed("gameplay_up"):
		movement_flags |= MapHolder.Direction.UP
		arrows_need_update = true
	if event.is_action_pressed("gameplay_down"):
		movement_flags |= MapHolder.Direction.DOWN
		arrows_need_update = true
	if event.is_action_pressed("gameplay_left"):
		movement_flags |= MapHolder.Direction.LEFT
		arrows_need_update = true
	if event.is_action_pressed("gameplay_right"):
		movement_flags |= MapHolder.Direction.RIGHT
		arrows_need_update = true
	
	if movement_flags != -1 and movement_flags != movement_flags_old:
		direction_activate.play()
	
	if arrows_need_update:
		_update_arrows()

func _check_controls() -> void:
	controls_offset = Vector2.ZERO
	if movement_flags == -1:
		return
	
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
			direction_reset.play()
			_update_arrows()
		MapHolder.TileType.EXIT:
			movement_flags = -1
			Audio.playSound('res://gameplay/level_complete.wav')
			Levels.complete_level(Levels.current_level_idx())
			Levels.current_level = Levels.next_level_name()
			$'/root/Gameplay/HUD/FadeAnimation'.play('FadeOut')

func _check_obstacles(tile_pos: Vector2, offset: Vector2) -> Vector2:
	# Horizontal
	var dx = Vector2(offset.x, 0)
	if map_holder.get_tilev(tile_pos + dx) == MapHolder.TileType.WALL:
		offset.x = 0
	if map_holder.get_tilev(tile_pos + dx) == MapHolder.TileType.CONVEYOR \
			and map_holder.get_conveyor_movement(tile_pos + dx) == -offset:
		offset.x = 0
	
	# Vertical
	var dy = Vector2(0, offset.y)
	if map_holder.get_tilev(tile_pos + dy) == MapHolder.TileType.WALL:
		offset.y = 0
	if map_holder.get_tilev(tile_pos + dy) == MapHolder.TileType.CONVEYOR \
			and map_holder.get_conveyor_movement(tile_pos + dy) == -offset:
		offset.y = 0
	
	# Diagonal
	if offset.x != 0 and offset.y != 0 \
			and map_holder.get_tilev(tile_pos + offset) == MapHolder.TileType.WALL:
		offset.x = 0

	return offset

func _check_stuck(offset: Vector2) -> void:
	var offset_x = offset
	offset_x.y = 0

	var offset_y = offset
	offset_y.x = 0

	var stuck_x = (movement_flags & (MapHolder.Direction.LEFT | MapHolder.Direction.RIGHT) != 0) \
		and offset_x == Vector2.ZERO
	var stuck_y = (movement_flags & (MapHolder.Direction.UP | MapHolder.Direction.DOWN) != 0) \
		and offset_y == Vector2.ZERO
	
	if stuck_x and stuck_y and movement_flags >= 0:
		stuck_hint.set_stuck(true)

func _update_target(tile_pos: Vector2) -> void:
	# Active tiles might change controls (e.g. reset tiles)
	_check_active_tiles(tile_pos)
	_check_controls()

	var offset = active_tile_offset

	# Do not apply controls if standing on a conveyor
	if offset == Vector2.ZERO:
		offset = controls_offset
	
	offset = _check_obstacles(tile_pos, offset)

	_check_stuck(offset)
	
	target = tile_pos + offset

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

		if target != tile_pos:
			movement_loop.play()
		else:
			movement_loop.stop()
