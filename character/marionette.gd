extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var immobilized = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and not immobilized:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction and not immobilized:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.y > 0:
		anim.play("Fall")
	elif velocity.y < 0:
		anim.play("Jump")
	else:
		if velocity.x == 0:
			anim.play("Idle")
		else:
			anim.play("Walk")
	move_and_slide()
	
func immobilize(boolean):
	immobilized = boolean
