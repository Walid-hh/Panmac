extends State
class_name GhostAfraid
@onready var panmac: Area2D = $"../../../Panmac"
@onready var area_2d: Area2D = $"../../Area2d"
@onready var pills: pills = $"../../../Pills"
@onready var enemy: Node2D = $"../.."
@onready var ghost_color: Sprite2D = $"../../GhostColor"
@onready var animation_player: AnimationPlayer = $"../../GhostColor/AnimationPlayer"
var initial_position : Vector2
var speed : float 
var timer : Timer 
var move_ghost : bool = true
var path : Array
var tween : Tween

func _ready() -> void:
	speed = 100
	initial_position = enemy.position


func enemy_movement() -> void :
	var duration = 100 / speed
	path = pills.get_astar_path(enemy.position , initial_position)
	if path.size() > 0 :
		#the front of the array list that is returned by the path method is the enemy position
		#we delete it from the array since we want the front to be the target poosition of the enemy
		path.pop_front()
	if move_ghost:
		if path.size() > 0 :
			tween = create_tween()
			tween.tween_property(enemy , "position" , path.pop_front() , duration)
			timer.start(duration)
			move_ghost = false

func enter():
	print("I am afraid")
	animation_player.play("afraid_animation")
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_move_ghost)
	area_2d.area_entered.connect(
		func (body_that_entered : Area2D) -> void :
			if body_that_entered.is_in_group("player"):
				if panmac.power_up == true :
					animation_player.stop()
					Transitioned.emit(self , "GhostEaten")
			else:
				return
				)

func update(delta : float):
	enemy_movement()
	if panmac.power_up == false :
		animation_player.stop()
		Transitioned.emit(self , "GhostNormal")


func _move_ghost() -> void :
	move_ghost = true
