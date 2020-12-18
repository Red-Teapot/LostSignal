extends Node

func _ready():
	# A hack to load the game properly if launched by F6 in the editor
	if get_tree().current_scene == self:
		var filename = get_tree().current_scene.filename
		var level_name = filename.get_file().rstrip('tscn').rstrip('.')
		Levels.current_level = level_name
		get_tree().change_scene('res://gameplay/gameplay.tscn')
