@icon("res://assets/ghost/blue ghost/spr_ghost_blue_0.png")
extends Node2D

@onready var ghost_outline: Sprite2D = $GhostOutline
@onready var ghost_color: Sprite2D = $GhostColor
@export var ghost_spec : Ghost

func _ready() -> void:
	ghost_outline.texture = ghost_spec.ghost_outline
	ghost_color.texture = ghost_spec.ghost_color
	ghost_color.hframes = 2
