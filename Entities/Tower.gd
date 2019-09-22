extends Node2D

onready var scene = load("res://Entities/Block.tscn")

func _ready():
	for x in range(30):
		for y in range(200):
			var child = scene.instance()
			child.init(x, y)
			self.add_child(child)