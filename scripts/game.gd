extends Node2D
class_name Game
@onready var music: AudioStreamPlayer = $Music
@onready var panmac: Area2D = $Panmac


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.play()
	process_mode = Node.PROCESS_MODE_ALWAYS
	for child in self.get_children():
		child.process_mode = Node.PROCESS_MODE_PAUSABLE

	
	
