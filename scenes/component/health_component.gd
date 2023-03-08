extends Node

@export var max_health: float = 10
var current_health: float

func _ready() -> void:
	current_health = max_health


func damage(damage: float):
	current_health -= damage
