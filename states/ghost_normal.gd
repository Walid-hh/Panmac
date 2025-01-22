extends State
class_name GhostNormal
@onready var panmac: Area2D = $"../../../Panmac"
@onready var area_2d: Area2D = $"../../Area2d"
@onready var pills: pills = $"../../../Pills"
@onready var enemy: Node2D = $"../.."
@onready var pause_interface := $"../../../../../PauseInterface"
@onready var pan_mac_kill_sfx: AudioStreamPlayer = $"../../PanMacKillSfx"
var speed : float 
var timer : Timer 
var move_ghost : bool = true
var path : Array
var tween : Tween

func _ready() -> void:
	speed = enemy.ghost_spec.speed
	


func enemy_movement() -> void :
	var duration = 100 / speed
	path = pills.get_astar_path(enemy.position , panmac.position)
	if path.size() > 0 :
		path.pop_front()
	if move_ghost:
		if path.size() > 0 :
			tween = create_tween()
			tween.tween_property(enemy , "position" , path.pop_front() , duration)
			timer.start(duration)
			move_ghost = false

func enter():
	pan_mac_kill_sfx.process_mode = PROCESS_MODE_ALWAYS
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_move_ghost)
	area_2d.area_entered.connect(_eat_player)
	
func update(delta : float):
	enemy_movement()
	if panmac.power_up == true:
			area_2d.area_entered.disconnect(_eat_player)
			Transitioned.emit(self , "GhostAfraid")

func _move_ghost() -> void :
	move_ghost = true

func _eat_player (body_that_entered : Area2D) -> void :
	if body_that_entered.is_in_group("player"):
		if panmac.power_up == false:
			pan_mac_kill_sfx.play()
			pause_interface.game_over.emit()
			get_tree().paused = true
	else:
		return
