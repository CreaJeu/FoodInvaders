extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GameOver/ScoreLabel").text = "%d" % Globals.score



func _on_MenuButton_pressed():
	get_tree().change_scene("res://MenuScreen.tscn")

func _on_TryAgainButton_pressed():
	get_tree().change_scene("res://SpaceInvadersLike.tscn")
