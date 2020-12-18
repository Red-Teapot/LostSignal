extends Node
class_name Gameplay

onready var _fade_animation: AnimationPlayer = $'HUD/FadeAnimation'

onready var _movement_loop: AudioStreamPlayer = $'MovementLoop'
onready var _direction_activate: AudioStreamPlayer = $'DirectionActivate'
onready var _direction_reset: AudioStreamPlayer = $'DirectionReset'

func _ready():
	Audio.play_music('res://gameplay/main_theme.ogg')
	
	_fade_animation.play('FadeIn')
	
	_setLevelNumText(Levels.current_level_idx() + 1)

func _setLevelNumText(level_num: int):
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
