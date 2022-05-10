extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
	var menu_screen = get_node("/root/GameScene/MenuScreen")
	menu_screen.hide()
	var timer = get_node("/root/GameScene/Timer")
	var player = get_node("/root/GameScene/Player")
	var stats = get_node("/root/GameScene/Stats")
	player.position.x = 480
	player.position.y = 544
	stats.life = stats.max_life
	stats.get_node("LifeBar/CurrentBar").scale.x = 1
	stats.score = 0
	stats.get_node("ScoreLabel").text = "SCORE : 0"
	timer.start()
