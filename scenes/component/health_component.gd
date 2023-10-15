class_name HealthComponent
extends Node

signal max_health_changed
signal health_changed
signal died

@export var max_health: int = 1:
	set(amount):
		max_health = amount
		self.health = min(health, max_health)
		emit_signal("max_health_changed", max_health)

@onready var health: int = max_health:
	get:
		return health
	set(amount):
		health = amount
		emit_signal("health_changed", health)
		if health <= 0:
			emit_signal("died")
