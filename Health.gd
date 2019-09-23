extends Node2D

onready var player = get_node("/root/World/Player")
var max_width = 1366

func _physics_process(delta):
	self.scale = Vector2(player.health / float(player.max_health), 1)