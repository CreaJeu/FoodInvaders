extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_MenuButton_pressed():
	var menu_screen = get_node("/root/GameScene/MenuScreen")
	var game_over_screen = get_node("/root/GameScene/GameOver")
	game_over_screen.hide()
	menu_screen.show()


func _on_TryAgainButton_pressed():
	var game_over_screen = get_node("/root/GameScene/GameOver")
	game_over_screen.hide()
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
