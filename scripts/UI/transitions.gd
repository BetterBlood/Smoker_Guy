extends Control

signal transitionned(value:int)
signal transition_finished(value:int)

func begin_transition(value:int):
	$AnimationPlayer.play("fade_to_black")
	show()
	print("fade to black")
	await $AnimationPlayer.animation_finished
	print("fade to black end")
	transitionned.emit(value)
	$AnimationPlayer.play("fade_to_transparent")
	print("fade to transparent")
	await $AnimationPlayer.animation_finished
	print("fade to transparent end")
	hide()
	print("fade finished")
	transition_finished.emit(value)
