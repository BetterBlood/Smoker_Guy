extends Control

signal transitionned(value:int)
signal transition_finished(value:int)

func begin_transition(value:int):
	$AnimationPlayer.play("fade_to_black")
	show()
	await $AnimationPlayer.animation_finished
	transitionned.emit(value)
	$AnimationPlayer.play("fade_to_transparent")
	await $AnimationPlayer.animation_finished
	hide()
	transition_finished.emit(value)
