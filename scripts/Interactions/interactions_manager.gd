extends Node3D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var label: Label = $Label

const beginText: String = "[F] "

var activeAreas = []
var canInteract: bool = true

func registerArea(area: InteractionsDetector):
	activeAreas.push_back(area)

func unregisterArea(area: InteractionsDetector):
	area.get_parent()._rem_out_line()
	var index = activeAreas.find(area)
	if index != -1:
		activeAreas.remove_at(index)

func _process(_delta: float) -> void:
	for area in activeAreas:
		area.get_parent()._rem_out_line()
	if canInteract:
		if activeAreas.size() == 0 :
			label.hide()
		else :
			if activeAreas.size() > 1 :
				activeAreas.sort_custom(_sortByDistToPlayer)
			var currArea: InteractionsDetector = activeAreas[0]
			_setActiveLabel(currArea)
			currArea.get_parent()._out_line()
			label.show()
	else:
		label.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") && canInteract:
		if activeAreas.size() > 0:
			canInteract = false
			label.hide()
			
			await activeAreas[0].interact.call()
			
			canInteract = true

func _setActiveLabel(currArea: InteractionsDetector):
	label.text = beginText + currArea.actionName
	label.global_position = get_window().size/2
	label.global_position.y += 50
	label.global_position.x -= label.size.x / 2

func _sortByDistToPlayer(a1: InteractionsDetector, a2: InteractionsDetector):
	return player.global_position.distance_to(a1.global_position) < player.global_position.distance_to(a2.global_position)
