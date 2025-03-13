extends CharacterBody2D

const JUMP_VELOCITY = -1000 # -500
const SPEED = 650
const weight = 8 # 4

var immobilized = false
var facing = "Right"
@onready var player = $"."
@onready var anim = $AnimationPlayer
@onready var head_sprite = $Body/Head
@onready var head_bone = $Bones/Core/Head
@onready var jump_timer = $JumpTimer


func _physics_process(delta: float) -> void:
	# Handle vertical movement
	if not is_on_floor():
		if velocity.y < 0: # going up
			anim.play("jump" + facing)
			#velocity += get_gravity() * delta
		else: # going down
			anim.play("fall" + facing)
			#velocity += get_gravity() * delta * weight
		if jump_timer.is_stopped() or velocity.y > 0: # apply weighted gravity
			print("hard")
			velocity += get_gravity() * delta * weight
		else: # slower fall
			print("soft")
			velocity += get_gravity() * delta
			
	# Handle jump input
	if Input.is_action_just_pressed("Jump") and is_on_floor() and not immobilized:
		velocity.y = JUMP_VELOCITY
		jump_timer.start()
	if Input.is_action_just_released("Jump") and not is_on_floor() and not immobilized:
		jump_timer.stop()

	# Handle horizontal movement
	var direction := Input.get_axis("Left", "Right")
	if direction and not immobilized:
		velocity.x = direction * SPEED
		if direction < 0:
			facing = "Left"
		else:
			facing = "Right"
		if is_on_floor():
			anim.play("walk" + facing)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			anim.play("idle" + facing)
	move_and_slide()
	
func _process(delta: float) -> void:
	if get_global_mouse_position().x < global_position.x:
		if not head_sprite.flip_h:
			head_sprite.flip_h = true
			head_bone.set_bone_angle(180)
	else:
		if head_sprite.flip_h:
			head_sprite.flip_h = false
			head_bone.set_bone_angle(0)
			
func immobilize(boolean):
	immobilized = boolean
