extends Node

const MAX_RANGE: int = 150

@export var sword_ability: PackedScene

var damage = 5
var base_wait_time


func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timerout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_timer_timerout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	#filter function takes each element in the array as an argument and runs it through the callable to see if
	#it will be preserved in the filter. ie. which element to take away
	#basically if enemy in within the MAX_RANGE it will stay within the array
	enemies = enemies.filter(func(enemy: Node2D):
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
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU )) * 8
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return
	
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	$Timer.wait_time = max(0.1, base_wait_time * (1 - percent_reduction))
	$Timer.start()
