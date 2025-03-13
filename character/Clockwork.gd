extends CharacterBody2D

# vertical movement
const weight = 7
@onready var JUMP_HEIGHT = -sqrt(0.5 * 980 * weight * 600) # -1000
const jump_limit = 2
var jump_count = 0

# horizontal movement
const WALK_SPEED = 600
const JUMP_SPEED = 700
var facing = "Right"

var immobilized = false
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
		velocity += get_gravity() * delta * weight
	else:
		jump_count = 0
		
	# Handle jump input
	if Input.is_action_just_pressed("Jump") and jump_count < jump_limit and not immobilized:
		velocity.y = JUMP_HEIGHT
		jump_count += 1

	# Handle horizontal movement
	var direction := Input.get_axis("Left", "Right")
	if direction and not immobilized:
		velocity.x = direction * (WALK_SPEED if jump_count <= 1 else JUMP_SPEED)
		if direction < 0:
			facing = "Left"
		else:
			facing = "Right"
		if is_on_floor():
			anim.play("walk" + facing)
	else:
		velocity.x = move_toward(velocity.x, 0, (WALK_SPEED if jump_count <= 1 else JUMP_SPEED))
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
