extends Node2D

@export var instant_death: bool = true  # If false, you can add a delay/damage effect
@onready var stream = $Water

func toggle():
	stream.visible = not stream.visible
	stream.monitoring = not stream.monitoring

func _process(delta: float) -> void:
	for item in stream.get_overlapping_bodies():
		if item.is_in_group("Player"):
			item.take_damage(50)
