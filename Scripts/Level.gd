extends Node

func _enter_tree():
	find_node('FadeRect').visible = true
	find_node('FadeAnims').play("FadeIn")

func fadeOut():
	find_node('FadeAnims').play("FadeOut")
