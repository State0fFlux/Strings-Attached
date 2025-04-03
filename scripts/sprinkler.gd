extends Node2D

@export var instant_death: bool = true  # If false, you can add a delay/damage effect
@onready var stream = $Water
@onready var particles = $Water/GPUParticles2D
@onready var polygon = $Water/fireLol

func toggle():
	particles.emitting = not particles.emitting # TODO: Decide between particles vs. polygon
	await get_tree().create_timer(.2).timeout
	polygon.visible = not polygon.visible
	stream.monitoring = not stream.monitoring

func _process(delta: float) -> void:
	if stream.monitoring:
		for item in stream.get_overlapping_bodies():
			if item.is_in_group("Player"):
				item.take_damage(50)
