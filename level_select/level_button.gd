extends Control
class_name LevelButton

signal pressed

export var level_number: int = -1
export var is_locked: bool = false

onready var _lock_icon: TextureRect = $'LockIcon'
onready var _level_number: Label = $'LevelNumber'
onready var _panel: Panel = $'Panel'

func _ready():
	connect('mouse_entered', self, '_mouse_in')
	connect('mouse_exited', self, '_mouse_out')
	connect('gui_input', self, '_gui_input')
	
	_lock_icon.visible = is_locked
	_level_number.visible = !is_locked
	_level_number.text = 'Lvl %s' % level_number
	
	if is_locked:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _mouse_in():
	if is_locked:
		return
	
	_panel.modulate = 0xFF00FBFF
	_level_number.modulate = 0x00FF4BFF

func _mouse_out():
	if is_locked:
		return
	
	_panel.modulate = 0xFFFFFFFF
	_level_number.modulate = 0xFFFFFFFF

func _gui_input(evt):
	if is_locked:
		return
	
	if evt is InputEventMouseButton:
		if evt.button_index == 1 and not evt.pressed:
			Audio.play_sound('res://ui/button_click.wav')
			emit_signal('pressed')
