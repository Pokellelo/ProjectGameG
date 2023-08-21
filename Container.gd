extends Panel


onready var world = get_tree().current_scene
onready var Sprites = [$Sprite, $Sprite2, $Sprite3, $Sprite4, $Sprite5]
func _physics_process(_delta):
	if world.indexSelected > 0 and world.sel_charac[world.indexSelected].selection.selected == true:
		for i in range(world.sel_charac[world.indexSelected].max_stackSkills):
			
			if world.sel_charac[world.indexSelected].actionsArray.size() > i:
				Sprites[i].texture = world.sel_charac[world.indexSelected].actionsArray[i].icon	
				Sprites[i].visible = true
			else:
				Sprites[i].visible = false
			
		

