extends Node

const MAX_RANGE: int = 150

@export var gun_ability: PackedScene

var base_damage = 15
var additional_damage_percent: float = 1
var base_wait_time


func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timerout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_timer_timerout():
	print("timer has timed out")
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var gun_instance = gun_ability.instantiate() as GunAbility
	gun_instance.scale.x = player.visuals.scale.x
	player.add_child(gun_instance)
	gun_instance.hitbox_component.damage = base_damage * additional_damage_percent

	gun_instance.global_position = player.global_position + Vector2(0, -5)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "gun_rate":
		var percent_reduction = current_upgrades["gun_rate"]["quantity"] * .1
		$Timer.wait_time = max(0.1, base_wait_time * (1 - percent_reduction))
		$Timer.start()
	elif upgrade.id == "gun_damage":
		additional_damage_percent = 1 + (current_upgrades["gun_damage"]["quantity"] * .15)
