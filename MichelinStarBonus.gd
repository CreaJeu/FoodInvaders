extends Node2D

var type_ = "bonus"

export var SPEED = 100
var dir = Vector2()
var random_speed_factor = 1

func _ready():
	random_speed_factor = rand_range(1.0, 1.5)

func _physics_process(delta):	
	dir.x = 0
	dir.y = SPEED*random_speed_factor*delta

	position.x += dir.x
	position.y += dir.y
	
func collision(area):
	var player = get_node("/root/GameScene/Player")
	var floor_ = get_node("/root/GameScene/Floor")
	var parent = area.get_parent()
	
	if parent == floor_:
		queue_free()
	elif parent == player:
		get_node("/root/GameScene/Sounds/Bonus").play()
		player.grant_michelin_bonus()
		queue_free()
	elif "type_" in parent and parent.type_ in ["simple_lazer", "super_lazer"]:
		get_node("/root/GameScene/Sounds/Explosion").play()
		queue_free()
