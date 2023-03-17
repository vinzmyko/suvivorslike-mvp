extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var required_experience_label: Label = %RequiredExperienceLabel
@onready var card_upgrade: MetaUpgrade
@onready var purchase_button: Button = %PurchaseButton
@onready var count_label: Label = %CountLabel

func _ready() -> void:
	purchase_button.pressed.connect(on_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade):
	card_upgrade = upgrade
	name_label.text = upgrade.title 
	description_label.text = upgrade.description
	update_progress(upgrade)


func update_progress(upgrade: MetaUpgrade):
	if upgrade.title != card_upgrade.title:
		var percent = min(MetaProgression.save_data["meta_upgrade_currency"] / upgrade.experience_cost, 1)
		progress_bar.value = percent
		required_experience_label.text = str(MetaProgression.save_data["meta_upgrade_currency"]) + "/" + str(upgrade.experience_cost)
		return

	var current_quantity = 0 
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]		
	var percent = min(MetaProgression.save_data["meta_upgrade_currency"] / upgrade.experience_cost, 1)
	progress_bar.value = percent 
	purchase_button.disabled = percent < 1 or current_quantity == upgrade.max_quantity
	required_experience_label.text = str(MetaProgression.save_data["meta_upgrade_currency"]) + "/" + str(upgrade.experience_cost)

	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id) == false:
		count_label.text = "x%d" % 0
	elif current_quantity == 0:
		count_label.text = "x%d" % current_quantity
	elif current_quantity == upgrade.max_quantity:
		count_label.text = "MAX"
	else:
		count_label.text = "x%d" % current_quantity	

func select_card():
	animation_player.play("click")


func on_pressed():
	if card_upgrade == null:
		return
	MetaProgression.add_meta_upgrade(card_upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= card_upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress", card_upgrade)
	
	animation_player.play("click")
