extends CharacterBody2D

const enemy_death_effect_scene = preload("res://scenes/effects/enemy_death_effect.tscn")

@onready var stats_component: StatsComponent = $StatsComponent

@export var knockback = 130.0

var knockback_speed = 200.0


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, knockback_speed * delta)
	move_and_slide()


func _on_hurtbox_component_area_entered(area):
	stats_component.health -= area.damage
	velocity = area.knockback_vector * knockback


func _on_stats_component_died():
	var enemy_death_effect = enemy_death_effect_scene.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
	queue_free()
