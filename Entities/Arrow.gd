extends RigidBody2D

var lifetime = 0
var max_lifetime = 10
onready var prev_direc = self.get_global_position()
onready var player = get_node("/root/World/Player")
var damaging = true
	
func _physics_process(delta):
	self.get_node("Sprite").rotation = (self.get_global_position() - prev_direc).angle()
	prev_direc = self.get_global_position()
	
	lifetime += delta
	if lifetime >= max_lifetime:
		get_parent().remove_child(self)
		
func disable_damage():
	damaging = false