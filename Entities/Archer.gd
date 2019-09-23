extends RigidBody2D

onready var arrow = preload("res://Entities/Arrow.tscn")
var rng = RandomNumberGenerator.new()

var atk_threshold = 20
var atk_accum = 3

func _ready():
	rng.randomize()
	atk_threshold = 40 * rng.randf()
	
func _process(delta):
	if atk_accum >= atk_threshold:
		attack()
		atk_accum = 0
		atk_threshold = 25 * rng.randf_range(0.5, 1.0)
	else:
		atk_accum += delta

func attack():
	var target = get_node("/root/World/Player").get_global_position()
	target.x = target.x + rng.randi_range(-200, 200)
	target.y = target.y + rng.randi_range(-200, 300)
	var child = arrow.instance()
	self.add_child(child)
	child.apply_impulse(Vector2(0, 0), (target-self.get_global_position()).normalized() * 1200)

	get_node("AudioStreamPlayer2D").play(0)

func damage():
	pass