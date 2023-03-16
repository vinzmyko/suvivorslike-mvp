extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var required_experience_label: Label = %RequiredExperienceLabel
@onready var card_upgrade: MetaUpgrade
@onready var purchase_button: Button = %PurchaseButton

# IF IT DOESN'T WORK IT WAS SOMETHING TO DO WITH THE SQUIGGLY LINES BECAUSE UPGRADE AT THE TOP IS NAMED THE NAME AS THE ARGUMENT

func _ready() -> void:
	purchase_button.pressed.connect(on_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade):
	card_upgrade = upgrade
	name_label.text = upgrade.title 
	description_label.text = upgrade.description
	update_progress(upgrade)


func update_progress(upgrade: MetaUpgrade):
	var percent = min(MetaProgression.save_data["meta_upgrade_currency"] / upgrade.experience_cost, 1)
	print(percent)
	progress_bar.value = percent 
	purchase_button.disabled = percent < 1
	required_experience_label.text = str(MetaProgression.save_data["meta_upgrade_currency"]) + "/" + str(upgrade.experience_cost)


func select_card():
	animation_player.play("click")


func on_pressed():
	if card_upgrade == null:
		return
	MetaProgression.add_meta_upgrade(card_upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= card_upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	update_progress(card_upgrade)
	animation_player.play("click")