extends Node2D
@onready var panmac: Area2D = $"../Panmac"
@onready var area_2d: Area2D = $Area2d
@onready var pills: pills = $"../Pills"
@export var speed : float = 200
var timer : Timer 
var move_ghost : bool = true
var path : Array
var tween : Tween
var duration := 100 / speed


func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	area_2d.area_entered.connect(_quit)
	timer.timeout.connect(_move_ghost)

func _process(delta: float) -> void:
	_enemy_movement()

func _enemy_movement() -> void :
	path = pills.get_astar_path(self.position , panmac.position)
	if path.size() > 0 :
		path.pop_front()
	if move_ghost:
		if path.size() > 0 :
			tween = create_tween()
			tween.tween_property(self , "position" , path.pop_front() , duration)
			timer.start(duration)
			move_ghost = false
	
func _quit(body_that_entered : Area2D) -> void :
	get_tree().quit()

func _move_ghost() -> void :
	move_ghost = true
