extends Control


func _ready():
	var clazz = get_class()
	
	connect('pressed', self, '_click')

func _click():
	Audio.playSound('res://ui/button_click.wav')
