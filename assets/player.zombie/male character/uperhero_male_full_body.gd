extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const WALK_SPEED = 4.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5

var punch_number = 0
var is_punching = false