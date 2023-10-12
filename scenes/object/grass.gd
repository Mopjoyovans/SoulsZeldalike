extends Node2D


func create_grass_effect():
	var grass_effect_scene: PackedScene = load("res://scenes/effects/grass_effect.tscn")
	var grass_effect = grass_effect_scene.instantiate()
	var world = get_tree().current_scene
	world.add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_hurtbox_component_area_entered(area):
	create_grass_effect()
	queue_free()
