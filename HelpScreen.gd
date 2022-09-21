extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$BackButton.set("custom_colors/font_color", Color(0, 1, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_home"):
		get_tree().change_scene("res://MenuScreen.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://MenuScreen.tscn")
