extends Control

func _ready():
	connect('pressed', self, '_click')

func _click():
	Audio.play_sound('res://ui/button_click.wav')
