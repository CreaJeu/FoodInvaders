extends Node2D

var SPEED = 1000
var time_till_flush = 0

var type_ = "super_lazer"

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
	if "type_" in area_parent:
		if area_parent.type_ in ["enemy","bonus","obstacle"]:
			SPEED = 0
			get_node("./Area2D/AnimatedSprite").play("explode")
			time_till_flush = 0.25
		if area_parent.type_ == "friend":
			get_node("/root/GameScene/Stats").change_score(-area_parent.points)
		if area_parent.type_ == "enemy":
			get_node("/root/GameScene/Stats").change_score(area_parent.points)
