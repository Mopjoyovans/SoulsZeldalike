extends Area2D

const HIT_EFFECT = preload("res://scenes/effects/hit_effect.tscn")

@export var show_hit_effect = true

func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not show_hit_effect:
		return

	var effect = HIT_EFFECT.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
