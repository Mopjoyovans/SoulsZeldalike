extends Area2D

var player: CharacterBody2D = null


func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	
func can_see_player():
	return player != null

	
func on_body_entered(body: Node2D):
	if not body is CharacterBody2D:
		return

	player = body
	
	
func on_body_exited(body: Node2D):
	if not body is CharacterBody2D:
		return

	player = null
