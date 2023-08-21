extends Area2D

signal selection_toggle(selection)


export var exclusive = true
export var selection_accion = "left_mouse"

var selected = false setget set_selected


func set_selected(selection):
	if selection:
		_make_exclusive()
		add_to_group("selected")
	else:
		remove_from_group("selected")
	
	selected = selection
	emit_signal("selection_toggle", selected)

func _make_exclusive():
	if not exclusive:
		return
	get_tree().call_group("selected", "set_selected", false)


func _input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed(selection_accion):
		set_selected(not selected)
