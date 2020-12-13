extends Node


func _enter_tree():
	$'HUD/FadeAnimation'.play('FadeIn')
	Globals.playMusic('res://gameplay/main_theme.ogg')
	call_deferred('_setLevelNumText')

func _setLevelNumText():
	var levelNum = Globals.LEVEL_SEQUENCE.find(Globals.current_level) + 1
	$'LevelNumLabel'.text = 'Lvl %s' % levelNum

func _input(event):
	if event.is_action_pressed('gameplay_restart'):
		Globals.playSound('res://gameplay/level_restart.wav')
		$'HUD/FadeAnimation'.play('FadeOut')

func _restart():
	$'MovementLoop'.stop()
	$'DirectionActivate'.stop()
	$'DirectionReset'.stop()
	get_tree().change_scene('res://gameplay/gameplay.tscn')
