extends KinematicBody2D

enum Direction {
  right,
  left
}

const mov_speed = 1
const veloc_decay = 1
const veloc_decay_thresh = 0.10
const max_veloc_len = 9

var atk_cooldown = 0
var veloc_decay_accum = 0
var pos = Vector2(30, 30)
var veloc = Vector2(0, 0)
var direction = Direction.right
var flames_queued = 0
var flame_cooldown = 0
onready var flame = preload("res://Entities/Flame.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _physics_process(delta):
	handle_movement(delta)
	handle_input(delta)
	handle_flame_queue(delta)
	move_and_collide(veloc)
	update()

func handle_input(delta):
	if atk_cooldown > 0:
		atk_cooldown -= delta
	else:
		atk_cooldown = 0
		
	if Input.is_action_pressed("right"):
		veloc.x += mov_speed
		direction = Direction.right
	if Input.is_action_pressed("left"):
		veloc.x -= mov_speed
		direction = Direction.left
	if Input.is_action_pressed("up"):
		veloc.y -= mov_speed
	if Input.is_action_pressed("down"):
		veloc.y += mov_speed
	if Input.is_action_pressed("attack") and atk_cooldown <= 0:
		flames_queued = 25
		atk_cooldown = 2

func handle_movement(delta):
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

func handle_flame_queue(delta):
	if flame_cooldown <= 0 and flames_queued > 0:
		var dir_scalar = 1
		if direction == Direction.left:
			dir_scalar = -1
		gen_flame(dir_scalar)
		flames_queued -= 1
		flame_cooldown = 0.03
		
	if flame_cooldown >= 0:
		flame_cooldown -= delta
	else:
		flame_cooldown = 0

func gen_flame(dir_scalar):
	var child = flame.instance()
	self.add_child(child)
	child.apply_impulse(Vector2(0,0), Vector2(dir_scalar * 800, rng.randi_range(-100, 200) - 400))
	child.add_torque(rng.randf_range(-120000.0, 120000.0))