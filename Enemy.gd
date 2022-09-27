extends Node2D

export var SPEED = 150

var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)
var points = 10
var life_malus = 5
var random_speed_x_factor = 1
var random_speed_y_factor = 1

var type_ = "enemy"

func _ready():
	random_speed_x_factor = rand_range(-0.4, 0.4)
	random_speed_y_factor = rand_range(1, 2)

func _physics_process(delta):	
	if position.x < 32 or position.x > 992:
		random_speed_x_factor *= -1
	
	# Free enemy	
	dir.x = SPEED*random_speed_x_factor*delta
	dir.y = SPEED*random_speed_y_factor*delta

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
			get_node("/root/GameScene/Sounds/BadFood").play()
			print("Player ate junk food")
			
			show_tween_label()
			
			stats.change_life(-life_malus)
			stats.change_score(-points)
			#queue_free()
	
	# fallen 
	elif parent == floor_:
		print("enemy fell down")
		# Player with chef hat bonus is resistant
		if not player.has_chef_hat:
			stats.change_score(-points)		
		queue_free()
	
	# hit by lazer
	elif "type_" in parent and parent.type_ in ["lame_lazer", "simple_lazer", "super_lazer"]:
		print("points enemy ", points)
		get_node("/root/GameScene/Sounds/Explosion").play()
		stats.change_score(points)
		queue_free()

func show_tween_label():
	var tween = $Tween
	$Sprite.visible = false
	$TweenLabel.text = "- %d" % points
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
