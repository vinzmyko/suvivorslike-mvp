extends CanvasLayer

@onready var panel_container = $%PanelContainer
@onready var animation_player = $AnimationPlayer
var options_menu = preload("res://scenes/ui/options_menu.tscn")

var is_closing: bool = false

func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	
	%ResumeButton.pressed.connect(on_resume_pressed)
	%OptionsButton.pressed.connect(on_option_pressed)
	%MainMenuButton.pressed.connect(on_main_menu_pressed)
	
	$AnimationPlayer.play("in")

	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		closed()
		get_tree().root.set_input_as_handled()
	

func closed():
	if is_closing:
		return

	is_closing = true
		
	animation_player.play_backwards("in")

	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

	await tween.finished

	get_tree().paused = false
	queue_free()

   

func on_resume_pressed():
	closed()


func on_option_pressed():
	var options_menu_instance = options_menu.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))


func on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_back_pressed(options_menu_instance: Node):
	options_menu_instance.queue_free()
