extends Node

var click = AudioStreamPlayer.new()
var clickStream = load('res://Sounds/PlayButtonClick.wav')

var sounds = {
	'click': click,
}

func _init():
	click.stream = clickStream
	add_child(click)

func play(name: String):
	sounds[name].play()
