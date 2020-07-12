extends Node

const soundList = {
	'click': 'res://Sounds/PlayButtonClick.wav',
	'mainTheme': 'res://Sounds/MainTheme.ogg',
	'levelRestart': 'res://Sounds/LevelRestart.wav',
	'levelCompletion': 'res://Sounds/LevelComplete.wav',
}
const volumeSettings = {
	'mainTheme': -15,
	'levelComplete': -9,
}
var soundPlayers = {}

func _init():
	for key in soundList:
		var res = soundList[key]
		var stream = load(res)
		var player = AudioStreamPlayer.new()
		player.stream = stream
		player.pause_mode = Node.PAUSE_MODE_PROCESS
		soundPlayers[key] = player
		
		if key in volumeSettings:
			player.volume_db = volumeSettings[key]
		
		add_child(player)

func play(name: String, restart: bool = false):
	var player = soundPlayers[name]
	
	if restart or not player.playing:
		player.play()

func stop(name: String):
	soundPlayers[name].stop()
