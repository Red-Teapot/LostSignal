extends Control


func _ready():
	$'FadeAnim'.play('FadeIn')
	$'CenterContainer/VBoxContainer/BackButton'.connect('pressed', self, '_back_to_menu')

func _back_to_menu():
	get_tree().change_scene('res://menu/menu.tscn')
