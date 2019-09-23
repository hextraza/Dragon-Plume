extends Control

onready var player = get_node("/root/World/Player")
var max_width = 1366

func _physics_process(delta):
	self.set_size(Vector2((player.health / player.max_health) * max_width, 0))