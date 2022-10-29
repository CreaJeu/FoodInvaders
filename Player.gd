extends Node2D

export var speed = 600
var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)

export var BONUS_ZOOM = 0.95

var HURT_TIME = 0.2
var time_till_end_hurt = 0

var LAZER_BONUS_TIME = 10
var time_till_end_lazer_bonus = 0

var SHIELD_BONUS_TIME = 10
var time_till_shield_end = 0

var CHEF_HAT_BONUS_TIME = 10
var time_till_chef_hat_bonus_end = 0

# lazer_type in ["simple", "super"]
var lazer_type = "simple"

var time_till_fire_end = 0

var has_shield = false
var has_chef_hat = false
var has_michelin_star = false

var final_bonus_position = {
	"ShieldBonus": null,
	"KnifeBonus": null,
	"ChefHatBonus": null,
	"SpoonBonus": null,
	"MichelinStarBonus": null,
}

var zoom_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in final_bonus_position:
		final_bonus_position[key] = get_node("/root/GameScene/Bonus/" + key).position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir.x = 0
	dir.y = 0
	
	# Input move
	if Input.is_action_pressed("ui_left"):
		dir.x = -speed*delta
	if Input.is_action_pressed("ui_right"):
		dir.x = speed*delta
	if Input.is_action_pressed("ui_up"):
		dir.y = -speed*delta
	if Input.is_action_pressed("ui_down"):
		dir.y = speed*delta
		
	if Input.is_action_just_pressed("custom_pause"):
		var time_scale = Engine.time_scale
		var pause_screen = get_node("/root/GameScene/PauseScreen")
		if time_scale > 0:
			Engine.time_scale = 0
			pause_screen.show()
		else:
			Engine.time_scale = 1
			pause_screen.hide()
	elif Input.is_action_pressed("ui_home"):
		get_tree().change_scene("res://MenuScreen.tscn")
	
	# improve speed +50% when michelin star
	if has_michelin_star:
		dir *= 1.5
	
	position.x += dir.x
	position.y += dir.y
	
	var player_dimensions = $PlayerArea2D/CollisionShape2D.shape.extents
	
	if position.x - player_dimensions.x < 0:
		position.x = player_dimensions.x;
	if position.x + player_dimensions.x > get_viewport().size.x:
		position.x = get_viewport().size.x - player_dimensions.x
	if position.y - player_dimensions.y < 0:
		position.y = player_dimensions.y
	if position.y + player_dimensions.y > get_viewport().size.y:
		position.y = get_viewport().size.y - player_dimensions.y
	
	# Input laser
	if Input.is_action_just_pressed("custom_fire"):
		get_node("/root/GameScene/Sounds/LazerShoot").play()
		fire()
	
	if time_till_end_hurt > 0:
		time_till_end_hurt -= delta
		if time_till_end_hurt <= 0:
			$PlayerArea2D/AnimatedSprite.play("idle")
	
	if time_till_fire_end > 0:
		time_till_fire_end -= delta
		if time_till_fire_end <= 0:
			fire_stop()
	
	if time_till_end_lazer_bonus > 0:
		time_till_end_lazer_bonus -= delta
		if time_till_end_lazer_bonus <= 0:
			lazer_type = "simple"
			get_node("/root/GameScene/Bonus/KnifeBonus").hide()
			get_node("/root/GameScene/Bonus/SpoonBonus").hide()
	
	if time_till_shield_end > 0:
		time_till_shield_end -= delta
		if time_till_shield_end <= 0:
			has_shield = false
			get_node("/root/GameScene/Bonus/ShieldBonus").hide()
			$PlayerArea2D/Shield.visible = false
			
	if time_till_chef_hat_bonus_end > 0:
		time_till_chef_hat_bonus_end -= delta
		if time_till_chef_hat_bonus_end <= 0:
			has_chef_hat = false
			get_node("/root/GameScene/Bonus/ChefHatBonus").hide()
		
func fire():
	time_till_fire_end = 0.25
	# Set fire type
	var fire_type = ""
	if lazer_type in ["simple", "lame"]:
		fire_type = "firing"
	elif lazer_type == "super":
		fire_type = "firing_super"
	
	get_node("./PlayerArea2D/AnimatedSprite").play(fire_type)
	var lazer_scene_name = ""
	
	if lazer_type in ["simple", "lame"]:
		lazer_scene_name = "SimpleLazer"
	elif lazer_type == "super":
		lazer_scene_name = "SuperLazer"
	
	var lazer = load(lazer_scene_name + ".tscn").instance()
	if lazer_type == "lame":
		lazer.SPEED = 150
		lazer.type_ = "lame_lazer"
	lazer.position.x = position.x
	lazer.position.y = position.y - 64
	get_node("/root/GameScene").add_child(lazer)

func fire_stop():
	get_node("./PlayerArea2D/AnimatedSprite").play("idle")


func change_lazer(new_lazer_type):
	lazer_type = new_lazer_type
	time_till_end_lazer_bonus = LAZER_BONUS_TIME
	get_node("/root/GameScene/Bonus/SpoonBonus").hide()
	_tween_bonus("KnifeBonus")

func set_lame_lazer():
	lazer_type = "lame"
	time_till_end_lazer_bonus = LAZER_BONUS_TIME
	get_node("/root/GameScene/Bonus/KnifeBonus").hide()
	_tween_bonus("SpoonBonus")

func grant_shield_bonus():
	has_shield = true
	time_till_shield_end = SHIELD_BONUS_TIME
	_tween_bonus("ShieldBonus")
	$PlayerArea2D/Shield.visible = true

func grant_chef_hat_bonus():
	has_chef_hat = true
	time_till_chef_hat_bonus_end = CHEF_HAT_BONUS_TIME	
	_tween_bonus("ChefHatBonus")
	
func grant_michelin_bonus():
	has_michelin_star = true
	_tween_bonus("MichelinStarBonus")

func remove_michelin_bonus():
	has_michelin_star = false
	get_node("/root/GameScene/Bonus/MichelinStarBonus").hide()


func _tween_bonus(bonus_name):
	var bonus = get_node("/root/GameScene/Bonus/" + bonus_name)
	var tween_position = get_node("/root/GameScene/TweenPosition")
	
	bonus.position = get_node("/root/GameScene/Player").position
	bonus.show()
	
	#get_node("/root/GameScene/Camera2D").set_zoom(Vector2(0.5, 0.5))
	tween_position.interpolate_property(
		bonus, 
		"position", 
		bonus.position, 
		final_bonus_position[bonus_name], 
		1,
		Tween.TRANS_QUART,
		Tween.EASE_IN_OUT
	)
	
	tween_position.start()
	
	var camera2D = get_node("/root/GameScene/Camera2D")
	
	var player_position = get_node("/root/GameScene/Player").position
	
	var final_position = (player_position - OS.window_size * 0.5) * 0.3
	
func hurt():
	time_till_end_hurt = HURT_TIME
	$PlayerArea2D/AnimatedSprite.play("hurt")
