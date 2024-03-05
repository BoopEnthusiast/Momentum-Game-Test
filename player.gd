extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0
const ACCELERATION = 30.0
const RELEASE_DECEL = 50.0
const DECEL_FACTOR = 8.0
const DECEL_LIMIT = 20.0
const MAX_JUMPS = 2

var deceleration = 50.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumps: int = 2

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps = MAX_JUMPS
	
	print(get_floor_angle(),"  ",get_floor_normal(),"  ",up_direction)
	if is_on_floor():
		up_direction = get_floor_normal()
	else:
		up_direction = Vector2.UP
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumps > 0:
			velocity.y = JUMP_VELOCITY
			jumps -= 1
	
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if abs(velocity.x) > DECEL_FACTOR:
		deceleration = abs(velocity.x) / DECEL_FACTOR
	else:
		velocity.x = 0
	
	if direction:
		if abs(velocity.x) < SPEED:
			velocity.x = SPEED * direction
		elif (velocity.x < -1 and direction > 0) or (velocity.x > 1 and direction < 0):
			velocity.x = move_toward(velocity.x, direction * INF, deceleration)
		else:
			velocity.x = move_toward(velocity.x, direction * INF, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, RELEASE_DECEL)

	move_and_slide()
