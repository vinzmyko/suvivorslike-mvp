extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")

func _ready() -> void:
	$%PlayButton.pressed.connect(on_play_button_pressed)
	$%OptionsButton.pressed.connect(on_options_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)
	%UpgradeButton.pressed.connect(on_upgrade_button_pressed)

func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_button_pressed() -> void:
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_back_pressed.bind(options_instance))	


func on_quit_button_pressed() -> void:
	get_tree().quit()


func on_back_pressed(options_instance):
	options_instance.queue_free()

func on_upgrade_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")