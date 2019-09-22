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
			self.mode = RigidBody2D.MODE_RIGID
			self.gravity_scale = 2.5
			self.mass = 10
			self.set_collision_mask_bit(2, true)
			var player_pos = get_node("/root/World/Player").get_position()
			var player_dir = 1
			if player_pos.x < self.get_position().x:
				player_dir = -1
				
			print(self.get_global_position().x)
			print(player_pos.x)
			print("\n")
			
			self.apply_impulse(Vector2(0,0), Vector2(player_dir*400, rng.randi_range(-400, 400)))
			health = -1