extends Node

const FIRST_LEVEL = 'Level1'
const LEVEL_SEQ = {
	'Level1': 'Level2',
	'Level2': 'GameWin',
}

func startScene(name: String):
	get_tree().change_scene('res://Scenes/' + name + '.tscn')

func startFirstLevel():
	startScene(FIRST_LEVEL)

func startNextLevel():
	var currentLevelName = get_tree().current_scene.name
	var nextLevelName = LEVEL_SEQ[currentLevelName]
	startScene(nextLevelName)
