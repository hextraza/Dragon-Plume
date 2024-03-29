extends Node2D

const tower_height = 200

onready var block = load("res://Entities/Block.tscn")
onready var arch = load("res://Entities/Arch.tscn")

onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	for x in range(30):
		for y in range(tower_height):
			var child
			if (y % rng.randi_range(2, 10) == 0 && x % (tower_height / (y + 1)) == 0 && y != 0 && x != 0 && x != 29):
				child = arch.instance()
			else:
				child = block.instance()
				
			child.init(x, y, y*10)
			self.add_child(child)