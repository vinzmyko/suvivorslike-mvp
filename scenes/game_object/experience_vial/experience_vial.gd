extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var random_stream_player = $RandomStreamPlayer2DComponent

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)


#we wanna pass in two arguments, percent is a given but we also want to pass in start_pos which you need
#to bind onto the callable via .bind()
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	#lerps from vial pos to player pos
	global_position = start_position.lerp(player.global_position, percent)
	#gets the dir from vial to the player
	var direction_from_start_to_player = player.global_position - start_position

	#rotates the vial towards to player
	var target_rotation = direction_from_start_to_player.angle() + deg_to_rad(90)
	#lerp between vials' current rotation to the target rotation
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-get_process_delta_time()))


func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()# runs multiple tweens at the same time
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, .05).set_delay(.45) #tween's property's initial value to final value
	#will wait .35s to run tween
	tween.chain() #tween calls bellow will run after tweens above do
	tween.tween_callback(collect)
	
	random_stream_player.play_random()