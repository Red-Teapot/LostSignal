extends Node
class_name Gameplay

onready var _fade_animation: AnimationPlayer = $'HUD/FadeAnimation'

onready var _movement_loop: AudioStreamPlayer = $'MovementLoop'
onready var _direction_activate: AudioStreamPlayer = $'DirectionActivate'
onready var _direction_reset: AudioStreamPlayer = $'DirectionReset'

onready var _controls_hint: AnimationPlayer = $'HUD/ControlsHint'

var _current_controls_hint: String = ''

func _ready():
	$'HUD/FadeAnimation/FadeRect'.visible = true
	Audio.play_music('res://gameplay/main_theme.ogg')
	
	_fade_animation.play('FadeIn')
	
	_set_level_num_text(Levels.current_level_idx() + 1)
	show_movement_hint()

func show_movement_hint():
	if Hints.movement_hint_shown:
		return
	
	var text = str(OS.get_scancode_string(Options.up_key))
	text += str(OS.get_scancode_string(Options.left_key))
	text += str(OS.get_scancode_string(Options.down_key))
	text += str(OS.get_scancode_string(Options.right_key))
	text += ' to move'
	_current_controls_hint = 'movement'
	_show_controls_hint(text)

func hide_movement_hint():
	if _current_controls_hint == 'movement':
		Hints.register_movement_hint()
		_hide_controls_hint()

func show_zoom_out_hint():
	if Hints.zoom_out_hint_shown:
		return
	
	var text = str(OS.get_scancode_string(Options.zoom_out_key))
	text += ' to zoom out'
	_current_controls_hint = 'zoom_out'
	_show_controls_hint(text)

func hide_zoom_out_hint():
	if _current_controls_hint == 'zoom_out':
		Hints.register_zoom_out_hint()
		_hide_controls_hint()

func _show_controls_hint(text: String):
	_controls_hint.get_node('CenterContainer/Panel/Label').text = text
	_controls_hint.play('Appear')

func _hide_controls_hint():
	if _controls_hint.get_node('CenterContainer').visible:
		_controls_hint.play('Disappear')

func _set_level_num_text(level_num: int):
	$'LevelNumLabel'.text = 'Lvl %s' % level_num

func _input(event):
	if event.is_action_pressed('gameplay_restart'):
		Audio.play_sound('res://gameplay/level_restart.wav')
		_fade_animation.play('FadeOut')

func _restart():
	_movement_loop.stop()
	_direction_activate.stop()
	_direction_reset.stop()
	Levels.save()
	get_tree().change_scene('res://gameplay/gameplay.tscn')
