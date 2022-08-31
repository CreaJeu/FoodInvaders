extends Node2D

var SPEED = 500
var time_till_flush = 0

var type_ = "simple_lazer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= SPEED*delta
	if time_till_flush > 0:
		time_till_flush -= delta
		if time_till_flush <= 0:
			queue_free()


func _on_collision(area):
	var area_parent = area.get_parent()
	if type_ == "lame_lazer":
		if "type_" in area_parent:
			if area_parent.type_ in ["friend", "enemy"]:
				SPEED = 0
				get_node("./Area2D/AnimatedSprite").play("explode")
				time_till_flush = 0.25
			elif area_parent.type_ == "bonus":
				queue_free()
	
	elif type_ == "simple_lazer":
		if "type_" in area_parent:
			if area_parent.type_ in ["friend", "enemy", "bonus"]:
				SPEED = 0
				get_node("./Area2D/AnimatedSprite").play("explode")
				time_till_flush = 0.25
