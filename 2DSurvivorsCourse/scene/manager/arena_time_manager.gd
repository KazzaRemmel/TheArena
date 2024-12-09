extends Node

signal arena_difficulty_increased(arena_difficulty: int)
@onready var audio_stream_player_2d = %AudioStreamPlayer2D


const DIFFICULTY_INTERVAL = 5
@export var end_screen_scene: PackedScene
@onready var timer = $Timer
var arena_difficulty = 0
var previous_time = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	var next_time_target = timer.wait_time - ((arena_difficulty + 1)*DIFFICULTY_INTERVAL) #this code decreases the target from 60 by multiples of 5 (difficulty_interval)

	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)

func get_time_elapsed():
	return timer.wait_time - timer.time_left

func on_timer_timeout():
	audio_stream_player_2d.stop()
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
	MetaProgression.save()
