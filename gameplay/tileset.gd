extends TileSet
tool

func _init() -> void:
	var fake_wall_id: int = find_tile_by_name('Fake Wall')
	var region: Rect2 = tile_get_region(fake_wall_id)
		
	if Engine.editor_hint:	
		region.position.x = 0
	else:
		region.position.x = 32
	
	tile_set_region(fake_wall_id, region)

func _is_tile_bound(drawn_id: int, neighbor_id: int) -> bool:
	if tile_get_name(drawn_id) == 'Wall':
		# Make regular walls stick to fake walls
		return tile_get_name(neighbor_id).ends_with('Wall')
	else:
		return ._is_tile_bound(drawn_id, neighbor_id)
