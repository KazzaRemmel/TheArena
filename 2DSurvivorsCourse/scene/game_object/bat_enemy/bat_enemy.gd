extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var death_component = $DeathComponent
@onready var visuals = $Visuals

var is_moving = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$HurtboxComponent.hit.connect(on_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)



func on_hit():
	$HitRandomStreamPlayer2DComponent.play_random()
