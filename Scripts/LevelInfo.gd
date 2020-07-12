extends Node

const FIRST_LEVEL = 'Level1'
const LEVEL_SEQ = {
	'Level1': 'Level1_3',
	'Level1_3': 'Level1_5',
	'Level1_5': 'Level2',
	'Level2': 'Level3',
	'Level3': 'Level3_5',
	'Level3_5': 'Level4',
	'Level4': 'S_level5',
	'S_level5': 'Level4_5',
	'Level4_5': 'Level5',
	'Level5': 'Level6',
	'Level6': 'Level7',
	'Level7': 'Level8',
	'Level8': 'S_level6',
	'S_level6': 'Level9',
	'Level9': 'Level10',
	'Level10': 'GameWin',
}

func startScene(name: String):
	get_tree().change_scene('res://Scenes/' + name + '.tscn')
	get_tree().paused = false

func startFirstLevel():
	startScene(FIRST_LEVEL)

func startLevel(name: String):
	get_tree().paused = true
	var currentScene = get_tree().current_scene
	currentScene.fadeOut()
	var timer = currentScene.find_node("FadeTimer")
	timer.set_wait_time(0.5)
	timer.connect('timeout', self, 'startScene', [name])
	timer.start()

func startNextLevel():
	var currentLevelName = get_tree().current_scene.name
	if currentLevelName in LEVEL_SEQ:
		var nextLevelName = LEVEL_SEQ[currentLevelName]
		startLevel(nextLevelName)
	else:
		get_tree().quit(-1)
