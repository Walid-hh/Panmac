extends CharacterBody2D
@onready var panmac: CharacterBody2D = $"."
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer



func _process(delta: float) -> void:
	_player_movement(delta)

func _player_movement(delta:float) -> void :
	var direction := Vector2(0,0)
	var speed := 50
	direction.x = Input.get_axis("move_left", "move_right")
	if direction.x > 0 :
		sprite_2d.flip_h = false
		sprite_2d.rotation = 0
	if direction.x <0 :
		sprite_2d.flip_h = true
		sprite_2d.rotation = 0
	direction.y = Input.get_axis("move_up","move_down")
	if direction.y > 0 :
		sprite_2d.rotation = 0.5 * PI
		sprite_2d.flip_h = false
	if direction.y < 0 :
		sprite_2d.rotation =  1.5 * PI
		sprite_2d.flip_h = false
	var movement = direction * speed * delta
	panmac.position += direction * speed * delta
	move_and_collide(movement)
