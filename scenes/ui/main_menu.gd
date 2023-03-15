extends CanvasLayer


func _ready() -> void:
    $%PlayButton.pressed.connect(on_play_button_pressed)
    $%OptionsButton.pressed.connect(on_options_button_pressed)
    $%QuitButton.pressed.connect(on_quit_button_pressed)
    
     
func on_play_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_button_pressed() -> void:
    pass


func on_quit_button_pressed() -> void:
    get_tree().quit()

