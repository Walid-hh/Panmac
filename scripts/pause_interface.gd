extends Control
@onready var replay: Button = $VBoxContainer/VBoxContainer/Replay
@onready var exit: Button = $VBoxContainer/VBoxContainer/Exit
@onready var score: RichTextLabel = $Score
@onready var win_text: RichTextLabel = $WinText
var panmac : Area2D
var max_score : int = 181000
var new_game := preload("res://scenes/Game.tscn")
signal game_over



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	replay.pressed.connect(func() -> void :
		get_node("../MainMenu").remove_child(get_node("../MainMenu/Game"))
		var new_game_instance = new_game.instantiate()
		get_node("../MainMenu").add_child(new_game_instance)
		visible = false
		win_text.visible = false
		get_tree().paused = false
		)
	exit.pressed.connect(func() -> void :
		get_tree().quit()
		)
	game_over.connect(lose_game)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_node("../MainMenu/Game/Panmac") == true :
		var panmac_instance = get_node("../MainMenu/Game/Panmac")
		panmac = panmac_instance
		win_game()
		score.text = "score : " + str(panmac.score)
		if panmac.score < max_score:
			toggle_pause()


func toggle_pause() -> void:
	if get_tree().paused == true and Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		self.visible = false
	elif get_tree().paused == false and Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		self.visible = true

func win_game() -> void:
	if panmac.score == max_score:
		get_tree().paused = true
		visible = true
		win_text.visible = true
	
func lose_game() -> void : 
		self.visible = true
