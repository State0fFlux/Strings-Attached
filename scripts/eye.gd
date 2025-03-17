extends Node2D

@export var accessory: Texture2D

@onready var character = $"../Clockwork"

func _ready():
	# Preload or load textures into the array
	accessory = preload("res://art/shell/iris.png")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if character:
			character.change_accessory(accessory)

func _on_area_2d_mouse_entered() -> void:
	print("hi!")
	modulate = Color.WHITE

func _on_area_2d_mouse_exited() -> void:
	print("bye!")
	modulate = Color.DIM_GRAY
