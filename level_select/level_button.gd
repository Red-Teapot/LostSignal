extends Control
class_name LevelButton

signal pressed

export var level_number: int = -1
export var is_locked: bool = false

func _ready():
	connect('mouse_entered', self, '_mouse_in')
	connect('mouse_exited', self, '_mouse_out')
	connect('gui_input', self, '_gui_input')

func _enter_tree():
	$'LockIcon'.visible = is_locked
	$'LevelNumber'.visible = !is_locked
	$'LevelNumber'.text = 'Lvl %s' % level_number
	
	if is_locked:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _mouse_in():
	if is_locked:
		return
	
	$'Panel'.modulate = 0x00FF4BFF
	$'LevelNumber'.modulate = 0xFF00FBFF

func _mouse_out():
	if is_locked:
		return
	
	$'Panel'.modulate = 0xFFFFFFFF
	$'LevelNumber'.modulate = 0xFFFFFFFF

func _gui_input(evt):
	if is_locked:
		return
	
	if evt is InputEventMouseButton:
		if evt.button_index == 1 and not evt.pressed:
			emit_signal('pressed')
