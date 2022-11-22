extends Node2D

var score = 0
var nb_highscores = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	"""
	clean_highscores()
	display_highscores()
	add_highscore("ulrich", 105)
	display_highscores()"""

func write_hello_world():
	var file = File.new()
	file.open("res://hello_world.txt", File.WRITE)
	file.store_string("hello world")
	file.close()

func read_hello_world():
	var file = File.new()
	file.open("res://hello_world.txt", File.READ)
	var text = file.get_as_text()
	print("contenu du fichier")
	print(text)
	file.close()
		
func compare_highscores(score1, score2):
	if score1["score"] < score2["score"]:
		return true
	else:
		return false

class HighscoreSorter:
	static func sort(score1, score2):
		if score1["score"] > score2["score"]:
			return true
		else:
			return false
			
func is_new_score_highscore(score):
	var file = File.new()
	file.open("res://highscores.dat", File.READ)
	var highscores = file.get_var()
	var is_highscore = len(highscores) < nb_highscores or score > highscores[-1]["score"]
	file.close()
	return is_highscore

func add_highscore(username, score):
	var file = File.new()
	file.open("res://highscores.dat", File.READ)
	var highscores = file.get_var()
	file.close()
	file.open("res://highscores.dat", File.WRITE)
	if len(highscores) < nb_highscores:
		highscores.append({"username": username, "score": score})
		highscores.sort_custom(HighscoreSorter, "sort")
		file.store_var(highscores)
	else:
		if score > highscores[-1]["score"]:
			highscores.append({"username": username, "score": score})
			highscores.sort_custom(HighscoreSorter, "sort")
			highscores.remove(len(highscores) - 1)
			file.store_var(highscores)
	print("tmp highscores")
	print(highscores)
	file.close()

func clean_highscores():
	var highscores = []
	var file = File.new()
	file.open("res://highscores.dat", File.WRITE)
	file.store_var(highscores)
	file.close()
	
func display_highscores():
	var file = File.new()
	file.open("res://highscores.dat", File.READ)
	var highscores = file.get_var()
	print(highscores)
	file.close()

func get_highscores():
	var file = File.new()
	file.open("res://highscores.dat", File.READ)
	var highscores = file.get_var()
	file.close()
	return highscores

	
