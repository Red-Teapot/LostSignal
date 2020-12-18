extends Node

var _music_player: AudioStreamPlayer = null
var _sounds_player: AudioStreamPlayer = null

func _init():
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = 'Music'
	
	_sounds_player = AudioStreamPlayer.new()
	_sounds_player.bus = 'Sounds'
	
	add_child(_music_player)
	add_child(_sounds_player)

func play_music(path: String, replace: bool = false, loop: bool = true):
	var new_stream = load(path)
	
	if new_stream == _music_player.stream and not replace:
		return
	
	_music_player.stop()
	_music_player.stream = new_stream
	_music_player.stream.loop = loop
	_music_player.play()

func play_sound(path: String, replace: bool = true):
	var new_stream = load(path)
	
	if new_stream == _sounds_player.stream and not replace:
		return
	
	_sounds_player.stop()
	
	_sounds_player.stream = new_stream
	_sounds_player.play()

func stop_all_audio():
	_music_player.stop()
	_sounds_player.stop()
