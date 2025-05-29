extends CanvasLayer

@export var character_resources: Array[CharacterData]

func _ready() -> void:
	$%CharOne.text = character_resources[0].character_name
	$%CharTwo.text = character_resources[1].character_name

	$%CharOne.pressed.connect(on_char_one_pressed)
	$%CharTwo.pressed.connect(on_char_two_pressed)
	$%Back.pressed.connect(on_back_pressed)

func start() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func on_char_one_pressed() -> void:
	GameSession.set_selected_character(character_resources[0])
	var message: String = "selected %s" % character_resources[0].character_name
	print(message)
	start()

func on_char_two_pressed() -> void:
	GameSession.set_selected_character(character_resources[1])
	var message: String = "selected %s" % character_resources[1].character_name
	print(message)
	start()

func on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
