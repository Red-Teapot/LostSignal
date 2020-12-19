extends Node

const SAVE_FILE_PATH = 'user://options.dat'

var music_bus = AudioServer.get_bus_index('Music')
var sounds_bus = AudioServer.get_bus_index('Sounds')

var music_volume: int = 60
var sounds_volume: int = 70

var up_key: int = KEY_W
var down_key: int = KEY_S
var left_key: int = KEY_A
var right_key: int = KEY_D

var zoom_out_key: int = KEY_Q
var restart_key: int = KEY_R

func _init():
	_load()
	_apply()

func save_and_apply():
	_apply()
	
	var save_file = File.new()
	save_file.open(SAVE_FILE_PATH, File.WRITE)
	
	save_file.store_8(music_volume)
	save_file.store_8(sounds_volume)
	
	save_file.store_8(up_key)
	save_file.store_8(down_key)
	save_file.store_8(left_key)
	save_file.store_8(right_key)
	
	save_file.store_8(zoom_out_key)
	save_file.store_8(restart_key)
	
	save_file.close()

func _load():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_FILE_PATH):
		return
	
	save_file.open(SAVE_FILE_PATH, File.READ)
	
	music_volume = save_file.get_8()
	sounds_volume = save_file.get_8()
	
	up_key = save_file.get_8()
	down_key = save_file.get_8()
	left_key = save_file.get_8()
	right_key = save_file.get_8()
	
	zoom_out_key = save_file.get_8()
	restart_key = save_file.get_8()
	
	save_file.close()

func _apply():
	InputMap.get_action_list('gameplay_up')[0].scancode = up_key
	InputMap.get_action_list('gameplay_down')[0].scancode = down_key
	InputMap.get_action_list('gameplay_left')[0].scancode = left_key
	InputMap.get_action_list('gameplay_right')[0].scancode = right_key
	
	InputMap.get_action_list('gameplay_zoom_out')[0].scancode = zoom_out_key
	InputMap.get_action_list('gameplay_restart')[0].scancode = restart_key

	AudioServer.set_bus_volume_db(music_bus, linear2db(music_volume * 0.01))
	AudioServer.set_bus_volume_db(sounds_bus, linear2db(sounds_volume * 0.01))
