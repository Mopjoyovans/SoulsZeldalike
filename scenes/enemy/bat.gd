extends CharacterBody2D

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
	queue_free()
