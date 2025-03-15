extends Node2D

@export var pipe: Node

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if pipe:
			pipe.toggle()

func _on_area_2d_mouse_entered() -> void:
	modulate = Color.WHITE

func _on_area_2d_mouse_exited() -> void:
	modulate = Color.DIM_GRAY
