extends Node
class_name MapHolder

var map: TileMap = null
var bounds: Rect2 = Rect2()

func _init() -> void:
	load_level('test')

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
