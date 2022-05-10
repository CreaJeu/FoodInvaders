extends Node2D

export var max_life = 100.0
var life = max_life
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_life(points):
	life += points
	if life < 0:
		life = 0
	if life > max_life:
		life = max_life
	
	$LifeBar/CurrentBar.scale.x = life / max_life
	if life == 0:
		game_over()

func change_score(points):
	score += points
	$ScoreLabel.text = "SCORE : %d" % score

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	var enemies_pool = get_node("/root/GameScene/EnemiesPool")
	var timer = get_node("/root/GameScene/Timer")
	timer.stop()
	for child in enemies_pool.get_children():
		enemies_pool.remove_child(child)
	var game_over_scene = get_node("/root/GameScene/GameOver")
	game_over_scene.get_node("ScoreLabel").text = "%d" % score
	game_over_scene.show()
	
	
