extends Node2D

export var MAX_ENNEMIES = 5
export var MAX_FRIENDS = 5
export var MAX_OBSTACLES = 5
export var MAX_BONUS = 1

var EnemyType = [
	"SodaEnemy",
	"BurgerEnemy"
]

var EnemyTypeRarity = {
	"SodaEnemy": 30,
	"BurgerEnemy": 70
}
var total_enemies_rarity = 0

var FriendType = [
	"CarotFriend",
	"SaladFriend", 
	"SoupFriend", 
	"TomatoFriend"
]

var FriendTypeRarity = {
	"CarotFriend": 20,
	"SaladFriend": 50, 
	"SoupFriend": 10, 
	"TomatoFriend": 20
}

var total_friends_rarity = 0

var ObstacleType = [
	"TableObstacle",
]

var ObstacleTypeRarity = {
	"TableObstacle": 100,
}

var total_obstacles_rarity = 0

var BonusType = [
	"ClosedBonus",
	"KnifeBonus",
	"ShieldBonus",
	"ChefHatBonus",
]

var BonusTypeRarity = {
	"ClosedBonus": 25,
	"KnifeBonus": 25,
	"ShieldBonus": 25,
	"ChefHatBonus": 25,
}

var total_bonus_rarity = 0

func _ready():
	randomize()
	total_friends_rarity = 0
	for friend_type in FriendType:
		total_friends_rarity += FriendTypeRarity[friend_type]
	
	total_enemies_rarity = 0
	for enemy_type in EnemyType:
		total_enemies_rarity += EnemyTypeRarity[enemy_type]
	
	total_obstacles_rarity = 0
	for obstacle_type in ObstacleType:
		total_obstacles_rarity += ObstacleTypeRarity[obstacle_type]

	total_bonus_rarity = 0
	for bonus_type in BonusType:
		total_bonus_rarity += BonusTypeRarity[bonus_type]

func _generate_random_type(random_value, type_clazz, rarity_clazz):
	var rand_acc = 0
	var generated_type = ""
	for type_ in type_clazz:
		generated_type = type_
		if rand_acc + rarity_clazz[type_] >= random_value:
			break
		rand_acc += rarity_clazz[type_]
	return generated_type

func create_enemy():
	var random_value = rand_range(0, total_enemies_rarity)
	var generated_enemy_type = _generate_random_type(random_value, EnemyType, EnemyTypeRarity)
	
	var enemy_res = load(generated_enemy_type + ".tscn")
	var enemy = enemy_res.instance()
	enemy.position.x = rand_range(0, 1000)
	enemy.position.y = 0
	add_child(enemy)
	
	enemy.get_node("Area2D").connect("area_entered", enemy, "collision")
	

func create_friend():
	var random_value = rand_range(0, total_friends_rarity)
	var generated_enemy_type = _generate_random_type(random_value, FriendType, FriendTypeRarity)
	
	var friend_res = load(generated_enemy_type + ".tscn")
	var friend = friend_res.instance()
	friend.position.x = rand_range(0, 1000)
	friend.position.y = 0
	add_child(friend)
	
	friend.get_node("Area2D").connect("area_entered", friend, "collision")
	
func create_obstacle():
	var random_value = rand_range(0, total_obstacles_rarity)
	var generated_obstacle_type = _generate_random_type(random_value, ObstacleType, ObstacleTypeRarity)
	
	var obstacle_res = load(generated_obstacle_type + ".tscn")
	var obstacle = obstacle_res.instance()
	obstacle.position.x = rand_range(0, 1000)
	obstacle.position.y = 0
	add_child(obstacle)
	
	obstacle.get_node("Area2D").connect("area_entered", obstacle, "collision")

func create_bonus():
	var random_value = rand_range(0, total_bonus_rarity)
	var generated_bonus_type = _generate_random_type(random_value, BonusType, BonusTypeRarity)
	
	var bonus_res = load(generated_bonus_type + ".tscn")
	var bonus = bonus_res.instance()
	bonus.position.x = rand_range(0, 1000)
	bonus.position.y = 0
	add_child(bonus)
	
	bonus.get_node("Area2D").connect("area_entered", bonus, "collision")

func _on_Timer_timeout():
	# score_label.text = "SCORE : %d" % score	
	var nb_children = get_child_count()
	var nb_friends = 0
	var nb_enemies = 0
	var nb_obstacles = 0
	var nb_bonus = 0
	
	for child in get_children():
		if child.type_ == "friend":
			nb_friends += 1
		elif child.type_ == "enemy":
			nb_enemies += 1
		elif child.type_ == "obstacle":
			nb_obstacles += 1
		elif child.type_ == "bonus":
			nb_bonus += 1
	
	var generate_type = []
	if nb_friends < MAX_FRIENDS:
		generate_type.append("friend")
	if nb_enemies < MAX_ENNEMIES:
		generate_type.append("enemy")
	if nb_obstacles < MAX_OBSTACLES:
		generate_type.append("obstacle")
	if nb_bonus < MAX_BONUS:
		generate_type.append("bonus")
	
	var id_to_generate = rand_range(0, len(generate_type))
	var type_to_generate = generate_type[id_to_generate]
	
	if type_to_generate == "friend":
		create_friend()
	elif type_to_generate == "enemy":
		create_enemy()
	elif type_to_generate == "obstacle":
		create_obstacle()
	elif type_to_generate == "bonus":
		create_bonus()
		
