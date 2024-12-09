extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start(text: String):
	$Label.text = text
	var tween = create_tween()
	tween.set_parallel()

	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16),.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


	tween.chain()
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48),0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC) #NOTE: The global position will *not* go to 16+48, it will only go to 48
	tween.tween_property(self,"scale",Vector2.ONE,.5).set_ease(Tween.EASE_IN).set_trans(tween.TRANS_CUBIC)
	tween.chain()

	tween.tween_callback(queue_free)


	var scale_tween = create_tween()
	scale_tween.tween_property(self,"scale",Vector2.ONE * 1.5,.15).set_ease(Tween.EASE_OUT).set_trans(tween.TRANS_CUBIC)
	scale_tween.tween_property(self,"scale",Vector2.ONE ,.15).set_ease(Tween.EASE_IN).set_trans(tween.TRANS_CUBIC)
