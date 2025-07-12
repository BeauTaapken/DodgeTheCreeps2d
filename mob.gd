extends RigidBody2D

@onready var mob_animation : AnimatedSprite2D = (%AnimatedSprite2D as AnimatedSprite2D)
@onready var mob_types : Array = Array(mob_animation.sprite_frames.get_animation_names())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mob_animation.animation = mob_types.pick_random()
	mob_animation.play()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
