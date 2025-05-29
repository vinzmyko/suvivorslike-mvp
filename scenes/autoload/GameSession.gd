extends Node

var character_res: CharacterData;

func set_selected_character(data: CharacterData) -> void:
	assert(data != null, "Character Data parameter is not valid when setting selected character")
	character_res = data

func get_selected_character() -> CharacterData:
	assert(character_res != null, "Attempting to get null on character resource")
	return character_res
