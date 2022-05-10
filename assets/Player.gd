extends KinematicBody2D

export var speed = 42000
var dir = Vector2()
var FLOOR_NORMAL = Vector2(0, -1)


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
	
	move_and_slide(dir, FLOOR_NORMAL)
