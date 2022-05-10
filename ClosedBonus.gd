extends Node2D

export var SPEED = 100
export var life_cost = 7
var dir = Vector2()
var random_speed_factor = 1

var type_ = "bonus"

func _ready():
	random_speed_factor = rand_range(1.0, 1.5)

func _physics_process(delta):	
	dir.x = 0
	dir.y = SPEED*random_speed_factor*delta

	position.x += dir.x
	position.y += dir.y

func collision(area):
	var parent = area.get_parent()
	var player = get_node("/root/GameScene/Player")
	var floor_ = get_node("/root/GameScene/Floor")
	var stats = get_node("/root/GameScene/Stats")

	if parent == floor_:
		queue_free()
	elif parent == player:
		# TODO: set bonus to player
		stats.change_life(-life_cost)
		var enemies_pool = get_node("/root/GameScene/EnemiesPool").get_children()
		for enemy in enemies_pool:
			enemy.queue_free()
		
	elif "type_" in parent and parent.type_ in ["simple_lazer", "super_lazer"]:
		queue_free()
		
