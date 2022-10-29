extends Node2D

export var max_life = 100.0
var life = max_life
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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

func change_life(points):
	var player = get_node("/root/GameScene/Player")
	if points < 0 and player.has_michelin_star:
		player.remove_michelin_bonus()
	life += points
	if life < 0:
		life = 0
	if life > max_life:
		life = max_life
	
	$LifeBar/CurrentBar.scale.x = life / max_life
	if life == 0:
		game_over()

func change_score(points):
	var player = get_node("/root/GameScene/Player")
	if points > 0 and player.has_michelin_star:
		points *= 2
	if points < 0 and player.has_michelin_star:
		player.remove_michelin_bonus()
	print("change score: ", points)
	score += points
	$ScoreLabel.text = "SCORE : %d" % score


func game_over():
	Globals.score = score
	Globals.add_highscore("TOTO", score)
	get_tree().change_scene("res://GameOver.tscn")
