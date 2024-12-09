extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = $%Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)

func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - minutes*60
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds)) #here the 02d is enforcing 2 digits, so if the number is less than 10, you will have the leading zero
