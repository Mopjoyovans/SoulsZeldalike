class_name Player
extends CharacterBody2D

enum CharacterState {
	MOVE,
	ROLL,
	ATTACK
}

const PLAYER_HURT_SOUND = preload("res://scenes/sound/player_hurt_sound.tscn")

@export var acceleration = 1000.0
@export var friction = 1000.0
@export var max_speed = 150.0
@export var dodge_speed = 200.0

var state = CharacterState.MOVE
var dodge_vector = Vector2.DOWN
var iframe_counter = 0.6

@onready var animation_player = %AnimationPlayer
@onready var blink_animation_player = $BlinkAnimationPlayer
@onready var animation_tree = %AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var hitbox_collision = $HitboxComponent/HitboxCollision
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var health_component = $HealthComponent


func _ready():
	health_component.died.connect(on_player_died)
	hurtbox_component.area_entered.connect(on_player_hit)
	animation_tree.active = true
	hitbox_component.knockback_vector = dodge_vector


func _physics_process(delta):
	match state:
		CharacterState.MOVE:
			move_state(delta)
			
		CharacterState.ROLL:
			roll_state(delta)
			
		CharacterState.ATTACK:
			attack_state(delta)


func attack_state(delta: float):
	velocity = Vector2.ZERO
	animation_state.travel("Sword")
	
	
func move_state(delta: float):
	hitbox_collision.disabled = true
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_direction = move_direction.normalized()

	handle_input(move_direction, delta)
	move_and_slide()
	update_animation(move_direction)


func roll_state(delta: float):
	velocity = dodge_vector * dodge_speed
	animation_state.travel("Roll")
	move_and_slide()
	
	
func handle_input(move_direction: Vector2, delta: float):

	if move_direction != Vector2.ZERO:
		velocity = velocity.move_toward(move_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	if Input.is_action_just_pressed("dodge"):
		state = CharacterState.ROLL
		
	elif Input.is_action_just_pressed("weapon"):
		state = CharacterState.ATTACK


func update_animation(move_direction: Vector2):
	if move_direction != Vector2.ZERO:
		dodge_vector = move_direction
		hitbox_component.knockback_vector = move_direction
		animation_tree.set("parameters/Idle/blend_position", move_direction)
		animation_tree.set("parameters/Run/blend_position", move_direction)
		animation_tree.set("parameters/Sword/blend_position", move_direction)
		animation_tree.set("parameters/Roll/blend_position", move_direction)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")


func attack_animation_finished():
	state = CharacterState.MOVE


func roll_animation_finished():
	state = CharacterState.MOVE


func on_player_hit(area):
	health_component.health -= area.damage
	hurtbox_component.start_invincibility(iframe_counter)
	var playerHurtSound = PLAYER_HURT_SOUND.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)


func on_player_died():
	queue_free()


func _on_hurtbox_component_invincibility_started():
	blink_animation_player.play("start")


func _on_hurtbox_component_invincibility_ended():
	blink_animation_player.play("stop")
