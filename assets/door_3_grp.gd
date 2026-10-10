extends Node3D

var player_near := false
@onready var animation_player = $AnimationPlayer


func _ready() -> void:
    pass


func _on_interaction_area_body_entered(body: Node3D) -> void:
    if body.name == "player":
        player_near = true


func _on_interaction_area_body_exited(body: Node3D) -> void:
    if body.name == "player":
        player_near = false


func _input(event):
    if event.is_action_pressed("interact") and player_near:
        animation_player.play("open")
