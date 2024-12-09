extends Node
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var end_screen_scene = $ArenaTimeManager.end_screen_scene
var pause_menu_scene = preload("res://scene/UI/pause_menu.tscn")

func _ready():
	$%Player.health_component.died.connect(on_player_died)
	audio_stream_player_2d.play()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()

func on_player_died():
	audio_stream_player_2d.stop()
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()

