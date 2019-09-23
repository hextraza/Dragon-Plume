extends RigidBody2D

var health = 7
var dmg_cooldown = 0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(delta):
	if dmg_cooldown >= 0:
		dmg_cooldown -= delta
	else:
		dmg_cooldown = 0

func init(x, y):
	self.position = Vector2(x*32, y*32)
	
func damage():
	if dmg_cooldown <= 0:
		health -= 1
		dmg_cooldown = 0.9
		
		get_node("Sprite").modulate = Color(health/7.0, health/7.0, health/7.0)
		
		if health == 0:
			get_node("/root/World/Player").manage_health(500)
			die_and_fly(self)
			
			var archer = self.get_node("Archer")
			if archer != null:
				die_and_fly(archer)
			health = -1
			
func die_and_fly(obj):
	obj.mode = RigidBody2D.MODE_RIGID
	obj.gravity_scale = 2.5
	obj.mass = 10
	obj.set_collision_mask_bit(2, true)
	var player_pos = get_node("/root/World/Player").get_position()
	var player_dir = 1
			
	if player_pos.x < obj.get_position().x:
		player_dir = -1
			
	obj.apply_impulse(Vector2(0,0), Vector2(player_dir*400, rng.randi_range(-400, 400)))