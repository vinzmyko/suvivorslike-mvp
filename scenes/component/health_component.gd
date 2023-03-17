extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10
var current_health: float

func _ready() -> void:
	current_health = max_health


func damage(damage_amount: float):
	current_health = max(min(current_health - damage_amount, 10), 0) # can use clamp() instead of nesting the min()
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()


func heal(heal_amount: float):
	damage(-heal_amount)
	print("healed" + str(current_health))


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
			died.emit()
			owner.queue_free()
