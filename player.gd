extends CharacterBody3D

@export var speed := 5.0

func _physics_process(delta):
	var input_direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var direction = Vector3(
		input_direction.x,
		0,
		input_direction.y
	)

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()