extends KinematicBody2D

const mov_speed = 1
const veloc_decay = 1
const veloc_decay_thresh = 0.10
const max_veloc_len = 9

var veloc_decay_accum = 0
var pos = Vector2(30, 30)
var veloc = Vector2(0, 0)
	
func _physics_process(delta):
	veloc_decay_accum += delta
	veloc = veloc.clamped(max_veloc_len).ceil()
	
	pos.x += veloc.x
	pos.y += veloc.y

	if veloc_decay_accum >= veloc_decay_thresh:
		veloc_decay_accum = 0
		
		if veloc.x < 0:
			veloc.x += veloc_decay
		elif veloc.x > 0:
			veloc.x -= veloc_decay
		
		if veloc.y < 0:
			veloc.y += veloc_decay
		elif veloc.y > 0:
			veloc.y -= veloc_decay
	
	if Input.is_action_pressed("right"):
		veloc.x += mov_speed
	if Input.is_action_pressed("left"):
		veloc.x -= mov_speed
	if Input.is_action_pressed("up"):
		veloc.y -= mov_speed
	if Input.is_action_pressed("down"):
		veloc.y += mov_speed
	
	move_and_collide(veloc)
	update()