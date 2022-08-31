extends Node2D

export var malus = 30

var type_ = "obstacle"

export var SPEED = 100
var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)
var random_speed_factor = 1

func _physics_process(delta):	
	dir.x = 0
	dir.y = SPEED * random_speed_factor * delta

	position.x += dir.x
	position.y += dir.y

# Called when the node enters the scene tree for the first time.
func _ready():
	random_speed_factor = rand_range(1.0, 1.5)

func collision(area):
	var stats = get_node("/root/GameScene/Stats")
	var parent = area.get_parent()
	var player = get_node("/root/GameScene/Player")
	var floor_ = get_node("/root/GameScene/Floor")
	
	if parent == player:
		# Player with shield is protected against obstacles
		if not player.has_shield:
			get_node("/root/GameScene/Sounds/Obstacle").play()
			stats.change_life(-malus)
			queue_free()
		
	elif parent == floor_:
		queue_free()
	
	elif "type_" in parent:
		if parent.type_ in ["lame_lazer", "simple_lazer"]:
			parent.queue_free()
		elif parent.type_ == "super_lazer":
			get_node("/root/GameScene/Sounds/Explosion").play()
			queue_free()
