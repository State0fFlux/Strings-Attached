extends Sprite2D

@export var max_offset: float = 40  # Maximum distance pupil can move from center
@onready var pupil = $Iris  # Reference to pupil sprite

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var eye_center = global_position  # Assume eye's position is its center
	var direction = (mouse_pos - eye_center).normalized()
	var distance = min((mouse_pos - eye_center).length(), max_offset)  # Clamp movement

	pupil.position = direction * distance
