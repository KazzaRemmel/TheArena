extends CanvasLayer

signal transitioned_halfway

var skip_emit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func transition():
	$AnimationPlayer.play("default")
	await get_tree().create_timer(0.4).timeout
	$AnimationPlayer.play("backwards")


func transition_to_scene(scene_path: String):
	transition()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file(scene_path)
