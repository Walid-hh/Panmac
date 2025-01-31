@icon("res://assets/pac man & life counter & death/pac man/happy_pac_man.png")
extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var pills: TileMapLayer = $"../Pills"
@onready var panmac_eat_sfx: AudioStreamPlayer = %PanmacEatSfx
@onready var panmac: Area2D = $"../Panmac"
@onready var panmac_shader : Shader = preload("res://shaders/Panmac.gdshader")
@onready var panmac_power_up_sfx: AudioStreamPlayer = %PanmacPowerUpSfx
@export var tween_duration := 0.3
var score : int = 0
var timer : Timer 
var power_up : bool = false
var power_up_timer : Timer
var input_access : bool = true
var last_input : Vector2 = Vector2.RIGHT

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	power_up_timer = Timer.new()
	add_child(power_up_timer)
	power_up_timer.timeout.connect(_power_up_timeout)
	timer.timeout.connect(_input_timeout)


func _process(delta: float) -> void:

	if Input.is_action_just_pressed("move_up") :
		last_input = Vector2.UP
		sprite_2d.rotation = 1.5 * PI
		sprite_2d.flip_h = false
	elif Input.is_action_just_pressed("move_down") :
		last_input = Vector2.DOWN
		sprite_2d.rotation =  0.5 * PI
		sprite_2d.flip_h = false
	elif Input.is_action_just_pressed("move_left") :
		last_input = Vector2.LEFT
		sprite_2d.rotation = 0
		sprite_2d.flip_h = true
	elif Input.is_action_just_pressed("move_right") :
		last_input = Vector2.RIGHT
		sprite_2d.rotation = 0
		sprite_2d.flip_h = false
	if input_access :
		_player_movement(last_input)
	var viewport_size = get_viewport_rect().size
	position.x = wrapf(position.x , 0 , viewport_size.x)
	position.y = wrapf(position.y , 0 , viewport_size.y)
	_powered_up(power_up)


func _player_movement(direction : Vector2) -> void :
	input_access = false
	var tween := create_tween()
	var current_tile : Vector2i = pills.local_to_map(panmac.position)
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	var tile_data : TileData = pills.get_cell_tile_data(target_tile)

	if tile_data == null :
		tween.kill()
		return
	if tile_data.get_custom_data("eatable") == true :
		tween.tween_property(panmac , "position" , pills.map_to_local(target_tile) , tween_duration)
		_eat_pill(target_tile)
	elif tile_data.get_custom_data("walkable") == true:
		tween.tween_property(panmac , "position" , pills.map_to_local(target_tile) , tween_duration)
	elif tile_data.get_custom_data("powerup") == true:
		tween.tween_property(panmac , "position" , pills.map_to_local(target_tile) , tween_duration)
		_eat_super_pill(target_tile)
		power_up_timer.start(5)
		
		
	timer.start(tween_duration-0.2)


func _eat_pill(target_tile : Vector2i) -> void :
	pills.set_cell(target_tile,pills.get_cell_source_id(Vector2(0,0)),Vector2i(2,0) , 0)
	panmac_eat_sfx.play()
	score += 1000


func _eat_super_pill(target_tile : Vector2i) -> void :
	pills.set_cell(target_tile,pills.get_cell_source_id(Vector2(0,0)),Vector2i(2,0) , 0)
	panmac_eat_sfx.play()
	power_up = true
	power_up_timer.start(5)
	score += 5000
	panmac_power_up_sfx.play()


func _input_timeout() -> void :
	input_access = true


func _power_up_timeout() -> void :
	power_up = false


func _powered_up(power_up : bool) -> void :
	if power_up == false:
		sprite_2d.material = null
		panmac_power_up_sfx.stop()
	if power_up ==  true :
		var shader_material := ShaderMaterial.new()
		shader_material.shader = panmac_shader
		sprite_2d.material = shader_material
