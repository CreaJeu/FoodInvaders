extends Node2D

export var SPEED = 100

export var points = 10
export var life_bonus = 2

var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)
var random_speed_factor = 1

var type_ = "friend"

func _ready():
	random_speed_factor = rand_range(1.0, 1.5)

func _physics_process(delta):	
	dir.x = 0
	dir.y = SPEED * random_speed_factor * delta

	position.x += dir.x
	position.y += dir.y

func collision(area):
	print("collision")
	var parent = area.get_parent()
	var player = get_node("/root/GameScene/Player")
	var floor_ = get_node("/root/GameScene/Floor")
	var stats = get_node("/root/GameScene/Stats")
	
	# eaten by player -> increase score & life
	if parent == player:
		print("Player ate good food")
		get_node("/root/GameScene/Sounds/GoodFood").play()
		stats.change_score(points)
		stats.change_life(life_bonus)
	
	# fallen -> descrease score
	elif parent == floor_:
		print("enemy fell down")
		stats.change_score(-3*points)
	
	# shot by lazer -> decrease score
	elif "type_" in parent and parent.type_ in ["lame_lazer", "simple_lazer", "super_lazer"]:
		get_node("/root/GameScene/Sounds/Explosion").play()
		stats.change_score(-points)
	
	# destroy element	
	if parent == player or parent == floor_ or (
		"type_" in parent and parent.type_ in ["lame_lazer", "simple_lazer", "super_lazer"]
	):
		queue_free()
