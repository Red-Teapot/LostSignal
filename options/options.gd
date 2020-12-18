extends Node

var default_key_button_theme = load('res://options/key_buttons.tres')
var active_key_button_theme = load('res://options/key_buttons_active.tres')

var active_key_button = null
var key_buttons_overrides = {}

func _ready():
	_register_key_button('UpButton')
	_register_key_button('DownButton')
	_register_key_button('LeftButton')
	_register_key_button('RightButton')
	
	_register_key_button('ZoomOutButton')
	_register_key_button('RestartButton')
	
	$'CenterContainer/VBoxContainer/SaveCancelButtons/HBoxContainer/SaveButton'.connect('pressed', self, '_save_button_press')
	$'CenterContainer/VBoxContainer/SaveCancelButtons/HBoxContainer/CancelButton'.connect('pressed', self, '_cancel_button_press')
	$'CenterContainer/VBoxContainer/ProgressOptions/ResetProgressButton'.connect('pressed', self, '_reset_progress')

func _enter_tree():
	$'CenterContainer/VBoxContainer/VolumeOptions/MusicVol'.value = Options.music_volume
	$'CenterContainer/VBoxContainer/VolumeOptions/SoundsVol'.value = Options.sounds_volume
	
	$'CenterContainer/VBoxContainer/Controls/UpButton'.text = OS.get_scancode_string(Options.up_key)
	$'CenterContainer/VBoxContainer/Controls/DownButton'.text = OS.get_scancode_string(Options.down_key)
	$'CenterContainer/VBoxContainer/Controls/LeftButton'.text = OS.get_scancode_string(Options.left_key)
	$'CenterContainer/VBoxContainer/Controls/RightButton'.text = OS.get_scancode_string(Options.right_key)
	
	$'CenterContainer/VBoxContainer/Controls/ZoomOutButton'.text = OS.get_scancode_string(Options.zoom_out_key)
	$'CenterContainer/VBoxContainer/Controls/RestartButton'.text = OS.get_scancode_string(Options.restart_key)

func _unhandled_key_input(event):
	if not active_key_button or not event.pressed or event.echo:
		return
	
	var button = _get_key_button(active_key_button)
	var new_text = char(event.unicode).to_upper()
	
	if new_text and new_text != button.text:
		key_buttons_overrides[active_key_button] = event.scancode
		button.text = new_text
	
	button.theme = default_key_button_theme
	active_key_button = null
	Audio.play_sound('res://ui/button_click.wav')

func _reset_progress():
	Levels.reset_progress()
	
func _get_key_button(button_name: String) -> Button:
	return get_node('CenterContainer/VBoxContainer/Controls/' + button_name) as Button

func _register_key_button(button_name: String):
	var button: Button = _get_key_button(button_name)
	button.connect('pressed', self, '_key_button_press', [button])

func _key_button_press(button: Button):
	if active_key_button:
		_get_key_button(active_key_button).theme = default_key_button_theme
	
	active_key_button = button.name
	button.theme = active_key_button_theme

func _save_button_press():
	if 'UpButton' in key_buttons_overrides:
		Options.up_key = key_buttons_overrides['UpButton']
	if 'DownButton' in key_buttons_overrides:
		Options.down_key = key_buttons_overrides['DownButton']
	if 'LeftButton' in key_buttons_overrides:
		Options.left_key = key_buttons_overrides['LeftButton']
	if 'RightButton' in key_buttons_overrides:
		Options.right_key = key_buttons_overrides['RightButton']
	
	if 'ZoomOutButton' in key_buttons_overrides:
		Options.zoom_out_key = key_buttons_overrides['ZoomOutButton']
	if 'RestartButton' in key_buttons_overrides:
		Options.restart_key = key_buttons_overrides['RestartButton']
	
	Options.music_volume = $'CenterContainer/VBoxContainer/VolumeOptions/MusicVol'.value
	Options.sounds_volume = $'CenterContainer/VBoxContainer/VolumeOptions/SoundsVol'.value
	
	Options.save_and_apply()

	get_tree().change_scene('res://menu/menu.tscn')

func _cancel_button_press():
	get_tree().change_scene('res://menu/menu.tscn')
