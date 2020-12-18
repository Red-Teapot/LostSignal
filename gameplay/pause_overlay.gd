extends Control
class_name PauseOverlay

func _ready():
	set_paused(false)
	
	$'Panel/VBoxContainer/ContinueButton'.connect('pressed', self, 'set_paused', [false])
	$'Panel/VBoxContainer/MenuButton'.connect('pressed', self, '_quit_to_menu')

func _input(event):
	if event.is_action_pressed('gameplay_pause'):
		set_paused(!get_tree().paused)

func set_paused(paused: bool) -> void:
	self.visible = paused
	get_tree().paused = paused

func _quit_to_menu():
	get_tree().paused = false
	get_tree().change_scene('res://menu/menu.tscn')
