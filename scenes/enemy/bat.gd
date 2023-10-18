extends CharacterBody2D

enum BatState {
	IDLE,
	WANDER,
	CHASE
}

const enemy_death_effect_scene = preload("res://scenes/effects/enemy_death_effect.tscn")
const PUSH_VELOCITY = 400.0

@export var acceleration = 400.0
@export var friction = 0.1
@export var knockback = 130.0
@export var max_speed = 70.0

var current_state = BatState.CHASE
var knockback_speed = 200.0

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var player_detection_zone = $PlayerDetectionZone
@onready var animated_sprite = $AnimatedSprite
@onready var soft_collision_component = $SoftCollisionComponent
@onready var wander_controller = $WanderController


func _ready():
	current_state = pick_random_idle_state()


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, knockback_speed * delta)
	
	match current_state:
		BatState.IDLE:
			seek_player(delta)
			if wander_controller.get_time_left() <= 0:
				randomize_wander_timer()
			
		BatState.WANDER:
			seek_player(delta)
			if wander_controller.get_time_left() <= 0:
				randomize_wander_timer()
			move_toward_target(wander_controller.target_position, delta)
			update_animation()
			
			if global_position.distance_to(wander_controller.target_position) <= max_speed * delta:
				randomize_wander_timer()
				
			
		BatState.CHASE:
			chase_player(delta)

	check_for_soft_collisions(delta)
	move_and_slide()


func chase_player(delta: float):
	var player = player_detection_zone.player
	
	if player != null:
		move_toward_target(player.global_position, delta)
		update_animation()
		
	else:
		current_state = BatState.IDLE


func seek_player(delta: float):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	if player_detection_zone.can_see_player():
		current_state = BatState.CHASE
		
		
func pick_random_idle_state():
	var idle_state_list = [BatState.IDLE, BatState.WANDER]
	idle_state_list.shuffle()
	return idle_state_list.pop_front()
	
	
func randomize_wander_timer():
	var lower_bound = 1.0
	var upper_bound = 3.0
	current_state = pick_random_idle_state()
	wander_controller.start_timer(randf_range(lower_bound, upper_bound))
		
		
func check_for_soft_collisions(delta: float):
	if soft_collision_component.is_colliding():
		velocity += soft_collision_component.get_push_vector() * delta * PUSH_VELOCITY
		
		
func move_toward_target(target_position: Vector2, delta: float):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		
		
func update_animation():
	animated_sprite.flip_h = velocity.x < 0


func _on_hurtbox_component_area_entered(area):
	health_component.health -= area.damage
	velocity = area.knockback_vector * knockback


func _on_health_component_died():
	var enemy_death_effect = enemy_death_effect_scene.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
	queue_free()
