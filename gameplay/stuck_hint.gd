extends AnimationPlayer
class_name StuckHint


var is_stuck: bool = false
var is_shown: bool = false


func set_stuck(stuck: bool) -> void:
	if self.is_stuck == stuck:
		return
	
	self.is_stuck = stuck
	
	if self.is_stuck:
		appear()
	else:
		disappear()

func appear() -> void:
	if not is_shown and is_stuck:
		is_shown = true
		$'CenterContainer/Panel/Label'.text = $'CenterContainer/Panel/Label'.text.replace('{0}', OS.get_scancode_string(Options.restart_key))
		play('Appear')

func disappear() -> void:
	if is_shown:
		is_shown = false
		play('Disappear')
