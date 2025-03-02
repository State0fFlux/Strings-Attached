extends Node2D
# write code for the various buttons etc
var lights: Array
var buttons: Array
var button_mappings: Dictionary

func _ready():
	randomize()
	update_mappings()
	
func update_mappings():
	await get_lights_and_buttons()
	button_mappings.clear()
	
	# TODO: This shouldn't be random lol, I need to figure out a way to make it a puzzle
	for button in buttons:
		var num_lights = randi_range(1,3)
		var selected_lights = []
		print(button)
		for i in range(0,num_lights):
			var light_index = randi_range(0,lights.size() - 1)
			while (selected_lights.has(lights[light_index])):
				light_index = (light_index + 1) % (lights.size() - 1)
			print(light_index)
			selected_lights.append(lights[light_index])
		button_mappings.get_or_add(button, selected_lights)
		button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))
		
func get_lights_and_buttons():
	lights = get_tree().get_nodes_in_group("Lights") # Get all lights dynamically
	buttons = get_tree().get_nodes_in_group("Buttons") # Get all buttons dynamically

func _on_button_pressed(button):
	if button in button_mappings:
		for light in button_mappings[button]:
			light.visible = not light.visible  # Toggle light on/off
