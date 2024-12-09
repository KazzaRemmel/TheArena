extends CanvasLayer

@onready var panel_container = $%PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	#panel_container.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ZERO, 0) #you have to do this because the upper commented line doesn't work on UI elements, godot automatically resets the scale of the panel between tween creation and run
	tween.tween_property(panel_container, "scale",Vector2.ONE,.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().paused = true
	$%ContinueButton.pressed.connect(on_continue_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)

func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You Lost!"
	play_jingle(true)

func on_continue_button_pressed():
	get_tree().paused = false
	await get_tree().create_timer(0.4).timeout
	ScreenTransition.transition_to_scene("res://scene/UI/meta_menu.tscn")

func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()

func on_quit_button_pressed():

	get_tree().paused = false

	await get_tree().create_timer(0.4).timeout
	ScreenTransition.transition_to_scene("res://scene/UI/main_menu.tscn")



