extends CharacterBody2D


const SPEED = 130
const JUMP_VELOCITY = -220

var sprite_direction: int = 1

var direction: float = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D


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
		var is_play_backwards: bool = direction * sprite_direction < 0
		if is_play_backwards:
			animated_sprite_2d.play_backwards("run")
		else:
			animated_sprite_2d.play("run")
	
	# Set vertical animation.
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	
	# Features for Weapons.
	# Make the weapons aim at the cursor.
	var weapons: Node2D = $Weapons
	weapons.look_at(get_global_mouse_position())
	
	# Make the animation always faces the cursor and make sure the right
	# direction of the weapons.
	if (
		global_position.direction_to(
			get_global_mouse_position()
		).dot(
			Vector2(sprite_direction, 0)
		) < 0
	):
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		sprite_direction = -sprite_direction
		weapons.scale.y = -weapons.scale.y
	
	# Camera
	# Move the camera according to the mouse position if the mouse is in the
	# viewport.
	if get_viewport_rect().abs().has_point(
		get_viewport().get_mouse_position()
	):
		($Camera2D as Camera2D).offset = (
			get_global_mouse_position() - global_position
		) * 0.4
