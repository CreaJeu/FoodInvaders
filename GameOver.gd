extends Node2D

var nb_highscores = 5
var focus_button = "menu_button"

var buttons_matrix = {
	"menu_button": {"ui_left": "menu_button", "ui_right": "try_again_button"},
	"try_again_button": {"ui_left": "menu_button", "ui_right": "raz_highscores_button"},
	"raz_highscores_button": {"ui_left": "try_again_button", "ui_right": "raz_highscores_button"}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameOver/ScoreLabel").text = "%d" % Globals.score
	$MenuButton.set("custom_colors/font_color", Color(0, 1, 0))
	
	var highscores = Globals.get_highscores()
	for index in range(len(highscores)):
		var username = highscores[index]["username"]
		var score = highscores[index]["score"]
		get_node("/root/GameOver/Highscores/Score%d" % (index+1)).text = username + " : %d" % score
	for index in range(len(highscores), nb_highscores):
		get_node("/root/GameOver/Highscores/Score%d" % (index+1)).text = ""
	
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		_process_button()
	elif Input.is_action_just_pressed("ui_left"):
		_change_button("ui_left")
	elif Input.is_action_just_pressed("ui_right"):
		_change_button("ui_right")

func _process_button():
	if focus_button == "menu_button":
		yield(get_tree().create_timer(0.25), "timeout")
		_on_MenuButton_pressed()
	elif focus_button == "try_again_button":
		_on_TryAgainButton_pressed()
	elif focus_button == "raz_highscores_button":
		reset_highscores()

func _change_button(direction):	
	focus_button = buttons_matrix[focus_button][direction]
	$MenuButton.set("custom_colors/font_color", Color(1, 1, 1))
	$TryAgainButton.set("custom_colors/font_color", Color(1, 1, 1))
	$ResetHighscoreButton.set("custom_colors/font_color", Color(1, 1, 1))
	
	if focus_button == "menu_button":
		$MenuButton.set("custom_colors/font_color", Color(0, 1, 0))
	elif focus_button == "try_again_button":
		$TryAgainButton.set("custom_colors/font_color", Color(0, 1, 0))
	elif focus_button == "raz_highscores_button":
		$ResetHighscoreButton.set("custom_colors/font_color", Color(0, 1, 0))
		

func _on_MenuButton_pressed():
	get_tree().change_scene("res://MenuScreen.tscn")

func _on_TryAgainButton_pressed():
	get_tree().change_scene("res://SpaceInvadersLike.tscn")

func _on_ResetHighscoreButton_pressed():
	reset_highscores()

func reset_highscores():
	$Highscores/Score1.text = ""
	$Highscores/Score2.text = ""
	$Highscores/Score3.text = ""
	$Highscores/Score4.text = ""
	$Highscores/Score5.text = ""
	Globals.clean_highscores()
