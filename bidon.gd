extends Node2D

export var speed = 400
export var score = 5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		dir.x = -speed*delta
		dir.y = 0
	elif Input.is_action_pressed("ui_right"):
		dir.x = speed*delta
		dir.y = 0
	elif Input.is_action_pressed("ui_up"):
		dir.x = 0
		dir.y = -speed*delta
	elif Input.is_action_pressed("ui_down"):
		dir.x = 0
		dir.y = speed*delta
	else:
		dir.x = 0
		dir.y = 0
	
	position.x += dir.x
	position.y += dir.y
		
	if Input.is_key_pressed(KEY_SPACE):
		var tween = $Tween
		$Label.text = "+ %d" % score
		$Label.visible = true
		tween.interpolate_property(
			$Label,
			"rect_position:y",
			$Label.rect_position.y,
			$Label.rect_position.y - 32,
			0.25,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tween.start()
		
		


func _on_Tween_tween_completed(object, key):
	$Label.visible = false
	$Label.rect_position = Vector2(
		$Sprite.position.x - 23,
		$Sprite.position.y - 60
	)
