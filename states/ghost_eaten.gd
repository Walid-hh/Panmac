extends State
class_name GhostEaten
@onready var panmac: Area2D = $"../../../Panmac"
@onready var area_2d: Area2D = $"../../Area2d"
@onready var pills: pills = $"../../../Pills"
@onready var enemy: Node2D = $"../.."
@onready var ghost_color: Sprite2D = $"../../GhostColor"
var initial_position : Vector2
var speed : float 
var timer : Timer 
var move_ghost : bool = true
var path : Array
var tween : Tween

func _ready() -> void:
	speed = enemy.ghost_spec.speed
	initial_position = enemy.position

func enemy_movement() -> void :
	var duration = 100 / speed
	path = pills.get_astar_path(enemy.position , initial_position)
	if path.size() > 0 :
		path.pop_front()
	if move_ghost:
		if path.size() > 0 :
			tween = create_tween()
			tween.tween_property(enemy , "position" , path.pop_front() , duration)
			timer.start(duration)
			move_ghost = false

func enter():
	ghost_color.visible = false
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_move_ghost)


func update(delta : float):
	enemy_movement()
	if pills.local_to_map(enemy.position) == pills.local_to_map(initial_position) :
		ghost_color.visible = true
		Transitioned.emit(self , "GhostNormal")


func _move_ghost() -> void :
	move_ghost = true
