extends TileSet
tool

func _is_tile_bound(drawn_id, neighbor_id):
	if neighbor_id == 1:
		return true
	else:
		return neighbor_id in get_tiles_ids()
