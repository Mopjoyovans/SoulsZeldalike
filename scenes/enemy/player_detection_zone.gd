extends Area2D

var player: CharacterBody2D = null


func _ready():
	body_entered.connect(on_area_entered)
	body_exited.connect(on_area_exited)
	
	
func can_see_player():
	return player != null

	
func on_area_entered(body: CharacterBody2D):
	if not body is CharacterBody2D:
		return

	player = body
	
	
func on_area_exited(body: CharacterBody2D):
	if not body is CharacterBody2D:
		return

	player = null
