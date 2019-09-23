extends KinematicBody2D

enum Direction {
  right,
  left
}

const mov_speed = 1
const veloc_decay = 1
const veloc_decay_thresh = 0.30
const max_veloc_len = 9
const max_health = 450

var score = 0
var atk_cooldown = 0
var veloc_decay_accum = 0
var pos = Vector2(30, 30)
var veloc = Vector2(0, 0)
var direction = Direction.right
var flames_queued = 0
var flame_cooldown = 0
onready var flame = preload("res://Entities/Flame.tscn")
onready var arrow = preload("res://Entities/Arrow.tscn")
var rng = RandomNumberGenerator.new()
var health = max_health
var dead = false

onready var sprite = self.get_node("Sprite")
onready var area = self.get_node("Area2D")
onready var collider = self.get_node("CollisionPolygon2D")
onready var death_label = self.get_node("Camera2D/DeathLabel")
onready var score_label = self.get_node("Camera2D/Score")

func _ready():
	rng.randomize()

func _physics_process(delta):
	print(self.get_position())
	if !dead:
		handle_movement(delta)
		handle_input(delta)
		move_and_slide(veloc * 50)
		handle_flame_queue(delta)
	else:
		move_and_slide(Vector2(0, 550))
		death_label.visible_characters = -1
		if Input.is_action_pressed("reload_scene"):
			get_tree().reload_current_scene()

func handle_input(delta):
	if atk_cooldown > 0:
		atk_cooldown -= delta
	else:
		atk_cooldown = 0
		
	if Input.is_action_pressed("right"):
		veloc.x += mov_speed
		direction = Direction.right
		sprite.set_flip_h(true)
		area.scale = Vector2(-1, 1)
		collider.scale = Vector2(-1, 1)
	if Input.is_action_pressed("left"):
		veloc.x -= mov_speed
		direction = Direction.left
		sprite.set_flip_h(false)
		area.scale = Vector2(1, 1)
		collider.scale = Vector2(1, 1)
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
	
func manage_health(amt):
	if (health + amt) <= max_health:
		health += amt
	else:
		health = max_health
	
	if health <= 0:
		dead = true
		sprite.frame = 1

func update_score(score):
	self.score += score
	self.score_label.text = "Score: " + str(self.score)
	
func _on_Area2D_body_entered(body):
	if body.get_filename() == arrow.get_path():
		if body.damaging:
			manage_health(-1)
			body.disable_damage()
