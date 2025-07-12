extends Node

@export var mob_scene: PackedScene

@onready var score_timer : Timer = (%ScoreTimer as Timer)
@onready var mob_timer : Timer = (%MobTimer as Timer)
@onready var start_timer : Timer = (%StartTimer as Timer)
@onready var player : Player = (%Player as Player)
@onready var start_position : Marker2D = (%StartPosition as Marker2D)
@onready var mob_spawn_location : PathFollow2D  = (%MobSpawnLocation as PathFollow2D)
@onready var hud : Hud = (%HUD as Hud)
@onready var music : AudioStreamPlayer = (%Music as AudioStreamPlayer)
@onready var death_sound : AudioStreamPlayer = (%DeathSound as AudioStreamPlayer)

var score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func game_over() -> void:
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over()
	music.stop()
	death_sound.play()
	
func new_game() -> void:
	score = 0
	player.start(start_position.position)
	start_timer.start()
	hud.update_score(score)
	hud.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	music.play()


func _on_mob_timer_timeout() -> void:
	var mob : RigidBody2D = mob_scene.instantiate()

	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	var direction : float = mob_spawn_location.rotation + (PI / 2)
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity : Vector2 = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# TODO: figure out if there is exists something like a pool, just like unity
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1;
	hud.update_score(score)


func _on_start_timer_timeout() -> void:
	mob_timer.start()
	score_timer.start()
