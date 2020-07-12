extends Button

func _pressed():
	SoundPlayer.play('click')
	LevelInfo.startFirstLevel()
