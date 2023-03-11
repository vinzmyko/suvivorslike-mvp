extends CharacterBody2D

#@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var visuals: Node2D = $Visuals

var is_moving: bool = false

func _process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()

	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale.x = move_sign


func set_is_moving(moving: bool):
	is_moving = moving
