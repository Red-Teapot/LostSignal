extends Node

const FIRST_LEVEL = 'TestLevel'
const LEVEL_SEQ = {
	'TestLevel': null,
}

func startLevel(name: String):
	get_tree().change_scene('res://Scenes/' + name + '.tscn')

func startFirstLevel():
	startLevel(FIRST_LEVEL)

func startNextLevel():
	var currentLevelName = get_tree().current_scene.name
	var nextLevelName = LEVEL_SEQ[currentLevelName]
	if nextLevelName == null:
		nextLevelName = 'GameWin'
	startLevel(nextLevelName)
