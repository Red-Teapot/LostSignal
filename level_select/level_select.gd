extends Node


onready var grid: GridContainer = $'CenterContainer/VBoxContainer/CenterContainer/LevelButtonGrid'

func _ready():
	var button = load('res://level_select/level_button.tscn')
	
	var last_completed_level = Levels.last_completed_level
	if last_completed_level == Levels.NO_LEVEL_COMPLETED:
		last_completed_level = -1
	
	for i in range(len(Levels.LEVEL_SEQUENCE)):
		var level_num = i + 1
		var is_locked = last_completed_level + 1 < i
		
		var item: LevelButton = button.instance()
		item.level_number = level_num
		item.is_locked = is_locked
		
		grid.add_child(item)
		item.connect('pressed', self, '_play_level', [i])
	
	$'CenterContainer/VBoxContainer/CenterContainer2/BackButton'.connect('pressed', self, '_back')

func _back():
	get_tree().change_scene('res://menu/menu.tscn')

func _play_level(level_number):
	Levels.current_level = Levels.LEVEL_SEQUENCE[level_number]
	get_tree().change_scene('res://gameplay/gameplay.tscn')
