extends Camera2D

const DEFAULT_LIMITS = Rect2(-1000000, -1000000, 2000000, 2000000)
const EDGE_OFFSET = 32
const DEFAULT_ZOOM = Vector2(0.5, 0.5)

var track_x: bool = true
var track_y: bool = true

var limits: Rect2 = DEFAULT_LIMITS
var player: Node2D = null
var map: MapHolder = null
var stuck_hint: StuckHint = null
var zoomout_zoom: Vector2 = DEFAULT_ZOOM
var target_zoom: Vector2 = DEFAULT_ZOOM

static func _center(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2
	)

func _set_limits(lims: Rect2) -> void:
	limit_left = lims.position.x
	limit_top = lims.position.y
	limit_right = lims.end.x
	limit_bottom = lims.end.y

func _resize() -> void:
	var viewport_rect: Rect2 = get_viewport_rect()
	var map_bounds: Rect2 = map.bounds.grow(-EDGE_OFFSET)
	
	# Multiply by 2 to adjust for camera zoom
	track_x = (viewport_rect.size.x < map_bounds.size.x * 2)
	track_y = (viewport_rect.size.y < map_bounds.size.y * 2)
	
	var zoomout_zoom_val = max(map_bounds.size.x / viewport_rect.size.x,
							   map_bounds.size.y / viewport_rect.size.y)
	zoomout_zoom_val = max(zoomout_zoom_val, 0.5)
	zoomout_zoom = Vector2(zoomout_zoom_val, zoomout_zoom_val)
	
	limits = DEFAULT_LIMITS
	if track_x:
		limits.position.x = map_bounds.position.x
		limits.end.x = map_bounds.end.x
	if track_y:
		limits.position.y = map_bounds.position.y
		limits.end.y = map_bounds.end.y
	_set_limits(limits)
	
	if not track_x:
		position.x = _center(map_bounds).x
	if not track_y:
		position.y = _center(map_bounds).y

func _enter_tree():
	player = $'/root/Gameplay/Player'
	map = $'/root/Gameplay/MapHolder'
	stuck_hint = $'/root/Gameplay/HUD/StuckHint' as StuckHint
	
	get_tree().get_root().connect('size_changed', self, '_resize')
	_resize()

func _process(delta: float) -> void:	
	if Input.is_action_pressed("gameplay_zoom_out"):
		target_zoom = zoomout_zoom
		position = _center(map.bounds)
		_set_limits(DEFAULT_LIMITS)
		stuck_hint.disappear()
	else:
		target_zoom = DEFAULT_ZOOM
		if track_x:
			position.x = player.position.x
		if track_y:
			position.y = player.position.y
		_set_limits(limits)
		stuck_hint.appear()
	
	if (target_zoom - zoom).length_squared() > 0.00001:
		zoom += (target_zoom - zoom) * delta * 8
	else:
		# Snap to avoid weird scaling issues
		zoom = target_zoom
