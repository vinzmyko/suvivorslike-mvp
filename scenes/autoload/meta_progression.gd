extends Node

const SAVE_FILE_PATH = "user://game_files.save"

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades":{}
}

func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_save_file()
	print(save_data)

func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		print("no save data")
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		print("Failed to open save file")
		return
		
	var loaded_data = file.get_var()
	if loaded_data != null:
		save_data = loaded_data
	file.close()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()

func get_upgrade_count(upgrade_id: String) -> int:
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0


func on_experience_collected(number: float):
	save_data["meta_upgrade_currency"] += number
