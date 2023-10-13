extends Node2D

const grass_effect_scene = preload("res://scenes/effects/grass_effect.tscn")

func create_grass_effect():
	var grass_effect = grass_effect_scene.instantiate()
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_hurtbox_component_area_entered(area):
	create_grass_effect()
	queue_free()
