extends Node3D

@export var chase_speed: float = 2.0
@export var detection_distance: float = 1.0
@export var lose_distance: float = 3.0
@export var punches_to_defeat: int = 4

var player: Node3D
var is_chasing := false


func _ready() -> void:
	player = get_parent().get_node_or_null("player")

	if player == null:
		push_warning("Player node not found!")


func _process(delta: float) -> void:
	if player == null:
		return

	var direction := player.global_position - global_position
	direction.y = 0

	var distance := direction.length()

	if not is_chasing and distance <= detection_distance:
		is_chasing = true

	elif is_chasing and distance > lose_distance:
		is_chasing = false

	if is_chasing and distance > 0.6:
		global_position += direction.normalized() * chase_speed * delta