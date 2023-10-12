extends CharacterBody2D

enum CharacterState {
	MOVE,
	ROLL,
	ATTACK
}

@export var acceleration = 1000.0
@export var friction = 1000.0
@export var max_speed = 150.0

@onready var animation_player = %AnimationPlayer
@onready var animation_tree = %AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var hitbox_collision = $HitboxComponent/HitboxCollision

var state = CharacterState.MOVE


func _ready():
	animation_tree.active = true


func _physics_process(delta):
	match state:
		CharacterState.MOVE:
			move_state(delta)
			
		CharacterState.ROLL:
			pass
			
		CharacterState.ATTACK:
			attack_state()


func attack_state():
	velocity = Vector2.ZERO
	animation_state.travel("Sword")
	
	
func move_state(delta: float):
	hitbox_collision.disabled = true
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_direction = move_direction.normalized()

	handle_input(move_direction, delta)
	move_and_slide()
	update_animation(move_direction)


func handle_input(move_direction: Vector2, delta: float):

	if move_direction != Vector2.ZERO:
		velocity = velocity.move_toward(move_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	if Input.is_action_just_pressed("weapon"):
		state = CharacterState.ATTACK


func update_animation(move_direction: Vector2):
	if move_direction != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", move_direction)
		animation_tree.set("parameters/Run/blend_position", move_direction)
		animation_tree.set("parameters/Sword/blend_position", move_direction)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")


func attack_animation_finished():
	state = CharacterState.MOVE
