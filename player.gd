extends CharacterBody3D

@export var speed := 10.0
@export var sprint_speed := 7.0
@export var gravity := 20.0
@export var mouse_sensitivity := 0.003

@onready var animation_player: AnimationPlayer = $CollisionShape3D/Superhero_Male_FullBody/AnimationPlayer
@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var health_bar: ProgressBar = get_tree().current_scene.get_node("HUD/HealthBar")
@onready var game_over_screen: Control = get_tree().current_scene.get_node("HUD/GameOverScreen")
@onready var win_screen: Control = get_tree().current_scene.get_node("HUD/WinScreen")
@onready var restart_button: Button = get_tree().current_scene.get_node("HUD/GameOverScreen/RestartButton")

var is_punching := false
var punch_number := 0

@export var max_health: float = 100.0
var health: float = 100.0

var game_over := false
var game_won := false


func _ready() -> void:
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health

	game_over_screen.hide()
	win_screen.hide()

	restart_button.pressed.connect(_on_restart_pressed)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	print("Animations available: ", animation_player.get_animation_list())
	animation_player.animation_finished.connect(_on_animation_finished)


func _input(event: InputEvent) -> void:
	if game_over or game_won:
		return

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		spring_arm.rotate_x(-event.relative.y * mouse_sensitivity)
		spring_arm.rotation.x = clamp(
			spring_arm.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if game_over or game_won:
		return

	var input_direction := Input.get_vector(
		"left", "right", "forward", "backward"
	)

	var direction := (
		transform.basis.x * input_direction.x
		+ transform.basis.z * input_direction.y
	).normalized()

	var sprinting := Input.is_action_pressed("run")
	var current_speed := sprint_speed if sprinting else speed

	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	if Input.is_action_just_pressed("punch") and not is_punching:
		is_punching = true

		if punch_number == 0:
			animation_player.play("player/Punch_Jab")
			punch_number = 1
		else:
			animation_player.play("player/Punch_Cross")
			punch_number = 0

	if not is_punching:
		if direction.length() < 0.01:
			play_animation("player/Idle")
		elif sprinting:
			play_animation("player/Sprint")
		else:
			play_animation("player/Walk")

	move_and_slide()


func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == "player/Punch_Jab" or animation_name == "player/Punch_Cross":
		is_punching = false


func play_animation(animation_name: String) -> void:
	if animation_player == null:
		return

	if animation_player.current_animation != animation_name:
		animation_player.play(animation_name)


func take_damage(amount: float) -> void:
	print("DAMAGE FUNCTION REACHED: ", amount)
	if game_over or game_won:
		return

	health -= amount
	health = maxf(health, 0.0)
	health_bar.value = health

	print("PLAYER HEALTH: ", health)

	if health <= 0:
		game_over = true
		velocity = Vector3.ZERO
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		game_over_screen.show()
		print("PLAYER DIED")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
