extends Node2D

export var SPEED = 150

export var points = 10
export var life_bonus = 2

var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)
var random_speed_x_factor = 1
var random_speed_y_factor = 1

var type_ = "friend"

func _ready():
	var random_dir = [-1, 1][randi() % 2]
	random_speed_x_factor = rand_range(0.1, 0.8) * random_dir 
	random_speed_y_factor = rand_range(1, 2)
	
	points *= random_speed_y_factor
	points = int(points)

func _physics_process(delta):	
	if position.x < 32 or position.x > 992:
		random_speed_x_factor *= -1
	
	dir.x = SPEED * random_speed_x_factor * delta
	dir.y = SPEED * random_speed_y_factor * delta

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
		
		show_tween_label()
		
		stats.change_score(points)
		stats.change_life(life_bonus)
	
	# fallen -> descrease score
	elif parent == floor_:
		print("enemy fell down")
		stats.change_score(-3*points)
		show_tween_label("lose")
	
	# shot by lazer -> decrease score
	elif "type_" in parent and parent.type_ in ["lame_lazer", "simple_lazer", "super_lazer"]:
		get_node("/root/GameScene/Sounds/Explosion").play()
		stats.change_score(-points)
	
	# destroy element	
	if (
		"type_" in parent and parent.type_ in ["lame_lazer", "simple_lazer", "super_lazer"]
	):
		queue_free()


func show_tween_label(type_points="win"):
	var player = get_node("/root/GameScene/Player")
	var computed_points = points
	if player.has_michelin_star:
		print("points avant michelin : %d" % points)
		computed_points *= 2
		
	var tween = $Tween
	$Sprite.visible = false
	if type_points == "win":
		$TweenLabel.text = "+ %d" % computed_points
	else:
		$TweenLabel.text = "- %d" % abs(computed_points)
		$TweenLabel.set("custom_colors/font_color", Color(1,0,0))
		get_node("/root/GameScene/Sounds/BadFood").play()
		
	$TweenLabel.visible = true
	tween.stop_all()
	tween.interpolate_property(
		$TweenLabel,
		"rect_position:y",
		$TweenLabel.rect_position.y,
		$TweenLabel.rect_position.y - 64,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()


func tween_label_over(object, key):
	$TweenLabel.visible = false
	$TweenLabel.rect_position = Vector2(
		position.x - 23,
		position.y - 60
	)
	queue_free()
