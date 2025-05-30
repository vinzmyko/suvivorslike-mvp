extends CharacterBody2D

@export var arena_time_manager: Node

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: Node = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var sprite = $Visuals/Sprite2D
@onready var velocity_component: Node = $VelocityComponent
@onready var hit_random_audio_player = $HitRandomAudio

# Make player get the GameSession.get_selected_character() and then use that for everything

var selected_character: CharacterData

var number_colliding_bodies = 0
var base_speed = 0
var move_sign
var last_dir = 1.0

@export var disabled: bool = false

func _ready() -> void:
	# Assign the character these things
	selected_character = GameSession.get_selected_character()
	assert(selected_character != null, "Singleton should have been assigned a character resource")
	assert(selected_character.starting_ability_controller != null, "Singleton should have been assigned a starting ability")
	base_speed = selected_character.max_speed
	sprite.texture = selected_character.sprite_texture
	var starting_ability_controller_node = selected_character.starting_ability_controller.instantiate()
	abilities.add_child(starting_ability_controller_node)

	if disabled:
		var string = "%s is diabled via script"	% name
		printerr(string)
		queue_free()	
		return
		
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_changed.connect(on_health_changed)
	
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)
	
	update_health_display()


func _process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	var direction: Vector2 = movement_vector.normalized()
	velocity_component.accelerate_to_direction(direction)
	velocity_component.move(self)

	
	if movement_vector.x != 0 or movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale.x = move_sign

func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement) 


func check_deal_damage():
	if number_colliding_bodies == 0 or !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	GameEvents.emit_player_damaged() #move back to on_health_decreased if problem
	damage_interval_timer.start()
  

func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_decreased():
	hit_random_audio_player.play_random()
	
func on_health_changed():
	update_health_display()	


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .05)


func on_arena_difficulty_increased(difficulty: int):
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regen") 
	if health_regeneration_quantity > 0:
		var is_15_second_interval = (difficulty % 3) == 0
		if is_15_second_interval:
			health_component.heal(health_regeneration_quantity)
