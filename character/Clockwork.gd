extends CharacterBody2D

# vertical movement
const weight = 4
@onready var JUMP_HEIGHT = -sqrt(0.5 * 980 * weight * 600) # -1000

# horizontal movement
var walk_speed = 750.0
var facing = "Right"

var health = 100
var invincible = false
@onready var invincible_timer = $InvincibilityTimer
var immobilized = false
@onready var respawn_point = get_parent().get_node("RespawnPoint")  # Reference to respawn marker

@onready var player = $"."
@onready var anim = $AnimationPlayer
@onready var head_sprite = $Body/Center/Head
@onready var head_bone = $Bones/Core/Head

@onready var mask = $Body/Center/Head/Mask
@onready var l_eyeball = $Body/Center/Head/LEyeball
@onready var l_iris = $Body/Center/Head/LEyeball/Iris
@onready var r_eyeball = $Body/Center/Head/REyeball
@onready var r_iris = $Body/Center/Head/REyeball/Iris

@onready var right = $Body/Right
@onready var center = $Body/Center
@onready var left = $Body/Left

func _physics_process(delta: float) -> void:
	# Handle death
	if health <= 0:
		position = respawn_point.position
		health = 100
		
	# Handle shadowing & ordering
	if facing == "Left":
		left.z_index = -3
		right.z_index = -1
		if left.material and right.material:
			left.material.set_shader_parameter("shadow_strength", 0.35)
			right.material.set_shader_parameter("shadow_strength", 0)
	elif facing == "Right":
		left.z_index = -1
		right.z_index = -3
		if left.material and right.material:
			left.material.set_shader_parameter("shadow_strength", 0)
			right.material.set_shader_parameter("shadow_strength", 0.35)
		
		
	# Handle vertical movement
	if not is_on_floor():
		if velocity.y < 0: # going up
			anim.play("jump" + facing)
			#velocity += get_gravity() * delta
		else: # going down
			anim.play("fall" + facing)
			#velocity += get_gravity() * delta * weight
		velocity += get_gravity() * delta * weight
		
	# Handle jump input
	elif Input.is_action_just_pressed("Jump") and not immobilized:
		velocity.y = JUMP_HEIGHT

	# Handle horizontal movement
	var direction := Input.get_axis("Left", "Right")
	if direction and not immobilized:
		velocity.x = direction * walk_speed
		if direction < 0:
			facing = "Left"
		else:
			facing = "Right"
		if is_on_floor():
			anim.play("walk" + ("Injured" if health <= 50 else "") + facing)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		if is_on_floor():
			anim.play("idle" + facing)
	move_and_slide()
	
func _process(delta: float) -> void:
	if get_global_mouse_position().x < global_position.x:
		if not head_sprite.flip_h:
			head_sprite.flip_h = true
			mask.flip_h = true
			head_bone.set_bone_angle(180)
	else:
		if head_sprite.flip_h:
			head_sprite.flip_h = false
			mask.flip_h = false
			head_bone.set_bone_angle(0)
			
func die():
	position = respawn_point.position  # Move player back to start
	
func change_accessory(newAccessory: CompressedTexture2D):
	var name = newAccessory.resource_path
	if name.ends_with("mask.png"):
		change_mask(newAccessory)
	elif name.ends_with("iris.png"):
		change_eye(newAccessory)
		
func change_mask(newMask: CompressedTexture2D):
	if newMask == mask.texture:
		mask.texture = null
	else:
		mask.texture = newMask

func change_eye(newIris: CompressedTexture2D):
	if newIris == r_iris.texture and newIris == l_iris.texture:
		# remove eyeballs
		l_iris.texture = null
		r_iris.texture = null
		l_eyeball.texture = null
		r_eyeball.texture = null
	else:
		var newEyeball = load("res://art/shell/eyeball.png")
		# add base eyeball
		l_eyeball.texture = newEyeball
		r_eyeball.texture = newEyeball
		l_iris.texture = newIris
		r_iris.texture = newIris

func immobilize(boolean):
	immobilized = boolean
	
func take_damage(amount):
	if not invincible:
		health -= amount
		
		# TODO: these should prob go somewhere else
		
		if left.material and right.material and center.material:
			var tween = create_tween().set_parallel(true)
			tween.tween_method(set_flash_modifier, 1.0, 0.0, 0.2)
		invincible = true
		invincible_timer.start()

func _on_invincibility_timer_timeout() -> void:
	invincible = false

func set_flash_modifier(value: float) -> void:
	if left.material and right.material and center.material:
		left.material.set_shader_parameter("strength", value)
		right.material.set_shader_parameter("strength", value)
		center.material.set_shader_parameter("strength", value)
