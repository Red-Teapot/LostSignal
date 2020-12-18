extends Node

onready var play_button = $'CenterContainer/VBoxContainer/PlayButton'
onready var options_button = $'CenterContainer/VBoxContainer/OptionsButton'
onready var quit_button = $'CenterContainer/VBoxContainer/QuitButton'

func _ready():
	Audio.play_music('res://menu/menu_theme.ogg')
	
	play_button.connect('pressed', self, '_play_button_press')
	options_button.connect('pressed', self, '_options_button_press')
	quit_button.connect('pressed', self, '_quit_button_press')

func _play_button_press():
	get_tree().change_scene('res://level_select/level_select.tscn')

func _options_button_press():
	get_tree().change_scene('res://options/options.tscn')

func _quit_button_press():
	get_tree().quit()
