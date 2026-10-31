
extends Node3D

var player_near := false
var door_open := false
var is_moving := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door_body: AnimatableBody3D = $Door_8/AnimatableBody3D
@onready var door_collision: CollisionShape3D = $Door_8/AnimatableBody3D/CollisionShape3D



func _ready() -> void:
	door_body.sync_to_physics = true
	door_collision.disabled = false


func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		player_near = true


func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.name == "player":
		player_near = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_near and not is_moving:
		is_moving = true

		if not door_open:
			door_collision.set_deferred("disabled", true)
			animation_player.play("open")
			await animation_player.animation_finished
			door_open = true
		else:
			animation_player.play("open", -1, -1.0, true)
			await animation_player.animation_finished
			door_collision.set_deferred("disabled", false)
			door_open = false

		is_moving = false
