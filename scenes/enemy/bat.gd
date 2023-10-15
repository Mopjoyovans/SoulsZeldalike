extends CharacterBody2D

enum BatState {
	IDLE,
	WANDER,
	CHASE
}

const enemy_death_effect_scene = preload("res://scenes/effects/enemy_death_effect.tscn")

@onready var stats_component: StatsComponent = $StatsComponent
@onready var player_detection_zone = $PlayerDetectionZone
@onready var animated_sprite = $AnimatedSprite

@export var acceleration = 400.0
@export var friction = 0.1
@export var knockback = 130.0
@export var max_speed = 70.0

var current_state = BatState.CHASE
var knockback_speed = 200.0


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, knockback_speed * delta)
	
	match current_state:
		BatState.IDLE:
			seek_player(delta)
			
		BatState.WANDER:
			pass
			
		BatState.CHASE:
			chase_player(delta)

	move_and_slide()


func chase_player(delta: float):
	var player = player_detection_zone.player
	
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		update_animation()
		
	else:
		current_state = BatState.IDLE


func seek_player(delta: float):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	if player_detection_zone.can_see_player():
		current_state = BatState.CHASE
		
		
func update_animation():
	animated_sprite.flip_h = velocity.x < 0


func _on_hurtbox_component_area_entered(area):
	stats_component.health -= area.damage
	velocity = area.knockback_vector * knockback


func _on_stats_component_died():
	var enemy_death_effect = enemy_death_effect_scene.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
	queue_free()
