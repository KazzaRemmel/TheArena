extends CanvasLayer

signal back_pressed
@onready var window_button: Button = %WindowButton
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var back_button = %BackButton


# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	update_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text ="Fullscreen"
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")

func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)#Returns the volume in decibels
	return db_to_linear(volume_db) #converts db to linear (between 0 and 1)

func set_bus_volume_percent(bus_name:String ,percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)#Returns the volume in decibels
	AudioServer.set_bus_volume_db(bus_index, volume_db)

func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false) #this has to be done as per the widows_set_flag documentation
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	update_display()



func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)

func on_back_pressed():
	ScreenTransition.transition()
	await get_tree().create_timer(0.4).timeout
	back_pressed.emit()
