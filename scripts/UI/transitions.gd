extends Control

signal transitionned(value:int)

func begin_transition(value:int):
	show()
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	transitionned.emit(value)
	$AnimationPlayer.play("fade_to_transparent")
	await $AnimationPlayer.animation_finished
	hide()
