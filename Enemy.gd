extends Node2D

export var SPEED = 100

var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)
var points = 5
var life_malus = 5
var random_speed_factor = 1

var type_ = "enemy"

func _ready():
	random_speed_factor = rand_range(1.0, 1.5)

func _physics_process(delta):	
	dir.x = 0
	dir.y = SPEED*random_speed_factor*delta

	position.x += dir.x
	position.y += dir.y

func collision(area):
	print("collision")
	var parent = area.get_parent()
	
	var player = get_node("/root/GameScene/Player")
	var floor_ = get_node("/root/GameScene/Floor")
	var stats = get_node("/root/GameScene/Stats")
	
	# eaten by player -> lose life & score
	if parent == player:
		# Player with chef hat bonus is resistant
		if not player.has_chef_hat:
			print("Player ate junk food")
			stats.change_life(-life_malus)
			stats.change_score(-points)
			queue_free()
	
	# fallen 
	elif parent == floor_:
		print("enemy fell down")
		# Player with chef hat bonus is resistant
		if not player.has_chef_hat:
			stats.change_score(-points)		
		queue_free()
	
	# hit by lazer
	elif "type_" in parent and parent.type_ in ["simple_lazer", "super_lazer"]:
		stats.change_score(points)
		queue_free()
	
