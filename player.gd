extends Area2D
class_name Player
signal hit

@export var speed : int = 400

@onready var player_animation : AnimatedSprite2D = (%AnimatedSprite2D as AnimatedSprite2D)
@onready var player_collision : CollisionShape2D = (%CollisionShape2D as CollisionShape2D)

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
		player_animation.play()
	else:
		player_animation.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		player_animation.animation = "walk"
		player_animation.flip_v = false
		player_animation.flip_h = velocity.x < 0
	elif velocity.y != 0:
		player_animation.animation = "up"
		player_animation.flip_v = velocity.y > 0

func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	player_collision.set_deferred("disabled", true)

func start(pos: Vector2) -> void:
	position = pos
	show()
	player_collision.disabled = false
