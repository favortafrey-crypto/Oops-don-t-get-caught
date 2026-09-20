extends CharacterBody3D

@export var speed := 5.0
@export var gravity := 20.0
@export var mouse_sensitivity := 0.003

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$SpringArm3D.rotate_x(-event.relative.y * mouse_sensitivity)

	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var input_direction = Input.get_vector(
		"left",
		"right",
		"forward",
		"backward"
	)

	var direction = (
		transform.basis.x * input_direction.x
		+ transform.basis.z * input_direction.y
	).normalized()

	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	move_and_slide()
