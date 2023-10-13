class_name StatsComponent
extends Node

signal died

@export var max_health: int = 1

@onready var health: int = max_health:
	get:
		return health
	set(amount):
		health = amount
		if health <= 0:
			emit_signal("died")
