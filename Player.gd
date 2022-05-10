extends Node2D

export var speed = 400
var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input move
	if Input.is_action_pressed("ui_left"):
		dir.x = -speed*delta
		dir.y = 0
	elif Input.is_action_pressed("ui_right"):
		dir.x = speed*delta
		dir.y = 0
	elif Input.is_action_pressed("ui_up"):
		dir.x = 0
		dir.y = -speed*delta
	elif Input.is_action_pressed("ui_down"):
		dir.x = 0
		dir.y = speed*delta
	else:
		dir.x = 0
		dir.y = 0
	
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
		fire()
	
	if time_till_fire_end > 0:
		time_till_fire_end -= delta
		if time_till_fire_end <= 0:
			fire_stop()
	
	if time_till_end_lazer_bonus > 0:
		time_till_end_lazer_bonus -= delta
		if time_till_end_lazer_bonus <= 0:
			lazer_type = "simple"
	
	if time_till_shield_end > 0:
		time_till_shield_end -= delta
		if time_till_shield_end <= 0:
			has_shield = false
			
	if time_till_chef_hat_bonus_end > 0:
		time_till_chef_hat_bonus_end -= delta
		if time_till_chef_hat_bonus_end <= 0:
			has_chef_hat = false
	
		
func fire():
	time_till_fire_end = 0.25
	# Set fire type
	var fire_type = ""
	if lazer_type == "simple":
		fire_type = "firing"
	elif lazer_type == "super":
		fire_type = "firing_super"
	
	get_node("./PlayerArea2D/AnimatedSprite").play(fire_type)
	var lazer_scene_name = ""
	
	if lazer_type == "simple":
		lazer_scene_name = "SimpleLazer"
	elif lazer_type == "super":
		lazer_scene_name = "SuperLazer"
	
	var lazer = load(lazer_scene_name + ".tscn").instance()
	lazer.position.x = position.x
	lazer.position.y = position.y - 64
	get_node("/root/GameScene").add_child(lazer)

func fire_stop():
	get_node("./PlayerArea2D/AnimatedSprite").play("idle")


func change_lazer(new_lazer_type):
	lazer_type = new_lazer_type
	time_till_end_lazer_bonus = LAZER_BONUS_TIME

func grant_shield_bonus():
	has_shield = true
	time_till_shield_end = SHIELD_BONUS_TIME

func grant_chef_hat_bonus():
	has_chef_hat = true
	time_till_chef_hat_bonus_end = CHEF_HAT_BONUS_TIME	
	
	