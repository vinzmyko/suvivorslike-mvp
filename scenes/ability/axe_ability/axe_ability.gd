extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready() -> void:
	#randomised the axe's spinning rotation
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	#call the tween_method while interpolating between 0 and 2 for a duration of 3 seconds
	tween.tween_method(tween_method, 0.0, 2.0, 3)
	tween.tween_callback(queue_free) #calls queue_free() after tween finished


#creates spinning axe
#rotations is the number inbetween 0 and 2
func tween_method(rotations: float):
	#percent makes it arc out, if we don't have this percent that maeans the radius will be constant to the 
	#MAX_RADIUS
	var percent = (rotations / 2) # since rotations is 0 to 2 you want it to go to 0 to 1
	var current_radius = percent * MAX_RADIUS #length radius of 0 to 100
	var current_direction = base_rotation.rotated(rotations * (TAU + PI)) #TAU means 2 full rotations or 2 PI
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)
