extends Node


func _ready():
	$"CenterContainer/VBoxContainer/PlayButton".connect('pressed', self, '_play_button_press')
	$"CenterContainer/VBoxContainer/OptionsButton".connect('pressed', self, '_options_button_press')
	$"CenterContainer/VBoxContainer/QuitButton".connect('pressed', self, '_quit_button_press')	

func _play_button_press():
	get_tree().change_scene('res://gameplay/gameplay.tscn')

func _options_button_press():
	get_tree().change_scene('res://options/options.tscn')

func _quit_button_press():
	get_tree().quit()
