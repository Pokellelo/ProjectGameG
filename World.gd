extends Node

export(float) var height_world_limit = 10 * 32

export (float) var width_world_limit = 10 * 32

#Generar biomas por regiones exparcidas por el mapa minimo existir uno por cada mapa generado

onready var tileLoad = $WorldNavigation/TileMap
enum TILES {DIRT, GRASS, WATER, GRASS2}
 #Los tiles son cuadrados
export(int) var generation_height
export(int) var generation_width
var number_rnd = RandomNumberGenerator.new()

const neightboorhood = [Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 0),
						Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1), Vector2(-1, 1)]


onready var nav = $WorldNavigation
onready var line = $YSort2/Line2D

var indexSelected = 0
onready var sel_charac = [null, $YSort2/YSort/Genebaz, $YSort2/YSort/Genebaz2, $YSort2/YSort/Genebaz3]
func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return

	if indexSelected > 0 and sel_charac[indexSelected].selection.selected == true:
		var new_path = nav.get_simple_path(sel_charac[indexSelected].global_position, get_viewport().canvas_transform.affine_inverse().xform(event.position))
		line.points = new_path
		sel_charac[indexSelected].path = new_path


# Called when the node enters the scene tree for the first time.
func _ready():
	
	number_rnd.randomize()
	for x in range(generation_width):
		for y in generation_height:
			#print( TILES.values() ) 
			tileLoad.set_cell(x, y, number_rnd.randi_range(0, TILES.size() -1 ) )
			#print(checkCell(x, y))
	
	tileLoad.update_bitmask_region(Vector2.ZERO, Vector2(height_world_limit, width_world_limit) )
	#El tile load solo debe correrse al final de la creación del mundo
	generateMapInput("ui_left", 1, 4)
	generateMapInput("ui_left", 1, 4)
	generateMapInput("ui_left", 1, 4)
	generateMapInput("ui_left", 1, 4)
	
func _physics_process(_delta):
	
	if Input.is_action_just_pressed("key_q"):
		rotateSelectedCharacter(true)
		
	if Input.is_action_just_pressed("key_e"):
		rotateSelectedCharacter(false)
		
	for i in range(3):
		if sel_charac[i+1].selection.selected == true:
			indexSelected = i+1
#
	#generación
		
	#generateMapInput("ui_right", 2, 2) #Mar   1.-
	#generateMapInput("ui_left", 1, 4) #Tierra 2.-
	#generateMapInput("ui_up", 0, 3) #Dirt  4.-
	
	#if Input.is_action_just_pressed("number_left"):
	
#	if Input.is_action_just_pressed("ui_down"):  #3.--
#		for x in range(generation_width):
#			for y in generation_height:
#
#				if (tileLoad.get_cell(x,y) == 1 ):
#					#number_rnd.randi_range(0, 5)
#					var prob_wall = [1, 1, 1, 1, 0]
#					tileLoad.set_cell(x, y, prob_wall[number_rnd.randi_range(0, 4)])

func generateMapInput(_input_name, default, adiacentes):
	#if Input.is_action_just_pressed(input_name):
		for x in range(generation_width):
			for y in generation_height:
				checkCell(x,y, default, adiacentes)
				#print(tileLoad.get_cell(x,y))
		tileLoad.update_bitmask_region(Vector2.ZERO, Vector2(height_world_limit, width_world_limit) )
		#El tile load solo debe correrse al final de la creación del mundo


func checkCell(x,y, default, adiacentes):
	var countNei = 0
	for neigh in neightboorhood:
		if x + neigh.x < 0 || y + neigh.y < 0:
			countNei += 1
			
		if tileLoad.get_cell(x + neigh.x, y + neigh.y) == tileLoad.get_cell(x,y):
			countNei += 1
	
	if countNei < adiacentes : 
		tileLoad.set_cell(x, y, default)

func rotateSelectedCharacter(direction):
	#true = right  0 = false
	var previousIndex = indexSelected
	if direction:
		if indexSelected == 3:
			indexSelected = 0
		else:
			indexSelected += 1
	else:
		if indexSelected == 0:
			indexSelected = 3
		else:
			indexSelected -= 1
			
	if indexSelected > 0:
		sel_charac[indexSelected].selection.selected = true
	else:
		sel_charac[previousIndex].selection.selected = false
	return
