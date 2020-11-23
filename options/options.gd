extends Node


func _ready():
	$"CenterContainer/VBoxContainer/SaveCancelButtons/HBoxContainer/SaveButton".connect('pressed', self, '_save_button_press')
	$"CenterContainer/VBoxContainer/SaveCancelButtons/HBoxContainer/CancelButton".connect('pressed', self, '_cancel_button_press')

func _save_button_press():
	print('Save button press')
	get_tree().change_scene('res://menu/menu.tscn')

func _cancel_button_press():
	get_tree().change_scene('res://menu/menu.tscn')
