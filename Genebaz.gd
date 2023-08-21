extends KinematicBody2D

onready var label = $Label
onready var selection = $SelectionArea
var velocity = Vector2.ZERO
export var ACCEL = 400
export var MAX_SPEED = 250.0
export var FRICTION = 40
export var genebaz_pos = 1
onready var softCol = $SoftCollision
onready var selectedPath = true
var path = PoolVector2Array() setget set_path
onready var spriteAnim = $AnimatedSprite
var selected = false
var selectedTarget = null setget set_action
onready var actionsArray = []
onready var skills = $Info
var max_stackSkills = 5
onready var timer = $Timer
func set_path(value):
	path = value
	if value.size() == 0:
		return
	selectedPath = true
	
	
func set_action(value):
	path = value
	if value.size() == 0:
		return
	selectedPath = true
	
func move_along_path(distance):
	var start_point = position
	
	if path.size() > 0 and selected:
		
		move_and_slide(path[path.size() - 1] - global_position)
	
func _physics_process(delta):
	
	if selection.selected and Input.is_action_just_pressed("number_down"):
		_on_Button_pressed()
	if selection.selected and Input.is_action_just_pressed("number_up"):
		_on_Button2_pressed()
	
	if actionsArray.size() == 0:
		spriteAnim.play("Anim")
		if selection.selected and selectedPath:
			var move_distance = MAX_SPEED * delta
			move_along_path(move_distance)
			
			#move_state(delta)

		else:
			recallToPlayer(delta)

			if global_position.distance_to(get_parent().get_parent().get_children()[0].global_position + Vector2(-40 * genebaz_pos, 12)) <= 500:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				
		if softCol.is_collidin():
			velocity+= softCol.get_push_vector() * delta * 400	
			
		velocity = move_and_slide(velocity)
	else:
		if timer.time_left <= 0:
			spriteAnim.play(actionsArray[0].type)

func recallToPlayer(delta):
	var pos = get_parent().get_parent().get_children()[0].global_position + Vector2(-40 * genebaz_pos, 100)
	velocity = velocity.move_toward(pos, 200 * delta)
	velocity = velocity.move_toward(global_position.direction_to(pos) * MAX_SPEED, ACCEL * delta)

func move_state(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("number_right") - Input.get_action_raw_strength("number_left")
	input_vector.y = Input.get_action_strength("number_down") - Input.get_action_raw_strength("number_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)



func _on_SelectionArea_selection_toggle(selectionArea):
	label.visible = selectionArea
	selected = selectionArea
	if selectionArea == false:
		path = PoolVector2Array()


func _on_Button_pressed():
	if selection.selected and actionsArray.size() < max_stackSkills:
		actionsArray.append(skills.skills[0])

func _on_Button2_pressed():
	if selection.selected and actionsArray.size() < max_stackSkills:
		actionsArray.append(skills.skills[1])

func _on_AnimatedSprite_animation_finished():
	if spriteAnim.animation != 'Anim':
		if spriteAnim.animation != 'Wait':
			timer.start(actionsArray[0].cooldown)
		spriteAnim.play("Wait")
	
func _on_Timer_timeout():
	timer.stop()
	actionsArray.remove(0)
