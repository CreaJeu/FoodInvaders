extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		start_game()


func _on_PlayButton_pressed():
	start_game()


func _on_HelpButton_pressed():
	show_help()


func start_game():
	get_tree().change_scene("res://SpaceInvadersLike.tscn")

func show_help():
	get_tree().change_scene("res://HelpScreen.tscn")
