extends CharacterBody2D

const JUMP_VELOCITY = -500
const SPEED = 550

var immobilized = false
var facing = "Right"
@onready var player = $"."
@onready var anim = $AnimationPlayer
@onready var head_sprite = $Body/Head
@onready var head_bone = $Bones/Core/Head


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		anim.play("jump" + facing)
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and not immobilized:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
