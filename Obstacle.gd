extends Node2D

export var malus = 30

var type_ = "obstacle"

export var SPEED = 100
var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)
var random_speed_x_factor = 1
var random_speed_y_factor = 1


var will_queue_free = false
var time_till_free = 1

func _physics_process(delta):	
	if will_queue_free:
		if time_till_free <= 0:
			queue_free()
		else:
			time_till_free -= delta
	
	if position.x < 32 or position.x > 992:
		random_speed_x_factor *= -1

	dir.x = SPEED * random_speed_x_factor * delta
	dir.y = SPEED * random_speed_y_factor * delta

	position.x += dir.x
	position.y += dir.y

# Called when the node enters the scene tree for the first time.
func _ready():
	random_speed_x_factor = rand_range(-0.4, 0.4)
	random_speed_y_factor = rand_range(1, 2)


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
			explode()
			#queue_free()
		
	elif parent == floor_:
		queue_free()
	
	elif "type_" in parent:
		if parent.type_ in ["lame_lazer", "simple_lazer"]:
			parent.queue_free()
		elif parent.type_ == "super_lazer":
			get_node("/root/GameScene/Sounds/Explosion").play()
			queue_free()

func explode():
	$Sprite.visible = false
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("explosion")
	will_queue_free = true
