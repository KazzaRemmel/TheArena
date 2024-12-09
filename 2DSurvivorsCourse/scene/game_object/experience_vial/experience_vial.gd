extends Node2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)


	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time())) #FRAME RATE ANGLE INDEPENDENT LERP


func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()

func disable_collision():
	collision_shape_2d.disabled = true #we disable to collision shape so that we only see on area entered once


func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred() #you cannot disable collision shapes in on area entered, this is a workaround
	var tween = create_tween()
	tween.set_parallel() #allows all the following tweens to execute at the same time
	tween.tween_method(tween_collect.bind(global_position), 0.0,1.0, .5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK) #creats easing and calls function
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, .05).set_delay(.45) #we need to set a delay so that it ends at the same time as the method above
	tween.chain() #allows the next tween to execute after the previous tweens (in series not parallel)
	tween.tween_callback(collect)
	$RandomStreamPlayer2DComponent.play_random()


