extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = "Nouvel highscore\n%s" % Globals.score
	$TextEditName.grab_focus()


func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		print("Nouveau nom: %s" % $TextEditName.text)
		_save_highscore($TextEditName.text)


func _on_TextEditName_text_changed():
	$TextEditName.text = $TextEditName.text.to_upper().replace("\n", "")
	if len($TextEditName.text) > 5:
		$TextEditName.text = $TextEditName.text.substr(0,7)
	$TextEditName.cursor_set_column(len($TextEditName.text))


func _save_highscore(username):
	Globals.add_highscore(username, Globals.score)
	get_tree().change_scene("res://GameOver.tscn")


func _on_ValidateButton_button_down():
	_save_highscore($TextEditName.text)
