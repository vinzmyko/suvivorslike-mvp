extends Node

const MAX_RANGE: int = 150

@export var sword_ability: PackedScene


func _ready() -> void:
	$Timer.timeout.connect(on_timer_timerout)


func on_timer_timerout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	#filter function takes each element in the array as an argument and runs it through the callable to see if
	#it will be preserved in the filter. ie. which element to take away
	#basically if enemy in within the MAX_RANGE it will stay within the array
	enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	#sort_custom(a, b) compares two variables in the array and returns either true or false, if it's false a
	#goes before b
	enemies.sort_custom(func(a:Node2D, b:Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	var sword_instance = sword_ability.instantiate() as Node2D
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU )) * 8
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()

