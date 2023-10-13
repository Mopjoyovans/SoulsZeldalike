extends AnimatedSprite2D


func _ready():
	connect("animation_finished", on_animation_finished)
	play("destroy")


func on_animation_finished():
	queue_free()
