extends Node2D

var type_ = "bonus"

export var SPEED = 150
export var life_cost = 7
var dir = Vector2()
var random_speed_x_factor = 1
var random_speed_y_factor = 1


func _ready():
	random_speed_x_factor = rand_range(-0.4, 0.4)
	random_speed_y_factor = rand_range(1, 2)

	$AnimatedSprite.play("default")

func _physics_process(delta):	
	if position.x < 32 or position.x > 992:
		random_speed_x_factor *= -1

	dir.x = SPEED * random_speed_x_factor * delta
	dir.y = SPEED * random_speed_y_factor * delta

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
		player.grant_shield_bonus()
		queue_free()
	elif "type_" in parent and parent.type_ in ["simple_lazer", "super_lazer"]:
		get_node("/root/GameScene/Sounds/Explosion").play()
		queue_free()
