extends Control


func _ready():
	var clazz = get_class()
	
	connect('pressed', self, '_click')

func _click():
	Globals.playSound('res://ui/button_click.wav')
