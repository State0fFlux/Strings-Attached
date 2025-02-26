extends Node2D

@onready var control_cam = $ControlRoom/Camera2D
@onready var player_cam = $Player/Camera2D
@onready var player = $Player
@onready var control_room = $ControlRoom

#var zoom_in_level: Vector2 = Vector2(2, 2)  # Normal gameplay zoom
#var zoom_out_level: Vector2 = Vector2(1, 1)  # Control room zoom
#var zoom_duration: float = 1  # Time to zoom in/out
#var zoom_in_offset = 70
var is_zoomed_out: bool = false  # Tracks current zoom state
var room_is_locked = false

func _ready() -> void:
	player_cam.make_current()
	
#debug
func _process(delta: float) -> void:
	if get_viewport().get_camera_2d() == player_cam:
		control_room.global_position = player_cam.global_position + Vector2(-1920/2, -1080/2)

func _unhandled_input(event):
	if event.is_action_pressed("ZoomOut") and not is_zoomed_out and not room_is_locked and player.is_on_floor():
		switch_camera(control_cam)  # Zoom out
		is_zoomed_out = true
	elif event.is_action_pressed("ZoomIn") and is_zoomed_out and not room_is_locked and player.is_on_floor():
		switch_camera(player_cam)  # Zoom in
		is_zoomed_out = false
		
func switch_camera(target_camera: Camera2D):
	# disable player movement
	player.immobilize(true)
	
	# lock the control room
	room_is_locked = true
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
		
	# save old status of current camera
	var curr_cam = get_viewport().get_camera_2d()

	# Duplicate the current camera
	var temp_cam = curr_cam.duplicate()
	get_tree().current_scene.add_child(temp_cam)  # Add to scene
	temp_cam.global_position = curr_cam.global_position
	temp_cam.make_current()  # Make it active

	# Tween temp camera to target properties
	tween.tween_property(temp_cam, "position", target_camera.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(temp_cam, "zoom", target_camera.zoom, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# adjust the control_room to the player
	if target_camera == player_cam:
		tween.tween_property(control_room, "position", player_cam.global_position + Vector2(-1920/2, -1080/2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	await tween.finished  # Wait for tween completion

	# Switch to the target camera and remove the temp camera
	target_camera.make_current()
	temp_cam.queue_free()

	# unlock the control room
	room_is_locked = false
	
	# re-enable player movement
	player.immobilize(false)
