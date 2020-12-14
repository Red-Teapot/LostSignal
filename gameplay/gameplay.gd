extends Node


func _enter_tree():
	$'HUD/FadeAnimation'.play('FadeIn')
	Audio.playMusic('res://gameplay/main_theme.ogg')
	_setLevelNumText(Levels.current_level_idx() + 1)

func _setLevelNumText(level_num: int):
	$'LevelNumLabel'.text = 'Lvl %s' % level_num

func _input(event):
	if event.is_action_pressed('gameplay_restart'):
		Audio.playSound('res://gameplay/level_restart.wav')
		$'HUD/FadeAnimation'.play('FadeOut')

func _restart():
	$'MovementLoop'.stop()
	$'DirectionActivate'.stop()
	$'DirectionReset'.stop()
	Levels.save()
	get_tree().change_scene('res://gameplay/gameplay.tscn')
