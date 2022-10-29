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
		if area_parent.type_ in ["friend", "enemy","bonus","obstacle"]:
			SPEED = 0
			get_node("./Area2D/AnimatedSprite").play("explode")
			handle_tween(area_parent)
			time_till_flush = 0.25

func handle_tween(area_parent):	
	var player = get_node("/root/GameScene/Player")
	
	if area_parent.type_ == "enemy" or area_parent.type_ == "friend":
		var points = area_parent.points
		if player.has_michelin_star:
			print("points avant michelin : %d" % points)
			points *= 2
			
		if area_parent.type_ == "enemy":
			show_tween_label("+ %d" % points, Color(0, 1, 0))
		if area_parent.type_ == "friend":
			show_tween_label("- %d" % area_parent.points, Color(1, 0, 0))


func show_tween_label(text, color):
	var tween = $Tween
	$TweenLabel.text = text
	$TweenLabel.set("custom_colors/font_color", color)
	$TweenLabel.visible = true
	tween.stop_all()
	tween.interpolate_property(
		$TweenLabel,
		"rect_position:y",
		$TweenLabel.rect_position.y,
		$TweenLabel.rect_position.y - 64,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
