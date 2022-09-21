extends Node2D

var focus_button = "play_button"

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayButton.set("custom_colors/font_color", Color(0, 1, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		_process_button()
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		_change_button()

func _process_button():
	if focus_button == "play_button":
		start_game()
	else:
		show_help()

func _change_button():
	# Focus help button
	if focus_button == "play_button" and Input.is_action_pressed("ui_right"):
		focus_button = "help_button"
		$PlayButton.set("custom_colors/font_color", Color(1, 1, 1))
		$HelpButton.set("custom_colors/font_color", Color(0, 1, 0))
	# Focus play button
	elif Input.is_action_pressed("ui_left"):
		focus_button = "play_button"
		$PlayButton.set("custom_colors/font_color", Color(0, 1, 0))
		$HelpButton.set("custom_colors/font_color", Color(1, 1, 1))

func _on_PlayButton_pressed():
	start_game()


func _on_HelpButton_pressed():
	show_help()


func start_game():
	get_tree().change_scene("res://SpaceInvadersLike.tscn")

func show_help():
	get_tree().change_scene("res://HelpScreen.tscn")
