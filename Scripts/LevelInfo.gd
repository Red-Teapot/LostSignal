extends Node

const FIRST_LEVEL = 'TestLevel'
const LEVEL_SEQ = {
	'TestLevel': 'GameWin',
}

func startScene(name: String):
	get_tree().change_scene('res://Scenes/' + name + '.tscn')

func startFirstLevel():
	startScene(FIRST_LEVEL)

func startNextLevel():
	var currentLevelName = get_tree().current_scene.name
	var nextLevelName = LEVEL_SEQ[currentLevelName]
	startScene(nextLevelName)
