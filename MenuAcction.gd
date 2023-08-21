extends Control


onready var world = get_tree().current_scene


func _physics_process(_delta):
	#print(world.selected_character)
	if world.indexSelected > 0 and world.sel_charac[world.indexSelected].selection.selected:
		visible = true
	else:
		visible = false

