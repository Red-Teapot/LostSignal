extends Node

const CELL_SIZE: int = 32
const CELL_SIZE_V: Vector2 = Vector2(CELL_SIZE, CELL_SIZE)
const TILEMAP_SCALE: Vector2 = Vector2(1, 1)

var _music_player: AudioStreamPlayer = null
var _sounds_player: AudioStreamPlayer = null

func _ready():
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = 'Music'
	
	_sounds_player = AudioStreamPlayer.new()
	_sounds_player.bus = 'Sounds'
	
	add_child(_music_player)
	add_child(_sounds_player)
	
	playMusic('res://menu/menu_theme.ogg')

func playMusic(path: String, replace: bool = false, loop: bool = true):
	var newStream = load(path)
	
	if newStream == _music_player.stream and not replace:
		return
	
	_music_player.stop()
	
	_music_player.stream = newStream
	_music_player.stream.loop = loop
	_music_player.play()

func playSound(path: String, replace: bool = true):
	var newStream = load(path)
	
	if newStream == _sounds_player.stream and not replace:
		return
	
	_sounds_player.stop()
	
	_sounds_player.stream = newStream
	_sounds_player.play()

func stopAllAudio():
	_music_player.stop()
	_sounds_player.stop()
