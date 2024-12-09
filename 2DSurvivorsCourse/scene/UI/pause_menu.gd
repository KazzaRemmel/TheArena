extends CanvasLayer
@onready var panel_container = %PanelContainer
var is_closing

var options_menu_scene = preload("res://scene/UI/options_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true #REMEMBER PROCESS MODE ALWAYS

	panel_container.pivot_offset = panel_container.size/2 #changes the pivot offset to be the middle of the container
	$%ResumeButton.pressed.connect(on_resume_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)


	$AnimationPlayer.play("default")

	var tween = create_tween() # Replace with function body.
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0) #REMEMBER: you cant set container sizing in animations or in code, so you have to do this to set it to 0 and have it flash in
	tween.tween_property(panel_container, "scale", Vector2.ONE,.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)



func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()

func close():
	if is_closing: #here, since we are instantiating the pause scene every time we pause, is closing is always false
		return
	is_closing = true
	$AnimationPlayer.play_backwards("default")
	var tween = create_tween() # Replace with function body.
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0) #REMEMBER: you cant set container sizing in animations or in code, so you have to do this to set it to 0 and have it flash in
	tween.tween_property(panel_container, "scale", Vector2.ZERO,.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

	await tween.finished



	get_tree().paused = false
	queue_free()


func on_resume_pressed():
	close()


func on_options_pressed():
	ScreenTransition.transition()
	await get_tree().create_timer(0.4).timeout
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))

func on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/UI/main_menu.tscn")





func on_options_back_pressed(options_menu: Node):
	options_menu.queue_free()
