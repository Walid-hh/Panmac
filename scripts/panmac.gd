extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var pills: TileMapLayer = $"../Pills"
@onready var pac_eat: AudioStreamPlayer = %PacEat
@onready var panmac: Area2D = $"../Panmac"
@export var tween_duration := 0.3
var timer : Timer 
var input_access : bool = true

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_timer_timeout)
func _process(delta: float) -> void:
	if input_access == false :
		return
	else :
		if Input.is_action_just_pressed("move_up") :
			_player_movement(Vector2.UP)
			sprite_2d.rotation = 1.5 * PI
			sprite_2d.flip_h = false
		elif Input.is_action_just_pressed("move_down") :
			sprite_2d.rotation =  0.5 * PI
			sprite_2d.flip_h = false
			_player_movement(Vector2.DOWN)
		elif Input.is_action_just_pressed("move_left") :
			_player_movement(Vector2.LEFT)
			sprite_2d.rotation = 0
			sprite_2d.flip_h = true
		elif Input.is_action_just_pressed("move_right") :
			_player_movement(Vector2.RIGHT)
			sprite_2d.rotation = 0
			sprite_2d.flip_h = false
	var viewport_size = get_viewport_rect().size
	position.x = wrapf(position.x , 0 , viewport_size.x)
	position.y = wrapf(position.y , 0 , viewport_size.y)

func _player_movement(direction : Vector2) -> void :
	input_access = false
	var tween := create_tween()
	var current_tile : Vector2i = pills.local_to_map(panmac.position)
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x ,
		current_tile.y + direction.y,
	)
	var tile_data : TileData = pills.get_cell_tile_data(target_tile)
	if tile_data == null :
		return
	if tile_data.get_custom_data("eatable") == true :
		tween.tween_property(panmac , "position" , pills.map_to_local(target_tile) , tween_duration)
		_eat_pill(target_tile)
	elif tile_data.get_custom_data("walkable") == true:
		tween.tween_property(panmac , "position" , pills.map_to_local(target_tile) , tween_duration)
	timer.start(tween_duration - 0.1)
	#direction.x = Input.get_axis("move_left", "move_right")
	#if direction.x > 0 :

	#if direction.x <0 :
		#sprite_2d.flip_h = true
		#sprite_2d.rotation = 0
	#direction.y = Input.get_axis("move_up","move_down")
	#if direction.y > 0 :

	#if direction.y < 0 :
		#
		#
	#if direction.length() > 1 :
		#direction.normalized()
	#var movement = direction * SPEED * delta
	#position += direction * SPEED * delta
	
	
	
func _eat_pill(target_tile : Vector2i) -> void :
	pills.set_cell(target_tile,pills.get_cell_source_id(Vector2(0,0)),Vector2i(2,0) , 0)
	pac_eat.play()

func _timer_timeout() -> void :
	input_access = true
	
