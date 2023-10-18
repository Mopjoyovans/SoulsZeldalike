extends Area2D

signal invincibility_started
signal invincibility_ended

const HIT_EFFECT = preload("res://scenes/effects/hit_effect.tscn")

var is_invincible = false:
	set(iframe_on):
		is_invincible = iframe_on
		if is_invincible:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

@onready var timer = $Timer


func _ready():
	area_entered.connect(on_area_entered)


func set_invincible(iframe_on):
	self.is_invincible = iframe_on
	if is_invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration: float):
	self.is_invincible = true
	timer.start(duration)


func create_hit_effect():
	var effect = HIT_EFFECT.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func on_area_entered(area: Area2D):
	create_hit_effect()


func _on_timer_timeout():
	self.is_invincible = false


func _on_invincibility_started():
	set_deferred("monitoring", false)


func _on_invincibility_ended():
	set_deferred("monitoring", true)
