extends Node2D

var focus_button = "menu_button"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameOver/ScoreLabel").text = "%d" % Globals.score
	$MenuButton.set("custom_colors/font_color", Color(0, 1, 0))
	
	var highscores = Globals.get_highscores()
	for index in range(len(highscores)):
		var username = highscores[index]["username"]
		var score = highscores[index]["score"]
		get_node("/root/GameOver/Highscores/Score%d" % (index+1)).text = username + " : %d" % score
	for index in range(len(highscores), 10):
		get_node("/root/GameOver/Highscores/Score%d" % (index+1)).text = ""
	
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		_process_button()
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		_change_button()

func _process_button():
	if focus_button == "menu_button":
		yield(get_tree().create_timer(0.25), "timeout")
		_on_MenuButton_pressed()
	else:
		_on_TryAgainButton_pressed()

func _change_button():
	# Focus try again button
	if focus_button == "menu_button" and Input.is_action_pressed("ui_right"):
		focus_button = "try_again"
		$MenuButton.set("custom_colors/font_color", Color(1, 1, 1))
		$TryAgainButton.set("custom_colors/font_color", Color(0, 1, 0))
	# Focus menu button
	elif Input.is_action_pressed("ui_left"):
		focus_button = "menu_button"
		$MenuButton.set("custom_colors/font_color", Color(0, 1, 0))
		$TryAgainButton.set("custom_colors/font_color", Color(1, 1, 1))
	


func _on_MenuButton_pressed():
	get_tree().change_scene("res://MenuScreen.tscn")

func _on_TryAgainButton_pressed():
	get_tree().change_scene("res://SpaceInvadersLike.tscn")
