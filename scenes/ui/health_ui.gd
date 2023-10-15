extends Control


@export var player: Player

var heart_ui_width = 15
var max_hearts = 4:
	set(amount):
		max_hearts = max(amount, 1)
		self.hearts = min(hearts, max_hearts)
		if heart_ui_empty != null:
			heart_ui_empty.size.x = max_hearts * heart_ui_width

var hearts = 4:
	set(amount):
		hearts = clamp(amount, 0, max_hearts)
		if heart_ui_full != null:
			heart_ui_full.size.x = hearts * heart_ui_width

@onready var heart_ui_empty = $HeartUIEmpty
@onready var heart_ui_full = $HeartUIFull


func _ready():
	if player.health_component is HealthComponent:
		max_hearts = player.health_component.max_health
		hearts = player.health_component.health
		player.health_component.connect("health_changed", on_health_changed)
		player.health_component.connect("max_health_changed", on_max_health_changed)


func on_health_changed(health):
	hearts = health

func on_max_health_changed(max_health):
	max_hearts = max_health
