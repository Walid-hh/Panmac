extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pause_interface: Control = $PauseInterface
@onready var panmac: Area2D = $Panmac
var max_score : int = 181000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()
	process_mode = Node.PROCESS_MODE_ALWAYS
	for child in self.get_children():
		child.process_mode = Node.PROCESS_MODE_PAUSABLE
		if child.name == "PauseInterface" :
			child.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if panmac.score < max_score :
		toggle_pause()

func toggle_pause() -> void:
	if get_tree().paused == true and Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		pause_interface.visible = false
	elif get_tree().paused == false and Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_interface.visible = true

func win_game() -> void:
	if panmac.score == max_score:
		get_tree().quit
	
