extends KinematicBody2D
	
var velocity = Vector2.ZERO
export var ACCEL = 600
export var MAX_SPEED = 500
export var FRICTION = 500
onready var softCol = $SoftCollision

func _physics_process(delta):
	move_state(delta)
	
func move_state(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("key_right") - Input.get_action_raw_strength("key_left")
	input_vector.y = Input.get_action_strength("key_down") - Input.get_action_raw_strength("key_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)

	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#if softCol.is_collidin():
	#	velocity+= softCol.get_push_vector() * delta * 400	
		
		
	velocity = move_and_slide(velocity)
