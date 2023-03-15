extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)

func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale.x = -move_sign


func on_hit():		
	$HitRandomStreamPlayer.play_random()