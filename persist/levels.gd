extends Node

const NO_LEVEL_COMPLETED = pow(2, 16) - 1

const LEVEL_SEQUENCE = [
	'level1',
	'level2',
	'level3',
	'level4',
	'level5',
	'level6',
	'level7',
	'level8',
	'level9',
	'level10',
	'level11',
	'level12',
	'level13',
	'template', # TODO
]
var LEVEL_NAME_TO_IDX: Dictionary = {}

var current_level: String = 'template'

const SAVE_FILE_PATH = 'user://levels.dat'

var last_completed_level: int = NO_LEVEL_COMPLETED

func current_level_idx():
	return LEVEL_NAME_TO_IDX[current_level]

func next_level_name():
	return LEVEL_SEQUENCE[current_level_idx() + 1]

func _init():
	for i in range(len(LEVEL_SEQUENCE)):
		LEVEL_NAME_TO_IDX[LEVEL_SEQUENCE[i]] = i
	
	_load()

func _load():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_FILE_PATH):
		return
	
	save_file.open(SAVE_FILE_PATH, File.READ)
	
	last_completed_level = save_file.get_16()
	
	save_file.close()

func complete_level(number):
	if last_completed_level == NO_LEVEL_COMPLETED or number > last_completed_level:
		last_completed_level = number

func reset_progress():
	last_completed_level = NO_LEVEL_COMPLETED
	save()

func save():
	var save_file = File.new()
	save_file.open(SAVE_FILE_PATH, File.WRITE)
	
	save_file.store_16(last_completed_level)
	
	save_file.close()
