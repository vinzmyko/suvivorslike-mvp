extends Node2D

@onready var label: Label = $Label

func _ready() -> void:
	pass


func start(text: String):
	label.text = text
	var tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .4)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE, .4).set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 2, .15).set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE * 0.8, .15).set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
