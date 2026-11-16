extends CharacterBody3D

@export var chase_speed: float = 9.5
@export var detection_distance: float = 8.0
@export var lose_distance: float = 12.0
@export var punches_to_defeat: int = 4
@export var gravity: float = 20.0

@export var attack_distance: float = 1.2
@export var damage_amount: float = 10.0
@export var attack_interval: float = 1.0
@export var punch_range: float = 2.0

var attack_cooldown: float = 0.0
var punches_received: int = 0
var was_punching: bool = false

var player: Node3D
var is_chasing: bool = false


func _ready() -> void:
	player = get_parent().get_node_or_null("player")

	if player == null:
		push_warning("PLAYER NOT FOUND!")
	else:
		print("ZOMBIE READY!")
		print("PLAYER FOUND!")


func _physics_process(delta: float) -> void:
	if player == null:
		return

	var direction: Vector3 = player.global_position - global_position
	direction.y = 0.0

	var distance: float = direction.length()

	# Detection and chasing
	if not is_chasing and distance <= detection_distance:
		is_chasing = true
	elif is_chasing and distance > lose_distance:
		is_chasing = false

	# Movement
	if is_chasing and distance > 0.6:
		direction = direction.normalized()
		velocity.x = direction.x * chase_speed
		velocity.z = direction.z * chase_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	# Player punching detection
	var currently_punching: bool = player.get("is_punching")

	if currently_punching and not was_punching:
		if distance <= punch_range:
			punches_received += 1
			print("ZOMBIE HIT! ", punches_received, "/", punches_to_defeat)

			if punches_received >= punches_to_defeat:
				print("ZOMBIE DEFEATED!")
				queue_free()
				return

	was_punching = currently_punching

	# Attack cooldown
	if attack_cooldown > 0.0:
		attack_cooldown -= delta

	# Damage player
	if distance <= attack_distance:
		if not currently_punching and attack_cooldown <= 0.0:
			
			player.call("take_damage", damage_amount)
			attack_cooldown = attack_interval

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	move_and_slide()