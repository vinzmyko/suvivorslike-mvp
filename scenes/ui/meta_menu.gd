extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn") 

func _ready() -> void:
	%BackButton.pressed.connect(on_back_button_pressed)
	for child in %GridContainer.get_children():
		child.queue_free()
		
	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		%GridContainer.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)
		
	
func on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")