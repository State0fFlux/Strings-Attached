extends Node2D

@export var instant_death: bool = true  # If false, you can add a delay/damage effect
@onready var stream = $Water

func toggle():
	stream.visible = not stream.visible
	stream.monitoring = not stream.monitoring


func _on_water_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Ensure the player has this group
		body.die()  # Call the player's death function
