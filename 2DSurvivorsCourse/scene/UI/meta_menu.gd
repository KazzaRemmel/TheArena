extends CanvasLayer

@onready var grid_container = %GridContainer
@onready var back_button = %BackButton

@export var upgrades: Array[MetaUpgrade] = []
var meta_upgrade_card_scene = preload("res://scene/UI/meta_upgrade_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.pressed.connect(on_back_pressed)
	for child in grid_container.get_children():
		child.queue_free()




	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)

func on_back_pressed():
	await get_tree().create_timer(0.4).timeout
	ScreenTransition.transition_to_scene("res://scene/UI/main_menu.tscn")

