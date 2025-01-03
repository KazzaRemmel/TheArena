extends Node

@export var health_component: Node
@export var hit_flash_material : ShaderMaterial
@export var sprite: Sprite2D
var hit_flash_tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.material = hit_flash_material
	health_component.health_decreased.connect(on_health_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.


func on_health_changed():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent",1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material,"shader_parameter/lerp_percent",0.0, .2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
