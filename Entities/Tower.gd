extends Node2D

const tower_height = 200

onready var block = load("res://Entities/Block.tscn")
onready var arch = load("res://Entities/Arch.tscn")



func _ready():	
	for x in range(30):
		for y in range(tower_height):
			var child
			if (y % 3 == 0 && x % (tower_height / (y + 1)) == 0 && y != 0 && x != 0 && x != 29):
				child = arch.instance()
			else:
				child = block.instance()
				
			child.init(x, y, y*10)
			self.add_child(child)