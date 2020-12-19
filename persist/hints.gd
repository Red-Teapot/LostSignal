extends Node

const SAVE_FILE_PATH = 'user://hints.dat'

var movement_hint_shown: bool = false
var zoom_out_hint_shown: bool = false

func _init():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_FILE_PATH):
		return
	
	save_file.open(SAVE_FILE_PATH, File.READ)
	
	movement_hint_shown = save_file.get_8()
	zoom_out_hint_shown = save_file.get_8()
	
	save_file.close()

func register_movement_hint():
	movement_hint_shown = true
	_save()

func register_zoom_out_hint():
	zoom_out_hint_shown = true
	_save()

func reset():
	movement_hint_shown = false
	zoom_out_hint_shown = false
	_save()

func _save():
	var save_file = File.new()
	save_file.open(SAVE_FILE_PATH, File.WRITE)
	
	save_file.store_8(movement_hint_shown)
	save_file.store_8(zoom_out_hint_shown)
	
	save_file.close()
