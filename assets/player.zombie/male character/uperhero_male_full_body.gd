extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const WALK_SPEED = 4.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5

var punch_number = 0
var is_punching = false
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Read movement input
	var input_dir := Input.get_vector(
		"ui_left", "ui_right",
		"ui_up", "ui_down"
	)

	var direction := (transform.basis * Vector3(
		input_dir.x, 0, input_dir.y
	)).normalized()

	# Determine movement speed
	var sprinting := Input.is_key_pressed(KEY_SPACE)
	var speed := SPRINT_SPEED if sprinting else WALK_SPEED

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)

	# Select the correct animation
	if direction == Vector3.ZERO:
		if animation_player.current_animation != "player/Idle":
			animation_player.play("player/Idle")
	elif sprinting:
		if animation_player.current_animation != "player/Sprint":
			animation_player.play("player/Sprint")
	else:
		if animation_player.current_animation != "player/Walk":
			animation_player.play("player/Walk")

	move_and_slide()