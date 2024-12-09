extends Area2D

class_name HurtboxComponent
signal hit

@export var health_component: HealthComponent
var floating_text_scene = preload("res://scene/UI/floating_text.tscn")
var floating_text


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return

	if health_component == null:
		return

	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP*16) #offset up 16 pixels

	var format_string = "%0.1f"
	if round(hitbox_component.damage) == hitbox_component.damage:
		format_string = "%0.0f" # if the rounded number is the same as the number itself, its a whole number and shouldnt show decimals
	floating_text.start(format_string % hitbox_component.damage)
	hit.emit()

