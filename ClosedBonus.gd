extends Node2D

export var life_cost = 30
var dir = Vector2()
var random_speed_x_factor = 1
var random_speed_y_factor = 1

var type_ = "bonus"

func _ready():
	random_speed_x_factor = rand_range(-0.4, 0.4)
	random_speed_y_factor = rand_range(1, 2)

func _physics_process(delta):	
	if position.x < 32 or position.x > 992:
		random_speed_x_factor *= -1

	dir.x = Globals.game_speed * random_speed_x_factor * delta
	dir.y = Globals.game_speed * random_speed_y_factor * delta

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
		get_node("/root/GameScene/Sounds/Explosion").play()
		player.hurt()
		var enemies_pool = get_node("/root/GameScene/EnemiesPool")
		if enemies_pool != null:
			for enemy in enemies_pool.get_children():
				enemy.queue_free()
		
	elif "type_" in parent and parent.type_ in ["simple_lazer", "super_lazer"]:
		get_node("/root/GameScene/Sounds/Explosion").play()
		queue_free()
		
