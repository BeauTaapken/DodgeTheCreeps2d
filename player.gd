extends Area2D
signal hit

@export var speed : int = 400

@onready var animated_sprite_2d : AnimatedSprite2D = (%AnimatedSprite2D as AnimatedSprite2D)

var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animated_sprite_2d.play()
	else:
		animated_sprite_2d.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		animated_sprite_2d.animation = "walk"
		animated_sprite_2d.flip_v = false
		animated_sprite_2d.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite_2d.animation = "up"
		animated_sprite_2d.flip_v = velocity.y > 0
