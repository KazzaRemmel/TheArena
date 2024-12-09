extends Node2D
const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent
var base_rotation = Vector2.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3) #call this tween method, from 0 to 2, for 3 seconds
	tween.tween_callback(queue_free)




func tween_method(rotations: float):
	var percent = rotations / 2 #rotations goes from 0 to 2
	var current_radius = (percent) * MAX_RADIUS #percent of max radius
	var current_direction = base_rotation.rotated(rotations * TAU)  #Vector2.RIGHT.rotated(rotations * TAU) #rotate a right vector by our current rotation to see where it should be


	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return


	global_position = player.global_position + (current_direction * current_radius)
