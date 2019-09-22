extends RigidBody2D

var lifetime = 0
var max_lifetime = 2

func _physics_process(delta):
	lifetime += delta
	if lifetime >= max_lifetime:
		get_parent().remove_child(self)
		
	var colliding_blocks = self.get_colliding_bodies()
	for elem in colliding_blocks:
		elem.damage()