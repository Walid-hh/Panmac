extends Control

@onready var play: Button = $VBoxContainer/VBoxContainer/Play
@onready var exit: Button = $VBoxContainer/VBoxContainer/Exit
@onready var pause_interface: Control = $"../PauseInterface"

var game := preload("res://scenes/Game.tscn")



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	play.pressed.connect(func() -> void : 
		for child in get_children():
			child.queue_free()
		var game_instance = game.instantiate()
		add_child(game_instance)
		
	)
	exit.pressed.connect(get_tree().quit)
