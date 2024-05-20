extends CharacterBody2D


const SPEED = 130
const JUMP_VELOCITY = -220

var direction: float = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _process(_delta: float) -> void:
	# Update input.
	direction = Input.get_axis("move_left", "move_right")
	
	# Set horizontal animation.
	if direction == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = direction < 0
	
	# Set vertical animation.
	if not is_on_floor():
		animated_sprite_2d.play("jump")
