extends Node2D
# write code for the various buttons etc
var lights: Array
var buttons: Array
var button_mappings: Dictionary

func _ready():
	update_mappings()
	
func update_mappings():
	await get_lights_and_buttons()
	button_mappings.clear()
	# TODO: Modify to be more challenging? (one switch does multiple lights, idk)
	for i in range(0, len(buttons)):
		var button = buttons[i]
		var light = lights[i]
		var selected_lights = [light]
		button_mappings.get_or_add(button, selected_lights)
		button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))
		
func get_lights_and_buttons():
	lights = get_tree().get_nodes_in_group("Lights") # Get all lights dynamically
	buttons = get_tree().get_nodes_in_group("Buttons") # Get all buttons dynamically

func _on_button_pressed(button):
	if button in button_mappings:
		for light in button_mappings[button]:
			print(light)
			light.visible = not light.visible  # Toggle light on/off
