extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Sky_area_entered(area):
	var parent = area.get_parent()
	var player = get_node("/root/GameScene/Player")
	if parent != player:
		parent.queue_free()

