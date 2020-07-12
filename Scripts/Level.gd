extends Node

func _enter_tree():
	SoundPlayer.play('mainTheme')
	find_node('FadeRect').visible = true
	find_node('FadeAnims').play("FadeIn")

func fadeOut():
	find_node('FadeAnims').play("FadeOut")
